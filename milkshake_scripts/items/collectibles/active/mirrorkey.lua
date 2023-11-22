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


---@return integer
local function GetCurrentRoomIndex()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()
    return roomDesc.ListIndex
end


local function CanUseMirrorKey()
    local level = Game():GetLevel()
    local roomIndex = level:GetCurrentRoomIndex()
    --If we use goto in a grid room, we'll end up in an infinite loop.
    if roomIndex < 0 then
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
local function SpawnFakeMirrorDoor(doorSlot, target)
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

    SpawnFakeMirrorDoor(closeDoorSlot, MIRROR_DOOR_INDEX)
    UpdateMirrorKeyChargeState()

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
        effects:AddNullEffect(NullItemID.ID_LOST_CURSE)
    end
end


local function RemoveLostCurse()
    for _, player in ipairs(TSIL.Players.GetPlayers()) do
        local effects = player:GetEffects()
        effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE)
    end
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

        SetMirrorShaderActive(false)
        Game():GetHUD():SetVisible(true)
        RemoveLostCurse()

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
    SpawnFakeMirrorDoor(doorSlot, prevRoomIndex)

    SetMirrorShaderActive(true)
    PlacePlayersInDoorSlot(doorSlot)
    AddLostCurse()
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    MirrorKey.OnNewRoom
)


function MirrorKey:GetShaderParams(shaderName)
    if shaderName == "Milkshake Mirror Room" then
        local isInMirrorRoom = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "EnableMirrorShader"
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

    if sprite:IsFinished("Close") then
        sprite:Play("Closed", true)
    elseif sprite:IsFinished("Opened") then
        sprite:Play("Opened")
    end
end


---@param doorDir Direction
---@param doorPos Vector
---@param playerPos Vector
local function IsPositionInEnterRange(doorDir, doorPos, playerPos)
    local posDiff = playerPos - doorPos

    return (doorDir == Direction.DOWN and posDiff.Y < 0)
    or (doorDir == Direction.LEFT and posDiff.X > 0)
    or (doorDir == Direction.RIGHT and posDiff.X < 0)
    or (doorDir == Direction.UP and posDiff.Y > 0)
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
                end
            )

            Game():StartRoomTransition(
                target,
                Direction.LEFT,
                RoomTransitionAnim.FADE_MIRROR
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


function MirrorKey:OnRender()
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
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    MirrorKey.OnRender
)