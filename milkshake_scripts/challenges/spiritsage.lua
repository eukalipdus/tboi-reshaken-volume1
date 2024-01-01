local spiritSage = {}
local enums = MilkshakeVol1.enums

function spiritSage:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.SPIRIT_SAGE then
        player:AddCollectible(enums.Collectibles.LYRA)
        TSIL.Utils.Functions.RunInFrames(function ()
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_LEMEGETON, true, ActiveSlot.SLOT_POCKET)
            player:SetPocketActiveItem(enums.Collectibles.SHATTERED_ORB)
            local shatteredOrbCharges = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.SHATTERED_ORB).MaxCharges
            player:SetActiveCharge(shatteredOrbCharges)
        end, 1, {})
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, spiritSage.PostPlayerInit)
return spiritSage