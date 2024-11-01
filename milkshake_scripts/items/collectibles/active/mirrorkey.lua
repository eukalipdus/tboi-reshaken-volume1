local MirrorKey = {}

local BELIAL_DMG_BONUS = 2.5
--- Max distance the player has to be from a door slot to be able to use the key
local DOOR_TRIGGER_DISTANCE = 120
local ROTATION_PER_DOOR_SLOT = {
    [DoorSlot.DOWN0] = 180,
    [DoorSlot.DOWN1] = 180,
    [DoorSlot.LEFT0] = -90,
    [DoorSlot.LEFT1] = -90,
    [DoorSlot.RIGHT0] = 90,
    [DoorSlot.RIGHT1] = 90,
    [DoorSlot.UP0] = 0,
    [DoorSlot.UP1] = 0
}
local GOTO_KEYWORD_PER_ROOM_TYPE = {
    [RoomType.ROOM_DEFAULT] = "default",
    [RoomType.ROOM_SHOP] = "shop",
    [RoomType.ROOM_ERROR] = "error",
    [RoomType.ROOM_TREASURE] = "treasure",
    [RoomType.ROOM_BOSS] = "boss",
    [RoomType.ROOM_MINIBOSS] = "miniboss",
    [RoomType.ROOM_SECRET] = "secret",
    [RoomType.ROOM_SUPERSECRET] = "supersecret",
    [RoomType.ROOM_ARCADE] = "arcade",
    [RoomType.ROOM_CURSE] = "curse",
    [RoomType.ROOM_CHALLENGE] = "challenge",
    [RoomType.ROOM_LIBRARY] = "library",
    [RoomType.ROOM_SACRIFICE] = "sacrifice",
    [RoomType.ROOM_DEVIL] = "devil",
    [RoomType.ROOM_ANGEL] = "angel",
    [RoomType.ROOM_DUNGEON] = "itemdungeon",
    [RoomType.ROOM_BOSSRUSH] = "bossrush",
    [RoomType.ROOM_ISAACS] = "isaacs",
    [RoomType.ROOM_BARREN] = "barren",
    [RoomType.ROOM_CHEST] = "chest",
    [RoomType.ROOM_DICE] = "dice",
    [RoomType.ROOM_BLACK_MARKET] = "blackmarket",
    [RoomType.ROOM_GREED_EXIT] = "greedexit",
    [RoomType.ROOM_PLANETARIUM] = "planetarium",
    [RoomType.ROOM_TELEPORTER] = "teleporter",
    [RoomType.ROOM_TELEPORTER_EXIT] = "teleporterexit",
    [RoomType.ROOM_SECRET_EXIT] = "secretexit",
    [RoomType.ROOM_BLUE] = "blue",
    [RoomType.ROOM_ULTRASECRET] = "ultrasecret"
}
local MIRRORED_INPUTS = {
    [ButtonAction.ACTION_LEFT] = ButtonAction.ACTION_RIGHT,
    [ButtonAction.ACTION_RIGHT] = ButtonAction.ACTION_LEFT,
    [ButtonAction.ACTION_SHOOTLEFT] = ButtonAction.ACTION_SHOOTRIGHT,
    [ButtonAction.ACTION_SHOOTRIGHT] = ButtonAction.ACTION_SHOOTLEFT,
}
--[[
local roomTypeToSprite = {
    [RoomType.ROOM_DEVIL] = "gfx/grid/door_mirror_challenge_devil",
    [RoomType.ROOM_ANGEL] = ""
}
]]
--- A mirror door with this index as target will travel to the mirror version of the room
local MIRROR_DOOR_INDEX = 9999

