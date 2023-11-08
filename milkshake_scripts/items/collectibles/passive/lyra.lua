local Lyra = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility


---@class UsingLyraData
---@field orb Card
---@field usedFrame integer
---@field noteMarkerSprite Sprite
---@field notes NoteData[]

---@class NoteSplashData
---@field sprite Sprite
---@field position Vector
---@field direction NoteDirection

---@class NoteData
---@field direction NoteDirection
---@field height number

---@class SongData
---@field song Music | SoundEffect
---@field notes NoteData[]

--CONSTANTS
local CLEAR_REWARD_REPLACE_CHANCE = 0.1
local ORB_REPLACE_CHANCE = 0.33
---@enum NoteDirection
local NOTE_DIRECTION = {
    UP = "Up",
    DOWN = "Down",
    LEFT = "Left",
    RIGHT = "Right"
}
local ALLOWED_INPUTS_DURING_LYRA = {
    [ButtonAction.ACTION_LEFT] = true,
    [ButtonAction.ACTION_RIGHT] = true,
    [ButtonAction.ACTION_UP] = true,
    [ButtonAction.ACTION_DOWN] = true,
    [ButtonAction.ACTION_PAUSE] = true,
    [ButtonAction.ACTION_MAP] = true
}
local NOTE_MARKER_ANM2 = "/gfx/lyra_note_marks.anm2"
local NOTE_SPEED = 0.6
local NOTE_PLAYING_INPUTS = {
    ButtonAction.ACTION_SHOOTDOWN,
    ButtonAction.ACTION_SHOOTLEFT,
    ButtonAction.ACTION_SHOOTRIGHT,
    ButtonAction.ACTION_SHOOTUP
}
local INPUT_PER_NOTE_DIRECTION = {
    [NOTE_DIRECTION.DOWN] = ButtonAction.ACTION_SHOOTDOWN,
    [NOTE_DIRECTION.LEFT] = ButtonAction.ACTION_SHOOTLEFT,
    [NOTE_DIRECTION.RIGHT] = ButtonAction.ACTION_SHOOTRIGHT,
    [NOTE_DIRECTION.UP] = ButtonAction.ACTION_SHOOTUP
}
local NOTE_ANIM_PER_DIRECTION = {
    [NOTE_DIRECTION.DOWN] = "Down",
    [NOTE_DIRECTION.LEFT] = "Left",
    [NOTE_DIRECTION.RIGHT] = "Right",
    [NOTE_DIRECTION.UP] = "Up"
}
local INPUT_FORGIVENESS = 6
---@type table<NoteDirection, Sprite>
local NOTE_SPRITES_PER_DIRECTION = {}
for dir, anim in pairs(NOTE_ANIM_PER_DIRECTION) do
    local sprite = Sprite()
    sprite:Load("/gfx/lyra_notes.anm2", true)
    sprite:Play(anim)
    NOTE_SPRITES_PER_DIRECTION[dir] = sprite
end


--SONGS
---@type SongData[]
local SONGS = {
    {
        song = SoundEffect.SOUND_1UP,
        notes = {
            {
                direction = NOTE_DIRECTION.DOWN,
                height = 40
            },
            {
                direction = NOTE_DIRECTION.LEFT,
                height = 20
            },
            {
                direction = NOTE_DIRECTION.UP,
                height = 20,
            }
        }
    },
    {
        song = SoundEffect.SOUND_BLOOD_LASER,
        notes = {
            {
                direction = NOTE_DIRECTION.UP,
                height = 30
            },
            {
                direction = NOTE_DIRECTION.UP,
                height = 15
            },
            {
                direction = NOTE_DIRECTION.RIGHT,
                height = 20,
            },
            {
                direction = NOTE_DIRECTION.DOWN,
                height = 15,
            },
        }
    },
}


---@type NoteSplashData[]
local noteSplashes = {}


---@param dir NoteDirection
---@param pos Vector
local function CreateNoteSplash(dir, pos)
    local sprite = Sprite()
    sprite:Load("gfx/lyra_note_splashes.anm2", true)
    local anim = NOTE_ANIM_PER_DIRECTION[dir]
    sprite:Play(anim, true)
    noteSplashes[#noteSplashes+1] = {
        direction = dir,
        position = pos,
        sprite = sprite
    }
end


---@param orb Card
---@param player EntityPlayer
---@param flags UseOrbFlag
function Lyra:OnOrbUse(orb, player, flags)
    if not player:HasCollectible(enums.Collectibles.LYRA) then return end

    if not TSIL.Utils.Flags.HasFlags(flags, enums.UseOrbFlags.ALLOW_LYRA) then
        return
    end

    local noteMarkerSprite = Sprite()
    noteMarkerSprite:Load(NOTE_MARKER_ANM2, true)
    noteMarkerSprite:Play("Idle", true)

    local rng = player:GetCollectibleRNG(enums.Collectibles.LYRA)

    local songToPlay = TSIL.Random.GetRandomElementsFromTable(SONGS, 1, rng)[1]
    ---@type NoteData[]
    local currentSongNotes = {}
    local currentHeight = 0

    TSIL.Utils.Tables.ForEach(songToPlay.notes, function (_, note)
        currentHeight = currentHeight + note.height
        currentSongNotes[#currentSongNotes+1] = {
            direction = note.direction,
            height = currentHeight
        }
    end)

    ---@type UsingLyraData
    local playerUsingLyraData = {
        orb = orb,
        usedFrame = Game():GetFrameCount(),
        noteMarkerSprite = noteMarkerSprite,
        notes = currentSongNotes
    }
    utility:SetTemporaryPlayerData(player, "UsingLyraData", playerUsingLyraData)

    player:AnimateCollectible(enums.Collectibles.LYRA, "LiftItem", "PlayerPickup")

    --Doesn't really mean anything, but will stop the other callbacks from running
    return true
