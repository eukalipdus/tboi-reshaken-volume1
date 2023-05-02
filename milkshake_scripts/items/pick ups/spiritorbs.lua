local SpiritOrbs = {}
local enums = require("milkshake_scripts.enums")


local ORB_SUBTYPES = {
    [enums.Cards.AMETHYST_ORB] = true,
    [enums.Cards.EMERALD_ORB] = true,
    [enums.Cards.RUBY_ORB] = true,
    [enums.Cards.SAPPHIRE_ORB] = true,
    [enums.Cards.RANDOM_ORB] = true
}


---@param card EntityPickup
function SpiritOrbs:OnCardUpdate(card)
    if not ORB_SUBTYPES[card.SubType] then return end

    local sprite = card:GetSprite()

    if sprite:IsEventTriggered("DropSound") then
        SFXManager():Stop(SoundEffect.SOUND_SCAMPER)
        SFXManager():Play(SoundEffect.SOUND_GOLD_HEART_DROP)
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    SpiritOrbs.OnCardUpdate,
    PickupVariant.PICKUP_TAROTCARD
)


---@param card EntityPickup
function SpiritOrbs:OnCardRender(card)
    if not ORB_SUBTYPES[card.SubType] then return end

    local sprite = card:GetSprite()

    if sprite:IsPlaying("Collect") and sprite:GetFrame() == 0 and
    SFXManager():IsPlaying(SoundEffect.SOUND_BOOK_PAGE_TURN_12) then
        SFXManager():Stop(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
        SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PICKUP_RENDER,
    SpiritOrbs.OnCardRender,
    PickupVariant.PICKUP_TAROTCARD
)
