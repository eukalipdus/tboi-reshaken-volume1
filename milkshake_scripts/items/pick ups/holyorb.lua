local HolyOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local LASER_DURATION = 60

--Extra measure for catching rocks on edges of lasers.
local ROCK_SEARCH_POSITION_STEP = 40
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
    GridEntityType.GRID_STATUE,
})

local function getLaserDamagePerTick()
    local stage = MilkshakeVol1.utility:GetCurrentChapter()
    return 2.93 * math.max(math.ceil(stage / 2.5), 1)
end

---@param player EntityPlayer
---@param position Vector
---@param isLyra boolean
local function orbAttack(player, position, isLyra)
    local damage = getLaserDamagePerTick()
    local angleStep = 45
    if isLyra then
        angleStep = angleStep/2
    end
    for angle = 0, 360, angleStep do
        local laser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM, position, angle, LASER_DURATION, Vector.Zero, player)
        laser.CollisionDamage = damage
        laser.OneHit = false
        laser.DisableFollowParent = true
        laser:GetData().MilkshakeSalvationBeam = true
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
    local samples = laser:GetSamples()
    local startPos = samples:Get(0)
    local endPos = samples:Get(#samples-1)
    local step = (endPos-startPos):Resized(ROCK_SEARCH_POSITION_STEP)
    local stepCount = math.ceil((endPos-startPos):Length()/ROCK_SEARCH_POSITION_STEP)
    for i = 0, stepCount do
        local point = startPos + (step*i)
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
        local height = data.StartHeight + THROW_VELOCITY*orb.FrameCount + GRAVITY*(orb.FrameCount^2)
        sprite.Offset = Vector(0, height)
        local offsetScale = orb.FrameCount*COLOR_SCALING_RATE
        local color = Color(1,1,1)
        color:SetOffset(RED_COLOR_LEVEL*offsetScale, GREEN_COLOR_LEVEL*offsetScale, BLUE_COLOR_LEVEL*offsetScale)
        sprite.Color = color
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
            orbAttack(player, orb.Position+Vector(0,-10), utility:GetData(orb, "IsLyraBoosted"))
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
---@param flags integer
function HolyOrb:OnHolyOrbUse(_, player, flags)
    -- hide the sprite because we are going to animate it
    local sprite = Sprite()
    sprite:Load("gfx/held_item.anm2", true)
    sprite:Play("Idle", true)
    player:AnimatePickup(sprite, true, "UseItem")

    local orb = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.SALVATION_ORB, 0, player.Position, Vector.Zero, player)
    local data = orb:GetData()
    -- "where did you get ~~-40~~ -20 from" it came to me in a prophecy
    data.StartHeight = -20 * (player.SpriteScale.Y + player.PositionOffset.Y)
    orb:GetSprite().Offset = Vector(0, data.StartHeight)

    utility:SetData(orb, "IsLyraBoosted", flags & enums.UseOrbFlags.DOUBLE_POWER > 0)
end

MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.ON_ORB_USE,
    HolyOrb.OnHolyOrbUse,
    MilkshakeVol1.enums.Orbs.HOLY
)