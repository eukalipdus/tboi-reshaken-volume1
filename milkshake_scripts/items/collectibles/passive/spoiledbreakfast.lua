local spoiledBreakfast = {}
local enums = MilkshakeVol1.enums

function spoiledBreakfast:postPlayerCollectibleAdded(player, collectibleType)
    if collectibleType == enums.Collectibles.SPOILED_BREAKFAST
    and player:GetHearts() >= 2 then
        player:AddHearts(-1)
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, spoiledBreakfast.postPlayerCollectibleAdded)