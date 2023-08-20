local HolyOrb = {}
local enums = MilkshakeVol1.enums

-- length of the appear animation
local APPEAR_LENGTH = 15

local FALL_DELAY_DURATION = 10
local FLOAT_UP_OFFSET = 24
local FALL_TIME = 15
local PRE_LASER_WAIT_TIME = 7
local LASER_DURATION = 60

local APPEAR_STATE = 1
local FALL_STATE = 10
local PRE_LASER_WAIT_STATE = 20
local LASER_STATE = 30

local GRID_DESTRUCTION_WHITELIST = TSIL.Utils.Tables.ConstructDictionaryFromTable({
    GridEntityType.GRID_POOP,
    GridEntityType.GRID_ROCK,
    GridEntityType.GRID_ROCKB,
    GridEntityType.GRID_ROCKT,
    GridEntityType.GRID_ROCK_ALT,
    GridEntityType.GRID_ROCK_ALT2,
    GridEntityType.GRID_ROCK_BOMB,
    GridEntityType.GRID_ROCK_GOLD,
    GridEntityType.GRID_ROCK_SPIKED,
    GridEntityType.GRID_ROCK_SS,
    GridEntityType.GRID_TNT,
})

local function getLaserDamagePerTick()
    local stage = MilkshakeVol1.utility:GetCurrentChapter()
    return 2.93 * math.max(math.ceil(stage / 2.5), 1)
end

local function vLerp(vec1, vec2, percent)
    return vec1 * (1 - percent) + vec2 * percent
end

---@param player EntityPlayer
---@param position Vector
local function orbAttack(player, position)
    local damage = getLaserDamagePerTick()
    for angle = 0, 45, 45 do
        for directions = 0, 360, 90 do
            local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, position, angle + directions, LASER_DURATION, Vector.Zero, player)
            laser.CollisionDamage = damage
            laser.OneHit = false
            laser.DisableFollowParent = true
            laser:GetData().MilkshakeSalvationBeam = true
        end
    end

    for _, projectile in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
        projectile:Die()
    end
end

---@param laser EntityLaser
function HolyOrb:BeamCollision(laser)
    local data = laser:GetData()
    if not data.MilkshakeSalvationBeam then
        return
    end

    -- check for collisions by getting the samples of a laser
    -- dont let the method name spook you. this is the only way.
    local samples = laser:GetNonOptimizedSamples()
    local room = Game():GetRoom()
    for i = 0, #samples - 1 do
        local point = samples:Get(i)
        local gridEntity = room:GetGridEntityFromPos(point)

        if gridEntity then
            if gridEntity:GetType() == GridEntityType.GRID_DOOR then
                local door = gridEntity:ToDoor()
                if door:CanBlowOpen() then
                    door:TryBlowOpen(true, laser)
                end
            elseif GRID_DESTRUCTION_WHITELIST[gridEntity:GetType()] then
                gridEntity:Destroy(false)
            end
        end
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_LASER_UPDATE,
    HolyOrb.BeamCollision,
    LaserVariant.LIGHT_BEAM
)

---@param orb EntityEffect
function HolyOrb:OrbEffect(orb)
    local sprite = orb:GetSprite()
    local data = orb:GetData()

    data.Timer = data.Timer or 0
    data.FloorPosition = data.FloorPosition or Game():GetRoom():GetCenterPos()
    orb.DepthOffset = 10000
    orb.Timeout = -1

    if sprite:IsPlaying("Rise") then
        local progress = sprite:GetFrame() / APPEAR_LENGTH
        local offset = Vector(0, -progress * FLOAT_UP_OFFSET)
        orb.PositionOffset = offset
    end

    if sprite:IsFinished("Rise") then
        orb.State = APPEAR_STATE
        sprite:Play("Idle", true)
    end

    if sprite:IsPlaying("Idle") then
        if orb.State == APPEAR_STATE then
            data.Timer = data.Timer + 1
            if data.Timer > FALL_DELAY_DURATION then
                orb.State = FALL_STATE
                data.Timer = 0
            end
        elseif orb.State == FALL_STATE then
            if data.Timer / FALL_TIME >=1 then
                orb.State = PRE_LASER_WAIT_STATE
                data.Timer = 0
                return
            end

            data.Timer = data.Timer + 1

            local progress = data.Timer / FALL_TIME
            orb.PositionOffset = vLerp(orb.PositionOffset, Vector.Zero, progress)
            orb.Position = vLerp(orb.Position, data.FloorPosition, progress)
        elseif orb.State == PRE_LASER_WAIT_STATE then
            data.Timer = data.Timer + 1
            if data.Timer > PRE_LASER_WAIT_TIME then
                orb.State = LASER_STATE
                sprite:Play("Attack", true)
            end
        end
    end

    if sprite:IsPlaying("Attack") and not sprite:WasEventTriggered("Attack") then
        orb.PositionOffset = orb.PositionOffset - Vector(0, 2)
    end

    if sprite:IsEventTriggered("Attack") then
        -- check for player's existance. naturally it'll always have a player, but spawning in from dev console can cause issues.
        -- we dont want it to error cause it is nice to be able to test the animations
        local player = orb.SpawnerEntity and orb.SpawnerEntity:ToPlayer()
        if player then
            orbAttack(player, orb.Position)
        end
    end

    if sprite:IsFinished("Attack") then
        orb:Remove()
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    HolyOrb.OrbEffect,
    enums.Effects.SALVATION_ORB
)

---@param player EntityPlayer
function HolyOrb:OnHolyOrbUse(_, player)
    -- hide the sprite because we are going to animate it
    local sprite = Sprite()
    sprite:Load("gfx/held_item.anm2", true)
    sprite:Play("Idle", true)
    player:AnimatePickup(sprite, true, "UseItem")

    -- "where did you get -40 from" it came to me in a prophecy
    local orbPosition = Vector(0, -40) * (player.SpriteScale.Y + player.PositionOffset.Y)
    local position = player.Position + orbPosition
    local orb = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.SALVATION_ORB, 0, position, Vector.Zero, player)
    orb:GetData().FloorPosition = player.Position
end

MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.ON_ORB_USE,
    HolyOrb.OnHolyOrbUse,
    MilkshakeVol1.enums.Orbs.HOLY
)