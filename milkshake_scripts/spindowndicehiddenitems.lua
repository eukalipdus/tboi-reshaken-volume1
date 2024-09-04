local ItemHider = {}
local enums = MilkshakeVol1.enums
local FINAL_VOL1_ITEM = enums.Collectibles.PRISMATIC_GOGGLES

local brendaWisps = {
    enums.Collectibles.SPECIAL_BRENDA_FIRE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_PSYCHIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_NATURE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_ELECTRIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_WATER_WISP,
    enums.Collectibles.SPECIAL_BRENDA_POISON_WISP,
    enums.Collectibles.SPECIAL_BRENDA_HOLY_WISP,
    enums.Collectibles.SPECIAL_BRENDA_TERRA_WISP
}

function ItemHider:UseItem()
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        local collectibles = Isaac.FindByType(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE
        )

        for _, currentCollectible in pairs(collectibles) do
            if TSIL.Utils.Tables.IsIn(brendaWisps, currentCollectible) then
                currentCollectible:Morph(
                    currentCollectible.Type,
                    currentCollectible.Variant,
                    FINAL_VOL1_ITEM
                )
            end
        end
    end, 1)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, ItemHider.UseItem, CollectibleType.COLLECTIBLE_SPINDOWN_DICE)