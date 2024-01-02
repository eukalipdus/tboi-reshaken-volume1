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
return isaacClicker