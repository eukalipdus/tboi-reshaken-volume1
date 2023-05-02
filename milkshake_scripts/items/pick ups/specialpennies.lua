local enums = milkshakeMod.enums

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ACID_PENNY, function (_, player)
    local randomPill = Game():GetItemPool():GetPill(Random() + 1)
    player:AddPill(randomPill)
    SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLESSED_PENNY, function (_, player)
    player:AddSoulHearts(1)
    SFXManager():Play(SoundEffect.SOUND_HOLY)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLOODY_PENNY, function (_, player)
    player:AddHearts(1)
    SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BURNT_PENNY, function (_, player)
    player:AddBombs(1)
    SFXManager():Play(SoundEffect.SOUND_FETUS_FEET)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BUTT_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, UseFlag.USE_NOANIM)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CHARGED_PENNY, function (_, player)
    TSIL.Charge.AddCharge(player)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.COUNTERFEIT_PENNY, function (_, player)
    player:AddCoins(1)
    SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CRYSTAL_PENNY, function (_, player)
    local randomCard = Game():GetItemPool():GetCard(Random() + 1, true, true, false)
    player:AddCard(randomCard)
    SFXManager():Play(SoundEffect.SOUND_MENU_NOTE_APPEAR)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CURSED_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT, UseFlag.USE_NOANIM)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.FLAT_PENNY, function (_, player)
    player:AddKeys(1)
    SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
end)

milkshakeMod:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ROTTEN_PENNY, function (pickup, player)
    player:AddBlueFlies(1, pickup.Position, player)
end)