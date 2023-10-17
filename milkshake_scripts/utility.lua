local utility = {}
local enums = MilkshakeVol1.enums

--- Used to spawn spirit orbs for the shard series of trinkets
---@param trinketType TrinketType
---@param cardType Card
---@param gridEntity GridEntity
function utility:ShardTrinkets(trinketType, cardType, gridEntity, chance)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(trinketType)
        and gridEntity:GetType() == GridEntityType.GRID_ROCKT then
            local rng = player:GetTrinketRNG(trinketType)
            for _ = 1, player:GetTrinketMultiplier(trinketType) do
                local roll = rng:RandomInt(100)
                if roll <= chance then
                    local velocity = RandomVector()
                    ---@diagnostic disable-next-line: param-type-mismatch
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardType, gridEntity.Position, velocity, nil)
                end
            end
        end
    end
end

--- Used to render crystal overlays over rocks if a player has a shard trinket
---@param gridEntity GridEntity
---@param animName string
function utility:RenderCrystalRockSprite(gridEntity, animName)
    local sprite = Sprite()
    sprite:Load("gfx/grid/grid_crystalrock.anm2", true)
    sprite:Play(animName, true)
    sprite:Render(Isaac.WorldToScreen(gridEntity.Position))
end

---Returns the tears stat after adding some value
---
---Provided by Hybrid
---@param firedelay number
---@param val number
---@return number
function utility:TearsUp(firedelay, val)
    local currentTears = 30 / (firedelay + 1)
    local newTears = currentTears + val
    return math.max((30 / newTears) - 1, -0.99)
end

---Acts as a replacement for Entity:GetData()
---@param entity Entity
---@param identifier string
---@return any
function utility:GetData(entity, identifier)
    return TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        entity,
        identifier
    )
end

---Acts as a replacement for Entity:GetData()
---@param entity Entity
---@param identifier string
---@param data any
function utility:SetData(entity, identifier, data)
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        entity,
        identifier,
        data
    )
end

---Concatenates 2 tables into 1
---https://stackoverflow.com/a/15278426
---@param t1 table
---@param t2 table
---@return table
function utility:TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

---Shuffles a table
---
---@param tbl table
---@param seed integer
---@return table
function utility:Shuffle(tbl, seed)
	math.randomseed(seed)
	for i = #tbl, 2, -1 do
	  local j = math.random(i)
	  tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

local tempPlayerData = {}

---Gets some temporary player data.
---
---Temporary player data gets removed when entering a new room or
---when exiting the game
---@param player EntityPlayer
---@param field string
---@return unknown?
function utility:GetTemporaryPlayerData(player, field)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playerData = tempPlayerData[playerIndex]
    if not playerData then
        playerData = {}
        tempPlayerData[playerIndex] = playerData
    end
    return playerData[field]
end

---Sets some temporary player data.
---
---Temporary player data gets removed when entering a new room or
---when exiting the game
---@param player EntityPlayer
---@param field string
---@param value unknown
function utility:SetTemporaryPlayerData(player, field, value)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playerData = tempPlayerData[playerIndex]
    if not playerData then
        playerData = {}
        tempPlayerData[playerIndex] = playerData
    end
    playerData[field] = value
end

local function OnNewRoom()
    tempPlayerData = {}
end
MilkshakeVol1:AddPriorityCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    CallbackPriority.IMPORTANT,
    OnNewRoom
)

---@return number
function utility:GetCurrentChapter()
    local level = Game():GetLevel()
    local levelStage = level:GetStage()

    if levelStage <= LevelStage.STAGE4_2 then
        ---@type number
        local chapter = math.floor(levelStage / 2)

        if TSIL.Stage.OnRepentanceStage() then
            chapter = chapter + 0.5
        end

        return chapter
    elseif levelStage == LevelStage.STAGE4_3 then
        return 4.5
    elseif levelStage == LevelStage.STAGE5 or levelStage == LevelStage.STAGE6 then
        return levelStage - 5
    elseif levelStage == LevelStage.STAGE7 or levelStage == LevelStage.STAGE8 then
        return 7
    end

    return 0
