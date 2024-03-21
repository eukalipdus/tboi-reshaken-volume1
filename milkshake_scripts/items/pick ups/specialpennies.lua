local enums = MilkshakeVol1.enums

local REPLACE_CHANCE = 0.01
local KEEPERB_REPLACE_CHANCE = 0
local TIMES_CAN_FAIL = 5000

local positivePillCollectibles = {
    CollectibleType.COLLECTIBLE_PHD,
    CollectibleType.COLLECTIBLE_LUCKY_FOOT,
    CollectibleType.COLLECTIBLE_VIRGO
}

local NUMBER_TAROT_CARDS = 22
local cardList = {}
for itr = 0, NUMBER_TAROT_CARDS do
    if itr ~= Card.CARD_EMPEROR then
        table.insert(cardList, itr)
    end
end

local function GetSpawnCount(player)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE) then return 1 end
    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE)
    return TSIL.Random.GetRandomInt(1, 2, rng)
end

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ACID_PENNY, function (_, player)
    local randomPill = PillEffect.PILLEFFECT_BAD_GAS
    local counter = 0
    repeat
        counter = counter + 1
        if counter == TIMES_CAN_FAIL then break end -- For the unluckiest person in the world
        randomPill = Game():GetItemPool():GetPill(Random() + 1)
    until randomPill ~= PillEffect.PILLEFFECT_TELEPILLS

    local realPhd = false
    local falsePhd = player:HasCollectible(CollectibleType.COLLECTIBLE_FALSE_PHD)

    for _, collectible in ipairs(positivePillCollectibles) do
        if player:HasCollectible(collectible) then
            realPhd = true
        end
    end

    if falsePhd and not realPhd then
        randomPill = TSIL.Pills.GetFalsePHDPillEffect(randomPill)
    elseif realPhd and not falsePhd then
        randomPill = TSIL.Pills.GetPHDPillEffect(randomPill)
    end
    player:UsePill(randomPill, PillColor.PILL_NULL)
    --player:AddPill(randomPill)
    --SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
end, 0.15)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLESSED_PENNY, function (_, player)
    player:AddSoulHearts(1)
    SFXManager():Play(SoundEffect.SOUND_HOLY)
end, 0.15)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLOODY_PENNY, function (_, player)
    player:AddHearts(1)
    SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
end, 0.45)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BURNT_PENNY, function (_, player)
    if player:GetPlayerType() ~= PlayerType.PLAYER_BLUEBABY_B then
        player:AddBombs(GetSpawnCount(player))
    else
        player:AddPoopMana(1)
    end
    SFXManager():Play(SoundEffect.SOUND_FETUS_FEET)
end, 0.45)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BUTT_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, UseFlag.USE_NOANIM)
end, 0.25)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CHARGED_PENNY, function (_, player)
    if not player:NeedsCharge(ActiveSlot.SLOT_PRIMARY) then return end
    TSIL.Charge.AddCharge(player)
end, 0.25)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.COUNTERFEIT_PENNY, function (_, player)
    player:AddCoins(1)
    SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
end, 0.25)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CRYSTAL_PENNY, function (_, player)
    local rng = TSIL.RNG.NewRNG()
    local randomCard = TSIL.Random.GetRandomElementsFromTable(cardList, 1, rng)
    player:UseCard(randomCard[1])
    --local cardName = Isaac.GetItemConfig():GetCard(randomCard).Name
    --Game():GetHUD():ShowItemText(cardName, "")
    --player:AddCard(randomCard)
    --SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
end, 0.15)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CURSED_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT, UseFlag.USE_NOANIM)
end, 0.10)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.FLAT_PENNY, function (_, player)
    player:AddKeys(GetSpawnCount(player))
    SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
end, 0.45)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ROTTEN_PENNY, function (pickup, player)
    player:AddBlueFlies(1, pickup.Position, player)
end, 0.25)

MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function (_, pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_COIN
    or (PickupVariant == PickupVariant.PICKUP_COIN and pickup.SubType ~= 1) then return end
    local sprite = pickup:GetSprite()
    if sprite:IsEventTriggered("DropSound") then
        SFXManager():Play(SoundEffect.SOUND_PENNYDROP)
    end
end)

function MilkshakeVol1:PostPickupInit(pickup)
    if (Game().Difficulty == Difficulty.DIFFICULTY_GREED or Game().Difficulty == Difficulty.DIFFICULTY_GREEDIER)
    or MilkshakeVol1.utility:DidEntityExist()
    or (Epiphany and MilkshakeVol1.utility:AnyPlayerIsCharacter(Epiphany.PlayerType.KEEPER)) then return end
    local chance
    if MilkshakeVol1.utility:AnyPlayerIsCharacter(PlayerType.PLAYER_KEEPER_B) then
        chance = KEEPERB_REPLACE_CHANCE
    else
        chance = REPLACE_CHANCE
    end
    MilkshakeVol1.API:TryReplacePickupWithRainbowPenny(pickup, chance, true)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, MilkshakeVol1.PostPickupInit)