local DoorFrameSprite = Sprite()
DoorFrameSprite:Load("gfx/1000.154_door outline.anm2", true)
DoorFrameSprite.Color = Color(1, 1, 1, 0.3, 0.5, 3, 4)
DoorFrameSprite:Play("Idle", true)


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "IsInMirrorRoom",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "EnableMirrorShader",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "MirrorDoorDoorSlot",
    DoorSlot.NO_DOOR_SLOT,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "PreviousRoomIndex",
    -1,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "MirrorRoomDesc",
    "",
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "RoomsMirrorKeyWasUsed",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "MirrorRoomPickupData",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_NONE
)

---Helper function to check if the players are currently in the mirror key room.
---@return boolean
function MilkshakeVol1.API:IsInMirrorRoom()
    return TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "IsInMirrorRoom"
    )
end


---@return integer
local function GetCurrentRoomIndex()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    return roomDesc.GridIndex
end


local function CanUseMirrorKey()
    local level = Game():GetLevel()
    local roomIndex = level:GetCurrentRoomIndex()
    --If we use goto in a grid room, we'll end up in an infinite loop.
    if roomIndex < 0 then
        return false
    end

    --Can only use on main dimension and mirror world
    local room = Game():GetRoom()
    if not TSIL.Dimensions.InDimension(TSIL.Enums.Dimension.MAIN) and not room:IsMirrorWorld() then
        return false
    end

    local roomDesc = level:GetCurrentRoomDesc()
    local roomData = roomDesc.Data
    local roomType = room:GetType()

    if (roomData.Variant == 1
    and roomType == RoomType.ROOM_BOSS)
    or roomType == RoomType.ROOM_ERROR then
        return false
    end

    local roomsMirrorKeyWasUsed = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "RoomsMirrorKeyWasUsed"
    )
    local roomListIndex = GetCurrentRoomIndex()

    local wasMirrorKeyUsed = roomsMirrorKeyWasUsed[roomListIndex]
    return not wasMirrorKeyUsed
end


---@param oldItem CollectibleType
---@param newItem CollectibleType
local function ReplaceItems(oldItem, newItem)
    for _, player in ipairs(TSIL.Players.GetPlayers()) do
        for activeSlot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2, 1 do
            local activeItem = player:GetActiveItem(activeSlot)
            if oldItem == activeItem then
                local charge = TSIL.Charge.GetTotalCharge(player, activeSlot)

                player:RemoveCollectible(
                    oldItem,
                    false,
                    activeSlot
                )

                player:AddCollectible(
                    newItem,
                    charge,
                    false,
                    activeSlot
                )
            end
        end
    end

    local collectibles = TSIL.EntitySpecific.GetPickups(PickupVariant.PICKUP_COLLECTIBLE, oldItem)
    for _, collectible in ipairs(collectibles) do
        collectible:Morph(
            collectible.Type,
            collectible.Variant,
            newItem,
            true,
            true
        )
    end
end


---Changes all mirror keys to uncharged mirror if the item can't be use and viceversa
local function UpdateMirrorKeyChargeState()
    if CanUseMirrorKey() then
        ReplaceItems(
            MilkshakeVol1.enums.Collectibles.UNCHARGED_MIRROR_KEY,
            MilkshakeVol1.enums.Collectibles.MIRROR_KEY
        )
    else
        ReplaceItems(
            MilkshakeVol1.enums.Collectibles.MIRROR_KEY,
            MilkshakeVol1.enums.Collectibles.UNCHARGED_MIRROR_KEY
        )
    end
end


---Returns the goto command that has to be run to teleport to a copy of the current room.
---@return string
local function GetGotoCommandForCurrentRoom()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local roomData = roomDesc.Data

    local cmd = "goto "

    if roomData.StageID == TSIL.Enums.StageID.SPECIAL_ROOMS then
        local keyword = GOTO_KEYWORD_PER_ROOM_TYPE[roomData.Type]
        cmd = cmd .. "s." .. keyword .. "."
    else
        if roomData.Type == RoomType.ROOM_DEFAULT then
            cmd = cmd .. "d."
        else
            local keyword = GOTO_KEYWORD_PER_ROOM_TYPE[roomData.Type]
            cmd = "x." .. keyword .. "."
        end
    end

    cmd = cmd .. roomData.Variant

    return cmd
