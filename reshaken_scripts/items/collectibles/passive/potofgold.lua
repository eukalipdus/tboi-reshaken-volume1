local potOfGold = {}
local enums = milkshakeMod.enums

local rainbowPennies = {
    [0] = enums.Coins.ROTTEN_PENNY,
    [1] = enums.Coins.FLAT_PENNY,
    [2] = enums.Coins.BURNT_PENNY,
    [3] = enums.Coins.BUTT_PENNY,
    [4] = enums.Coins.CHARGED_PENNY,
    [5] = enums.Coins.CURSED_PENNY,
    [6] = enums.Coins.BLOODY_PENNY,
    [7] = enums.Coins.BLESSED_PENNY,
    [8] = enums.Coins.COUNTERFEIT_PENNY,
    [9] = enums.Coins.ACID_PENNY,
    [10] = enums.Coins.CRYSTAL_PENNY
}

function potOfGold:onPlayerEffectUpdate(player)
    if not player then return end
    if player:HasCollectible(milkshakeMod.enums.Collectibles.POT_OF_GOLD) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP then
                local pickup = entity:ToPickup()
                if (pickup.Variant == PickupVariant.PICKUP_KEY or pickup.Variant == PickupVariant.PICKUP_BOMB) then
                    local rng = player:GetCollectibleRNG(enums.Collectibles.POT_OF_GOLD)
                    local roll = rng:RandomInt(#rainbowPennies + 1)
                    pickup:Remove()
                    TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_COIN, rainbowPennies[roll], pickup.Position, Vector.Zero, player)
                end
            end
        end
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, potOfGold.onPlayerEffectUpdate)
return potOfGold