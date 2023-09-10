local rainbowFragment = {}

local PENNY_COUNT = 4
local MAX_ROLL_RETRY_COUNT = 200 --I'm not taking any chances okay.
local LUCK_BONUS = 1

---@param player EntityPlayer
function rainbowFragment:EvaluateCache(player)
    player.Luck = player.Luck + LUCK_BONUS*player:GetCollectibleNum(MilkshakeVol1.enums.Collectibles.RAINBOW_FRAGMENT)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, rainbowFragment.EvaluateCache, CacheFlag.CACHE_LUCK)

---@param player EntityPlayer
function rainbowFragment:PostItemAdded(player, _, firstTime)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B and firstTime == false then
        return  --(T)Isaac we (don't) love you!
    end
    local rng = player:GetCollectibleRNG(MilkshakeVol1.enums.Collectibles.RAINBOW_FRAGMENT)
    local spawnedPennies = {}
    for i=1,PENNY_COUNT do
        local penny = MilkshakeVol1.API:GetRainbowPenny(rng)
        for y=1, MAX_ROLL_RETRY_COUNT do
            if not spawnedPennies[penny] then
                break
            end
            penny = MilkshakeVol1.API:GetRainbowPenny(rng)
        end
        spawnedPennies[penny] = true

        local position = Isaac.GetFreeNearPosition(player.Position, 15)
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            penny.variant,
            penny.subtype,
            position,
            Vector.Zero,
            player
        )
    end
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    rainbowFragment.PostItemAdded,
    {
        nil,
        nil,
        MilkshakeVol1.enums.Collectibles.RAINBOW_FRAGMENT,
    }
)