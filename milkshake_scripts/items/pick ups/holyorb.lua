local HolyOrb = {}


---@param player EntityPlayer
function HolyOrb:OnHolyOrbUse(_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_CRACK_THE_SKY)
end
MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.ON_ORB_USE,
    HolyOrb.OnHolyOrbUse,
    MilkshakeVol1.enums.Orbs.HOLY
)