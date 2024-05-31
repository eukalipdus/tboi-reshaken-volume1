local balancedBreakfast = {}
local enums = MilkshakeVol1.enums
local LUCK_UP = 1

function balancedBreakfast:onCache(player)
    player.Luck = player.Luck + LUCK_UP * player:GetCollectibleNum(enums.Collectibles.BALANCED_BREAKFAST)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, balancedBreakfast.onCache, CacheFlag.CACHE_LUCK)