local enums = MilkshakeVol1.enums

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ACID_PENNY, function (_, player)
    local randomPill = Game():GetItemPool():GetPill(Random() + 1)
    player:AddPill(randomPill)
    SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLESSED_PENNY, function (_, player)
    player:AddSoulHearts(1)
    SFXManager():Play(SoundEffect.SOUND_HOLY)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLOODY_PENNY, function (_, player)
    player:AddHearts(1)
    SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BURNT_PENNY, function (_, player)
    player:AddBombs(1)
    SFXManager():Play(SoundEffect.SOUND_FETUS_FEET)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BUTT_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, UseFlag.USE_NOANIM)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CHARGED_PENNY, function (_, player)
    TSIL.Charge.AddCharge(player)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.COUNTERFEIT_PENNY, function (_, player)
    player:AddCoins(1)
    SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CRYSTAL_PENNY, function (_, player)
    local randomCard = Game():GetItemPool():GetCard(Random() + 1, true, true, false)
    player:AddCard(randomCard)
    SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CURSED_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT, UseFlag.USE_NOANIM)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.FLAT_PENNY, function (_, player)
    player:AddKeys(1)
    SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
end)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ROTTEN_PENNY, function (pickup, player)
    player:AddBlueFlies(1, pickup.Position, player)
end)