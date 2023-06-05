local enums = MilkshakeVol1.enums
local ShatteredOrb = {}

local SHATTERED_ORB_THROW_SPEED = 8
local SHATTERED_ORB_FALL_ACCEL = 0.1
local SHATTERED_ORB_RADIUS = 20


ORBS_PER_ENEMY = {}

function MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(orbsPerEnemy)
    TSIL.Utils.Tables.ForEach(orbsPerEnemy, function(_, orbPerEnemy)
        if ORBS_PER_ENEMY[orbPerEnemy.type] == nil then
            ORBS_PER_ENEMY[orbPerEnemy.type] = {}
        end

        local perType = ORBS_PER_ENEMY[orbPerEnemy.type]

        if orbPerEnemy.variant == nil then
            --There is no variant, so just set the orb here
            perType.orb = orbPerEnemy.orb
            return
        end

        if not perType.entities then
            perType.entities = {}
        end

        if perType.entities[orbPerEnemy.variant] == nil then
            perType.entities[orbPerEnemy.variant] = {}
        end

        local perVariant = perType.entities[orbPerEnemy.variant]

        if orbPerEnemy.subtype == nil then
            --There is no subtype, so just set the orb here
            perVariant.orb = orbPerEnemy.orb
            return
        end

        if not perVariant.entities then
            perVariant.entities = {}
        end

        perVariant.entities[orbPerEnemy.subtype] = { orb = orbPerEnemy.orb }
    end)
end

local OrbsPerEnemy = {
    { orb = enums.Orbs.ELECTRIC, type = 60,  variant = 0, },
    { orb = enums.Orbs.ELECTRIC, type = 230, variant = 0, },
    { orb = enums.Orbs.ELECTRIC, type = 201, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 832, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 832, variant = 1, },
    { orb = enums.Orbs.PSYCHIC,  type = 836, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 248, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 828, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 24,  variant = 3, },
    { orb = enums.Orbs.PSYCHIC,  type = 26,  variant = 2, },
    { orb = enums.Orbs.PSYCHIC,  type = 246, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 246, variant = 1, },
    { orb = enums.Orbs.PSYCHIC,  type = 57,  variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 886, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 212, variant = 2, },
    { orb = enums.Orbs.PSYCHIC,  type = 253, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 885, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 885, variant = 1, },
    { orb = enums.Orbs.PSYCHIC,  type = 816, variant = 1, },
    { orb = enums.Orbs.PSYCHIC,  type = 306, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 306, variant = 1, },
    { orb = enums.Orbs.PSYCHIC,  type = 877, variant = 0, },
    { orb = enums.Orbs.PSYCHIC,  type = 409, variant = 1, },
    { orb = enums.Orbs.FIRE,     type = 10,  variant = 2, },
    { orb = enums.Orbs.FIRE,     type = 87,  variant = 1, },
    { orb = enums.Orbs.FIRE,     type = 808, variant = 0, },
    { orb = enums.Orbs.FIRE,     type = 15,  variant = 3, },
    { orb = enums.Orbs.FIRE,     type = 820, variant = 1, },
    { orb = enums.Orbs.FIRE,     type = 25,  variant = 3, subtype = 0, },
    { orb = enums.Orbs.FIRE,     type = 25,  variant = 3, subtype = 1, },
    { orb = enums.Orbs.FIRE,     type = 54,  variant = 0, },
    { orb = enums.Orbs.FIRE,     type = 824, variant = 1, },
    { orb = enums.Orbs.FIRE,     type = 41,  variant = 4, },
    { orb = enums.Orbs.FIRE,     type = 818, variant = 2, },
    { orb = enums.Orbs.FIRE,     type = 208, variant = 2, },
    { orb = enums.Orbs.FIRE,     type = 212, variant = 4, },
    { orb = enums.Orbs.FIRE,     type = 838, variant = 0, },
    { orb = enums.Orbs.FIRE,     type = 226, variant = 2, },
    { orb = enums.Orbs.FIRE,     type = 833, variant = 0, },
    { orb = enums.Orbs.FIRE,     type = 841, variant = 0, },
    { orb = enums.Orbs.FIRE,     type = 841, variant = 1, },
    { orb = enums.Orbs.FIRE,     type = 825, variant = 0, },
    { orb = enums.Orbs.NATURE,   type = 300, variant = 0, },
}

MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerEnemy)


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "PlayersUsingShatteredOrb",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "DataPerShatteredOrb",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param player EntityPlayer
---@param slot ActiveSlot
local function AddPlayerUsingShatteredOrb(player, slot)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayersUsingShatteredOrb"
    )

    playersUsingShatteredOrb[tostring(playerIndex)] = slot
