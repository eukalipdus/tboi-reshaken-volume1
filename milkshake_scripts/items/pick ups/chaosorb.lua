local ChaosOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility


local SPRITESHEET_PER_ORB = {
    [enums.Orbs.PSYCHIC] = "spirit_psychic",
    [enums.Orbs.FIRE] = "spirit_fire",
    [enums.Orbs.NATURE] = "spirit_nature",
    [enums.Orbs.ELECTRIC] = "spirit_electricity",
    [enums.Orbs.HOLY] = "spirit_holy",
    [enums.Orbs.UNHOLY] = "spirit_unholy",
    [enums.Orbs.POISON] = "spirit_poison",
    [enums.Orbs.UNDEAD] = "spirit_undead",
    [enums.Orbs.WATER] = "spirit_water",
    [enums.Orbs.ROCK] = "spirit_ground",
}

local moveOrbHudPerPlayer = {
    Vector(-15, -12),
    Vector(394, 147),
}

local playerAnchor = {
    "bottomright",
}

local function CreateOrbOverlay()
    local orbHud = Sprite()
    orbHud:Load("gfx/ui/ui_chaosorb.anm2", true)
    orbHud:Play("Spirit Of Chaos")
    return orbHud
end

local orbHuds = {
    CreateOrbOverlay(),
    CreateOrbOverlay(),
    CreateOrbOverlay(),
    CreateOrbOverlay(),
}

local NON_P1_SCALE = Vector(0.5, 0.5)

local frame = 1

---@param player EntityPlayer
---@param flags UseOrbFlag
function ChaosOrb:OnChaosOrbUse(_, player, flags)
    local rng = player:GetCardRNG(enums.Orbs.RANDOM)

    local orbToUse = MilkshakeVol1.utility:GetRandomSpiritOrb(false, rng)

    MilkshakeVol1:UseSpiritOrb(orbToUse, player, flags | enums.UseOrbFlags.NO_SOUND)

    local sprite = Sprite()
    sprite:Load("/gfx/chaos_orb_flash.anm2", true)
    local orbSpritesheet = SPRITESHEET_PER_ORB[orbToUse]
    sprite:ReplaceSpritesheet(1, "/gfx/items/pick ups/" .. orbSpritesheet .. ".png")
    sprite:LoadGraphics()
    sprite:Play("Idle", true)
    player:AnimatePickup(sprite)
end
MilkshakeVol1:AddCallback(
    enums.Callbacks.ON_ORB_USE,
    ChaosOrb.OnChaosOrbUse,
    enums.Orbs.RANDOM
)

function ChaosOrb:PostRender()
    frame = frame + 0.3
    if frame > 60 then frame = 1 end
    if Game():GetHUD():IsVisible() then
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i)
            if player:GetCard(0) == enums.Orbs.RANDOM then

                if player:GetPlayerType() ~= PlayerType.PLAYER_JACOB
                and player:GetPlayerType() ~= PlayerType.PLAYER_ESAU then
                    local position = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) + moveOrbHudPerPlayer[i]
                    local x, y = utility:HUDOffset(position.X, position.Y, playerAnchor[i])
                    position = Vector(x,y)
                    orbHuds[i]:Render(position)
                    orbHuds[i]:SetFrame(math.floor(frame))
                end

                if i > 1 then
                    orbHuds[i].Scale = NON_P1_SCALE
                end
            end
        end
    end
end
if REPENTOGON then
    MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_HUD_RENDER, ChaosOrb.PostRender)
else
    MilkshakeVol1:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, ChaosOrb.PostRender)
end