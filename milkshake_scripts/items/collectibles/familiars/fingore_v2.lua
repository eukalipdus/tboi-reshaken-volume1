local mod = MilkshakeVol1
local fingore = {}
local game = Game()
local enums = mod.enums
local utility = mod.utility

fingore.item = enums.Collectibles.FINGORE
fingore.head = enums.Familiars.FINGORE_HEAD
fingore.finger = enums.Familiars.FINGORE_FINGER
fingore.detect = 5000
fingore.baitDuration = 62
fingore.orbit = 40 -- 1 tile
fingore.innerorbit = 20
fingore.distance = 80 -- head distance
fingore.innerdistance = 40
fingore.cooldown = 30 * 5 -- 5 seconds
fingore.delayFrames = 60
fingore.velocity = 0.9
fingore.speed = 0.5
fingore.knockPower = 10

-- fingore -  entering new room: spawn at the room center
-- room with enemy - spawn finger, follow finger
-- room without enemy - remove finger, wander in the room
-- finger targets enemy, moves fast, head moves slowly
-- finger in line between head and enemy
-- target enemy gets Decoy mark effect
-- targeting cooldown if target enemy is dead (reset on new room)

function fingore:EvaluateCache(player)
	-- familiars handle
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        fingore.item,
        fingore.head
    )
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, fingore.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

--[[
function fingore:FamiliarInit(familiar)
	-- spawn finger?
	--local data = familiar:GetData()
	-- res
	familiar.Velocity = Vector.Zero
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, fingore.FamiliarInit, fingore.head)
--]]

function fingore:HeadUpdate(familiar)
	local player = familiar.Player
	local data = familiar:GetData()
	local rng = familiar:GetDropRNG()

	-- if familiar has target (finger)
	if familiar.Target then
		-- get finger position and velocity
		local targetPos = familiar.Target.Position
		local targetVel = familiar.Target.Velocity

		-- follow it's finger at some distance
		if (familiar.Position - targetPos):Length() > fingore.distance then
			familiar:FollowPosition(targetPos)
		else
			-- if passed some distance, stop following
			-- move back if head gets too close to finger (TODO)
			if (familiar.Position - targetPos):Length() < fingore.innerdistance then
				local vel = (familiar.Position-targetPos):Normalized(fingore.knockPower)
				familiar:AddVelocity(vel)
			end
			-- velocity decrease, stoppping
			familiar.Velocity = familiar.Velocity*fingore.velocity
		end

		-- flip head direction regarding finger position
		--if targetVel.X ~= 0 then familiar.FlipX = targetVel.X < 0 end
		familiar.FlipX = familiar.Position.X > targetPos.X
	else
		-- logic if not following finger
		-- flip head direction regarding own velocity
		if familiar.Velocity.X ~= 0 then familiar.FlipX = familiar.Velocity.X < 0 end

		-- cooldown between targeting new enemy
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
			-- get target and spawn finger
			local enemies = Isaac.FindInRadius(familiar.Position, fingore.detect, EntityPartition.ENEMY)
			if #enemies > 0 then
				local target = enemies[rng:RandomInt(#enemies)+1]
				if target and target:IsVulnerableEnemy() then
					local finger = Isaac.Spawn(3, fingore.finger, 0, familiar.Position, Vector.Zero, player)
					finger.Parent = familiar
					finger.Target = target
					familiar.Target = finger
					return
				end
			end
			--]
		end
		-- move randomly, speed multiplied
		familiar:GetPathFinder():MoveRandomly(true)
		familiar.Velocity = familiar.Velocity*fingore.velocity
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.HeadUpdate, fingore.head)

function fingore:FingerUpdate(familiar)
	-- line between head and enemy (TODO)
	local player = familiar.Player
	local parent = familiar.Parent

	if familiar.Target then
		-- get target npc
		local target = familiar.Target
		local targetPos = target.Position

		-- flip head direction regarding npc positiop
		familiar.FlipX = familiar.Position.X > targetPos.X

		-- follow it's finger in some distance
		if (familiar.Position - targetPos):Length() > fingore.orbit then
			familiar:FollowPosition(targetPos)
		else
			-- get if npc has baited status, if not - add
			if not target:HasEntityFlags(EntityFlag.FLAG_BAITED) then
				target:AddBaited(EntityRef(player), fingore.baitDuration)
			end
			-- follow npc position at some distance
			if (familiar.Position - targetPos):Length() <= fingore.innerorbit then
				local vel = (familiar.Position - targetPos):Normalized(fingore.knockPower)
				familiar:AddVelocity(vel)
			else
				-- speed multiplied
				familiar.Velocity = familiar.Velocity*fingore.velocity
			end
		end
	else
		-- set cooldown to targeting next enemy
		parent:GetData().cooldown = fingore.cooldown
		-- reset target entity
		parent.Target = nil
		-- remove finger
		familiar:Remove()
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.FingerUpdate, fingore.finger)
