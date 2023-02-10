local ChaosOrb = {}
local enums = require("milkshake_scripts.enums")


local ORBS = {
    enums.Cards.AMETHYST_ORB,
    enums.Cards.RUBY_ORB,
    enums.Cards.EMERALD_ORB,
    enums.Cards.SAPPHIRE_ORB,
}


---@param player EntityPlayer
function ChaosOrb:OnChaosOrbUse(player)
    local rng = player:GetCardRNG(enums.Cards.RANDOM_ORB)

    local orbToUse = TSIL.Random.GetRandomElementsFromTable(
        ORBS,
        1,
        rng
    )[1]

    player:UseCard(orbToUse)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_USE_CARD,
    ChaosOrb.OnChaosOrbUse,
    enums.Cards.RANDOM_ORB
)