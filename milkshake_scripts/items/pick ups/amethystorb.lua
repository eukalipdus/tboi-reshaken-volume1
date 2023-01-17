local SapphireOrb = {}
local enums = require("milkshake_scripts.enums")


local defaultRNG = TSIL.RNG.NewRNG()

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "AmethystOrbRNG",
    defaultRNG,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

function SapphireOrb:OnGameStart(isContinued)
    if isContinued then return end

    local seed = Game():GetSeeds():GetStartSeed()
    local newRNG = TSIL.RNG.NewRNG(seed)

    TSIL.SaveManager.SetPersistentVariable(
        milkshakeMod,
        "AmethystOrbRNG",
        newRNG,
        true
    )
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, SapphireOrb.OnGameStart)


---@param player EntityPlayer
function SapphireOrb:OnAmethystOrbUse(_, player)
    local rng = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "SapphireOrbRNG")

    local itemConfig = Isaac.GetItemConfig()
    local cards = itemConfig:GetCards()

    ---@type Card[]
    local possibleRunes = {}

    for i = 0, cards.Size-1, 1 do
        local cardConfig = itemConfig:GetCard(i)

        if cardConfig ~= nil and
        cardConfig.CardType == ItemConfig.CARDTYPE_RUNE and
        cardConfig:IsAvailable() then
            possibleRunes[#possibleRunes+1] = cardConfig.ID
        end
    end

    local chosenRunes = TSIL.Random.GetRandomElementsFromTable(possibleRunes, 2, rng)

    for _, chosenRune in ipairs(chosenRunes) do
        player:UseCard(chosenRune, UseFlag.USE_NOANIM)
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, SapphireOrb.OnAmethystOrbUse, enums.Cards.AMETHYST_ORB)