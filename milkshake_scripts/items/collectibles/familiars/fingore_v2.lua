local mod = MilkshakeVol1
local fingore = {}
local game = Game()
local enums = mod.enums
local utility = mod.utility

fingore.item = enums.Collectibles.FINGORE
fingore.head = enums.Familiars.FINGORE_HEAD
fingore.finger = enums.Familiars.FINGORE_FINGER
fingore.detect = 5000
fingore.baitDuration = 10*30
fingore.boredTimeout = 10*30
fingore.orbit = 60 -- 1 tile
fingore.innerorbit = 40
fingore.distance = 40 -- head distance
fingore.innerdistance = 20
fingore.cooldown = 30 * 5 -- 5 seconds
fingore.delayFrames = 60
fingore.velocity = 0.9
fingore.speed = 20
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

function fingore:FamiliarInit(familiar)
	local data = familiar:GetData()
	data.bored = 0
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, fingore.FamiliarInit, fingore.finger)

function fingore:HeadUpdate(familiar)
	local player = familiar.Player
	--local data = familiar:GetData()
	--local rng = familiar:GetDropRNG()

	-- if familiar has target (finger)
	if familiar.Target then
		-- get finger position and velocity
		local targetPos = familiar.Target.Position
		--local targetVel = familiar.Target.Velocity
		local vector3 = (familiar.Position - targetPos)
		-- follow it's finger at some distance
		if vector3:Length() > fingore.distance then
			familiar:FollowPosition(targetPos)
		else
			-- if passed some distance, stop following
			-- move back if head gets too close to finger (TODO)
			if vector3:Length() < fingore.innerdistance then
				local vel = vector3:Normalized(fingore.knockPower)
				familiar:AddVelocity(vel)
			end
			-- velocity decrease, stoppping
			familiar.Velocity = familiar.Velocity*fingore.velocity
		end

		-- flip head direction regarding finger position
		--if targetVel.X ~= 0 then familiar.FlipX = targetVel.X < 0 end
        --if familiar.Target.Target then
        --
        --else
        --    familiar.FlipX = familiar.Position.X > targetPos.X
        --end
        familiar.FlipX = familiar.Target.FlipX

	else
		-- spawn finger if no finger
		local finger = Isaac.Spawn(3, fingore.finger, 0, familiar.Position, Vector.Zero, player)
		finger.Parent = familiar
		familiar.Target = finger
	end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.HeadUpdate, fingore.head)

