local spiritSage = {}
local enums = MilkshakeVol1.enums

local inventory = {
    enums.Collectibles.SHATTERED_ORB,
    enums.Collectibles.LYRA
}

function spiritSage:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.SPIRIT_SAGE then
        for _, collectible in ipairs(inventory) do
            player:AddCollectible(collectible)
        end
        local shatteredOrbCharges = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.SHATTERED_ORB).MaxCharges
        player:SetActiveCharge(shatteredOrbCharges)
        TSIL.Utils.Functions.RunInFrames(function ()
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_LEMEGETON, true, ActiveSlot.SLOT_POCKET)
        end, 1, {})
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, spiritSage.PostPlayerInit)
return spiritSage