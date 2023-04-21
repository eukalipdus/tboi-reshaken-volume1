local spoiledBreakfast = {}
local enums = milkshakeMod.enums

function spoiledBreakfast:postPlayerCollectibleAdded(player, collectibleType)
    if collectibleType == enums.Collectibles.SPOILED_BREAKFAST
    and player:GetHearts() >= 2 then
        player:AddHearts(-1)
    end
end
milkshakeMod:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, spoiledBreakfast.postPlayerCollectibleAdded)