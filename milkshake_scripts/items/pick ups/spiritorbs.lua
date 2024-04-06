local SpiritOrbs = {}
local enums = MilkshakeVol1.enums

local SoundPerOrb = {
    [enums.Orbs.ELECTRIC] = enums.Sounds.SPIRIT_CONDUCTIVITY,
    [enums.Orbs.FIRE] = enums.Sounds.SPIRIT_INFERNO,
    [enums.Orbs.HOLY] = enums.Sounds.SPIRIT_SALVATION,
    [enums.Orbs.NATURE] = enums.Sounds.SPIRIT_DRUIDITY,
    [enums.Orbs.POISON] = enums.Sounds.SPIRIT_VIRULENCE,
    [enums.Orbs.PSYCHIC] = enums.Sounds.SPIRIT_CLAIRVOYANCE,
    [enums.Orbs.RANDOM] = enums.Sounds.SPIRIT_CHAOS,
    [enums.Orbs.ROCK] = enums.Sounds.SPIRIT_TERRASTRIUM,
    [enums.Orbs.UNDEAD] = enums.Sounds.SPIRIT_REVENANCE,
    [enums.Orbs.UNHOLY] = enums.Sounds.SPIRIT_SACRILEGE,
    [enums.Orbs.WATER] = enums.Sounds.SPIRIT_DELUGE,
    [enums.Orbs.ORDER] = 0,
}

---@param orb Card
---@param player EntityPlayer
---@param flags UseOrbFlag | integer
function MilkshakeVol1:UseSpiritOrb(orb, player, flags)
    if not TSIL.Utils.Flags.HasFlags(flags, enums.UseOrbFlags.NO_SOUND) then
        SFXManager():Play(SoundPerOrb[orb])
    end

    Isaac.RunCallbackWithParam(enums.Callbacks.ON_ORB_USE, orb, orb, player, flags)
end


---@param orb Card
---@param player any
function SpiritOrbs:OnCardUse(orb, player)
    MilkshakeVol1:UseSpiritOrb(
        orb,
        player,
        enums.UseOrbFlags.ALLOW_LYRA
    )
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
    local triggeredDrop = sprite:IsEventTriggered("DropSound")

    if triggeredDrop then
        SFXManager():Stop(SoundEffect.SOUND_SCAMPER)
    end

    if card.SubType == enums.Orbs.ORDER
    and sprite:IsPlaying("Appear") then
        if sprite:GetFrame() == 23 then
            SFXManager():Play(enums.Sounds.ORB_DROP)
        end
    elseif triggeredDrop then
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
        if card.SubType == enums.Orbs.ORDER then
            SFXManager():Play(enums.Sounds.ORB_PICKUP)
        else
            SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_RENDER,
    SpiritOrbs.OnCardRender,
    PickupVariant.PICKUP_TAROTCARD
)


---@param rng RNG
---@param card Card
---@param playing boolean
---@param runes boolean
---@param onlyRunes boolean
function SpiritOrbs:GetCard(rng, card, playing, runes, onlyRunes)
    if MilkshakeVol1.utility:IsSpiritOrb(card) then
        local itemPool = Game():GetItemPool()

        return itemPool:GetCard(rng:Next(), playing, runes, onlyRunes)
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_GET_CARD,
    SpiritOrbs.GetCard
)