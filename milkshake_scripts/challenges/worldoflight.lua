local worldOfLight = {}
local enums = MilkshakeVol1.enums

function worldOfLight:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.WORLD_OF_LIGHT then
        player:AddCollectible(enums.Collectibles.PRISMATIC_DICE)
        local prismaticDiceCharges = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.PRISMATIC_DICE).MaxCharges
        player:SetActiveCharge(prismaticDiceCharges)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, worldOfLight.PostPlayerInit)

function worldOfLight:PostNewRoom()
    if not Game():GetRoom():IsFirstVisit()
    or Game().Challenge ~= enums.Challenges.WORLD_OF_LIGHT then return end
    local collectibles = TSIL.PickupSpecific.GetCollectibles()
    for _, currentCollectible in ipairs(collectibles) do
        local quality = Isaac.GetItemConfig():GetCollectible(currentCollectible.SubType).Quality
        local newCollectibleID
        TSIL.Utils.Functions.RunInFrames(function ()
            currentCollectible:Remove()
            MilkshakeVol1.API.SplitCollectible(Isaac.GetPlayer(), currentCollectible:ToPickup(), quality-1, newCollectibleID, quality)
            SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
        end, 1, {})
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, worldOfLight.PostNewRoom)

return worldOfLight