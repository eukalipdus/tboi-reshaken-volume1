local mod = MilkshakeVol1
local fingore = {}
local game = Game()
local enums = mod.enums
local utility = mod.utility

fingore.item = enums.Collectibles.FINGORE
fingore.head = enums.Familiars.FINGORE_HEAD
fingore.finger = enums.Familiars.FINGORE_FINGER
fingore.detect = 5000
fingore.baitDuration = 15
fingore.orbit = 40 -- 1 tile
fingore.distance = 40 -- head distance
fingore.cooldown = 30 * 5 -- 5 seconds
fingore.delayFrames = 60
fingore.velocity = 0.8
fingore.speed = 1

-- fingore -  entering new room: spawn at the room center
-- room with enemy - spawn finger, follow finger
-- room without enemy - remove finger, wander in the room
-- finger targets enemy, moves fast, head moves slowly
-- finger in line between head and enemy
-- target enemy gets Decoy mark effect
-- targeting cooldown if target enemy is dead (reset on new room)

function fingore:EvaluateCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        fingore.item,
        fingore.head
    )
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, fingore.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

function fingore:FamiliarInit(familiar)
	-- spawn finger?
	local data = familiar:GetData()
	familiar.Velocity = Vector.Zero
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, fingore.FamiliarInit, fingore.head)

function fingore:HeadUpdate(familiar)
	local player = familiar.Player
	local data = familiar:GetData()
	local rng = familiar:GetDropRNG()
	--local room = game:GetRoom()

	if familiar.Velocity.X ~= 0 then familiar.FlipX = familiar.Velocity.X < 0 end

	if familiar.Target then
		local targetPos = familiar.Target.Position
		-- follow it's finger in some distance
		if (familiar.Position - targetPos):Length() > fingore.distance then
			familiar:FollowPosition(targetPos)
		else
			familiar.Velocity = familiar.Velocity*fingore.velocity
		end
	else
		if data.cooldown then
			if data.cooldown > 0 then
				data.cooldown = data.cooldown - 1
			else
				data.cooldown = nil
			end
		else
			--familiar.PickEnemyTarget(fingore.detect, 13, 16, Vector.Zero, 0) -- idk if it gets familiar.Target
			--return
			--[
			local enemies = Isaac.FindInRadius(familiar.Position, fingore.detect, EntityPartition.ENEMY)
			if #enemies > 0 then
				local target = enemies[rng:RandomInt(#enemies)+1]
				if target then
					--familiar.Target = target
					local finger = Isaac.Spawn(3, fingore.finger, 0, familiar.Position, Vector.Zero, player)
					finger.Parent = familiar
					finger.Target = target
					--data.finger = finger
					--familiar.Parent = finger
					--familiar:FollowParent()
					familiar.Target = finger
					--some animation idk
					return
				end
			end
			--]
		end
		-- AI wandering -- placeholder
		familiar:MoveDelayed(fingore.delayFrames)
		--familiar:MoveDiagonally(fingore.speed)
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.HeadUpdate, fingore.head)

function fingore:FingerUpdate(familiar)
	-- target enemy
	-- line between head and enemy
	-- in orbit distance
	local player = familiar.Player
	local parent = familiar.Parent
	local data = familiar:GetData()
	local rng = familiar:GetDropRNG()
	if familiar.Target then
		local target = familiar.Target
		local targetPos = target.Position
		-- follow it's finger in some distance
		if (familiar.Position - targetPos):Length() > fingore.orbit then
			familiar:FollowPosition(targetPos)
		else
			target:AddBaited(EntityRef(player), fingore.baitDuration)
			familiar.Velocity = familiar.Velocity*fingore.velocity
		end
	else
		parent:GetData().cooldown = fingore.cooldown
		parent.Target = nil
		familiar:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.FingerUpdate, fingore.finger)
