local utility = {}
local enums = milkshakeMod.enums

--- Used to spawn spirit orbs for the shard series of trinkets
---@param player EntityPlayer
---@param rng RNG
function utility:shardTrinkets(player, rng)
    local BASE_CHANCE = 50
    local velocity = Vector(2,2)
    for gridIndex = 1, Game():GetRoom():GetGridSize() do
        local grid = Game():GetRoom():GetGridEntity(gridIndex)
        if grid then
            if grid:GetType() == GridEntityType.GRID_ROCKT and grid.State == 2 then -- Destroyed

                local roll = rng:RandomInt(100)

                if player:HasTrinket(enums.Trinkets.AMETHYST_SHARD)  then
                    if roll <= BASE_CHANCE then
						---@diagnostic disable-next-line: param-type-mismatch
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, enums.Cards.AMETHYST_ORB, grid.Position, velocity, nil)
                    end
                end

                if player:HasTrinket(enums.Trinkets.RUBY_SHARD) then
                    if roll <= BASE_CHANCE then
						---@diagnostic disable-next-line: param-type-mismatch
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, enums.Cards.RUBY_ORB, grid.Position, velocity, nil)
                    end
                end
                
                if player:HasTrinket(enums.Trinkets.SAPPHIRE_SHARD) then
                    if roll <= BASE_CHANCE then
						---@diagnostic disable-next-line: param-type-mismatch
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, enums.Cards.SAPPHIRE_ORB, grid.Position, velocity, nil)
                    end
                end

                if player:HasTrinket(enums.Trinkets.EMERALD_SHARD) then
                    if roll <= BASE_CHANCE then
						---@diagnostic disable-next-line: param-type-mismatch
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, enums.Cards.EMERALD_ORB, grid.Position, velocity, nil)
                    end
                end
                grid.State = -1
            end
        end
    end
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

local NotGetData = {}
---Acts as a replacement for Entity:GetData()
---@param entity Entity
---@param identifier string
---@return any
function utility:GetData(entity, identifier)
	if (not NotGetData[GetPtrHash(entity)]) then NotGetData[GetPtrHash(entity)] = {} end
	return NotGetData[GetPtrHash(entity)][identifier]
end
---Acts as a replacement for Entity:GetData()
---@param entity Entity
---@param identifier string
---@param data any
---@return boolean
function utility:SetData(entity, identifier, data)
    local existedBefore = true
	if (not NotGetData[GetPtrHash(entity)]) then
        NotGetData[GetPtrHash(entity)] = {}
        existedBefore = false
    end
	NotGetData[GetPtrHash(entity)][identifier] = data
	return existedBefore
end

local function PreGameExit()
	NotGetData = {}
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, PreGameExit)

---@param entity Entity
local function OnEntityRemoved(_, entity)
    local ptrHash = GetPtrHash(entity)

    NotGetData[ptrHash] = nil
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, OnEntityRemoved)

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
milkshakeMod:AddPriorityCallback(
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
---@param collectible EntityPickup
---@param player EntityPlayer
---@param roomType integer
---@param itemPool ItemPool
---@param seed integer
---@param rng RNG
function utility:recycleCollectible(collectible, player, roomType, itemPool, seed, rng)
    local mulVecBy = 4
    local coins = rng:RandomInt(7)
    local keysBombsHearts = rng:RandomInt(4) + 1
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, collectible.Position, Vector.Zero, player)
    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)

    for _ = 1, coins do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, collectible.Position, RandomVector() * mulVecBy, player)
    end

    for _ = 1, keysBombsHearts do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 3, collectible.Position, RandomVector() * mulVecBy, player)
    end

    if roomType == RoomType.ROOM_ANGEL then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ETERNAL, collectible.Position, RandomVector() * mulVecBy, player)
    
    elseif roomType == RoomType.ROOM_DEVIL then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, collectible.Position, RandomVector() * mulVecBy, player)
    
    elseif roomType == RoomType.ROOM_SECRET then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BONE, collectible.Position, RandomVector() * mulVecBy, player)
    
    elseif roomType == RoomType.ROOM_CURSE then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, collectible.Position, RandomVector() * mulVecBy, player)
        
    elseif roomType == RoomType.ROOM_PLANETARIUM then
        local rune = itemPool:GetCard(seed, false, true, true)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, collectible.Position, RandomVector() * mulVecBy, player)
    end
end

return utility