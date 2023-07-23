local rainbowFragment = {}

---@param player EntityPlayer
function rainbowFragmet:EvaluateCache(player)
    player.Luck = player.Luck + player:GetCollectibleNum(MilkshakeVol1.enums.Collectibles.RA)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rainbowFragment.EvaluateCache, CacheFlag.CACHE_LUCK)