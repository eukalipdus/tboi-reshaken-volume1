local ChaosOrb = {}
local enums = MilkshakeVol1.enums


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