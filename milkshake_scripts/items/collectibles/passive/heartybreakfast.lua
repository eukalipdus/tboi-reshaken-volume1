local heartyBreakfast = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local LUCK_UP = 1
local DMG_UP = 0.5
local TEARS_UP = 0.3

function heartyBreakfast:onCache(player, cacheFlag)
    if player:HasCollectible(enums.Collectibles.HEARTY_BREAKFAST) then
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + LUCK_UP
        end

        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + DMG_UP
        end

        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = utility:TearsUp(player.MaxFireDelay, TEARS_UP)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, heartyBreakfast.onCache)