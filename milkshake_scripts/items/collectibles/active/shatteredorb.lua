local enums = MilkshakeVol1.enums
local ShatteredOrb = {}

local SHATTERED_ORB_THROW_SPEED = 8
local SHATTERED_ORB_FALL_ACCEL = 0.1
local SHATTERED_ORB_RADIUS = 20


local OrbsPerEnemy = {
    {trinket=enums.Orbs.ELECTRIC, type=60, variant=0, },
    {trinket=enums.Orbs.ELECTRIC, type=230, variant=0, },
    {trinket=enums.Orbs.ELECTRIC, type=201, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=832, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=832, variant=1, },
    {trinket=enums.Orbs.PSYCHIC, type=836, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=248, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=828, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=24, variant=3, },
    {trinket=enums.Orbs.PSYCHIC, type=26, variant=2, },
    {trinket=enums.Orbs.PSYCHIC, type=246, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=246, variant=1, },
    {trinket=enums.Orbs.PSYCHIC, type=57, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=886, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=212, variant=2, }, 
    {trinket=enums.Orbs.PSYCHIC, type=253, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=885, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=885, variant=1, },
    {trinket=enums.Orbs.PSYCHIC, type=816, variant=1, },
    {trinket=enums.Orbs.PSYCHIC, type=306, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=306, variant=1, },
    {trinket=enums.Orbs.PSYCHIC, type=877, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=409, variant=1, },
    {trinket=enums.Orbs.FIRE, type=10, variant=2, },
    {trinket=enums.Orbs.FIRE, type=87, variant=1, },
    {trinket=enums.Orbs.FIRE, type=808, variant=0, },
    {trinket=enums.Orbs.FIRE, type=15, variant=3, },
    {trinket=enums.Orbs.FIRE, type=817, variant=1, },
    {trinket=enums.Orbs.FIRE, type=820, variant=1, },
    {trinket=enums.Orbs.FIRE, type=25, variant=3, subtype=0, },
    {trinket=enums.Orbs.FIRE, type=25, variant=3, subtype=1, },
    {trinket=enums.Orbs.FIRE, type=54, variant=0, },
    {trinket=enums.Orbs.FIRE, type=824, variant=1, },
    {trinket=enums.Orbs.FIRE, type=41, variant=4, },
    {trinket=enums.Orbs.FIRE, type=818, variant=2, },
    {trinket=enums.Orbs.FIRE, type=208, variant=2, },
    {trinket=enums.Orbs.FIRE, type=212, variant=4, },
    {trinket=enums.Orbs.FIRE, type=838, variant=0, },
    {trinket=enums.Orbs.FIRE, type=226, variant=2, },
    {trinket=enums.Orbs.FIRE, type=833, variant=0, },
    {trinket=enums.Orbs.FIRE, type=841, variant=0, },
    {trinket=enums.Orbs.FIRE, type=841, variant=1, },
    {trinket=enums.Orbs.FIRE, type=825, variant=0, },
    {trinket=enums.Orbs.NATURE, type=300, variant=0, },
}

