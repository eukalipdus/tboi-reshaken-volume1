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

local orbHud = Sprite()
orbHud:Load("gfx/ui/ui_chaosorb.anm2", true)
orbHud:Play("Spirit Of Chaos")

---@param player EntityPlayer
---@param flags UseOrbFlag
function ChaosOrb:OnChaosOrbUse(_, player, flags)
    local rng = player:GetCardRNG(enums.Orbs.RANDOM)

    local orbToUse = MilkshakeVol1.utility:GetRandomSpiritOrb(MilkshakeVol1.enums.GetOrbFlag.NO_RANDOM | MilkshakeVol1.enums.GetOrbFlag.NO_ORDER, rng)

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

MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
    orbHud:Update()
end)

HudHelper.RegisterHUDElement({
    Name = "RE1_CHAOS",
	Priority = HudHelper.Priority.NORMAL,
	Condition = function(player)
		return player:GetCard(0) == MilkshakeVol1.enums.Orbs.RANDOM
	end,
	OnRender = function(player, _, _, position, alpha, scale)
        orbHud.Color = Color(1, 1, 1, alpha)
        orbHud.Scale = Vector(scale, scale)
        orbHud:Render(position)
	end,
}, HudHelper.HUDType.POCKET)