end

--- Recreation of Tainted Cain's item to pickup effect
---@param position Vector
---@param player EntityPlayer
---@param roomType integer
---@param itemPool ItemPool
---@param seed integer
---@param rng RNG
---@param specialPickupOnly boolean
function utility:RecycleCollectible(position, player, roomType, itemPool, seed, rng, specialPickupOnly)
    local mulVecBy = 4
    if not specialPickupOnly then
        local coins = rng:RandomInt(3) + 2
        local keysBombsHearts = rng:RandomInt(3) + 1
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, position, Vector.Zero, player)
        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)

        for _ = 1, coins do
            ---@diagnostic disable-next-line: param-type-mismatch
            TSIL.PickupSpecific.SpawnCoin(0, position, RandomVector() * mulVecBy, player, rng)
        end

        for _ = 1, keysBombsHearts do
            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_NULL,
                TSIL.Enums.PickupNullSubType.EXCLUDE_COLLECTIBLES_TRINKETS_CHESTS,
                position,
                RandomVector() * mulVecBy,
                player
            )
        end
    end

    if roomType == RoomType.ROOM_ANGEL then
        TSIL.PickupSpecific.SpawnHeart(HeartSubType.HEART_ETERNAL, position, RandomVector() * mulVecBy, player)
    
    elseif roomType == RoomType.ROOM_DEVIL then
        TSIL.PickupSpecific.SpawnHeart(HeartSubType.HEART_BLACK, position, RandomVector() * mulVecBy, player)
    
    elseif roomType == RoomType.ROOM_SECRET then
        TSIL.PickupSpecific.SpawnHeart(HeartSubType.HEART_BONE, position, RandomVector() * mulVecBy, player)
    
    elseif roomType == RoomType.ROOM_CURSE then
        TSIL.PickupSpecific.SpawnHeart(HeartSubType.HEART_ROTTEN, position, RandomVector() * mulVecBy, player)
        
    elseif roomType == RoomType.ROOM_PLANETARIUM then
        local rune = itemPool:GetCard(seed, false, true, true)
        TSIL.PickupSpecific.SpawnCard(rune, position, RandomVector() * mulVecBy, player, rng)
    end
end

--- If you want to use this, just use TSIL.Utils.Tables.IsIn
-- --- Check if a value is inside of a table
-- ---@param table table
-- ---@param val any
-- function utility:HasValue(table, val)
--     for i, value in pairs(table) do
--         if value == val then
--             return true
--         end
--     end

--     return false
-- end


--- Checks if a player is the main player, i.e. the one who started the run.
--- Useful because it's the only one whose stats are rendered.
---@param player EntityPlayer
---@return boolean
function utility:IsFirstPlayer(player)
    local mainTwin = player:GetMainTwin()
    local playerIndex = TSIL.Players.GetPlayerIndex(mainTwin)

    local firstPlayer = Isaac.GetPlayer()
    local firstPlayerIndex = TSIL.Players.GetPlayerIndex(firstPlayer)

    return playerIndex == firstPlayerIndex
end


---Checks if a player's stats are in the found HUD.
---@param player EntityPlayer
---@return boolean
function utility:IsPlayerShowingStatsUI(player)
    --Child players never show stats
    if TSIL.Players.IsChildPlayer(player) then return false end

    --The first player always shows their stats
    if utility:IsFirstPlayer(player) then return true end

    --If the first player is jacob and esau, the player 2 stats don't show
    local firstPlayer = Isaac.GetPlayer()
    if firstPlayer:GetPlayerType() == PlayerType.PLAYER_JACOB then return false end

    local initialControllerIndex = firstPlayer.ControllerIndex
    local mainSecondPlayer = nil
    for i = 0, Game():GetNumPlayers() - 1, 1 do
        local otherPlayer = Game():GetPlayer(i)
        local otherControllerIndex = otherPlayer.ControllerIndex

        if initialControllerIndex ~= otherControllerIndex then
            mainSecondPlayer = otherPlayer
            break
        end
    end

    if not mainSecondPlayer then return false end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local secondPlayerIndex = TSIL.Players.GetPlayerIndex(mainSecondPlayer)

    return playerIndex == secondPlayerIndex
