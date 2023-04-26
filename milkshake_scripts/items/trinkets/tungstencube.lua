local TungstenCube = {}
local enums = milkshakeMod.enums


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "NumTungstenCubesPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)
TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "NumGoldenTungstenCubesPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)
TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "FrameStartedPressingDropKeyPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param trinket EntityPickup
function TungstenCube:OnTrinketUpdate(trinket)
    if trinket.SubType ~= enums.Trinkets.TUNGSTEN_CUBE then return end

    local spr = trinket:GetSprite()

    if not spr:IsPlaying("Appear") then return end

    if spr:IsEventTriggered("DropSound") then
        local damage = TSIL.Entities.GetEntityData(
            milkshakeMod,
            trinket,
            "TungstenDamage"
        )

        if not damage then return end

        Game():ShakeScreen(10)
        local params = TSIL.ShockWaves.CustomShockwaveParams()

        local totalMultiplier = 1
        for _ = 2, damage, 1 do
            totalMultiplier = totalMultiplier * 1.5
        end

        local wasDroppedEarly = TSIL.Entities.GetEntityData(
            milkshakeMod,
            trinket,
            "HalfTungstenDamage"
        )

        local level = Game():GetLevel()
        params.Damage = (5 + 2*(level:GetStage()-1)) * totalMultiplier
        if wasDroppedEarly then
            params.Damage = params.Damage / 2
        end
        params.DamagePlayers = false

        local numRings = 3
        if wasDroppedEarly then
            numRings = 2
        end

        TSIL.ShockWaves.CreateShockwaveRing(
            trinket,
            trinket.Position,
            40,
            params,
            nil,
            nil,
            nil,
            numRings
        )
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    TungstenCube.OnTrinketUpdate,
    PickupVariant.PICKUP_TRINKET
)


---@param player EntityPlayer
function TungstenCube:OnSpeedCache(player)
    if not player:HasTrinket(enums.Trinkets.TUNGSTEN_CUBE) then return end

    player.MoveSpeed = player.MoveSpeed - 0.2
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    TungstenCube.OnSpeedCache,
    CacheFlag.CACHE_SPEED
)


---@param player EntityPlayer
---@param droppedCube EntityPickup
local function SetTungstenDamageMultipler(player, droppedCube)
    --We add one for the dropped trinket
    local trinketMultiplier = player:GetTrinketMultiplier(enums.Trinkets.TUNGSTEN_CUBE)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and trinketMultiplier == 0 then
        --We only add mom's box multiplier if we only had the dropped trinket
        trinketMultiplier = trinketMultiplier + 1
    end

    --We add the trinket multiplier corresponding to the one we just dropped
    if TSIL.Trinkets.IsGoldenTrinket(droppedCube.SubType) then
        trinketMultiplier = trinketMultiplier + 2
    else
        trinketMultiplier = trinketMultiplier + 1
    end

    TSIL.Entities.SetEntityData(
        milkshakeMod,
        droppedCube,
        "TungstenDamage",
        trinketMultiplier
    )

    --Check if the trinket was dropped early
    local frameStartedPressingDropKeyPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "FrameStartedPressingDropKeyPerPlayer"
    )
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local frameStartedPressing = frameStartedPressingDropKeyPerPlayer[playerIndex]

    if frameStartedPressing == nil or Game():GetFrameCount() - frameStartedPressing < 60 then
        TSIL.Entities.SetEntityData(
            milkshakeMod,
            droppedCube,
            "HalfTungstenDamage",
            true
        )
    end
end


---@param player EntityPlayer
---@param trinketType TrinketType
---@param numTrinketsPerPlayer table<integer, integer>
local function CheckPlayerTrinkets(player, trinketType, numTrinketsPerPlayer)
    local numTrinkets = 0
    for i = 0, 1, 1 do
        local trinket = player:GetTrinket(i)
        if trinket == trinketType then
            numTrinkets = numTrinkets + 1
        end
    end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local numTrinketsLastFrame = numTrinketsPerPlayer[playerIndex]

    if numTrinketsLastFrame == nil then
        numTrinketsLastFrame = numTrinkets
    end

    if numTrinketsLastFrame > numTrinkets then
        local droppedAmount = numTrinketsLastFrame - numTrinkets

        local tungstenCubes = TSIL.EntitySpecific.GetPickups(
            PickupVariant.PICKUP_TRINKET,
            trinketType
        )

        local droppedCubes = TSIL.Utils.Tables.Filter(tungstenCubes, function (_, trinket)
            --I'd like it so it's only FrameCount == 0, but it breaks with Fiend Folio's quick drop
            return trinket.FrameCount == 0 or trinket.FrameCount == 1
        end)

        for i = 1, droppedAmount, 1 do
            local droppedCube = droppedCubes[i]

            if droppedCube then
                SetTungstenDamageMultipler(player, droppedCube)
            end
        end
    end

    numTrinketsPerPlayer[playerIndex] = numTrinkets
end


---@param player EntityPlayer
local function CheckIfPressingDropKey(player)
    if Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then
        local frameStartedPressingDropKeyPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            milkshakeMod,
            "FrameStartedPressingDropKeyPerPlayer"
        )
        local playerIndex = TSIL.Players.GetPlayerIndex(player)
        frameStartedPressingDropKeyPerPlayer[playerIndex] = Game():GetFrameCount()
    elseif not Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
        local frameStartedPressingDropKeyPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            milkshakeMod,
            "FrameStartedPressingDropKeyPerPlayer"
        )
        local playerIndex = TSIL.Players.GetPlayerIndex(player)
        frameStartedPressingDropKeyPerPlayer[playerIndex] = nil
    end
end


---@param player EntityPlayer
function TungstenCube:OnPlayerUpdate(player)
    CheckIfPressingDropKey(player)

    local numTungstenCubesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "NumTungstenCubesPerPlayer"
    )
    local numGoldenTungstenCubesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "NumGoldenTungstenCubesPerPlayer"
    )

    CheckPlayerTrinkets(
        player,
        enums.Trinkets.TUNGSTEN_CUBE,
        numTungstenCubesPerPlayer
    )
    CheckPlayerTrinkets(
        player,
        TSIL.Trinkets.GetGoldenTrinketType(enums.Trinkets.TUNGSTEN_CUBE),
        numGoldenTungstenCubesPerPlayer
    )
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_UPDATE_REORDERED,
    TungstenCube.OnPlayerUpdate
)


return TungstenCube