end


local function GetTrueUnusedDoorSlots()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local roomData = roomDesc.Data
    local doorSlots = TSIL.Doors.GetDoorSlotsFromDoorSlotBitMask(roomData.Doors)

    local room = Game():GetRoom()
    return TSIL.Utils.Tables.Filter(doorSlots, function (_, doorSlot)
        return not room:GetDoor(doorSlot)
    end)
end

---@return string
local function GetCurrentRoomStringDesc()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    local roomData = roomDesc.Data

    return roomData.Type .. "-" .. roomData.Variant .. "-" .. roomData.Subtype
end


---@param doorSlot DoorSlot
---@param target integer
---@param targetDimension Dimension
---@param canSpawnOtherDoor boolean?
-----@param roomType RoomType? | The mirror door will use the door sprite of the given RoomType
local function SpawnFakeMirrorDoor(doorSlot, target, targetDimension, canSpawnOtherDoor)
    if canSpawnOtherDoor == nil then
        canSpawnOtherDoor = true
    end

    local room = Game():GetRoom()
    local doorSlotPos = room:GetDoorSlotPosition(doorSlot)

    local fakeDoor = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.MIRROR_KEY_DOOR,
        0,
        doorSlotPos
    )
    local sprite = fakeDoor:GetSprite()

    --[[if roomType then
        for idx = 0, 5 do
            sprite:ReplaceSpritesheet(idx, roomTypeToSprite[roomType])
        end
        sprite:LoadGraphics()
    end]]

    local rotation = ROTATION_PER_DOOR_SLOT[doorSlot]
    sprite.Offset = Vector(0, 15):Rotated(rotation)
    sprite.Rotation = rotation
    fakeDoor.SortingLayer = SortingLayer.SORTING_DOOR
    fakeDoor:AddEntityFlags(EntityFlag.FLAG_DONT_OVERWRITE)

    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        fakeDoor,
        "MirrorDoorDoorSlot",
        doorSlot
    )
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        fakeDoor,
        "MirrorDoorTarget",
        target
    )
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        fakeDoor,
        "MirrorDoorTargetDimension",
        targetDimension
    )
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        fakeDoor,
        "CanSpawnOtherDoor",
        canSpawnOtherDoor
    )
end


---@param player EntityPlayer
function MirrorKey:OnMirrorKeyUse(_, _, player)
    if not CanUseMirrorKey() then
        UpdateMirrorKeyChargeState()

        return {
            Discharge = false,
            ShowAnim = false,
            Remove = false
        }
    end

    local room = Game():GetRoom()

    local unusedDoorSlots = GetTrueUnusedDoorSlots()
    local closeDoorSlot = TSIL.Utils.Tables.FindFirst(unusedDoorSlots, function (_, doorSlot)
        local doorSlotPos = room:GetDoorSlotPosition(doorSlot)

        return doorSlotPos:DistanceSquared(player.Position) <= DOOR_TRIGGER_DISTANCE ^ 2
    end)

    if not closeDoorSlot then
        return {
            Discharge = false,
            ShowAnim = false,
            Remove = false
        }
    end

    local roomsMirrorKeyWasUsed = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "RoomsMirrorKeyWasUsed"
    )
    local roomIndex = GetCurrentRoomIndex()
    roomsMirrorKeyWasUsed[roomIndex] = true

    local dimension = TSIL.Enums.Dimension.CURRENT
    local target = MIRROR_DOOR_INDEX

    local level = Game():GetLevel()
    if level:GetStage() == LevelStage.STAGE1_2
    and TSIL.Stage.OnRepentanceStage()
    and not level:IsAscent() then
        target = level:GetCurrentRoomIndex()

        if TSIL.Dimensions.InDimension(TSIL.Enums.Dimension.SECONDARY) then
            dimension = TSIL.Enums.Dimension.MAIN
        else
            dimension = TSIL.Enums.Dimension.SECONDARY
        end
    end

    SpawnFakeMirrorDoor(closeDoorSlot, target, dimension)
    UpdateMirrorKeyChargeState()

    SFXManager():Play(SoundEffect.SOUND_UNLOCK00)

    return {
        Discharge = true,
        ShowAnim = true,
        Remove = false
    }
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    MirrorKey.OnMirrorKeyUse,
    MilkshakeVol1.enums.Collectibles.MIRROR_KEY
)


