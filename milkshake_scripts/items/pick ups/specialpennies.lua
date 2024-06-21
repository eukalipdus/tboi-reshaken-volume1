local enums = MilkshakeVol1.enums

local REPLACE_CHANCE = 0.01
local RAINBOW_COOKIE_CHANCE = 0.1
local RAINBOW_COOKIE_CHANCE_INCREASE = 0.05
local TIMES_CAN_FAIL = 5000
local BASE_DELAY_NEXT_CARDPILL = 30
local CARDPILL_USE_DELAY = 15
local VANILLA_PILLCOLOR_COUNT = 13

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

---Returns the sum of the trinket multiplier for all players for Rainbow Cookie
---@return number
local function GetTotalTrinketMultiplier()
    local multiplier = 0
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        multiplier = multiplier + player:GetTrinketMultiplier(enums.Trinkets.RAINBOW_COOKIE)
    end
    return multiplier - 1
end

---Calculates and returns the chance for a Rainbow Penny to spawn
---@return number
local function GetRainbowPennySpawnChance()
    local spawnChance = REPLACE_CHANCE
    if TSIL.Players.DoesAnyPlayerHasTrinket(enums.Trinkets.RAINBOW_COOKIE) then
        local trinketMultiplierIncrease = RAINBOW_COOKIE_CHANCE_INCREASE * GetTotalTrinketMultiplier()
        spawnChance = RAINBOW_COOKIE_CHANCE + trinketMultiplierIncrease
    elseif MilkshakeVol1.utility:AnyPlayerIsCharacter(PlayerType.PLAYER_KEEPER_B) then
        spawnChance = 0
    end
    return spawnChance
end

---Returns how many of a given pickup a rainbow penny should give
---@param player EntityPlayer
---@return integer
local function GetActivationCount(player)
    if player:HasTrinket(enums.Trinkets.RAINBOW_COOKIE) then
        return 2
    end
    return 1
end

---Activate per Acid Penny activation
local function AcidPennyPickupEffect(player, rng)
    local randomPill = PillEffect.PILLEFFECT_BAD_GAS
    local counter = 0
    repeat
        counter = counter + 1
        if counter == TIMES_CAN_FAIL then break end -- For the unluckiest person in the world
        randomPill = Game():GetItemPool():GetPill(Random() + 1)
    until randomPill ~= PillEffect.PILLEFFECT_TELEPILLS and randomPill < 2048

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

    local effectToColor = {}
    for i = 1, PillColor.NUM_STANDARD_PILLS do
        effectToColor[Game():GetItemPool():GetPillEffect(i, player)] = i
    end

    if effectToColor[randomPill] then
        --print(effectToColor[randomPill])
        Game():GetItemPool():IdentifyPill(effectToColor[randomPill])
    end

    local randomPillColor = rng:RandomInt(VANILLA_PILLCOLOR_COUNT) + 1

    player:AnimatePill(randomPillColor, "Pickup")
    SFXManager():Play(SoundEffect.SOUND_SHELLGAME)

    TSIL.Utils.Functions.RunInFrames(function ()
        player:UsePill(randomPill, PillColor.PILL_NULL, UseFlag.USE_NOANNOUNCER)
    end, CARDPILL_USE_DELAY, {})
end

---Activate per Crystal Penny activation
---@param player EntityPlayer
---@param rng Rng
local function CrystalPennyPickupEffect(player, rng)
    local randomCard = TSIL.Random.GetRandomElementsFromTable(cardList, 1, rng)
    player:AnimateCard(randomCard[1], "Pickup")
    SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)

    TSIL.Utils.Functions.RunInFrames(function ()
        player:UseCard(randomCard[1], UseFlag.USE_NOANNOUNCER)
    end, CARDPILL_USE_DELAY, {})
end

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ACID_PENNY, function (_, player)
    local timesToActivate = 1
    if player:HasTrinket(enums.Trinkets.RAINBOW_COOKIE) then
        timesToActivate = 2
    end
    local delay = BASE_DELAY_NEXT_CARDPILL
    for i = 1, timesToActivate do
        if i > 1 then
            TSIL.Utils.Functions.RunInFrames(AcidPennyPickupEffect, delay, player, player:GetDropRNG())
            delay = delay + BASE_DELAY_NEXT_CARDPILL
        else
            AcidPennyPickupEffect(player, player:GetDropRNG())
        end
    end
end, 0.15)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLESSED_PENNY, function (_, player)
    player:AddSoulHearts(GetActivationCount(player))
    SFXManager():Play(SoundEffect.SOUND_HOLY)
end, 0.15)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BLOODY_PENNY, function (_, player)
    player:AddHearts(GetActivationCount(player))
    SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
end, 0.45)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BURNT_PENNY, function (_, player)
    if player:GetPlayerType() ~= PlayerType.PLAYER_BLUEBABY_B then
        player:AddBombs(GetSpawnCount(player) + GetActivationCount(player))
    else
        player:AddPoopMana(GetActivationCount(player))
    end
    SFXManager():Play(SoundEffect.SOUND_FETUS_FEET)
end, 0.45)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.BUTT_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, UseFlag.USE_NOANIM)
end, 0.25)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CHARGED_PENNY, function (_, player)
    if not player:NeedsCharge(ActiveSlot.SLOT_PRIMARY) then return end
    TSIL.Charge.AddCharge(player, nil, GetActivationCount(player))
end, 0.25)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.COUNTERFEIT_PENNY, function (_, player)
    player:AddCoins(GetActivationCount(player))
    SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
end, 0.25)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CRYSTAL_PENNY, function (_, player)
    local rng = TSIL.RNG.NewRNG()
    local timesToActivate = 1
    if player:HasTrinket(enums.Trinkets.RAINBOW_COOKIE) then
        timesToActivate = 2
    end
    local delay = BASE_DELAY_NEXT_CARDPILL
    for i = 1, timesToActivate do
        if i > 1 then
            TSIL.Utils.Functions.RunInFrames(CrystalPennyPickupEffect, delay, player, rng)
            delay = delay + BASE_DELAY_NEXT_CARDPILL
        else
            CrystalPennyPickupEffect(player, rng, delay)
        end
    end
    --local cardName = Isaac.GetItemConfig():GetCard(randomCard).Name
    --Game():GetHUD():ShowItemText(cardName, "")
    --player:AddCard(randomCard)
    --SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
end, 0.15)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.CURSED_PENNY, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT, UseFlag.USE_NOANIM)
end, 0.10)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.FLAT_PENNY, function (_, player)
    player:AddKeys(GetSpawnCount(player) + GetActivationCount(player))
    SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
end, 0.45)

MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, enums.Coins.ROTTEN_PENNY, function (pickup, player)
    player:AddBlueFlies(GetActivationCount(player), pickup.Position, player)
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
    --if not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.RAINBOW_PENNIES)
    if (Game().Difficulty == Difficulty.DIFFICULTY_GREED or Game().Difficulty == Difficulty.DIFFICULTY_GREEDIER)
    or MilkshakeVol1.utility:DidEntityExist()
    or (Epiphany and MilkshakeVol1.utility:AnyPlayerIsCharacter(Epiphany.PlayerType.KEEPER)) then
        return
    end
    local chance = GetRainbowPennySpawnChance()
    print("chance is " .. chance)
    MilkshakeVol1.API:TryReplacePickupWithRainbowPenny(pickup, chance, true)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, MilkshakeVol1.PostPickupInit)