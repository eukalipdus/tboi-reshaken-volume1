local enums = require "milkshake_scripts.enums"
local TatteredPage = {}

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "AvailableItems",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)


---@param isContinue boolean
function TatteredPage:OnGameStarted(isContinue)
    if isContinue then return end

    local collectibles = TSIL.Collectibles.GetCollectibles()
    local availableItems = TSIL.Utils.Tables.Filter(collectibles, function (_, collectible)
        return collectible:IsAvailable()
    end)
    local availableItemIDs = TSIL.Utils.Tables.Map(availableItems, function (_, collectible)
        return collectible.ID
    end)

    TSIL.SaveManager.SetPersistentVariable(
        milkshakeMod,
        "AvailableItems",
        availableItemIDs
    )
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    TatteredPage.OnGameStarted
)


---@param player EntityPlayer
function TatteredPage:OnTatteredPageUse(_, player)
    local rng = player:GetCardRNG(enums.Cards.TATTERED_PAGE)
    ---@type CollectibleType[]
    local availableItems = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "AvailableItems"
    )
    local chosenItem = TSIL.Random.GetRandomElementsFromTable(availableItems, 1, rng)[1]

    player:AddItemWisp(
        chosenItem,
        player.Position,
        true
    )
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_USE_CARD,
    TatteredPage.OnTatteredPageUse,
    enums.Cards.TATTERED_PAGE
)


return TatteredPage