function MirrorKey:OnUnnchargedMirrorKeyUse()
    return {
        Discharge = false,
        ShowAnim = false
    }
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    MirrorKey.OnUnnchargedMirrorKeyUse,
    MilkshakeVol1.enums.Collectibles.UNCHARGED_MIRROR_KEY
)


---@param doorSlot DoorSlot
local function PlacePlayersInDoorSlot(doorSlot)
    local room = Game():GetRoom()
    local doorSlotPosition = room:GetDoorSlotPosition(doorSlot)
    local playerPosOffset = Vector(0, 40):Rotated(ROTATION_PER_DOOR_SLOT[doorSlot])

    for _, player in ipairs(TSIL.Players.GetPlayers()) do
        player.Position = doorSlotPosition + playerPosOffset
    end
end


---@param isActive boolean
local function SetMirrorShaderActive(isActive)
    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "EnableMirrorShader",
        isActive
    )
end


local function RemoveAllPickups()
    local pickups = TSIL.EntitySpecific.GetPickups()
    pickups = TSIL.Utils.Tables.Filter(pickups, function (_, pickup)
        return pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
        or pickup.Price ~= 0
    end)

    for _, pickup in ipairs(pickups) do
        pickup:Remove()
    end
end


local function RemoveTallLadder()
    local tallLadders = TSIL.EntitySpecific.GetEffects(EffectVariant.TALL_LADDER)
    for _, ladder in ipairs(tallLadders) do
        ladder:Remove()
    end
end


local function AddLostCurse()
    for _, player in ipairs(TSIL.Players.GetPlayers()) do
        local effects = player:GetEffects()
        if not effects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
            effects:AddNullEffect(NullItemID.ID_LOST_CURSE)
        end
    end
end


local function RemoveLostCurse()
    if TSIL.Dimensions.InDimension(TSIL.Enums.Dimension.SECONDARY) then return end

    for _, player in ipairs(TSIL.Players.GetPlayers()) do
        local effects = player:GetEffects()
        effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE)
    end
end


local function UpdateDamageBonusCache()
    local innerReflectionPlayers = TSIL.Players.GetPlayersByCollectible(MilkshakeVol1.enums.Collectibles.INNER_REFLECTION)
    for _, player in ipairs(innerReflectionPlayers) do
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end

    local belialPlayers = TSIL.Players.GetPlayersByCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)
    for _, player in ipairs(belialPlayers) do
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

local function SavePickupData()
    local pickups = TSIL.EntitySpecific.GetPickups()
    local pickupData = {}

    pickups = TSIL.Utils.Tables.Filter(pickups, function (_, pickup)
        return pickup.SubType ~= 0
    end)

    for _, currentPickup in pairs(pickups) do
        local info = {
            VARIANT = currentPickup.Variant,
            SUBTYPE = currentPickup.SubType,
            POSITION = currentPickup.Position
        }
        table.insert(pickupData, info)
    end

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "MirrorRoomPickupData",
        pickupData
    )
end

local function RespawnSavedPickups()
    local savedPickupData = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "MirrorRoomPickupData"
    )

    for _, pickupInfo in pairs(savedPickupData) do
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            pickupInfo.VARIANT,
            pickupInfo.SUBTYPE,
            pickupInfo.POSITION,
            Vector.Zero,
            nil
        )
    end

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "MirrorRoomPickupData",
        {}
    )
