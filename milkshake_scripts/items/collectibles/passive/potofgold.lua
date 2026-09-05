local potOfGold = {}

local enums = MilkshakeVol1.enums
local PENNY_CONVERT_CHANCE = 0.35

---@class RainbowPenny
---@field variant PickupVariant
---@field subtype integer
---@field onPickup fun(pickup: EntityPickup, player: EntityPlayer)
---@field weight number

---@type RainbowPenny[]
MilkshakeVol1.RainbowPennies = {}

local coinBlacklist = {
    CoinSubType.COIN_LUCKYPENNY,
    CoinSubType.COIN_GOLDEN
}

MilkshakeVol1.WeightedRainbowPennies = { -- Workaround to the other table making items added first being more common
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.ROTTEN_PENNY, weight = 0.25},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.FLAT_PENNY, weight = 0.50},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.BURNT_PENNY, weight = 0.50},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.BUTT_PENNY, weight = 0.25},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.CHARGED_PENNY, weight = 0.20},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.CURSED_PENNY, weight = 0.10},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.BLOODY_PENNY, weight = 0.45},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.BLESSED_PENNY, weight = 0.15},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.COUNTERFEIT_PENNY, weight = 0.25},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.ACID_PENNY, weight = 0.10},
    {variant = PickupVariant.PICKUP_COIN, subtype = enums.Coins.CRYSTAL_PENNY, weight = 0.10},
}

if FiendFolio then
    table.insert(MilkshakeVol1.WeightedRainbowPennies,
        {
            variant = PickupVariant.PICKUP_COIN,
            subtype = enums.Coins.SHARP_PENNY,
            weight = 0.15
        }
    )

    table.insert(MilkshakeVol1.WeightedRainbowPennies,
        {
            variant = PickupVariant.PICKUP_COIN,
            subtype = enums.Coins.EGG_PENNY,
            weight = 0.10
        }
    )

    table.insert(MilkshakeVol1.WeightedRainbowPennies,
        {
            variant = PickupVariant.PICKUP_COIN,
            subtype = enums.Coins.FUZZY_PENNY,
            weight = 0.25
        }
    )

    table.insert(MilkshakeVol1.WeightedRainbowPennies,
        {
            variant = PickupVariant.PICKUP_COIN,
            subtype = enums.Coins.MOLTEN_PENNY,
            weight = 0.05
        }
    )

    table.insert(MilkshakeVol1.WeightedRainbowPennies,
        {
            variant = PickupVariant.PICKUP_COIN,
            subtype = enums.Coins.SCARAB_PENNY,
            weight = 0.25
        }
    )

    table.insert(MilkshakeVol1.WeightedRainbowPennies,
        {
            variant = PickupVariant.PICKUP_COIN,
            subtype = enums.Coins.FLAMING_PENNY,
            weight = 0.05
        }
    )

    table.insert(MilkshakeVol1.WeightedRainbowPennies,
        {
            variant = PickupVariant.PICKUP_COIN,
            subtype = enums.Coins.STACKED_PENNY,
            weight = 0.05
        }
    )
end

--- Returns the proper chance to convert a penny
---@return number
local function GetConversionChance()
    if MilkshakeVol1.utility:AnyPlayerIsCharacter(PlayerType.PLAYER_KEEPER_B)
    or (Epiphany and MilkshakeVol1.utility:AnyPlayerIsCharacter(Epiphany.PlayerType.KEEPER))
    then
        return (PENNY_CONVERT_CHANCE / 2)
    else
        return PENNY_CONVERT_CHANCE
    end
end

---Adds a special penny to the pool of pennies spawnable by Pot Of Gold
---@param variant PickupVariant
---@param subtype integer
---@param onPickup fun(pickup: EntityPickup, player: EntityPlayer)
function MilkshakeVol1.API:AddRainbowPenny(variant, subtype, onPickup, weight)
    MilkshakeVol1.RainbowPennies[#MilkshakeVol1.RainbowPennies+1] = {
        variant = variant,
        subtype = subtype,
        onPickup = onPickup,
        weight = weight
    }
end

---Gives a random type of rainbow penny
---NOTE: Access the Variant through returnedNumber.variant, and SubType through returnedNumber.subtype
---@param rng RNG
---@return RainbowPenny
function MilkshakeVol1.API:GetRainbowPenny(rng)
    return TSIL.Random.GetRandomElementsFromTable(MilkshakeVol1.RainbowPennies, 1, rng)[1]
end