end


---@param player EntityPlayer
---@return boolean
local function IsPlayerUsingShatteredOrb(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayersUsingShatteredOrb"
    )

    return playersUsingShatteredOrb[tostring(playerIndex)] ~= nil
end


---@param player EntityPlayer
---@return ActiveSlot
local function GetShatteredOrbActiveSlotFromPlayer(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayersUsingShatteredOrb"
    )

    return playersUsingShatteredOrb[tostring(playerIndex)]
end


---@param player EntityPlayer
local function RemovePlayerUsingShatteredOrb(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
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
        MilkshakeVol1,
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
        MilkshakeVol1,
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

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    ShatteredOrb.OnShatteredOrbUse,
    enums.Collectibles.SHATTERED_ORB
)


---@param player EntityPlayer
function ShatteredOrb:OnPlayerUpdate(player)
    if not IsPlayerUsingShatteredOrb(player) then return end

    --If the player is not player the lift item anim, they're not using the item anymore
    local sprite = player:GetSprite()
    if sprite:IsPlaying("LiftItem") then
        RemovePlayerUsingShatteredOrb(player)
        return
    end

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

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    ShatteredOrb.OnPlayerUpdate
)


---@param entity Entity
---@return Card
function GetEntityOrb(entity)
    local orb
    local orbsPerType = ORBS_PER_ENEMY[entity.Type]

    if orbsPerType then
        orb = orbsPerType.orb

        if orbsPerType.entities then
            local orbsPerVariant = orbsPerType.entities[entity.Variant]

            if orbsPerVariant then
                if orbsPerVariant.orb then
                    orb = orbsPerVariant.orb
                end

                if orbsPerVariant.entities then
                    local orbsPerSubtype = orbsPerVariant.entities[entity.SubType]

                    if orbsPerSubtype then
                        if orbsPerSubtype.orb then
                            orb = orbsPerVariant.orb
                        end
                    end
                end
            end
        end
    end

    if not orb then
        orb = enums.Orbs.RANDOM
    end

    return orb
end

---@param shatteredOrb EntityEffect
function ShatteredOrb:OnShatteredOrbUpdate(shatteredOrb)
    local sprite = shatteredOrb:GetSprite()

    if sprite:IsPlaying("Shatter") or sprite:IsPlaying("Capture") or sprite:IsPlaying("Broken") then
        shatteredOrb.Velocity = Vector.Zero
        return
    end

    if sprite:IsFinished("Shatter") then
        sprite:Play("Broken", true)
        return
    end

    if sprite:IsFinished("Capture") then
        shatteredOrb:Remove()
        return
    end

    local shatteredOrbData = GetShatteredOrbData(shatteredOrb)

    shatteredOrb.Velocity = shatteredOrbData.direction

    shatteredOrb.SpriteOffset = shatteredOrb.SpriteOffset + Vector(0, shatteredOrbData.fallingSpeed)
    shatteredOrbData.fallingSpeed = shatteredOrbData.fallingSpeed + SHATTERED_ORB_FALL_ACCEL

    if shatteredOrb.SpriteOffset.Y >= 0 then
        SFXManager():Play(SoundEffect.SOUND_MIRROR_BREAK, 1, 2, false, 1.3)

        MusicManager():Pause()
        TSIL.Utils.Functions.RunInFrames(function()
            MusicManager():Resume()
        end, 30 * 2)

        sprite:Load("/gfx/shattered_orb_effects.anm2", true)
        sprite:Play("Shatter", true)

        return
    end

    local npcs = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, true)
    npcs = TSIL.Utils.Tables.Filter(npcs, function(_, npc)
        return npc:IsVulnerableEnemy() and not npc:IsBoss() and
            not (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or
                npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL))
    end)

    for _, npc in ipairs(npcs) do
        local distanceSqr = npc.Position:DistanceSquared(shatteredOrb.Position)
        local distanceToCollide = npc.Size + SHATTERED_ORB_RADIUS
        distanceToCollide = distanceToCollide ^ 2

        if distanceSqr < distanceToCollide then
            npc:Remove()

            local orbToSpawn = GetEntityOrb(npc)

            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_TAROTCARD,
                orbToSpawn,
                npc.Position
            )

            sprite:Load("/gfx/shattered_orb_effects.anm2", true)
            sprite:Play("Capture", true)
            break
        end
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    ShatteredOrb.OnShatteredOrbUpdate,
    enums.Effects.SHATTERED_ORB
)


return ShatteredOrb
