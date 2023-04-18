local ChaosOrb = {}
local enums = milkshakeMod.enums


local ORBS = {
    enums.Cards.AMETHYST_ORB,
    enums.Cards.RUBY_ORB,
    enums.Cards.EMERALD_ORB,
    enums.Cards.SAPPHIRE_ORB,
}


local SPRITESHEET_PER_ORB = {
    [enums.Cards.AMETHYST_ORB] = "spirit_psychic",
    [enums.Cards.RUBY_ORB] = "spirit_fire",
    [enums.Cards.EMERALD_ORB] = "spirit_nature",
    [enums.Cards.SAPPHIRE_ORB] = "spirit_electricity",
}


---@param player EntityPlayer
function ChaosOrb:OnChaosOrbUse(_, player)
    local rng = player:GetCardRNG(enums.Cards.RANDOM_ORB)

    local orbToUse = TSIL.Random.GetRandomElementsFromTable(
        ORBS,
        1,
        rng
    )[1]

    player:UseCard(orbToUse)

    local sprite = Sprite()
    sprite:Load("/gfx/chaos_orb_flash.anm2", true)
    local orbSpritesheet = SPRITESHEET_PER_ORB[orbToUse]
    sprite:ReplaceSpritesheet(1, "/gfx/items/pick ups/" .. orbSpritesheet .. ".png")
    sprite:LoadGraphics()
    sprite:Play("Idle", true)
    player:AnimatePickup(sprite)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_USE_CARD,
    ChaosOrb.OnChaosOrbUse,
    enums.Cards.RANDOM_ORB
)


-- function onrender()

-- end
-- milkshakeMod:AddCallback(
--     ModCallbacks.MC_POST_RENDER,
--     onrender
-- )