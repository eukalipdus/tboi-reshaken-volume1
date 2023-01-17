local blackEye = {}
local Enums = require("milkshake_scripts.enums")

local blackEyeData = {
    FIRE_DELAY = 1.50
}

function blackEye:postTearInit(tear)
    if not tear then return end
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:HasCollectible(Enums.Collectibles.BLACK_EYE) then
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_KNOCKBACK
    end
end

function blackEye:onCache(player, cacheFlag)
    if player == nil then return end
    if player:HasCollectible(Enums.Collectibles.BLACK_EYE) then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.MaxFireDelay = player.MaxFireDelay - blackEyeData.FIRE_DELAY
        end
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, blackEye.postTearInit)
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, blackEye.onCache)
return blackEye