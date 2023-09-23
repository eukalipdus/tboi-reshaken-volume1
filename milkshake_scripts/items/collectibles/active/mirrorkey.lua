local MirrorKey = {}

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
--- Distance to the door the player needs to be to enter it
local ENTER_DOOR_DISTANCE = 10
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

local IsMovingToMirrorRoom = false
local PreviousMirrorDoorSlot = DoorSlot.NO_DOOR_SLOT


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "MirrorDoorSlot",
    DoorSlot.NO_DOOR_SLOT,
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "IsInMirrorRoom",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)


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


---@param doorSlot DoorSlot
local function SpawnFakeMirrorDoor(doorSlot)
    local room = Game():GetRoom()
    local doorSlotPos = room:GetDoorSlotPosition(doorSlot)

    local fakeDoor = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.MIRROR_KEY_DOOR,
        0,
        doorSlotPos
    )
    local sprite = fakeDoor:GetSprite()
    local rotation = ROTATION_PER_DOOR_SLOT[doorSlot]
    sprite.Offset = Vector(0, 15):Rotated(rotation)
    sprite.Rotation = rotation
    fakeDoor.Color = Color(1, 1, 1, 1, 0.2, 0.4, 0.7)
    fakeDoor.SortingLayer = SortingLayer.SORTING_DOOR
end


---@param player EntityPlayer
function MirrorKey:OnMirrorKeyUse(_, _, player)
    local room = Game():GetRoom()

    local unusedDoorSlots = TSIL.Doors.GetUnusedDoorSlots()
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

    local doorSlotPos = room:GetDoorSlotPosition(closeDoorSlot)
    local wall = room:GetGridEntityFromPos(doorSlotPos)

    wall.CollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
    SpawnFakeMirrorDoor(closeDoorSlot)

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "MirrorDoorSlot",
        closeDoorSlot
    )

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


---@param player EntityPlayer
function MirrorKey:OnPlayerUpdate(player)
    ---@type DoorSlot
    local doorSlot = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "MirrorDoorSlot"
    )
    if doorSlot == DoorSlot.NO_DOOR_SLOT then return end

    local room = Game():GetRoom()
    local doorPosition = room:GetDoorSlotPosition(doorSlot)

    if player.Position:DistanceSquared(doorPosition) <= ENTER_DOOR_DISTANCE ^ 2 then
        IsMovingToMirrorRoom = true
        PreviousMirrorDoorSlot = doorSlot

        local cmd = GetGotoCommandForCurrentRoom()
        Isaac.ExecuteCommand(cmd)
        Game():StartRoomTransition(
            GridRooms.ROOM_DEBUG_IDX,
            Direction.LEFT,
            RoomTransitionAnim.FADE_MIRROR
        )
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    MirrorKey.OnPlayerUpdate
)


function MirrorKey:OnNewRoom()
    if not IsMovingToMirrorRoom then return end
    IsMovingToMirrorRoom = false

    local room = Game():GetRoom()
    local doorSlot = PreviousMirrorDoorSlot

    TSIL.Doors.RemoveDoors(TSIL.Doors.GetDoors())
    SpawnFakeMirrorDoor(doorSlot)

    local doorSlotPosition = room:GetDoorSlotPosition(doorSlot)
    local playerPosOffset = Vector(0, 40):Rotated(ROTATION_PER_DOOR_SLOT[doorSlot])

    for _, player in ipairs(TSIL.Players.GetPlayers()) do
        player.Position = doorSlotPosition + playerPosOffset
    end

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "IsInMirrorRoom",
        true
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    MirrorKey.OnNewRoom
)


function MirrorKey:GetShaderParams(shaderName)
    if shaderName == "Milkshake Mirror Room" then
        local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "IsInMirrorRoom"
        )

        local enableShader = 0.0
        if isInMirrorRoom then
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