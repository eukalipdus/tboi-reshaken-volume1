local PrismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local TIMES_CAN_FAIL = 1000
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220/255, 1, 0, 0, 0)
local RED = Color(141 / 255, 2 / 255, 0, 1, 141 / 255, 2 / 255, 0)
local BELIAL_RED = Color(1, 0.2, 0, 0.6)
local YELLOW = Color(135 / 255, 140 / 255, 20 / 255, 1, 135 / 255, 140 / 255, 20 / 255)
local BLUE = Color(4 / 255, 99 / 255, 147 / 255, 1, 4 / 255, 99 / 255, 147 / 255)
local BELIAL_DEVIL_CHANCE = 30
local COLOR_FRAMES = 15
local COLLECTIBLE_DIST_SHIFT = 40
local INITIAL_BREAKFAST_CHECK = 15

local antiRecursion = false

local breakfastsByQuality = {
    enums.Collectibles.SPOILED_BREAKFAST,
    CollectibleType.COLLECTIBLE_BREAKFAST,
    enums.Collectibles.BALANCED_BREAKFAST,
    enums.Collectibles.HEARTY_BREAKFAST,
    CollectibleType.COLLECTIBLE_BINGE_EATER,
    enums.Collectibles.GOLDEN_BREAKFAST
}

local forbiddenSplitItems = {
    CollectibleType.COLLECTIBLE_NULL,
    CollectibleType.COLLECTIBLE_DADS_NOTE
}

local oneHeart = math.abs(PickupPrice.PRICE_ONE_HEART)
local twoHearts = math.abs(PickupPrice.PRICE_TWO_HEARTS)
local threeSoulHearts = math.abs(PickupPrice.PRICE_THREE_SOULHEARTS)
local oneHeartTwoSoulHearts = math.abs(PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS)
local oneSoulHeart = math.abs(PickupPrice.PRICE_ONE_SOUL_HEART)
local twoSoulHearts = math.abs(PickupPrice.PRICE_TWO_SOUL_HEARTS)
local oneHeartOneSoulHeart = math.abs(PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART)

local heartPriceToHalf = {
    [oneHeart] = oneHeart,
    [twoHearts] = oneHeart,
    [threeSoulHearts] = twoSoulHearts,
    [oneHeartTwoSoulHearts] = oneHeartOneSoulHeart,
    [oneSoulHeart] = oneSoulHeart,
    [twoSoulHearts] = oneSoulHeart
}

local splitColors = {
    CYAN,
    PINK
}

local effectPerGodheadSplit = {
    {
        COLOR = YELLOW,
        OFFSET = Vector(COLLECTIBLE_DIST_SHIFT, 0),
        COLLECTIBLE = CollectibleType.COLLECTIBLE_MIND
    },
    {
        COLOR = BLUE,
        OFFSET = Vector(-COLLECTIBLE_DIST_SHIFT, 0),
        COLLECTIBLE = CollectibleType.COLLECTIBLE_SOUL
    },
    {
        COLOR = RED,
        OFFSET = Vector(0, COLLECTIBLE_DIST_SHIFT),
        COLLECTIBLE = CollectibleType.COLLECTIBLE_BODY
    },
}

---Returns the regular or greed version of an ItemPoolType
---@param poolType ItemPoolType
---@return ItemPoolType
local function GetProperPool(poolType)
    local isGreedMode = Game():IsGreedMode()

    if not isGreedMode then
        return poolType
    end

    if poolType == ItemPoolType.POOL_TREASURE then
        return ItemPoolType.POOL_GREED_TREASURE

    elseif poolType == ItemPoolType.POOL_DEVIL then
        return ItemPoolType.POOL_GREED_DEVIL

    else
        return poolType
    end
end

---Attempts to find a collectible that satisfies the given pool and quality. Returns nil on failure
---@param poolType ItemPoolType
---@param itemPool ItemPool
---@param forceQuality number
---@return integer | nil
local function TryGetCollectible(poolType, itemPool, forceQuality)
    local newCollectibleID
    local finalCollectibleId

    for itr = 1, TIMES_CAN_FAIL do
        antiRecursion = true
        newCollectibleID = itemPool:GetCollectible(poolType, false)
        antiRecursion = false

        if itr > INITIAL_BREAKFAST_CHECK then
            poolType = GetProperPool(ItemPoolType.POOL_TREASURE)
        end

        if Isaac.GetItemConfig():GetCollectible(newCollectibleID).Quality == forceQuality then
            finalCollectibleId = newCollectibleID
            break
        end
    end

    if finalCollectibleId then
        itemPool:RemoveCollectible(finalCollectibleId)
    end

    return finalCollectibleId
end

