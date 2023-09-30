local rockOrb = {}
local enums = MilkshakeVol1.enums

function rockOrb:OnUse(_, player, _)
    player:UseCard(Card.CARD_TOWER, UseFlag.USE_NOANIM)
    player:UseCard(Card.CARD_REVERSE_TOWER, UseFlag.USE_NOANIM)
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, rockOrb.OnUse)

return rockOrb