---Gives you a random rainbow penny, selecting them through their weight
---@param rng RNG
---@return RainbowPenny
function MilkshakeVol1.API:GetWeightedRainbowPenny(rng)
    local total = 0
    for i = 1, #MilkshakeVol1.WeightedRainbowPennies do
        total = total + MilkshakeVol1.WeightedRainbowPennies[i].weight
    end
    local randomFloat = TSIL.Random.GetRandomFloat(0, total, rng)
    for i = 1, #MilkshakeVol1.WeightedRainbowPennies do
        if randomFloat < MilkshakeVol1.WeightedRainbowPennies[i].weight then
            return MilkshakeVol1.WeightedRainbowPennies[i]
        end
        randomFloat = randomFloat - MilkshakeVol1.WeightedRainbowPennies[i].weight
    end

    return MilkshakeVol1.WeightedRainbowPennies[1]
end

---@param pickup EntityPickup
local function CanPickupBeReplaced(pickup, convertChance, isNatural)
    local pickupSeed = pickup.InitSeed

    if pickupSeed == 0 then
        pickupSeed = 1
    end

    local isBombAndNotTroll = pickup.Variant == PickupVariant.PICKUP_BOMB
                              and pickup.SubType ~= BombVariant.BOMB_TROLL
                              and pickup.SubType ~= BombVariant.BOMB_SUPERTROLL
                              and pickup.SubType ~= BombVariant.BOMB_GOLDENTROLL

    local rng = TSIL.RNG.NewRNG(pickupSeed)
    local roll = rng:RandomFloat()
    if (not isNatural and (pickup.Variant == PickupVariant.PICKUP_KEY or isBombAndNotTroll))
    or (pickup.Variant == PickupVariant.PICKUP_COIN and roll <= convertChance and not TSIL.Utils.Tables.IsIn(coinBlacklist, pickup.SubType))
    or (not isNatural and (pickup.Variant == PickupVariant.PICKUP_COIN and (pickup.SubType == CoinSubType.COIN_NICKEL or pickup.SubType == CoinSubType.COIN_DIME or pickup.SubType == CoinSubType.COIN_STICKYNICKEL))) then
        return true
    end
    return false
end

---@param pickup EntityPickup
function MilkshakeVol1.API:TryReplacePickupWithRainbowPenny(pickup, chance, isNatural)
    if not CanPickupBeReplaced(pickup, chance, isNatural)
    or (not TSIL.Players.DoesAnyPlayerHasItem(MilkshakeVol1.enums.Collectibles.POT_OF_GOLD)
        and not isNatural)
    then return end

    --local rng = TSIL.RNG.NewRNG(pickup.InitSeed)
    local rng = pickup:GetDropRNG()
    local chosenCoin = MilkshakeVol1.API:GetWeightedRainbowPenny(rng)

    pickup:Morph(
        pickup.Type,
        chosenCoin.variant,
        chosenCoin.subtype,
        true,
        false
    )
end

---@param pickup EntityPickup
function potOfGold:OnPickupUpdate(pickup)
    MilkshakeVol1.API:TryReplacePickupWithRainbowPenny(pickup, GetConversionChance())
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    potOfGold.OnPickupUpdate
)


function potOfGold:PostPickupInit(pickup)
    MilkshakeVol1.API:TryReplacePickupWithRainbowPenny(pickup, GetConversionChance())
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    potOfGold.PostPickupInit
)


-- function potOfGold:PostPEffectUpdate(player)
--     if not player:HasCollectible(MilkshakeVol1.enums.Collectibles.POT_OF_GOLD) then return end
--     local rng = player:GetCollectibleRNG(enums.Collectibles.POT_OF_GOLD)
--     local pickups = TSIL.EntitySpecific.GetPickups()

--     for _, pickup in pairs(pickups) do
--         if pickup.Variant == PickupVariant.PICKUP_KEY
--         or pickup.Variant == PickupVariant.PICKUP_BOMB then
--             local chosenCoin = TSIL.Random.GetRandomElementsFromTable(MilkshakeVol1.RainbowPennies, 1, rng)[1]
--             pickup:Remove()
--             local coin = TSIL.EntitySpecific.SpawnPickup(chosenCoin.variant, chosenCoin.subtype, pickup.Position, Vector.Zero, player):ToPickup()
--             coin.AutoUpdatePrice = false
--             coin.Price = pickup.Price
--         end
--     end
-- end
-- MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, potOfGold.PostPEffectUpdate)

return potOfGold