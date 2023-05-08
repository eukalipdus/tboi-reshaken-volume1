local balancedBreakfast = {}
local enums = MilkshakeVol1.enums
local LUCK_UP = 1

function balancedBreakfast:onCache(player, cacheFlag)
    if player:HasCollectible(enums.Collectibles.BALANCED_BREAKFAST) then
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + LUCK_UP
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, balancedBreakfast.onCache)