end

function MirrorKey:OnNewRoom()
    UpdateMirrorKeyChargeState()

    local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "IsInMirrorRoom"
    )
    if not isInMirrorRoom then return end

    local roomDesc = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "MirrorRoomDesc"
    )
    local currentRoomDesc = GetCurrentRoomStringDesc()
    local level = Game():GetLevel()
    local currentRoomIndex = level:GetCurrentRoomIndex()

    if currentRoomIndex ~= GridRooms.ROOM_DEBUG_IDX and roomDesc ~= currentRoomDesc then
        --They teleported out of the mirror room or got out somehow without using the door
        TSIL.SaveManager.SetPersistentVariable(
            MilkshakeVol1,
            "IsInMirrorRoom",
            false
        )

        local doors = TSIL.Doors.GetDoors()
        local prevRoomIndex = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "PreviousRoomIndex"
        )
        TSIL.Doors.RemoveDoors(doors)
        SpawnFakeMirrorDoor(doors[1].Slot, prevRoomIndex, TSIL.Enums.Dimension.CURRENT, false)

        SetMirrorShaderActive(false)
        Game():GetHUD():SetVisible(true)
        RemoveLostCurse()
        UpdateDamageBonusCache()

        return
    end

    local doorSlot = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "MirrorDoorDoorSlot"
    )
    local prevRoomIndex = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PreviousRoomIndex"
    )

    TSIL.Doors.RemoveDoors(TSIL.Doors.GetDoors())
    SpawnFakeMirrorDoor(doorSlot, prevRoomIndex, TSIL.Enums.Dimension.CURRENT)

    SetMirrorShaderActive(true)
    PlacePlayersInDoorSlot(doorSlot)
    AddLostCurse()
    UpdateDamageBonusCache()
    RemoveTallLadder()
    RespawnSavedPickups()
    SavePickupData()

    if EID then
        EID.isMirrorRoom = true
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    MirrorKey.OnNewRoom
)

function MirrorKey:PostUpdate()
    local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "IsInMirrorRoom"
    )

    if not isInMirrorRoom then
        return
    end

    SavePickupData()
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    MirrorKey.PostUpdate
)


function MirrorKey:GetShaderParams(shaderName)
    if shaderName == "Milkshake Mirror Room" then
        local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "EnableMirrorShader"
        )

        local enableShader = 0.0
        if isInMirrorRoom and not MilkshakeVol1.utility:IsVersusScreenPlaying()
        and not TSIL.Dimensions.InDimension(TSIL.Enums.Dimension.SECONDARY) then
            enableShader = 1.0

            local hud = Game():GetHUD()
            hud:SetVisible(true)
            hud:Render()
            hud:SetVisible(false)
        end

        return {
            Time = Isaac.GetFrameCount()/200,
            Amount = 1,
            PixelationAmount = 1,
            Enabled = enableShader,
            TextureSize = {1,1},
            Ratio = {10,10,0,0}
        }
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_GET_SHADER_PARAMS,
    MirrorKey.GetShaderParams
)


---@param entity Entity
---@param inputHook InputHook
---@param buttonAction ButtonAction
function MirrorKey:OnInput(entity, inputHook, buttonAction)
    local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "IsInMirrorRoom"
    )
    if not isInMirrorRoom then return end

    if not entity then return end
    local player = entity:ToPlayer()
    if not player then return end
    local controllerIndex = player.ControllerIndex

    local mirroredInput = MIRRORED_INPUTS[buttonAction]
    if not mirroredInput then return end

    if inputHook == InputHook.GET_ACTION_VALUE then
        return Input.GetActionValue(mirroredInput, controllerIndex)
    elseif inputHook == InputHook.IS_ACTION_PRESSED then
        return Input.IsActionPressed(mirroredInput, controllerIndex)
    elseif inputHook == InputHook.IS_ACTION_TRIGGERED then
        return Input.IsActionTriggered(mirroredInput, controllerIndex)
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_INPUT_ACTION,
    MirrorKey.OnInput
)


