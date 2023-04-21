local globinInABucket = {}
local enums = milkshakeMod.enums

local globinTypes = {
    [1] = EntityType.ENTITY_GLOBIN,
    [2] = EntityType.ENTITY_BLACK_GLOBIN
}

function globinInABucket:onUse(collectible, rng, player, flags, slot)
    if player == nil then return end
    player:AnimateCollectible(enums.Collectibles.GLOBIN_IN_A_BUCKET, "Pickup", "PlayerPickupSparkle")
    local roll = rng:RandomInt(#globinTypes) + 1
    local globin = Isaac.Spawn(globinTypes[roll], 0, 0, player.Position, Vector(0,0), player)
    globin:AddCharmed(EntityRef(player), -1)
end

milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, globinInABucket.onUse, enums.Collectibles.GLOBIN_IN_A_BUCKET)

return {
    Discharge = true,
    Remove = false,
    ShowAnim = true,
}