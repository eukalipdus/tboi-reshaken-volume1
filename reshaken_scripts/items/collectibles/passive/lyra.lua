local Lyra = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility


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
local ORBS = {
    enums.Cards.RANDOM_ORB,
    enums.Cards.AMETHYST_ORB,
    enums.Cards.RUBY_ORB,
    enums.Cards.EMERALD_ORB,
    enums.Cards.SAPPHIRE_ORB,
}
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
local PILL_CARD_REPLACE_CHANCE = 20
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


---@param pickup EntityPickup
function Lyra:OnPickupInitFirst(pickup)
    if not TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.LYRA) then return end

    --It's already an orb
    if TSIL.Utils.Tables.IsIn(ORBS, pickup.SubType) then
        return
    end

    local rng = TSIL.RNG.NewRNG(pickup.InitSeed)
    local chance = TSIL.Random.GetRandomInt(1, 100, rng)

    if chance > PILL_CARD_REPLACE_CHANCE then return end

    local chosenOrb = TSIL.Random.GetRandomElementsFromTable(ORBS, 1, rng)[1]
    pickup:Morph(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_TAROTCARD,
        chosenOrb,
        true
    )
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST,
    Lyra.OnPickupInitFirst,
    PickupVariant.PICKUP_TAROTCARD
)
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_PICKUP_INIT_FIRST,
    Lyra.OnPickupInitFirst,
    PickupVariant.PICKUP_PILL
)


---@param orb Card
---@param player EntityPlayer
function Lyra:OnOrbUse(orb, player)
    if not player:HasCollectible(enums.Collectibles.LYRA) then return end

    if utility:GetTemporaryPlayerData(player, "JustFinishedUsingLyra") then
        utility:SetTemporaryPlayerData(player, "JustFinishedUsingLyra", false)
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
    --player.ControlsEnabled = false

    player:AnimateCollectible(enums.Collectibles.LYRA, "LiftItem", "PlayerPickup")
end
for _, orb in ipairs(ORBS) do
    milkshakeMod:AddPriorityCallback(
        ModCallbacks.MC_USE_CARD,
        CallbackPriority.EARLY,
        Lyra.OnOrbUse,
        orb
    )
end


---@param player EntityPlayer
---@param data UsingLyraData
local function StopUsingLyra(player, data)
    utility:SetTemporaryPlayerData(player, "UsingLyraData", nil)
    utility:SetTemporaryPlayerData(player, "JustFinishedUsingLyra", true)
    player.ControlsEnabled = true
    player:UseCard(data.orb)
end


---@param player EntityPlayer
---@param playerUsingLyraData UsingLyraData
local function RenderLyraNotes(player, playerUsingLyraData)
    local renderPos = Isaac.WorldToScreen(player.Position)
    local baseYPos = -40 * player.SpriteScale.Y
    playerUsingLyraData.noteMarkerSprite:Render(renderPos + Vector(0, baseYPos))

    TSIL.Utils.Tables.ForEach(playerUsingLyraData.notes, function (_, note)
        if not Game():IsPaused() then
            note.height = note.height - NOTE_SPEED
        end

        local spriteToRender = NOTE_SPRITES_PER_DIRECTION[note.direction]
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
    local controllerIndex = player.ControllerIndex
    local firstNote = playerUsingLyraData.notes[1]
    local inputToCheck = INPUT_PER_NOTE_DIRECTION[firstNote.direction]

    if firstNote.height < -INPUT_FORGIVENESS then
        StopUsingLyra(player, playerUsingLyraData)
        player:AnimateSad()
        return
    end

    if IsPlayingWrongInput(inputToCheck, controllerIndex) then
        StopUsingLyra(player, playerUsingLyraData)
        player:AnimateSad()
        return
    end

    if Input.IsActionTriggered(inputToCheck, player.ControllerIndex) then
        local difference = math.abs(firstNote.height)

        if difference <= INPUT_FORGIVENESS then
            local renderPos = Isaac.WorldToScreen(player.Position)
            local baseYPos = -40 * player.SpriteScale.Y
            CreateNoteSplash(firstNote.direction, renderPos + Vector(0, baseYPos - firstNote.height))
            table.remove(playerUsingLyraData.notes, 1)

            if #playerUsingLyraData.notes == 0 then
                utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
                StopUsingLyra(player, playerUsingLyraData)
                player:AnimateHappy()
            end
        else
            StopUsingLyra(player, playerUsingLyraData)
            player:AnimateSad()
        end
    end
end


---@param player EntityPlayer
function Lyra:OnPlayerRender(player)
    ---@type UsingLyraData?
    local playerUsingLyraData = utility:GetTemporaryPlayerData(player, "UsingLyraData")

    if not playerUsingLyraData then return end

    RenderLyraNotes(player, playerUsingLyraData)

    if Game():IsPaused() then return end

    HandleLyraInput(player, playerUsingLyraData)
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, Lyra.OnPlayerRender)


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
milkshakeMod:AddCallback(ModCallbacks.MC_INPUT_ACTION, Lyra.OnInput)


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
milkshakeMod:AddCallback(ModCallbacks.MC_POST_RENDER, Lyra.OnRender)


function Lyra:OnNewRoom()
    noteSplashes = {}
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Lyra.OnNewRoom)