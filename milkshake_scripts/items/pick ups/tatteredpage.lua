local enums = MilkshakeVol1.enums
local TatteredPage = {}


---@param rng RNG
---@param onlyRunes boolean
function TatteredPage:OnGetCard(rng, _, _, _, onlyRunes)
    if onlyRunes then return end

    if rng:RandomFloat() < 0.02 then
        return enums.Cards.TATTERED_PAGE
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_GET_CARD,
    TatteredPage.OnGetCard
)


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