local mod = MilkshakeVol1

local TrueTrueOrbs = {}; for k, v in pairs(mod.enums.Orbs) do
    if v ~= mod.enums.Orbs.RANDOM then
        TrueTrueOrbs[k] = v
    end
end

local ORBS = {}
local idx = 1
for _, v in pairs(TrueTrueOrbs) do
    ORBS[idx] = v
    idx = idx + 1
end

local NUM_ORBS = #ORBS - 1

local SELECTION_TO_FRAME = {
    0,
    1,
    2,
    3,
    5,
    6,
    7,
    8,
    9,
    10
}

local FRAME_TO_ORB = {
    mod.enums.Orbs.FIRE,
    mod.enums.Orbs.ELECTRIC,
    mod.enums.Orbs.NATURE,
    mod.enums.Orbs.PSYCHIC,
    mod.enums.Orbs.RANDOM,
    mod.enums.Orbs.HOLY,
    mod.enums.Orbs.UNHOLY,
    mod.enums.Orbs.POISON,
    mod.enums.Orbs.UNDEAD,
    mod.enums.Orbs.WATER,
    mod.enums.Orbs.ROCK,
}

local sprite = Sprite(); sprite:Load("gfx/ui/ui_orderspiritoverlay.anm2", true); sprite:Play(sprite:GetDefaultAnimation(), true)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
    if player:GetCard(0) ~= mod.enums.Orbs.ORDER then return end
    local data = mod:GetData(player, "SpiritOfOrder"); data.Selected = data.Selected or 1
    if not Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then return end

    data.Selected = data.Selected + 1; if data.Selected > NUM_ORBS then data.Selected = 1 end
    mod.SFX:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 1, 2, false, 1 + data.Selected * 0.1)
end)

local function GetCallback()
    if REPENTOGON then
        return ModCallbacks.MC_POST_HUD_RENDER
    end
    return ModCallbacks.MC_GET_SHADER_PARAMS
end

mod:AddCallback(GetCallback(), function ()
    if REPENTOGON and RoomTransition.IsRenderingBossIntro() then return end
    local player = Isaac.GetPlayer() if player:GetCard(0) ~= mod.enums.Orbs.ORDER then return end

    local renderPos = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
    + Vector(-16, -12)
    + Vector(-16, -6) * Options.HUDOffset

    sprite:Render(renderPos)
    sprite:SetFrame(SELECTION_TO_FRAME[mod:GetData(player, "SpiritOfOrder").Selected or 1])
end)

---@param player EntityPlayer
---@param flags UseFlag
mod:AddCallback(ModCallbacks.MC_USE_CARD, function (_, _, player, flags)
    MilkshakeVol1:UseSpiritOrb(FRAME_TO_ORB[SELECTION_TO_FRAME[mod:GetData(player, "SpiritOfOrder").Selected] + 1], player, 0)
    mod.SFX:Play(mod.enums.Sounds.ORB_CAPTURE)
end, mod.enums.Orbs.ORDER)