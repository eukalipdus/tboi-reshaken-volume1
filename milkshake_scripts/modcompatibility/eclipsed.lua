MilkshakeVol1:AddModCompatibility("EclipsedMod", function ()
    local EclipsedBeggars = {
        [Isaac.GetEntityVariantByName("Mongo Beggar")] = {
            Config = {Count = 2, MinCount = 2},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.MINISAAC, SubType = 0},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLUE_FLY, SubType = 0},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLUE_FLY, SubType = 1},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLUE_FLY, SubType = 2},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLUE_FLY, SubType = 3},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLUE_FLY, SubType = 4},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLUE_SPIDER, SubType = 0},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLOOD_BABY, SubType = 0},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLOOD_BABY, SubType = 1},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLOOD_BABY, SubType = 2},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLOOD_BABY, SubType = 3},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLOOD_BABY, SubType = 4},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLOOD_BABY, SubType = 5},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = FamiliarVariant.BLOOD_BABY, SubType = 6},
        },
        [Isaac.GetEntityVariantByName("Delirious Bum")] = {
            Config = {Count = 1, MinCount = 0},
            --idk where is half black and immoral harts
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectCell,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectBomb,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectKey,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectCard,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectPill,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectRune,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectHeart,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectCoin,},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = EclipsedMod.enums.Pickups.DeliObjectBattery,},
        },
    }
    for key, datatable in pairs(EclipsedBeggars) do
        MilkshakeVol1.API:AddUnholyOrbBeggar(key, datatable)
    end
end)