---Splits a collectible into two of 1 less quality
---@param iteration integer
---@param player EntityPlayer
---@param collectible EntityPickup
---@param itemPool ItemPool
---@param poolType ItemPoolType
---@param quality integer
---@return EntityPickup
local function SplitCollectible(iteration, player, collectible, itemPool, poolType, quality)
    local belialConversion = false
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        local roll = TSIL.Random.GetRandomInt(1, 100)
        if roll <= BELIAL_DEVIL_CHANCE then
            poolType = GetProperPool(ItemPoolType.POOL_DEVIL)
            belialConversion = true
        end
    end

    local newCollectibleID = TryGetCollectible(
        poolType,
        itemPool,
        quality
    )

    if not newCollectibleID
    and breakfastsByQuality[quality + 1] then
        newCollectibleID = breakfastsByQuality[quality + 1]
    end

    local spawnPosition
    local optionsIndex = collectible.OptionsPickupIndex

    if iteration == 1 then
        spawnPosition = Isaac.GetFreeNearPosition(
            collectible.Position,
            COLLECTIBLE_DIST_SHIFT
        )
        optionsIndex = collectible.OptionsPickupIndex
    else
        spawnPosition = Isaac.GetFreeNearPosition(
            collectible.Position,
            -COLLECTIBLE_DIST_SHIFT
        )
        if collectible.OptionsPickupIndex > 0 then
            optionsIndex = collectible.OptionsPickupIndex + 1
        end
    end

    local splitCollectible = Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        newCollectibleID,
        spawnPosition,
        Vector.Zero,
        player
    ):ToPickup()

    if belialConversion then
        local effect = TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.POOF02,
            2,
            splitCollectible.Position
        )
        effect:GetSprite().Color = BELIAL_RED
    end

    splitCollectible.OptionsPickupIndex = optionsIndex

    if collectible:IsShopItem() then
        splitCollectible.AutoUpdatePrice = false
        if collectible.Price > 0 then
            if iteration == 1 then
                splitCollectible.Price = math.ceil(collectible.Price / 2)
            else
                splitCollectible.Price = math.floor(collectible.Price / 2)
            end
        else
            local positivePrice = math.abs(collectible.Price)
            if heartPriceToHalf[positivePrice] then
                splitCollectible.Price = -heartPriceToHalf[positivePrice]
            end
        end
    end

    return splitCollectible
end

function PrismaticDice:PostGetCollectible()
    if antiRecursion then
        return
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_GET_COLLECTIBLE,
    PrismaticDice.PostGetCollectible
)

---@param rng RNG
---@param player EntityPlayer
---@param useFlags UseFlag
---@return table | nil
function PrismaticDice:UseItem(_, rng, player, useFlags)
    if useFlags & UseFlag.USE_CARBATTERY ~= 0 then
        return
    end

    SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)

    local roomCollectibles = TSIL.EntitySpecific.GetPickups(PickupVariant.PICKUP_COLLECTIBLE)

    if #roomCollectibles == 0 then
        return
    end

    local itemPool = Game():GetItemPool()
    local roomType = Game():GetRoom():GetType()
    local seed = rng:GetSeed()
    local poolType = itemPool:GetPoolForRoom(roomType, seed)

    if poolType == ItemPoolType.POOL_NULL then
        poolType = GetProperPool(ItemPoolType.POOL_TREASURE)
    end

    for _, collectible in pairs(roomCollectibles) do
        if not TSIL.Utils.Tables.IsIn(forbiddenSplitItems, collectible.SubType) then
            collectible:Remove()
            local newQuality = -1

            if collectible.SubType
            and Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality ~= nil then
                newQuality = Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality - 1
            end

            for idx = 1, 2 do
                if collectible.SubType == CollectibleType.COLLECTIBLE_GODHEAD then
                    for _, itemData in pairs(effectPerGodheadSplit) do
                        local splitCollectible = Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            itemData.COLLECTIBLE,
                            collectible.Position + itemData.OFFSET,
                            Vector.Zero,
                            player
                        )
                        splitCollectible:SetColor(itemData.COLOR, COLOR_FRAMES, 2, true, false)
                        break
                    end

                elseif newQuality >= 0 then
                    local splitTimes = 0

                    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
                        splitTimes = 2
                    end

                    if FiendFolio and player:HasTrinket(FiendFolio.ITEM.TRINKET.ETERNAL_CAR_BATTERY) then
                        splitTimes = splitTimes + 4 + rng:RandomInt(2)
                    end

                    if splitTimes == 0 then
                        splitTimes = 1
                    end

                    for _ = 1, splitTimes do
                        local splitCollectible = SplitCollectible(idx, player, collectible, itemPool, poolType, newQuality)
                        splitCollectible:SetColor(splitColors[idx], COLOR_FRAMES, 2, true, false)
                    end
                else
                    utility:RecycleCollectible(
                        collectible.Position,
                        player,
                        roomType,
                        itemPool,
                        collectible.DropSeed,
                        rng,
                        false,
                        1
                    )
                    break
                end
            end
        end
    end
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    PrismaticDice.UseItem,
    enums.Collectibles.PRISMATIC_DICE
)