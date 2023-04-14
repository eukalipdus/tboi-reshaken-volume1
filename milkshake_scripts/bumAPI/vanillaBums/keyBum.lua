BumAPI:AddBumFamiliar(
    FamiliarVariant.KEY_BUM,
    CollectibleType.COLLECTIBLE_KEY_BUM,
    true,
    1,
    {
        {reward = 1, value = {
            variant = PickupVariant.PICKUP_KEY,
            subtype = KeySubType.KEY_NORMAL
        }},
        {reward = 2, value = {
            variant = PickupVariant.PICKUP_KEY,
            subtype = KeySubType.KEY_DOUBLEPACK
        }},
        {reward = 1, value = {
            variant = PickupVariant.PICKUP_KEY,
            subtype = KeySubType.KEY_CHARGED
        }, spawn = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_LIL_BATTERY,
            subtype = BatterySubType.BATTERY_NORMAL
        }},
    },
    {
        {chance = 40, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_CHEST,
            subtype = ChestSubType.CHEST_CLOSED
        }},
        {chance = 30, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_REDCHEST,
            subtype = ChestSubType.CHEST_CLOSED
        }},
        {chance = 20, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_LOCKEDCHEST,
            subtype = ChestSubType.CHEST_CLOSED
        }},
        {chance = 10, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_GRAB_BAG,
            subtype = SackSubType.SACK_NORMAL
        }},
    }
)