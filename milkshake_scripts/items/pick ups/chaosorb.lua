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
}

local movePillHudPerPlayer = {
    Vector(-13, -12),
    Vector(394, 147),
}

local playerAnchor = {
    "bottomright",
}

local function CreatePillOverlay()
    local orbPillHud = Sprite()
    orbPillHud:Load("gfx/ui/ui_chaosorb.anm2", true)
    orbPillHud:Play("Spirit Of Chaos")
    return orbPillHud
end

local orbPillHuds = {
    CreatePillOverlay(),
    CreatePillOverlay(),
    CreatePillOverlay(),
    CreatePillOverlay(),
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
    frame = frame + 0.15
    if frame > 60 then frame = 1 end
    if Game():GetHUD():IsVisible() then
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i)
            local heldPill = player:GetPill(0)
            if player:GetCard(0) == enums.Orbs.RANDOM then

                if player:GetPlayerType() ~= PlayerType.PLAYER_JACOB
                and player:GetPlayerType() ~= PlayerType.PLAYER_ESAU then
                    local position = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) + movePillHudPerPlayer[i]
                    local x, y = utility:HUDOffset(position.X, position.Y, playerAnchor[i])
                    position = Vector(x,y)
                    orbPillHuds[i]:Render(position)
                    orbPillHuds[i]:SetFrame(math.floor(frame))
                end

                if i > 1 then
                    orbPillHuds[i].Scale = NON_P1_SCALE
                end
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, ChaosOrb.PostRender)