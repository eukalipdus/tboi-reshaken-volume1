BumAPI:AddBumFamiliar(
    FamiliarVariant.BUMBO,
    CollectibleType.COLLECTIBLE_BUMBO,
    false,
    5,
    {
        {reward = 1, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_PENNY
        }},
        {reward = 5, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_NICKEL
        }},
        {reward = 10,value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_DIME
        }},
        {reward = 2, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_DOUBLEPACK
        }},
        {reward = 1, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_LUCKYPENNY
        }},
        {reward = -1,value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_STICKYNICKEL
        }},
        {reward = 1, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_GOLDEN
        }}
    },
    {
        {chance = 100, value = {
            type = EntityType.ENTITY_PICKUP,
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_FULL
        }},
    }
)