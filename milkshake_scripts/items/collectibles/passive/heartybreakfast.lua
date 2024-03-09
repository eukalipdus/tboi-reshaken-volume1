local heartyBreakfast = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local LUCK_UP = 1
local DMG_UP = 0.5
local TEARS_UP = 0.3

function heartyBreakfast:onCache(player, cacheFlag)
    local collectibleNum = player:GetCollectibleNum(enums.Collectibles.HEARTY_BREAKFAST)

    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + LUCK_UP * collectibleNum
    end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + DMG_UP * collectibleNum
    end

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = utility:TearsUp(player.MaxFireDelay, TEARS_UP * collectibleNum)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, heartyBreakfast.onCache)