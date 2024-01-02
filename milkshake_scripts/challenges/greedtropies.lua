local greedtropies = {}
local enums = MilkshakeVol1.enums

local game = Game()

greedtropies.exitRoomIndex = 110
greedtropies.trapdoorIndex = nil
greedtropies.trapdoorIndexes = {}

function greedtropies:onGameExit()
  greedtropies.trapdoorIndex = nil
  greedtropies:clearTrapdoorIndexes()
end

function greedtropies:onPreNewRoom(entityType, variant, subType, gridIdx, seed)
  if greedtropies:isGreedChallenge() then
    local trapdoor = 9000
    
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()
    
    if roomDesc.GridIndex == greedtropies.exitRoomIndex and room:GetType() == RoomType.ROOM_GREED_EXIT then
      if entityType == trapdoor then
        table.insert(greedtropies.trapdoorIndexes, gridIdx)
      end
    end
  end
end

function greedtropies:onNewRoom()
  if greedtropies:isGreedChallenge() then
    greedtropies.trapdoorIndex = nil
    
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()
    
    if roomDesc.GridIndex == greedtropies.exitRoomIndex and room:GetType() == RoomType.ROOM_GREED_EXIT then
      for i = #greedtropies.trapdoorIndexes, 1, -1 do -- backwards loop for better removal logic
        local gridEntity = room:GetGridEntity(greedtropies.trapdoorIndexes[i])
        if not (gridEntity and gridEntity:GetType() == GridEntityType.GRID_SPIDERWEB) then -- the game replaces trapdoors with spiderwebs in this case
          table.remove(greedtropies.trapdoorIndexes, i)
        end
      end
      
      if #greedtropies.trapdoorIndexes > 0 then
        if room:IsClear() then
          greedtropies:spawnTrophy(greedtropies.trapdoorIndexes[1])
        else
          greedtropies.trapdoorIndex = greedtropies.trapdoorIndexes[1]
        end
        
        greedtropies:clearTrapdoorIndexes()
      end
    end
  end
end

function greedtropies:onUpdate()
  if greedtropies:isGreedChallenge() then
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()
    
    if greedtropies.trapdoorIndex and roomDesc.GridIndex == greedtropies.exitRoomIndex and room:GetType() == RoomType.ROOM_GREED_EXIT and room:IsClear() then
      greedtropies:spawnTrophy(greedtropies.trapdoorIndex)
      greedtropies.trapdoorIndex = nil
    end
  end
end

-- filtered to PICKUP_BIGCHEST
function greedtropies:onPickupInit(pickup)
  if greedtropies:isGreedChallenge() then
    pickup:Remove()
    greedtropies:spawnTrophy(pickup.Position)
  end
end

function greedtropies:spawnTrophy(idxOrPos)
  local room = game:GetRoom()
  local idx = nil
  local pos = nil
  
  if math.type(idxOrPos) == 'integer' then
    idx = idxOrPos
    pos = room:GetGridPosition(idxOrPos)
  else -- userdata / vector
    pos = idxOrPos
  end
  
  if idx then
    local gridEntity = room:GetGridEntity(idx)
    if gridEntity and gridEntity:GetType() == GridEntityType.GRID_SPIDERWEB then
      room:RemoveGridEntity(idx, 0, false)
    end
  end
  
  if #Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY, 0, false, false) == 0 then
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY, 0, pos, Vector.Zero, nil)
  end
end

function greedtropies:clearTrapdoorIndexes()
  for i, _ in ipairs(greedtropies.trapdoorIndexes) do
    greedtropies.trapdoorIndexes[i] = nil
  end
end

function greedtropies:isGreedChallenge()
  return game:IsGreedMode() and Isaac.GetChallenge() ~= Challenge.CHALLENGE_NULL
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, greedtropies.onGameExit)
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, greedtropies.onPreNewRoom)
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, greedtropies.onNewRoom)
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_UPDATE, greedtropies.onUpdate)
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, greedtropies.onPickupInit, PickupVariant.PICKUP_BIGCHEST)

return greedtropies