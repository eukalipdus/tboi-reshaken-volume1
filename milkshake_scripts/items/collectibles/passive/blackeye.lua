local blackEye = {}
local Enums = MilkshakeVol1.enums

local blackEyeData = {
    FIRE_DELAY = 1.50
}

function blackEye:onCache(player, cacheFlag)
    if player == nil then return end
    if player:HasCollectible(Enums.Collectibles.BLACK_EYE) then
        if cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay - blackEyeData.FIRE_DELAY
        end
    end
end

function blackEye:AddKnockback(player)
    if player:GetCollectibleNum(Enums.Collectibles.BLACK_EYE) > 0 then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_KNOCKBACK
    end
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, blackEye.AddKnockback, CacheFlag.CACHE_TEARFLAG)
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, blackEye.onCache)
return blackEye