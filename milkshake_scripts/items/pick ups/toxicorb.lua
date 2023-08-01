local ToxicOrb = {}


---@param player EntityPlayer
function ToxicOrb:OnToxicOrbUse(_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_BEAN)
end
MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.ON_ORB_USE,
    ToxicOrb.OnToxicOrbUse,
    MilkshakeVol1.enums.Orbs.HOLY
)