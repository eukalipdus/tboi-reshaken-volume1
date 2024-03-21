local milkshake = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local PINK_TEAR_COLOR = Color(1, 0, 1, 1, 0.196, 0, 0)
local STAT_COUNTER_DURATION = 150
local STAT_COUNTER_MOVEMENT_DURATION = 10
local STAT_COUNTER_FADING_DURATION = 40
local MIN_MULTI = 1.1
local MAX_MULTI = 1.5
local StatsFont = Font() -- init font object
StatsFont:Load("font/luaminioutlined.fnt") -- load a font into the font object

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "MilkshakeMultiplierFramePerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param rng RNG
---@param itemNum integer
function MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, min, max)
    local baseMultiplier = TSIL.Random.GetRandomFloat(min, max, rng)
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

    local MilkShakeSpeed = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local MilkShakeTears = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local MilkShakeDamage = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local MilkShakeRange = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local MilkShakeShotSpeed = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local MilkShakeLuck = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = ((player.MaxFireDelay + 1) / MilkShakeTears) - 1
    end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * MilkShakeDamage
    end

    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * MilkShakeSpeed
    end

    if cacheFlag == CacheFlag.CACHE_LUCK and player.Luck > 0 then
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
MilkshakeVol1:AddPriorityCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    CallbackPriority.LATE + 2000, --Very low priority so the multiplier works with mods
    milkshake.onCache
)


---@param player EntityPlayer
---@param firstTime boolean
function milkshake:OnMilkshakeAdded(player, collectibleType, firstTime)
    if collectibleType ~= enums.Collectibles.MILKSHAKE
    and collectibleType ~= enums.Collectibles.WATER_WITH_FOOD_COLORING then return end
    if utility:IsPlayerShowingStatsUI(player) then
        local playerIndex = TSIL.Players.GetPlayerIndex(player)
        local multiplierCounterFramesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
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

    if collectibleType == enums.Collectibles.MILKSHAKE then
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
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    milkshake.OnMilkshakeAdded,
    {
        nil,
        nil,
        nil
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


local function IsDisplayingMultiplayerStats()
    return utility:IsMultiplayer() and not TSIL.Players.IsJacobOrEsau(Isaac.GetPlayer())
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
        MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI),
        MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI),
        MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI),
        MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI),
        MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI),
        MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    }

    local baseXPos = 75
    local baseYPos = 87
    local alpha = 0.5

    if IsDisplayingMultiplayerStats() then
        if utility:IsFirstPlayer(player) then
            baseYPos = baseYPos - 4
        else
            baseYPos = baseYPos + 4
        end
    end

    if Game().Challenge == Challenge.CHALLENGE_NULL
    and Game().Difficulty == Difficulty.DIFFICULTY_NORMAL
    and TSIL.Run.CanRunUnlockAchievements() then
        --If there are no symbols (Hard mode, greed, achievements disabled, etc..) move the ui up
        baseYPos = baseYPos - 15.5
    end

    if utility:AnyPlayerIsCharacter(PlayerType.PLAYER_BETHANY) then
        --If the player is playing bethany, account for the soul charge
        baseYPos = baseYPos + 10
    end

    if utility:AnyPlayerIsCharacter(PlayerType.PLAYER_BETHANY_B) then
        --If the player is playing T.bethany, account for the red health charge
        baseYPos = baseYPos + 10
    end

    if utility:AnyPlayerIsCharacter(PlayerType.PLAYER_BLUEBABY_B) and utility:IsMultiplayer() then
        --If there is a t.blue baby and playing coop poop is separate from bombs
        baseYPos = baseYPos + 10
    end

    if TSIL.Players.IsJacobOrEsau(Isaac.GetPlayer()) then
        --If the main player is jacob and esau lower it a bit
        baseYPos = baseYPos + 16
    end

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

    for index, mult in ipairs(statMultipliers) do
        RenderStat(mult, Vector(baseXPos, baseYPos), alpha)

        if IsDisplayingMultiplayerStats() then
            baseYPos = baseYPos + 14
        else
            if index == 1 and player:GetPlayerType() == PlayerType.PLAYER_JACOB then
                baseYPos = baseYPos + 8
            elseif index == 1 and player:GetPlayerType() == PlayerType.PLAYER_ESAU then
                baseYPos = baseYPos + 16
            elseif TSIL.Players.IsJacobOrEsau(player) then
                baseYPos = baseYPos + 14
            else
                baseYPos = baseYPos + 12
            end
        end
    end

    return false
end


function milkshake:OnRender()
    local multiplierCounterFramesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
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
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    milkshake.OnRender
)