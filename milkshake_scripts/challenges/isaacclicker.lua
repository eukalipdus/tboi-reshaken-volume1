local isaacClicker = {}
local enums = MilkshakeVol1.enums

local inventory = {
    CollectibleType.COLLECTIBLE_MARKED,
    enums.Collectibles.SHARP_CURSOR
}

local poolsToReplace = {
    ItemPoolType.POOL_GREED_SHOP,
    ItemPoolType.POOL_GREED_TREASURE,
}

if TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "PreviousMouseSetting") == nil then
    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "PreviousMouseSetting",
        Options.MouseControl,
        TSIL.Enums.VariablePersistenceMode.NONE
    )
end

---@param player EntityPlayer
function isaacClicker:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.ISAAC_CLICKER then
        player:AddKeys(1)
        player:AddTrinket(TrinketType.TRINKET_ADOPTION_PAPERS)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false)
        for _, collectible in ipairs(inventory) do
            player:AddCollectible(collectible)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, isaacClicker.PostPlayerInit)

---@param isContinued boolean
function isaacClicker:PostGameStartedReordered(isContinued)
    if Game().Challenge == enums.Challenges.ISAAC_CLICKER
    and not isContinued then
        Options.MouseControl = true

        print(TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "PreviousMouseSetting"))

        TSIL.SaveManager.SetPersistentVariable(
            MilkshakeVol1,
            "SharpCursorFollowMouse",
            true
        )
    elseif TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "PreviousMouseSetting") ~= nil then
        Options.MouseControl = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "PreviousMouseSetting")

        local toSet

        if TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "PreviousMouseSetting") then
            toSet = true
        else
            toSet = false
        end

        TSIL.SaveManager.SetPersistentVariable(
            MilkshakeVol1,
            "SharpCursorFollowMouse",
            toSet
        )
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GAME_STARTED_REORDERED, isaacClicker.PostGameStartedReordered)

---@param poolType ItemPoolType
function isaacClicker:PostGetCollectible(_, poolType)
    if Game().Challenge == enums.Challenges.ISAAC_CLICKER
    and TSIL.Utils.Tables.IsIn(poolsToReplace, poolType) then
        return enums.Collectibles.SHARP_CURSOR
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, isaacClicker.PostGetCollectible)
return isaacClicker