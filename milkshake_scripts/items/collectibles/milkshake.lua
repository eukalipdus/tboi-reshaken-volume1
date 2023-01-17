local milkshake = {}
local enums = require("milkshake_scripts.enums")
local utility = require("milkshake_scripts.utility")


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

    local MilkShakeTears = 1 - (GetStatMultiplier(rng, itemNum) - 1)
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
end
milkshakeMod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE + 2000, milkshake.onCache)--Very low priority so the multiplier works with mods