local SataAndagi = {}


function SataAndagi:OnSataAndagiAdd()
    SFXManager():Play(MilkshakeVol1.enums.Sounds.SATA_ANDAGI)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    SataAndagi.OnSataAndagiAdd,
    {
        nil,
        nil,
        MilkshakeVol1.enums.Collectibles.SATA_ANDAGI
    }
)