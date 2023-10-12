local HolyOrb = {}
local enums = MilkshakeVol1.enums

local LASER_DURATION = 60

--Extra measure for catching rocks on edges of lasers.
local ROCK_SEARCH_RANGE = 15
local ROCK_SEARCH_ANGLE_STEP = 45

--For falling animation.
local GRAVITY = 0.1
local THROW_VELOCITY = -2.5

--For changing color as it falls.
local RED_COLOR_LEVEL = 0.8
local GREEN_COLOR_LEVEL = 0.6
local BLUE_COLOR_LEVEL = 0.2
local COLOR_SCALING_RATE = 0.06

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

---@param position Vector
---@param source Entity
local function DestroyGridAtPosition(position, source)
    local room = Game():GetRoom()
    local gridEntity = room:GetGridEntityFromPos(position)

    if gridEntity then
        if gridEntity:GetType() == GridEntityType.GRID_DOOR then
            local door = gridEntity:ToDoor()
            if door:CanBlowOpen() then
                door:TryBlowOpen(true, source)
            end
        elseif GRID_DESTRUCTION_WHITELIST[gridEntity:GetType()] then
            gridEntity:Destroy(false)
        end
    end
end

---@param laser EntityLaser
function HolyOrb:BeamCollision(laser)
    if laser.FrameCount ~= 2 then   --Making the destruction apply only once shouldn't be a big deal, and I'm gonna make this code way worse.
        return
    end
    local data = laser:GetData()
    if not data.MilkshakeSalvationBeam then
        return
    end

    -- check for collisions by getting the samples of a laser
    -- dont let the method name spook you. this is the only way.
    local samples = laser:GetNonOptimizedSamples()
    for i = 0, #samples - 1 do
        local point = samples:Get(i)
        DestroyGridAtPosition(point, laser)
        for angle = 0, 360, ROCK_SEARCH_ANGLE_STEP do
            local pointOffset = Vector.One:Rotated(angle) * ROCK_SEARCH_RANGE
            DestroyGridAtPosition(point + pointOffset, laser)
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

    orb.DepthOffset = 10000
    orb.Timeout = -1

    if sprite:IsPlaying("Idle") then
        --I almost failed physics in high school so please be patient.
        sprite.Offset.Y = data.StartHeight + THROW_VELOCITY*orb.FrameCount + GRAVITY*(orb.FrameCount^2)
        local offsetScale = orb.FrameCount*COLOR_SCALING_RATE
        sprite.Color:SetOffset(RED_COLOR_LEVEL*offsetScale, GREEN_COLOR_LEVEL*offsetScale, BLUE_COLOR_LEVEL*offsetScale)
        if sprite.Offset.Y > 0 then
            sprite:Play("Attack")
        end
        return
    end

    if sprite:IsPlaying("Attack") and not sprite:WasEventTriggered("Attack") then
        orb.PositionOffset = orb.PositionOffset - Vector(0, 2)
    end

    if sprite:IsEventTriggered("Attack") then
        -- check for player's existance. naturally it'll always have a player, but spawning in from dev console can cause issues.
        -- we dont want it to error cause it is nice to be able to test the animations
        local player = orb.SpawnerEntity and orb.SpawnerEntity:ToPlayer()
        if player then
            orbAttack(player, orb.Position+Vector(0,-10))
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

    local orb = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.SALVATION_ORB, 0, player.Position, Vector.Zero, player)
    local data = orb:GetData()
    -- "where did you get ~~-40~~ -20 from" it came to me in a prophecy
    data.StartHeight = -20 * (player.SpriteScale.Y + player.PositionOffset.Y)
    orb:GetSprite().Offset.Y = data.StartHeight
end

MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.ON_ORB_USE,
    HolyOrb.OnHolyOrbUse,
    MilkshakeVol1.enums.Orbs.HOLY
)