---@param door EntityEffect
function MirrorKey:OnMirrorDoorInit(door)
    local sprite = door:GetSprite()
    sprite:Play("Closed", true)

    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        door,
        "IsClosed",
        true
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_INIT,
    MirrorKey.OnMirrorDoorInit,
    MilkshakeVol1.enums.Effects.MIRROR_KEY_DOOR
)


---@param door EntityEffect
local function UpdateOpenState(door)
    local sprite = door:GetSprite()
    local room = Game():GetRoom()
    local wall = room:GetGridEntityFromPos(door.Position)
    local isClear = room:IsClear()

    local isClosed = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        door,
        "IsClosed"
    )

    if isClear and isClosed then
        sprite:Play("Open", true)
        wall.CollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            door,
            "IsClosed",
            false
        )
    elseif not isClear and not isClosed then
        sprite:Play("Close", true)
        wall.CollisionClass = GridCollisionClass.COLLISION_WALL
        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            door,
            "IsClosed",
            true
        )
    end

    if sprite:IsEventTriggered("Sound") then
        SFXManager():Play(SoundEffect.SOUND_CANDLE_LIGHT)
    end

    if sprite:IsFinished("Close") then
        sprite:Play("Closed", true)
    elseif sprite:IsFinished("Open") then
        sprite:Play("Opened", true)
    end
end


---@param doorDir Direction
---@param doorPos Vector
---@param playerPos Vector
local function IsPositionInEnterRange(doorDir, doorPos, playerPos)
    local posDiff = playerPos - doorPos

    return (doorDir == Direction.DOWN and posDiff.Y < 0 and math.abs(posDiff.X) < 50)
    or (doorDir == Direction.LEFT and posDiff.X > 0 and math.abs(posDiff.Y) < 50)
    or (doorDir == Direction.RIGHT and posDiff.X < 0 and math.abs(posDiff.Y) < 50)
    or (doorDir == Direction.UP and posDiff.Y > 0 and math.abs(posDiff.X) < 50)
end


