MilkshakeVol1:AddModCompatibility("Epiphany", function()
    --Add slots
    MilkshakeVol1.API:AddConductivityOrbSlotPayout(Epiphany.Slot.GLITCH.ID, {
        {
            chance = 100,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = 0,
                weight = 1
            }
        },
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_HEART,
                subtype = 0,
                weight = 1
            }
        },
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_BOMB,
                subtype = 0,
                weight = 1
            }
        },
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_KEY,
                subtype = 0,
                weight = 1
            }
        },
        {
            chance = 15,
            value = {
                variant = PickupVariant.PICKUP_CHEST,
                subtype = ChestSubType.CHEST_CLOSED,
                weight = 1
            }
        }
    })

    MilkshakeVol1.API:AddConductivityOrbSlotPayout(Epiphany.Slot.DICE_MACHINE.ID, {
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_TAROTCARD,
                subtype = Epiphany.PickupGetter.MakeCardGetter({"DiceCapsule"}),
                weight = 1
            }
        }
    })

    MilkshakeVol1:AddConductivityOrbSlotPayout(Epiphany.Slot.PAIN_O_MATIC.ID, {
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_HEART,
                subtype = Epiphany.PickupGetter.MakeHeartGetter({ "Red", "Rotten" }),
                weight = 1
            }
        }
    })

    MilkshakeVol1.API:AddConductivityOrbSlotPayout(Epiphany.Slot.TURNOVER_RESTOCK.ID, {
        {
            chance = 100,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = CoinSubType.COIN_PENNY,
                weight = 1
            }
        },
        {
            chance = 30,
            value = {
                variant = PickupVariant.PICKUP_HEART,
                subtype = HeartSubType.HEART_HALF,
                weight = 1
            }
        },
        {
            chance = 30,
            value = {
                variant = PickupVariant.PICKUP_HEART,
                subtype = HeartSubType.HEART_FULL,
                weight = 1
            }
        },
        {
            chance = 30,
            value = {
                variant = PickupVariant.PICKUP_BOMB,
                subtype = BombSubType.BOMB_NORMAL,
                weight = 1
            }
        },
        {
            chance = 20,
            value = {
                variant = PickupVariant.PICKUP_KEY,
                subtype = KeySubType.KEY_NORMAL,
                weight = 1
            }
        },
        {
            chance = 15,
            value = {
                variant = PickupVariant.PICKUP_HEART,
                subtype = HeartSubType.HEART_DOUBLEPACK,
                weight = 2
            }
        },
        {
            chance = 10,
            value = {
                variant = PickupVariant.PICKUP_BOMB,
                subtype = BombSubType.BOMB_DOUBLEPACK,
                weight = 2
            }
        },
        {
            chance = 10,
            value = {
                variant = PickupVariant.PICKUP_KEY,
                subtype = KeySubType.KEY_DOUBLEPACK,
                weight = 2
            }
        },
        {
            chance = 5,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = CoinSubType.COIN_NICKEL,
                weight = 2
            }
        },
        {
            chance = 1,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = CoinSubType.COIN_DIME,
                weight = 3
            }
        },
    })

    MilkshakeVol1.API:AddConductivityOrbSlotPayout(Epiphany.Slot.CONVERTER_BEGGAR.ID, {
        {
            chance = 25,
            value = {
                variant = PickupVariant.PICKUP_HEART,
                subtype = Epiphany.PickupGetter.MakeHeartGetter({"Red"}),
                weight = 1
            }
        },
        {
            chance = 15,
            value = {
                variant = PickupVariant.PICKUP_HEART,
                subtype = Epiphany.PickupGetter.MakeHeartGetter({"Soul"}),
                weight = 1
            }
        }
    })
end)
