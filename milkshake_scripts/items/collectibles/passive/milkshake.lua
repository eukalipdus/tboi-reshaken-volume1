local milkshake = {}
local enums = milkshakeMod.enums

local milkshakeData = {
    TEAR_COLOR = Color(1, 0, 1, 1, 0.196, 0, 0)
}


---@param rng RNG
---@param itemNum integer
local function GetStatMultiplier(rng, itemNum)
    local baseMultiplier = TSIL.Random.GetRandomFloat(1.1, 1.5, rng)
    local totalMultiplier = 1

    for _ = 1, itemNum, 1 do
        totalMultiplier = totalMultiplier * baseMultiplier
    end

    return totalMultiplier
end


---@param player EntityPlayer
---@param cacheFlag CacheFlag
function milkshake:onCache(player, cacheFlag)
    if not player:HasCollectible(enums.Collectibles.MILKSHAKE) then return end

    local rng = TSIL.RNG.CopyRNG(player:GetCollectibleRNG(enums.Collectibles.MILKSHAKE))
    local itemNum = player:GetCollectibleNum(enums.Collectibles.MILKSHAKE)

    local MilkShakeTears = 1 / GetStatMultiplier(rng, itemNum)
    local MilkShakeDamage = GetStatMultiplier(rng, itemNum)
    local MilkShakeSpeed = GetStatMultiplier(rng, itemNum)
    local MilkShakeLuck = GetStatMultiplier(rng, itemNum)
    local MilkShakeRange = GetStatMultiplier(rng, itemNum)
    local MilkShakeShotSpeed = GetStatMultiplier(rng, itemNum)

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay * MilkShakeTears
    end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * MilkShakeDamage
    end

    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * MilkShakeSpeed
    end

    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck * MilkShakeLuck
    end

    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange * MilkShakeRange
    end

    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed * MilkShakeShotSpeed
    end

    if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        player.TearColor = milkshakeData.TEAR_COLOR
    end
end
milkshakeMod:AddPriorityCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    CallbackPriority.LATE + 2000, --Very low priority so the multiplier works with mods
    milkshake.onCache
)


---@param player EntityPlayer
---@param firstTime boolean
function milkshake:OnMilkshakeAdded(player, _, firstTime)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B and not firstTime then return end

    local rng = TSIL.RNG.CopyRNG(player:GetCollectibleRNG(enums.Collectibles.MILKSHAKE))
    local itemNum = player:GetCollectibleNum(enums.Collectibles.MILKSHAKE)

    for _ = 1, itemNum, 1 do
        rng:Next()
    end

    local chosenHeart = rng:RandomInt(3)

    if chosenHeart == 0 then
        player:AddMaxHearts(2)
        player:AddHearts(2)
    elseif chosenHeart == 1 then
        player:AddSoulHearts(2)
    elseif chosenHeart == 2 then
        player:AddBlackHearts(2)
    end
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    milkshake.OnMilkshakeAdded,
    {
        nil,
        enums.Collectibles.MILKSHAKE
    }
)