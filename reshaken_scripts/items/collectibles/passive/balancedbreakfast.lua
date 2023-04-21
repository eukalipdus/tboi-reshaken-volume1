local balancedBreakfast = {}
local enums = milkshakeMod.enums
local LUCK_UP = 1

function balancedBreakfast:onCache(player, cacheFlag)
    if player:HasCollectible(enums.Collectibles.BALANCED_BREAKFAST) then
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + LUCK_UP
        end
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, balancedBreakfast.onCache)