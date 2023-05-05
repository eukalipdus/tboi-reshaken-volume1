local SpiritOrbs = {}
local enums = require("milkshake_scripts.enums")


---@param orb Card
---@param player any
function SpiritOrbs:OnCardUse(orb, player)
    local isDoublePower = false

    --Chaos orb doesn't use up the double lyra power
    if orb ~= enums.Orbs.RANDOM then
        ---@diagnostic disable-next-line: cast-local-type
        isDoublePower = MilkshakeVol1.utility:GetTemporaryPlayerData(player, "IsUsingDoublePowerOrb")
        MilkshakeVol1.utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", nil)
    end

    Isaac.RunCallbackWithParam(enums.Callbacks.ON_ORB_USE, orb, orb, player, isDoublePower)
end
for _, orb in pairs(enums.Orbs) do
    MilkshakeVol1:AddCallback(
        ModCallbacks.MC_USE_CARD,
        SpiritOrbs.OnCardUse,
        orb
    )
end


---@param card EntityPickup
function SpiritOrbs:OnCardUpdate(card)
    if not MilkshakeVol1.utility:IsSpiritOrb(card.SubType) then return end

    local sprite = card:GetSprite()

    if sprite:IsEventTriggered("DropSound") then
        SFXManager():Stop(SoundEffect.SOUND_SCAMPER)
        SFXManager():Play(SoundEffect.SOUND_GOLD_HEART_DROP)
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    SpiritOrbs.OnCardUpdate,
    PickupVariant.PICKUP_TAROTCARD
)


---@param card EntityPickup
function SpiritOrbs:OnCardRender(card)
    if not MilkshakeVol1.utility:IsSpiritOrb(card.SubType) then return end

    local sprite = card:GetSprite()

    if sprite:IsPlaying("Collect") and sprite:GetFrame() == 0 and
    SFXManager():IsPlaying(SoundEffect.SOUND_BOOK_PAGE_TURN_12) then
        SFXManager():Stop(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
        SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_RENDER,
    SpiritOrbs.OnCardRender,
    PickupVariant.PICKUP_TAROTCARD
)