end
MilkshakeVol1:AddPriorityCallback(
    enums.Callbacks.ON_ORB_USE,
    CallbackPriority.EARLY,
    Lyra.OnOrbUse
)


---@param player EntityPlayer
---@param data UsingLyraData
---@param success boolean
local function StopUsingLyra(player, data, success)
    utility:SetTemporaryPlayerData(player, "UsingLyraData", nil)
    player.ControlsEnabled = true

    local flags = enums.UseOrbFlags.NONE
    if success then
        flags = flags | enums.UseOrbFlags.DOUBLE_POWER
    end

    MilkshakeVol1:UseSpiritOrb(data.orb, player, flags | enums.UseOrbFlags.NO_SOUND)
end


---@param player EntityPlayer
---@param playerUsingLyraData UsingLyraData
local function RenderLyraNotes(player, playerUsingLyraData)
    local room = Game():GetRoom()
    local isMirror = room:IsMirrorWorld()

    local renderPos = Isaac.WorldToScreen(player.Position)
    local baseYPos = -40 * player.SpriteScale.Y
    playerUsingLyraData.noteMarkerSprite.FlipX = isMirror
    playerUsingLyraData.noteMarkerSprite:Render(renderPos + Vector(0, baseYPos))

    TSIL.Utils.Tables.ForEach(playerUsingLyraData.notes, function (_, note)
        if not Game():IsPaused() then
            note.height = note.height - NOTE_SPEED
        end

        local spriteToRender = NOTE_SPRITES_PER_DIRECTION[note.direction]
        spriteToRender.FlipX = isMirror
        spriteToRender:Render(renderPos + Vector(0, baseYPos - note.height))
    end)
end


---@param targetInput ButtonAction
---@param controllerIndex integer
---@return boolean
local function IsPlayingWrongInput(targetInput, controllerIndex)
    for _, input in ipairs(NOTE_PLAYING_INPUTS) do
        if input ~= targetInput then
            if Input.IsActionTriggered(input, controllerIndex) then
                return true
            end
        end
    end

    return false
end


---@param player EntityPlayer
---@param playerUsingLyraData UsingLyraData
local function HandleLyraInput(player, playerUsingLyraData)
    local room = Game():GetRoom()
    local isMirror = room:IsMirrorWorld()

    local controllerIndex = player.ControllerIndex
    local firstNote = playerUsingLyraData.notes[1]
    local inputToCheck = INPUT_PER_NOTE_DIRECTION[firstNote.direction]

    if firstNote.height < -INPUT_FORGIVENESS then
        StopUsingLyra(player, playerUsingLyraData, false)
        player:AnimateSad()
        return
    end

    if IsPlayingWrongInput(inputToCheck, controllerIndex) then
        StopUsingLyra(player, playerUsingLyraData, false)
        player:AnimateSad()
        return
    end

    if Input.IsActionTriggered(inputToCheck, player.ControllerIndex) then
        local difference = math.abs(firstNote.height)

        if difference <= INPUT_FORGIVENESS then
            local renderPos = Isaac.WorldToScreen(player.Position)
            local baseYPos = -40 * player.SpriteScale.Y
            local noteSplashPos = renderPos + Vector(0, baseYPos)
            if isMirror then
                CreateNoteSplash(
                    firstNote.direction,
                    Vector(Isaac.GetScreenWidth() - noteSplashPos.X, noteSplashPos.Y)
                )
            else
                CreateNoteSplash(firstNote.direction, noteSplashPos)
            end
            local shockwavePos = Isaac.ScreenToWorld(noteSplashPos * Isaac.GetScreenPointScale())
            if Options.MaxRenderScale ~= Options.MaxScale then
                local x = 0
                if firstNote.direction == NOTE_DIRECTION.LEFT then
                    x = -20
                elseif firstNote.direction == NOTE_DIRECTION.UP then
                    x = -7
                elseif firstNote.direction == NOTE_DIRECTION.DOWN then
                    x = 7
                elseif firstNote.direction == NOTE_DIRECTION.RIGHT then
                    x = 20
                end
                local y = -45 * player.SpriteScale.Y
                shockwavePos = player.Position + Vector(x, y)
            end
            TSIL.Utils.Functions.RunNextCallback(
                MilkshakeVol1,
                ModCallbacks.MC_POST_UPDATE,
                function ()
                    Game():MakeShockwave(shockwavePos, 0.005, 0.005, 4)
                end
            )
            table.remove(playerUsingLyraData.notes, 1)

            if #playerUsingLyraData.notes == 0 then
                utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
                StopUsingLyra(player, playerUsingLyraData, true)
                player:AnimateHappy()
            end
        else
            StopUsingLyra(player, playerUsingLyraData, false)
            player:AnimateSad()
        end
    end
