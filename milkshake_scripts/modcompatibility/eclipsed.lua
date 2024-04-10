MilkshakeVol1:AddModCompatibility("Eclipsed", function ()
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
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Object"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Bomb"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Key"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Card"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Pill"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Rune"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Heart"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Coin"),},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Isaac.GetCardIdByName("Dell_Battery"),},
        },
        [Isaac.GetEntityVariantByName("Void Beggar")] = {
            Config = {Count = 1, MinCount = 0},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Card.RUNE_BLACK},
        },
        [Isaac.GetEntityVariantByName("Gimpy Beggar")] = {
            Config = {Count = 1, MinCount = 2},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_PILL, SubType = 0},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_HALF},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_HALF_SOUL},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SCARED},
            {Type = EntityType.ENTITY_BOMB, Variant = BombVariant.BOMB_TROLL, SubType = 0},
        },
        [Isaac.GetEntityVariantByName("Candy Beggar")] = {
            Config = {Count = 2, MinCount = 1},
            {Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = 1},
        },
        [Isaac.GetEntityVariantByName("Warlock Beggar")] = {
            Config = {Count = 2, MinCount = 1},
            {Type = EntityType.ENTITY_FAMILIAR, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = 0},
        },
    }
    for key, datatable in pairs(EclipsedBeggars) do
        MilkshakeVol1.API:AddUnholyOrbBeggar(key, datatable)
    end

    --Glass Item Pool
    MilkshakeVol1.API:AddItemsToGlassPool({
        { Collectible = Isaac.GetItemIdByName("Glass Bombs"),
            Weight = 1,
            DecreaseBy = 1,
            RemoveOn = 0.1,
            IsUnlocked = function()
                return
                    Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("Glass Bombs"))
            end
        },
        {
            Collectible = Isaac.GetItemIdByName("Red Mirror"),
            Weight = 1,
            DecreaseBy = 1,
            RemoveOn = 0.1,
            IsUnlocked = function()
                return
                    Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("Red Mirror"))
            end
        },
        { Collectible = Isaac.GetItemIdByName("Lost Mirror"),       Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
        { Collectible = Isaac.GetItemIdByName("Space Jam"),       Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
        { Collectible = Isaac.GetItemIdByName("Blood V"),       Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    })
end)