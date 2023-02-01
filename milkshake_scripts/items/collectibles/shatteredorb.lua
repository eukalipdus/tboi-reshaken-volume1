local enums = require "milkshake_scripts.enums"
local ShatteredOrb = {}

local SHATTERED_ORB_THROW_SPEED = 8
local SHATTERED_ORB_FALL_ACCEL = 0.1
local SHATTERED_ORB_RADIUS = 16


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "PlayersUsingShatteredOrb",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "DataPerShatteredOrb",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param player EntityPlayer
---@param slot ActiveSlot
local function AddPlayerUsingShatteredOrb(player, slot)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersUsingShatteredOrb"
    )

    playersUsingShatteredOrb[tostring(playerIndex)] = slot
end


---@param player EntityPlayer
---@return boolean
local function IsPlayerUsingShatteredOrb(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersUsingShatteredOrb"
    )

    return playersUsingShatteredOrb[tostring(playerIndex)] ~= nil
end


---@param player EntityPlayer
---@return ActiveSlot
local function GetShatteredOrbActiveSlotFromPlayer(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersUsingShatteredOrb"
    )

    return playersUsingShatteredOrb[tostring(playerIndex)]
end


---@param player EntityPlayer
local function RemovePlayerUsingShatteredOrb(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersUsingShatteredOrb"
    )

    playersUsingShatteredOrb[tostring(playerIndex)] = nil
end

---@class ShatteredOrbData
---@field direction Vector
---@field fallingSpeed number

---@param effect EntityEffect
---@param direction Vector
local function AddShatteredOrbData(effect, direction)
    local ptrHash = GetPtrHash(effect)

    local directionsPerShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "DataPerShatteredOrb"
    )

    directionsPerShatteredOrb[tostring(ptrHash)] = {
        direction = direction,
        fallingSpeed = 0
    }
end


---@param effect EntityEffect
---@return ShatteredOrbData
local function GetShatteredOrbData(effect)
    local ptrHash = GetPtrHash(effect)

    local directionsPerShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "DataPerShatteredOrb"
    )

    return directionsPerShatteredOrb[tostring(ptrHash)]
end


---@param player EntityPlayer
---@param useFlags UseFlag
---@param activeSlot ActiveSlot
function ShatteredOrb:OnShatteredOrbUse(_, _, player, useFlags, activeSlot)
    if TSIL.Utils.Flags.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false
        }
    end

    local animToPlay

    if IsPlayerUsingShatteredOrb(player) then
        RemovePlayerUsingShatteredOrb(player)
        animToPlay = "HideItem"
    else
        AddPlayerUsingShatteredOrb(player, activeSlot)
        animToPlay = "LiftItem"
    end

    player:AnimateCollectible(enums.Collectibles.SHATTERED_ORB, animToPlay, "PlayerPickup")

    return {
        Discharge = false,
        Remove = false,
        ShowAnim = false
    }
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ShatteredOrb.OnShatteredOrbUse,
    enums.Collectibles.SHATTERED_ORB
)


---@param player EntityPlayer
function ShatteredOrb:OnPlayerUpdate(player)
    if not IsPlayerUsingShatteredOrb(player) then return end

    local shootingDir = player:GetFireDirection()

    if shootingDir == Direction.NO_DIRECTION then return end

    local activeSlot = GetShatteredOrbActiveSlotFromPlayer(player)
    player:DischargeActiveItem(activeSlot)
    player:PlayExtraAnimation("HideItem")
    RemovePlayerUsingShatteredOrb(player)

    local shatteredOrb = TSIL.EntitySpecific.SpawnEffect(
        enums.Effects.SHATTERED_ORB,
        0,
        player.Position
    )

    shatteredOrb.SpriteOffset = Vector(0, -36) * player.SpriteScale
    shatteredOrb:GetSprite():Play("Thrown", true)

    local direction = TSIL.Direction.DirectionToVector(shootingDir) * SHATTERED_ORB_THROW_SPEED + player.Velocity
    AddShatteredOrbData(shatteredOrb, direction)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    ShatteredOrb.OnPlayerUpdate
)


---@param shatteredOrb EntityEffect
function ShatteredOrb:OnShatteredOrbUpdate(shatteredOrb)
    local shatteredOrbData = GetShatteredOrbData(shatteredOrb)

    shatteredOrb.Velocity = shatteredOrbData.direction

    shatteredOrb.SpriteOffset = shatteredOrb.SpriteOffset + Vector(0, shatteredOrbData.fallingSpeed)
    shatteredOrbData.fallingSpeed = shatteredOrbData.fallingSpeed + SHATTERED_ORB_FALL_ACCEL

    if shatteredOrb.SpriteOffset.Y >= 0 then
        SFXManager():Play(SoundEffect.SOUND_POT_BREAK_2, 1, 2, false, 1.3)

        MusicManager():Pause()
        TSIL.Utils.Functions.RunInFrames(function ()
            MusicManager():Resume()
        end, 30 * 2)

        shatteredOrb:Remove()
        return
    end

    local npcs = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, true)
    npcs = TSIL.Utils.Tables.Filter(npcs, function (_, npc)
        return npc:IsVulnerableEnemy() and not npc:IsBoss()
    end)

    for _, npc in ipairs(npcs) do
        local distanceSqr = npc.Position:DistanceSquared(shatteredOrb.Position + shatteredOrb.SpriteOffset)
        local distanceToCollide = npc.Size + SHATTERED_ORB_RADIUS
        distanceToCollide = distanceToCollide ^ 2

        if distanceSqr < distanceToCollide then
            shatteredOrb:Remove()
            npc:Remove()
            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_TAROTCARD,
                enums.Cards.EMERALD_ORB,
                npc.Position
            )
            break
        end
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    ShatteredOrb.OnShatteredOrbUpdate,
    enums.Effects.SHATTERED_ORB
)


return ShatteredOrb