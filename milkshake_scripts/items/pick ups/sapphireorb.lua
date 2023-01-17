local SapphireOrb = {}
local enums = require("milkshake_scripts.enums")

local defaultRNG = TSIL.RNG.NewRNG()

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "SapphireOrbRNG",
    defaultRNG,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

function SapphireOrb:OnGameStart(isContinued)
    if isContinued then return end

    local seed = Game():GetSeeds():GetStartSeed()
    local newRNG = TSIL.RNG.NewRNG(seed)

    TSIL.SaveManager.SetPersistentVariable(
        milkshakeMod,
        "SapphireOrbRNG",
        newRNG,
        true
    )
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, SapphireOrb.OnGameStart)


---@param player EntityPlayer
function SapphireOrb:OnSapphireOrbUse(_, player)
    local rng = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "SapphireOrbRNG")

    local itemConfig = Isaac.GetItemConfig()
    local cards = itemConfig:GetCards()

    ---@type Card[]
    local possibleCards = {}

    for i = 0, cards.Size-1, 1 do
        local cardConfig = itemConfig:GetCard(i)

        if cardConfig ~= nil and
        cardConfig.CardType == ItemConfig.CARDTYPE_TAROT and
        cardConfig:IsAvailable() then
            possibleCards[#possibleCards+1] = cardConfig.ID
        end
    end

    local chosenCard = TSIL.Random.GetRandomElementsFromTable(possibleCards, 1, rng)[1]

    player:UseCard(chosenCard, UseFlag.USE_NOANIM)
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, SapphireOrb.OnSapphireOrbUse, enums.Cards.SAPPHIRE_ORB)