---@param door EntityEffect
local function CheckIfPlayerEnters(door)
    local player = Game():GetNearestPlayer(door.Position)
    local room = Game():GetRoom()
    local gridIndex = room:GetGridIndex(door.Position)
    local doorPosition = room:GetGridPosition(gridIndex)
    local direction = TSIL.Direction.AngleToDirection(door:GetSprite().Rotation + 90)

    if IsPositionInEnterRange(direction, doorPosition, player.Position) then
        local target = TSIL.Entities.GetEntityData(
            MilkshakeVol1,
            door,
            "MirrorDoorTarget"
        )
        local doorSlot = TSIL.Entities.GetEntityData(
            MilkshakeVol1,
            door,
            "MirrorDoorDoorSlot"
        )
        local canSpawnDoor = TSIL.Entities.GetEntityData(
            MilkshakeVol1,
            door,
            "CanSpawnOtherDoor"
        )

        if target == MIRROR_DOOR_INDEX then
            local level = Game():GetLevel()
            local roomIndex = level:GetCurrentRoomIndex()

            TSIL.Utils.Functions.RunNextCallback(
                MilkshakeVol1,
                ModCallbacks.MC_POST_NEW_ROOM,
                function ()
                    RemoveAllPickups()
                    RemoveTallLadder()
                    AddLostCurse()
                    UpdateDamageBonusCache()
                end
            )

            TSIL.SaveManager.SetPersistentVariable(
                MilkshakeVol1,
                "IsInMirrorRoom",
                true
            )
            TSIL.SaveManager.SetPersistentVariable(
                MilkshakeVol1,
                "MirrorDoorDoorSlot",
                doorSlot
            )
            TSIL.SaveManager.SetPersistentVariable(
                MilkshakeVol1,
                "PreviousRoomIndex",
                roomIndex
            )
            TSIL.SaveManager.SetPersistentVariable(
                MilkshakeVol1,
                "MirrorRoomDesc",
                GetCurrentRoomStringDesc()
            )

            local cmd = GetGotoCommandForCurrentRoom()
            Isaac.ExecuteCommand(cmd)
            Game():StartRoomTransition(
                GridRooms.ROOM_DEBUG_IDX,
                Direction.LEFT,
                RoomTransitionAnim.FADE_MIRROR
            )
        else
            local dimension = TSIL.Entities.GetEntityData(
                MilkshakeVol1,
                door,
                "MirrorDoorTargetDimension"
            )

            if dimension == TSIL.Enums.Dimension.CURRENT then
                TSIL.SaveManager.SetPersistentVariable(
                    MilkshakeVol1,
                    "IsInMirrorRoom",
                    false
                )
                TSIL.Utils.Functions.RunNextCallback(
                    MilkshakeVol1,
                    ModCallbacks.MC_POST_NEW_ROOM,
                    function ()
                        SetMirrorShaderActive(false)
                        Game():GetHUD():SetVisible(true)
                        PlacePlayersInDoorSlot(doorSlot)
                        RemoveLostCurse()
                        UpdateDamageBonusCache()
                    end
                )
            elseif dimension == TSIL.Enums.Dimension.MAIN then
                TSIL.Utils.Functions.RunNextCallback(
                    MilkshakeVol1,
                    ModCallbacks.MC_POST_NEW_ROOM,
                    function ()
                        RemoveLostCurse()
                        PlacePlayersInDoorSlot(doorSlot)
                        if canSpawnDoor then
                            SpawnFakeMirrorDoor(doorSlot, target, TSIL.Enums.Dimension.SECONDARY, false)
                        end
                    end
                )
            elseif dimension == TSIL.Enums.Dimension.SECONDARY then
                TSIL.Utils.Functions.RunNextCallback(
                    MilkshakeVol1,
                    ModCallbacks.MC_POST_NEW_ROOM,
                    function ()
                        AddLostCurse()
                        PlacePlayersInDoorSlot(doorSlot)
                        if canSpawnDoor then
                            SpawnFakeMirrorDoor(doorSlot, target, TSIL.Enums.Dimension.MAIN, false)
                        end
                    end
                )
            end

            Game():StartRoomTransition(
                target,
                Direction.LEFT,
                RoomTransitionAnim.FADE_MIRROR,
                nil,
                dimension
            )
        end
    end
end


---@param door EntityEffect
local function CheckIfDoorExists(door)
    local room = Game():GetRoom()
    local gridEntity = room:GetGridEntityFromPos(door.Position)

    if gridEntity and gridEntity:GetType() == GridEntityType.GRID_DOOR then
        SFXManager():Play(SoundEffect.SOUND_MIRROR_BREAK)
        door:Remove()
    end
end


---@param door EntityEffect
function MirrorKey:OnMirrorDoorUpdate(door)
    UpdateOpenState(door)

    CheckIfPlayerEnters(door)

    CheckIfDoorExists(door)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    MirrorKey.OnMirrorDoorUpdate,
    MilkshakeVol1.enums.Effects.MIRROR_KEY_DOOR
)


---@return boolean
local function ShouldSpawnMirrorDoorOutlines()
    if not CanUseMirrorKey() then return false end
    return TSIL.Players.DoesAnyPlayerHasItem(MilkshakeVol1.enums.Collectibles.MIRROR_KEY)
end


local function AreThereDoorOutlines()
    return Isaac.CountEntities(nil, EntityType.ENTITY_EFFECT, MilkshakeVol1.enums.Effects.MIRROR_DOOR_OUTLINE) > 0
end


---@param door EntityEffect
function MirrorKey:OnMirrorDoorOutlineUpdate(door)
    if not ShouldSpawnMirrorDoorOutlines() then
        door:Remove()
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    MirrorKey.OnMirrorDoorOutlineUpdate,
    MilkshakeVol1.enums.Effects.MIRROR_DOOR_OUTLINE
)


