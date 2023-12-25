local worldOfLight = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local ignore = 0

function worldOfLight:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.WORLD_OF_LIGHT then
        player:AddCollectible(enums.Collectibles.PRISMATIC_DICE)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, worldOfLight.PostPlayerInit)

function worldOfLight:PostPickupInit(pickup)
    if ignore ~= 0
    or Game().Challenge ~= enums.Challenges.WORLD_OF_LIGHT
    or pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE
    or utility:DidEntityExist() then return end
    local quality = Isaac.GetItemConfig():GetCollectible(pickup.SubType).Quality
    local newCollectibleID
    TSIL.Utils.Functions.RunInFrames(function ()
        pickup:Remove()
        ignore = ignore + 1
        MilkshakeVol1.API.SplitCollectible(Isaac.GetPlayer(), pickup, quality-1, newCollectibleID, quality)
        SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
        TSIL.Utils.Functions.RunInFrames(function ()
            ignore = ignore - 1
        end, 1, {})
    end, 2, {})
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, worldOfLight.PostPickupInit)

return worldOfLight