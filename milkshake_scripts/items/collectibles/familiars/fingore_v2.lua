local mod = MilkshakeVol1
local fingore = {}
local enums = mod.enums
local utility = mod.utility

fingore.item = enums.Collectibles.FINGORE
fingore.head = enums.Familiars.FINGORE_HEAD
fingore.finger = enums.Familiars.FINGORE_FINGER
fingore.orbit = 40 -- 1 tile
fingore.distance = 60 -- head distance
fingore.cooldown = 30 * 5 -- 5 seconds

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

end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, fingore.FamiliarInit, fingore.head)

function fingore:HeadUpdate(familiar)
	-- check room for enemy
	-- check cooldown
	-- move after finger, in distance
	-- or
	-- wander
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.HeadUpdate, fingore.head)

function fingore:FingerUpdate(familiar)
	-- target enemy
	-- line between head and enemy
	-- in orbit distance
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.FingerUpdate, fingore.finger)
