local UnholyOrb = {}


---@param player EntityPlayer
function UnholyOrb:OnUnholyOrbUse(_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS)
end
MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.ON_ORB_USE,
    UnholyOrb.OnUnholyOrbUse,
    MilkshakeVol1.enums.Orbs.UNHOLY
)