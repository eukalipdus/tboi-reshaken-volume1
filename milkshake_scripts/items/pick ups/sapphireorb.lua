local SapphireOrb = {}
local enums = require("milkshake_scripts.enums")


---@param player EntityPlayer
function SapphireOrb:OnSapphireOrbUse(_, player)
    local rng = player:GetCollectibleRNG(enums.Cards.SAPPHIRE_ORB)

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