function fingore:FingerUpdate(familiar)
	-- line between head and enemy (TODO)
	local data = familiar:GetData()
	--local player = familiar.Player
	local parent = familiar.Parent
	local rng = familiar:GetDropRNG()

	-- remove if no head
	if not parent then
		familiar:Remove()
	end

	-- cooldown between targeting new enemy
	if data.cooldown then
		if data.cooldown > 0 then
			data.cooldown = data.cooldown - 1
		else
			data.cooldown = nil
		end
	else
		-- get target if not bored
		-- if has enemy to follow
		if familiar.Target then
			local target = familiar.Target
			local targetPos = target.Position
			local vector3 = (familiar.Position - targetPos)

			-- follow target
			if vector3:Length() > fingore.orbit then
				familiar:FollowPosition(targetPos)
			else
				-- get if npc has baited status, if not - add
				if not target:HasEntityFlags(EntityFlag.FLAG_BAITED) then
					target:AddEntityFlags(EntityFlag.FLAG_BAITED)-- fingore.baitDuration)
					-- set bored timeout to stop targeting enemy
					data.bored = fingore.boredTimeout
				end
				-- follow npc position at some distance
				if vector3:Length() <= fingore.innerorbit then
					local vel = vector3:Normalized(fingore.knockPower)
					familiar:AddVelocity(vel)
				else
					-- speed multiplied
					familiar.Velocity = familiar.Velocity*fingore.velocity
				end
			end

			local angle = (targetPos-familiar.Position):GetAngleDegrees()
            if angle > 90 or angle < -90 then
                angle = 180 - angle
            end
			--if angle >= 3 * math.pi / 4 and angle < 5 * math.pi / 4 then
			--	familiar.FlipX = familiar.Position.X > targetPos.X
			--end

            familiar.FlipX = familiar.Position.X > targetPos.X

            familiar.SpriteRotation = angle



			-- gets bored after timeout
			if data.bored then
				data.bored = data.bored - 1
				if data.bored <= 0 then
					data.bored = nil
					data.cooldown = fingore.cooldown
					target:ClearEntityFlags(EntityFlag.FLAG_BAITED)
					familiar.Target = nil
				end
			end
			-- prevents randomly moving logic
			return
		else
			-- if enemy died before fingore getting bored
			if data.bored then
				data.bored = nil
				data.cooldown = fingore.cooldown
				familiar.Target = nil
				return
			end
			-- get target enemy
			local enemies = Isaac.FindInRadius(familiar.Position, fingore.detect, EntityPartition.ENEMY)
			if #enemies > 0 then
				local target = enemies[rng:RandomInt(#enemies)+1]
				if target and target:IsVulnerableEnemy() then --- (would be funny to target any enemy lol)
					familiar.Target = target
				end
			end
		end
	end

	-- move randomly, speed multiplied
	--familiar:GetPathFinder():MoveRandomly(true)
	if familiar.Velocity:Length() < 0.01 then
		local pos = game:GetRoom():GetRandomPosition(0)
		familiar:FollowPosition(pos)
		familiar.Velocity = familiar.Velocity:Normalized()*fingore.speed
	end
	familiar.Velocity = familiar.Velocity*fingore.velocity

	-- flip finger direction regarding own velocity

    if familiar.SpriteRotation ~= 0 then -- huh
        familiar.SpriteRotation = 0
    end

	if familiar.Velocity.X ~= 0 then familiar.FlipX = familiar.Velocity.X < 0 end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.FingerUpdate, fingore.finger)


--- EASTER EGG
local fingoreCollectiblesInRoom = {}

---Gets the location of a stored ptrHash in the table fingoreCollectiblesInRoom
---@param ptrHash integer
---@return unknown
local function FindFingoreKey(ptrHash)
	for key, storedPtrHash in pairs(fingoreCollectiblesInRoom) do
		if ptrHash == storedPtrHash then
			return key
		end
	end
	return -1
end

---Displays an easter egg message using a random player's name
---@param rng RNG
local function FingoreHiddenMessage(rng)
	local players = TSIL.Players.GetPlayers()
	local randomPlayer = TSIL.Random.GetRandomElementsFromTable(players, 1, rng)
	local chosenName = randomPlayer[1]:GetName()
	Game():GetHUD():ShowFortuneText(
		"You cannot",
		"ignore me",
		"forever, " .. chosenName
	)
end

---@param pickup EntityPickup
function fingore:PostPickupInit(pickup)
	local ptrHash = GetPtrHash(pickup)--TSIL.Collectibles.GetCollectibleIndex(pickup)
	if pickup.SubType == enums.Collectibles.FINGORE then
		table.insert(fingoreCollectiblesInRoom, ptrHash)

	elseif TSIL.Utils.Tables.IsIn(fingoreCollectiblesInRoom, ptrHash) then
		local tableKey = FindFingoreKey(ptrHash)
		if tableKey ~= -1 then
			table.remove(fingoreCollectiblesInRoom, tableKey)
		end
		FingoreHiddenMessage(pickup:GetDropRNG())
	end
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_POST_PICKUP_INIT,
	fingore.PostPickupInit,
	PickupVariant.PICKUP_COLLECTIBLE
)

---@param pickup Entity
function fingore:PostEntityRemove(pickup)
	if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
	and pickup.SubType == enums.Collectibles.FINGORE then
		FingoreHiddenMessage(pickup:GetDropRNG())
	end
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_POST_ENTITY_REMOVE,
	fingore.PostEntityRemove,
	EntityType.ENTITY_PICKUP
)