end


---Checks if there is more than one real player in the run
---@return boolean
function utility:IsMultiplayer()
    local players = TSIL.Players.GetPlayers()

    local firstPlayer = Isaac.GetPlayer()
    local initialControllerIndex = firstPlayer.ControllerIndex

    return TSIL.Utils.Tables.Some(players, function (player)
        return initialControllerIndex ~= player.ControllerIndex
    end)
end


---Checks if any player is the given player type
---@param character PlayerType
---@return boolean
function utility:AnyPlayerIsCharacter(character)
    local players = TSIL.Players.GetPlayers()

    return TSIL.Utils.Tables.Some(players, function (player)
        return player:GetPlayerType() == character
    end)
end


local SPIRIT_ORBS = {}
local SPIRIT_ORBS_NO_RANDOM = {}
local SPIRIT_ORBS_MAP = {}
for _, orb in pairs(enums.Orbs) do
    SPIRIT_ORBS_MAP[orb] = true
    SPIRIT_ORBS[#SPIRIT_ORBS+1] = orb
    if orb ~= enums.Orbs.RANDOM then
        SPIRIT_ORBS_NO_RANDOM[#SPIRIT_ORBS_NO_RANDOM+1] = orb
    end
end

---Checks if a given card is a spirit orb
---@param card Card
function utility:IsSpiritOrb(card)
    return SPIRIT_ORBS_MAP[card] ~= nil
end

---Helper function to get a random orb
---@param includeChaos? boolean @Default: true
---@param seedOrRNG? integer | RNG
---@return Card
function utility:GetRandomSpiritOrb(includeChaos, seedOrRNG)
    if includeChaos == nil then includeChaos = true end

    local orbs = SPIRIT_ORBS
    if not includeChaos then
        orbs = SPIRIT_ORBS_NO_RANDOM
    end

    return TSIL.Random.GetRandomElementsFromTable(orbs, 1, seedOrRNG)[1]
end

--- To be used when entities are initialized, returns true if this entity was previously seen by the player, false if it is the first time it ever spawned
---@return boolean
function utility:DidEntityExist()
    local room = Game():GetRoom()
    if not room:IsFirstVisit()
    and room:GetFrameCount() <= 0 then
        return true
    else
        return false
    end
end


---Helper function to make a player able/unable to shoot.
---@param player EntityPlayer
---@param canShoot boolean
function utility:SetCanShoot(player, canShoot)
    --whats this??
	-- local data = player:GetData()
	-- if data.eclipsed and data.eclipsed.BlindCharacter then return end -- eclipsed

	---Blindfold
    local challenge = Isaac.GetChallenge()
    if not canShoot then
        Game().Challenge = Challenge.CHALLENGE_SOLAR_SYSTEM
        player:UpdateCanShoot()
        Game().Challenge = challenge
        player:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
    else
        Game().Challenge = Challenge.CHALLENGE_NULL
        player:UpdateCanShoot()
        Game().Challenge = challenge
    end
end


---Helper function to check if an enemy should have a scared behaviour.
---@param enemy EntityNPC
---@return boolean
function utility:IsEnemyScared(enemy)
    return enemy:HasEntityFlags(EntityFlag.FLAG_FEAR)
    or enemy:HasEntityFlags(EntityFlag.FLAG_SHRINK)
end


---Helper function to check if an enemy should have a confused behaviour.
---@param enemy EntityNPC
---@return boolean
function utility:IsEnemyConfused(enemy)
    return enemy:HasEntityFlags(EntityFlag.FLAG_CONFUSION)
end

--- Find out if at least one player has a given trinket, returns the first player found that has it
---@param trinketType integer
---@return EntityPlayer | nil
function utility:DoesTrinketExist(trinketType)
    for i = 0, Game():GetNumPlayers() - 1 do
      local player = Isaac.GetPlayer(i)
      if player:HasTrinket(trinketType) then
        return player
      end
    end
    return nil
end


MilkshakeVol1.utility = utility