local OrbsPerFiendFolioEntities = {
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=210, },
    {trinket=enums.Orbs.PSYCHIC, type=29, variant=960, },
    {trinket=enums.Orbs.PSYCHIC, type=170, variant=90, },
    {trinket=enums.Orbs.PSYCHIC, type=234, variant=960, },
    {trinket=enums.Orbs.PSYCHIC, type=258, variant=961, },
    {trinket=enums.Orbs.PSYCHIC, type=666, variant=20, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=1160, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=1140, },
    {trinket=enums.Orbs.PSYCHIC, type=21, variant=115, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=41, variant=114, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=1100, },
    {trinket=enums.Orbs.PSYCHIC, type=240, variant=450, },
    {trinket=enums.Orbs.PSYCHIC, type=25, variant=920, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=7, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=7, subtype=1, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=7,2, },
    {trinket=enums.Orbs.PSYCHIC, type=130, variant=40, },
    {trinket=enums.Orbs.PSYCHIC, type=10, variant=40, subtype=1, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=59, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=1, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=21, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=29, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=24, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=27, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=52, },
    {trinket=enums.Orbs.PSYCHIC, type=369, variant=14, },
    {trinket=enums.Orbs.PSYCHIC, type=120, variant=225, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=30, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=25, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=1130, },
    {trinket=enums.Orbs.PSYCHIC, type=451, variant=220, },
    {trinket=enums.Orbs.PSYCHIC, type=451, variant=220, subtype=1, },
    {trinket=enums.Orbs.PSYCHIC, type=877, variant=114, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=18, },
    {trinket=enums.Orbs.PSYCHIC, type=750, variant=201, subtype=11, },
    {trinket=enums.Orbs.PSYCHIC, type=108, variant=118, },
    {trinket=enums.Orbs.PSYCHIC, type=156, variant=0, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=971, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=510, },
    {trinket=enums.Orbs.PSYCHIC, type=451, variant=180, },
    {trinket=enums.Orbs.PSYCHIC, type=114, variant=50, subtype=0, },
    {trinket=enums.Orbs.PSYCHIC, type=666, variant=30, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=901, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=900, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=521, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=420, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=870, subtype=1, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=960, },
    {trinket=enums.Orbs.PSYCHIC, type=108, variant=111, },
    {trinket=enums.Orbs.PSYCHIC, type=108, variant=112, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=37, },
    {trinket=enums.Orbs.PSYCHIC, type=120, variant=236, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=670, },
    {trinket=enums.Orbs.PSYCHIC, type=150, variant=23, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=341, },
    {trinket=enums.Orbs.PSYCHIC, type=21, variant=961, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=34, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=340, },
    {trinket=enums.Orbs.PSYCHIC, type=450, variant=1510, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=951, },
    {trinket=enums.Orbs.PSYCHIC, type=112, variant=1, },
    {trinket=enums.Orbs.PSYCHIC, type=956, variant=666, },
    {trinket=enums.Orbs.PSYCHIC, type=160, variant=822, subtype=2, },
    {trinket=enums.Orbs.PSYCHIC_ORB, type=160, variant=80, subtype=3, },
    {trinket=enums.Orbs.PSYCHIC, type=120, variant=232, subtype=1, },
    {trinket=enums.Orbs.FIRE, type=151, variant=5, },
    {trinket=enums.Orbs.FIRE, type=160, variant=310, },
    {trinket=enums.Orbs.FIRE, type=750, variant=110, },
    {trinket=enums.Orbs.FIRE, type=160, variant=280, },
    {trinket=enums.Orbs.FIRE, type=160, variant=281, },
    {trinket=enums.Orbs.FIRE, type=240, variant=700, },
    {trinket=enums.Orbs.FIRE, type=61, variant=960, },
    {trinket=enums.Orbs.FIRE, type=160, variant=152, },
    {trinket=enums.Orbs.FIRE, type=451, variant=151, },
    {trinket=enums.Orbs.FIRE, type=160, variant=430, },
    {trinket=enums.Orbs.FIRE, type=160, variant=43, },
    {trinket=enums.Orbs.FIRE, type=208, variant=963, },
    {trinket=enums.Orbs.FIRE, type=114, variant=33, },
    {trinket=enums.Orbs.FIRE, type=817, variant=140, },
    {trinket=enums.Orbs.FIRE, type=160, variant=350, },
    {trinket=enums.Orbs.FIRE, type=160, variant=351, },
    {trinket=enums.Orbs.FIRE, type=160, variant=441, },
    {trinket=enums.Orbs.FIRE, type=160, variant=442, },
    {trinket=enums.Orbs.FIRE, type=180, variant=21, },
    {trinket=enums.Orbs.FIRE, type=160, variant=1080, },
    {trinket=enums.Orbs.FIRE, type=114, variant=4, },
    {trinket=enums.Orbs.FIRE, type=450, variant=33, },
    {trinket=enums.Orbs.FIRE, type=450, variant=2, },
    {trinket=enums.Orbs.FIRE, type=450, variant=42, },
    {trinket=enums.Orbs.FIRE, type=160, variant=1160, },
    {trinket=enums.Orbs.FIRE, type=450, variant=7, },
    {trinket=enums.Orbs.FIRE, type=450, variant=43, subtype=1, },
    {trinket=enums.Orbs.FIRE, type=160, variant=35, },
    {trinket=enums.Orbs.FIRE, type=42, variant=964, },
    {trinket=enums.Orbs.FIRE, type=160, variant=661, },
    {trinket=enums.Orbs.FIRE, type=956, variant=666, },
    {trinket=enums.Orbs.FIRE, type=160, variant=1170, },
    {trinket=enums.Orbs.FIRE, type=170, variant=80, },
    {trinket=enums.Orbs.FIRE, type=160, variant=153, },
    {trinket=enums.Orbs.FIRE, type=160, variant=153, subtype=1, },
    {trinket=enums.Orbs.FIRE, type=160, variant=154, },
    {trinket=enums.Orbs.FIRE, type=160, variant=154, subtype=1, },
    {trinket=enums.Orbs.FIRE, type=815, variant=960, },
    {trinket=enums.Orbs.FIRE, type=450, variant=14, },
    {trinket=enums.Orbs.FIRE, type=451, variant=40, },
    {trinket=enums.Orbs.FIRE, type=451, variant=41, },
    {trinket=enums.Orbs.FIRE, type=451, variant=42, },
    {trinket=enums.Orbs.FIRE, type=170, variant=110, },
    {trinket=enums.Orbs.ELECTRIC, type=61, variant=5, },
    {trinket=enums.Orbs.ELECTRIC, type=160, variant=640, },
    {trinket=enums.Orbs.ELECTRIC, type=160, variant=641, },
    {trinket=enums.Orbs.ELECTRIC, type=170, variant=30, },
    {trinket=enums.Orbs.ELECTRIC, type=114, variant=65, },
    {trinket=enums.Orbs.ELECTRIC, type=451, variant=140, },
    {trinket=enums.Orbs.ELECTRIC, type=451, variant=10, },
    {trinket=enums.Orbs.ELECTRIC, type=160, variant=1120, },
    {trinket=enums.Orbs.ELECTRIC, type=450, variant=21, },
    {trinket=enums.Orbs.ELECTRIC, type=114, variant=10, },
    {trinket=enums.Orbs.ELECTRIC, type=450, variant=5, },
    {trinket=enums.Orbs.ELECTRIC, type=160, variant=1150, },
    {trinket=enums.Orbs.ELECTRIC, type=120, variant=222, },
    {trinket=enums.Orbs.ELECTRIC, type=450, variant=20, },
    {trinket=enums.Orbs.ELECTRIC, type=160, variant=420, },
    {trinket=enums.Orbs.ELECTRIC, type=450, variant=3, },
    {trinket=enums.Orbs.ELECTRIC, type=450, variant=1510, },
    {trinket=enums.Orbs.ELECTRIC, type=451, variant=250, },
    {trinket=enums.Orbs.ELECTRIC, type=451, variant=141, },
    {trinket=enums.Orbs.ELECTRIC, type=617, variant=402, },
    {trinket=enums.Orbs.ELECTRIC, type=160, variant=80, subtype=68, },
    {trinket=enums.Orbs.ELECTRIC, type=160, variant=85, subtype=395, },
    {trinket=enums.Orbs.ELECTRIC, type=195, variant=30},
    {trinket=enums.Orbs.NATURE, type=160, variant=360, },
    {trinket=enums.Orbs.NATURE, type=29, variant=962, },
    {trinket=enums.Orbs.NATURE, type=160, variant=361, },
    {trinket=enums.Orbs.NATURE, type=160, variant=1718, },
    {trinket=enums.Orbs.NATURE, type=160, variant=750, },
    {trinket=enums.Orbs.NATURE, type=160, variant=840, },
    {trinket=enums.Orbs.NATURE, type=160, variant=2001, },
    {trinket=enums.Orbs.NATURE, type=160, variant=2000, },
    {trinket=enums.Orbs.NATURE, type=666, variant=110, },
    {trinket=enums.Orbs.NATURE, type=451, variant=30, },
    {trinket=enums.Orbs.NATURE, type=25, variant=962, },
    {trinket=enums.Orbs.NATURE, type=160, variant=683, },
    {trinket=enums.Orbs.NATURE, type=160, variant=683, subtype=1, },
    {trinket=enums.Orbs.NATURE, type=160, variant=90, },
    {trinket=enums.Orbs.NATURE, type=160, variant=60, },
    {trinket=enums.Orbs.NATURE, type=170, variant=100, },
    {trinket=enums.Orbs.NATURE, type=114, variant=57, },
    {trinket=enums.Orbs.NATURE, type=450, variant=6, },
}


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
---@param table table
---@return Card?
function GetMathchingOrbFromEntity(entity, table)
    for _, orbMatch in ipairs(table) do
        if entity.Type == orbMatch.type and
        (entity.Variant == orbMatch.variant or orbMatch.variant == nil) and
        (entity.SubType == orbMatch.subtype or orbMatch.subtype == nil) then
            return orbMatch.trinket
        end
    end
end


---@param entity Entity
---@return Card
function GetEntityOrb(entity)
    local entityOrb = GetMathchingOrbFromEntity(entity, OrbsPerEnemy)

    if entityOrb then return entityOrb end

	---@diagnostic disable-next-line: undefined-global
    if FiendFolio then
        entityOrb = GetMathchingOrbFromEntity(entity, OrbsPerFiendFolioEntities)

        if entityOrb then return entityOrb end
    end

    return enums.Orbs.RANDOM
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
        TSIL.Utils.Functions.RunInFrames(function ()
            MusicManager():Resume()
        end, 30 * 2)

        sprite:Load("/gfx/shattered_orb_effects.anm2", true)
        sprite:Play("Shatter", true)

        return
    end

    local npcs = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, true)
    npcs = TSIL.Utils.Tables.Filter(npcs, function (_, npc)
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