local function TryRenderOutlines()
    if not ShouldSpawnMirrorDoorOutlines() then return end
    if AreThereDoorOutlines() then return end

    local unusedDoorSlots = GetTrueUnusedDoorSlots()
    local room = Game():GetRoom()

    for _, doorSlot in ipairs(unusedDoorSlots) do
        local doorPos = room:GetDoorSlotPosition(doorSlot)
        local rotation = ROTATION_PER_DOOR_SLOT[doorSlot]
        local offset = Vector(0, 20):Rotated(rotation)
        local spawnPos = doorPos + offset

        local door = TSIL.EntitySpecific.SpawnEffect(
            MilkshakeVol1.enums.Effects.MIRROR_DOOR_OUTLINE,
            0,
            spawnPos
        )
        door.SortingLayer = SortingLayer.SORTING_DOOR
        local sprite = door:GetSprite()
        sprite:Load("gfx/1000.154_door outline.anm2", true)
        sprite:Play("Idle", true)
        sprite.Color = Color(1, 1, 1, 0.3, 0.5, 3, 4)
        sprite.Rotation = rotation
    end
end


local function TryPlayBossMusic()
    local customMusicEnabled = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "CustomMirrorWorldBossMusic"
    )
    if not customMusicEnabled then return end

    local isInMirror = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "IsInMirrorRoom"
    )
    if not isInMirror then return end

    if Game():IsPaused() then return end

    local room = Game():GetRoom()
    if room:GetType() ~= RoomType.ROOM_BOSS then return end
    if room:IsClear() then return end

    local musicManager = MusicManager()

    if musicManager:GetCurrentMusicID() == Music.MUSIC_JINGLE_BOSS_OVER
    or musicManager:GetCurrentMusicID() == Music.MUSIC_JINGLE_BOSS_OVER2
    or musicManager:GetCurrentMusicID() == Music.MUSIC_JINGLE_BOSS_OVER3 then
        musicManager:Play(MilkshakeVol1.enums.Music.GLASS_BOSS_OUTRO)
        musicManager:Queue(Music.MUSIC_BOSS_OVER)

        return
    end

    if musicManager:GetCurrentMusicID() ~= MilkshakeVol1.enums.Music.GLASS_BOSS
    and musicManager:GetCurrentMusicID() ~= MilkshakeVol1.enums.Music.GLASS_BOSS_OUTRO then
        musicManager:Play(MilkshakeVol1.enums.Music.GLASS_BOSS)
    end
end


function MirrorKey:OnRender()
    TryRenderOutlines()
    TryPlayBossMusic()
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    MirrorKey.OnRender
)


if EID then
    local renderCallback = ModCallbacks.MC_POST_RENDER
    if REPENTOGON then
        -- with repentogon they use the hud render callback to render on top of the vanilla hud
        renderCallback = ModCallbacks.MC_HUD_RENDER
    end
    EID:RemoveCallback(renderCallback, EID.OnRender)

    EID:AddPriorityCallback(ModCallbacks.MC_GET_SHADER_PARAMS, -100, function (_, shaderParams)
        if shaderParams == "Milkshake Mirror Room" then
            local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
                MilkshakeVol1,
                "EnableMirrorShader"
            )

            if isInMirrorRoom then
                EID.OnRender()
            end
        end
    end)

    EID:AddCallback(renderCallback, function()
        local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "EnableMirrorShader"
        )

        if not isInMirrorRoom then
            EID.OnRender()
        end
    end)
end

function MirrorKey:EvaluateCache(player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) and MilkshakeVol1.API:IsInMirrorRoom() then
        player.Damage = player.Damage + BELIAL_DMG_BONUS
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    MirrorKey.EvaluateCache,
    CacheFlag.CACHE_DAMAGE
)