end


---@param player EntityPlayer
function Lyra:OnPlayerRender(player)
    local room = Game():GetRoom()
    local renderMode = room:GetRenderMode()
    if renderMode == RenderMode.RENDER_WATER_REFLECT then return end

    ---@type UsingLyraData?
    local playerUsingLyraData = utility:GetTemporaryPlayerData(player, "UsingLyraData")

    if not playerUsingLyraData then return end

    RenderLyraNotes(player, playerUsingLyraData)

    if Game():IsPaused() then return end

    HandleLyraInput(player, playerUsingLyraData)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, Lyra.OnPlayerRender)


---@param entity Entity
---@param inputHook InputHook
---@param buttonAction ButtonAction
function Lyra:OnInput(entity, inputHook, buttonAction)
    if not entity then return end
    local player = entity:ToPlayer()
    if not player then return end

    local playerUsingLyraData = utility:GetTemporaryPlayerData(player, "UsingLyraData")

    if not playerUsingLyraData then return end

    if ALLOWED_INPUTS_DURING_LYRA[buttonAction] then return end

    if inputHook == InputHook.GET_ACTION_VALUE then
        return 0
    else
        return false
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_INPUT_ACTION, Lyra.OnInput)


function Lyra:OnRender()
    local filteredSplashes = {}

    TSIL.Utils.Tables.ForEach(noteSplashes, function (_, noteSplash)
        local anim = NOTE_ANIM_PER_DIRECTION[noteSplash.direction]

        if noteSplash.sprite:IsFinished(anim) then
            return
        end

        noteSplash.sprite:Render(noteSplash.position)
        noteSplash.sprite:Update()
        filteredSplashes[#filteredSplashes+1] = noteSplash
    end)

    noteSplashes = filteredSplashes
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_RENDER, Lyra.OnRender)


function Lyra:OnNewRoom()
    noteSplashes = {}
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Lyra.OnNewRoom)


---@param rng RNG
---@param pos Vector
function Lyra:OnClearAwardSpawn(rng, pos)
    local room = Game():GetRoom()
    local roomType = room:GetType()
    if roomType == RoomType.ROOM_BOSS then return end

    if not TSIL.Players.DoesAnyPlayerHasItem(MilkshakeVol1.enums.Collectibles.LYRA) then return end

    if rng:RandomFloat() >= CLEAR_REWARD_REPLACE_CHANCE then return end

    local hasContract = TSIL.Players.DoesAnyPlayerHasItem(CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW)

    if hasContract and rng:RandomFloat() < 0.33 then return true end

    pos = room:FindFreePickupSpawnPosition(pos)
    local orb = MilkshakeVol1.utility:GetRandomSpiritOrb(true, rng)
    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        orb,
        pos
    )

    if hasContract then
        pos = room:FindFreePickupSpawnPosition(pos)
        orb = MilkshakeVol1.utility:GetRandomSpiritOrb(true, rng)
        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_TAROTCARD,
            orb,
            pos
        )
    end

    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, Lyra.OnClearAwardSpawn)


---@param rng RNG
---@param position Vector
local function SpawnRewardOrb(rng, position)
    local orb = MilkshakeVol1.utility:GetRandomSpiritOrb(true, rng)

    local angle = rng:RandomInt(360)
    local speed = TSIL.Random.GetRandomFloat(4, 6, rng)
    local velocity = Vector.FromAngle(angle):Resized(speed)

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        orb,
        position,
        velocity
    )
end


---@param gridEntity GridEntity
function Lyra:OnTintedRockBreak(gridEntity)
    if not TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.LYRA) then return end

    local rng = gridEntity:GetRNG()
    if rng:RandomFloat() >= ORB_REPLACE_CHANCE then return end

    SpawnRewardOrb(rng, gridEntity.Position)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN,
    Lyra.OnTintedRockBreak,
    GridEntityType.GRID_ROCKT
)


---@param slot Entity
function Lyra:OnSlotDestroyed(slot)
    if not TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.LYRA) then return end

    local rng = slot:GetDropRNG()
    if rng:RandomFloat() >= ORB_REPLACE_CHANCE then return end

    SpawnRewardOrb(rng, slot.Position)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_SLOT_DESTROYED,
    Lyra.OnSlotDestroyed
)


---@param chest EntityPickup
function Lyra:OnChestOpened(chest)
    if not TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.LYRA) then return end

    local rng = chest:GetDropRNG()
    if rng:RandomFloat() >= ORB_REPLACE_CHANCE then return end

    SpawnRewardOrb(rng, chest.Position)
end
MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.POST_CHEST_OPENED,
    Lyra.OnChestOpened
)