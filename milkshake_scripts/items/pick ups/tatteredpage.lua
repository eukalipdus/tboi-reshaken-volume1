local enums = MilkshakeVol1.enums
local TatteredPage = {}


---@param player EntityPlayer
function TatteredPage:OnTatteredPageUse(_, player)
    player:UseActiveItem(
        CollectibleType.COLLECTIBLE_LEMEGETON,
        UseFlag.USE_NOANIM
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_USE_CARD,
    TatteredPage.OnTatteredPageUse,
    enums.Cards.TATTERED_PAGE
)


return TatteredPage