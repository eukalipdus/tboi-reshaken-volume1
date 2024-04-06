local mod = MilkshakeVol1
local utils = mod.utility
local enums = mod.enums
local orbs = utils:GetOrbs()

local ORB_ID = enums.Orbs.ORDER

local game = Game()
local sfx = SFXManager()

local frameToOrb = {
    enums.Orbs.FIRE,
    enums.Orbs.ELECTRIC,
    enums.Orbs.NATURE,
    enums.Orbs.PSYCHIC,
    enums.Orbs.RANDOM,
    enums.Orbs.HOLY,
    enums.Orbs.UNHOLY,
    enums.Orbs.POISON,
    enums.Orbs.UNDEAD,
    enums.Orbs.WATER,
    enums.Orbs.ROCK,
}

---@return Sprite
local function createSprite()
    local sprite = Sprite()

    sprite:Load("gfx/ui/ui_orderspiritoverlay.anm2", true)
    sprite:Play(sprite:GetDefaultAnimation(), true)

    return sprite
end

---@type Sprite[]
local sprites = {
    createSprite(),
    createSprite(),
    createSprite(),
    createSprite(),
}

local orbsPerPlayer = {}

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_USE_CARD, function (_, _, player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    MilkshakeVol1:UseSpiritOrb(frameToOrb[orbsPerPlayer[playerIndex]], player, 0)
    sfx:Play(enums.Sounds.ORB_CAPTURE)
end, ORB_ID)

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
    if player:GetCard(0) == ORB_ID then
        local playerIndex = TSIL.Players.GetPlayerIndex(player)

        if orbsPerPlayer[playerIndex] and Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then
            orbsPerPlayer[playerIndex] = orbsPerPlayer[playerIndex] + 1

            if orbsPerPlayer[playerIndex] > #orbs - 1 then
                orbsPerPlayer[playerIndex] = 1
            end

            sfx:Play(SoundEffect.SOUND_GOLD_HEART_DROP, 1, 2, false, 1 + orbsPerPlayer[playerIndex] * 0.1)
        end
    end
end)

local function onRender()
    for i = 0, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i)

        if player:GetCard(0) == ORB_ID then
            local controllerIndex = player.ControllerIndex + 1
            local playerIndex = TSIL.Players.GetPlayerIndex(player)

            if not orbsPerPlayer[playerIndex] then
                orbsPerPlayer[playerIndex] = 1
            end

            local sprite = sprites[controllerIndex]

            local renderPos = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
            + Vector(-16, -12)
            + Vector(-16, -6) * Options.HUDOffset

            sprite:Render(renderPos)
            sprite:SetFrame(orbsPerPlayer[playerIndex] - 1)
        end
    end
end
if REPENTOGON then
    mod:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, onRender)
else
    mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, onRender)
end