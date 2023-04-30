local milkshake = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

local PINK_TEAR_COLOR = Color(1, 0, 1, 1, 0.196, 0, 0)
local STAT_COUNTER_DURATION = 150
local STAT_COUNTER_MOVEMENT_DURATION = 10
local STAT_COUNTER_FADING_DURATION = 40
local StatsFont = Font() -- init font object
StatsFont:Load("font/luaminioutlined.fnt") -- load a font into the font object

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "MilkshakeMultiplierFramePerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param rng RNG
---@param itemNum integer
local function GetStatMultiplier(rng, itemNum)
    local baseMultiplier = TSIL.Random.GetRandomFloat(1.1, 1.5, rng)
    local totalMultiplier = 1

    for _ = 1, itemNum, 1 do
        totalMultiplier = totalMultiplier * baseMultiplier
    end

    return totalMultiplier
end


---@param player EntityPlayer
---@param cacheFlag CacheFlag
function milkshake:onCache(player, cacheFlag)
    if not player:HasCollectible(enums.Collectibles.MILKSHAKE) then return end

    local rng = TSIL.RNG.CopyRNG(player:GetCollectibleRNG(enums.Collectibles.MILKSHAKE))
    local itemNum = player:GetCollectibleNum(enums.Collectibles.MILKSHAKE)

    local MilkShakeTears = 1 / GetStatMultiplier(rng, itemNum)
    local MilkShakeDamage = GetStatMultiplier(rng, itemNum)
    local MilkShakeSpeed = GetStatMultiplier(rng, itemNum)
    local MilkShakeLuck = GetStatMultiplier(rng, itemNum)
    local MilkShakeRange = GetStatMultiplier(rng, itemNum)
    local MilkShakeShotSpeed = GetStatMultiplier(rng, itemNum)

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay * MilkShakeTears
    end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * MilkShakeDamage
    end

    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * MilkShakeSpeed
    end

    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck * MilkShakeLuck
    end

    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange * MilkShakeRange
    end

    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed * MilkShakeShotSpeed
    end

    if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        player.TearColor = PINK_TEAR_COLOR
    end
end
milkshakeMod:AddPriorityCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    CallbackPriority.LATE + 2000, --Very low priority so the multiplier works with mods
    milkshake.onCache
)


---@param player EntityPlayer
---@param firstTime boolean
function milkshake:OnMilkshakeAdded(player, _, firstTime)
    if utility:IsFirstPlayer(player) then
        local playerIndex = TSIL.Players.GetPlayerIndex(player)
        local multiplierCounterFramesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            milkshakeMod,
            "MilkshakeMultiplierFramePerPlayer"
        )
        multiplierCounterFramesPerPlayer[playerIndex] = Game():GetFrameCount()
    end

    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B and not firstTime then return end

    local rng = TSIL.RNG.CopyRNG(player:GetCollectibleRNG(enums.Collectibles.MILKSHAKE))
    local itemNum = player:GetCollectibleNum(enums.Collectibles.MILKSHAKE)

    for _ = 1, itemNum, 1 do
        rng:Next()
    end

    local chosenHeart = rng:RandomInt(3)

    if chosenHeart == 0 then
        player:AddMaxHearts(2)
        player:AddHearts(2)
    elseif chosenHeart == 1 then
        player:AddSoulHearts(2)
    elseif chosenHeart == 2 then
        player:AddBlackHearts(2)
    end
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    milkshake.OnMilkshakeAdded,
    {
        nil,
        nil,
        enums.Collectibles.MILKSHAKE
    }
)


---@param mult number
---@param pos Vector
local function RenderStat(mult, pos, alpha)
    local value = string.format("x%.2f", mult)
    pos = pos + (Options.HUDOffset * Vector(20, 12))
    pos = pos + Game().ScreenShakeOffset

    StatsFont:DrawString(
        value,
        pos.X,
        pos.Y,
        KColor(255/255, 153/255, 255/255, alpha),
        0,
        true
    )
end


---@param player EntityPlayer
---@param startingFrame integer
---@return boolean
local function RenderMultiplier(player, startingFrame)
    local currentFrame = Game():GetFrameCount()
    local duration = currentFrame - startingFrame

    if duration >= STAT_COUNTER_DURATION then return true end

    if not Options.FoundHUD then return false end

    if not player:HasCollectible(enums.Collectibles.MILKSHAKE) then return true end

    local rng = TSIL.RNG.CopyRNG(player:GetCollectibleRNG(enums.Collectibles.MILKSHAKE))
    local itemNum = player:GetCollectibleNum(enums.Collectibles.MILKSHAKE)

    local statMultipliers = {
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum),
        GetStatMultiplier(rng, itemNum)
    }

    local baseXPos = 75
    local baseYPos = 87
    local alpha = 0.5

    if duration <= STAT_COUNTER_MOVEMENT_DURATION then
        local percent = duration / STAT_COUNTER_MOVEMENT_DURATION
        local movementPercent = TSIL.Utils.Easings.EaseOutSine(percent)

        local XOffset = TSIL.Utils.Math.Lerp(20, 0, movementPercent)
        baseXPos = baseXPos - XOffset

        alpha = TSIL.Utils.Math.Lerp(0, 0.5, percent)
    end

    if STAT_COUNTER_DURATION - duration <= STAT_COUNTER_FADING_DURATION then
        local percent = (STAT_COUNTER_DURATION - duration) / STAT_COUNTER_FADING_DURATION

        alpha = TSIL.Utils.Math.Lerp(0, 0.5, percent)
    end

    for _, mult in ipairs(statMultipliers) do
        RenderStat(mult, Vector(baseXPos, baseYPos), alpha)
        baseYPos = baseYPos + 12
    end

    return false
end


function milkshake:OnRender()
    local multiplierCounterFramesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "MilkshakeMultiplierFramePerPlayer"
    )

    for playerIndex, startingFrame in pairs(multiplierCounterFramesPerPlayer) do
        local player = TSIL.Players.GetPlayerByIndex(playerIndex)
        if not player then
            multiplierCounterFramesPerPlayer[playerIndex] = nil
        else
            if RenderMultiplier(player, startingFrame) then
                multiplierCounterFramesPerPlayer[playerIndex] = nil
            end
        end
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    milkshake.OnRender
)