BumAPI:AddBumFamiliar(
    FamiliarVariant.DARK_BUM,
    CollectibleType.COLLECTIBLE_DARK_BUM,
    true,
    3,
    {
        {reward = 2, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_FULL
        }},
        {reward = 1, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_HALF
        }},
        {reward = 4, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_DOUBLEPACK
        }},
        {reward = 2, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_SCARED
        }},
    }, {
        {chance = 40, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_BLACK
        }},
        {chance = 20, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_TAROTCARD,
            subtype = -1
        }},
        {chance = 20, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_PILL,
            subtype = -1
        }},
        {chance = 10, value = {
            type = EntityType.ENTITY_FAMILIAR,
            variant = FamiliarVariant.BLUE_SPIDER,
            subtype = 0
        }},
        {chance = 10, value = {
            type = EntityType.ENTITY_SPIDER,
            variant = 0,
            subtype = 0
        }},
    }
)