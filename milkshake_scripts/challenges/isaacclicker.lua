local isaacClicker = {}
local enums = MilkshakeVol1.enums

local inventory = {
    CollectibleType.COLLECTIBLE_BFFS,
    enums.Collectibles.SHARP_CURSOR
}

function isaacClicker:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.ISAAC_CLICKER then
        player:AddTrinket(TrinketType.TRINKET_ADOPTION_PAPERS)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false)
        for _, collectible in ipairs(inventory) do
            player:AddCollectible(collectible)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, isaacClicker.PostPlayerInit)

function isaacClicker:PreGetCollectible(poolType)
    if Game().Challenge ~= enums.Challenges.ISAAC_CLICKER then return end
    if poolType == ItemPoolType.POOL_GREED_TREASURE
    or poolType == ItemPoolType.POOL_TREASURE then
        return enums.Collectibles.SHARP_CURSOR
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, isaacClicker.PreGetCollectible)
return isaacClicker