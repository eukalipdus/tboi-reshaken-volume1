local SapphireOrb = {}
local enums = MilkshakeVol1.enums
local Utilities = MilkshakeVol1.utility


local CLAIRVOYANCE_ORB_DURATION = 30 * 75
local PROJECTILE_REFLECTION_RADIUS = 135
local PROJECTILE_REFLECTION_INTERVAL = 10
local FAKE_CENSER_RADIUS = 70


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "ClairvoyanceOrbPlayerFrames",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "ClairvoyanceDoubleEffectPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param player EntityPlayer
---@param flags UseOrbFlag
function SapphireOrb:OnAmethystOrbUse(_, player, flags)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    player:AddNullCostume(enums.Costumes.CLAIRVOYANCE_ORB)

    local clairvoyanceOrbPlayerFrames = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "ClairvoyanceOrbPlayerFrames"
    )
    local frameCount = Game():GetFrameCount()
    local wasUsingOrb = clairvoyanceOrbPlayerFrames[playerIndex] ~= nil
    clairvoyanceOrbPlayerFrames[playerIndex] = frameCount

    local doubleEffectPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "ClairvoyanceDoubleEffectPerPlayer"
    )
    doubleEffectPerPlayer[playerIndex] = TSIL.Utils.Flags.HasFlags(flags, enums.UseOrbFlags.DOUBLE_POWER)

    if wasUsingOrb then return end
    local aura = TSIL.EntitySpecific.SpawnEffect(
        enums.Effects.CLAIRVOYANCE_AURA,
        0,
        player.Position
    )
    aura.Parent = player
    aura:FollowParent(player)
    aura.DepthOffset = -100
end
MilkshakeVol1:AddCallback(
    enums.Callbacks.ON_ORB_USE,
    SapphireOrb.OnAmethystOrbUse,
    enums.Orbs.PSYCHIC
)


---@param player EntityPlayer
local function TryReflectProjectile(player)
    local rng = player:GetCardRNG(enums.Orbs.PSYCHIC)

    local nearProjectiles = Isaac.FindInRadius(
        player.Position,
        PROJECTILE_REFLECTION_RADIUS,
        EntityPartition.BULLET
    )

    if #nearProjectiles == 0 then
        return
    end

    nearProjectiles = TSIL.Utils.Tables.Map(nearProjectiles, function (_, projectile)
        return projectile:ToProjectile()
    end)

    nearProjectiles = TSIL.Utils.Tables.Filter(nearProjectiles, function (_, projectile)
        return not projectile:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER)
    end)

    if #nearProjectiles == 0 then
        return
    end

    local projectileToReflect = TSIL.Random.GetRandomElementsFromTable(
        nearProjectiles,
        1,
        rng
    )[1]

    local laserSpawnPoint = player.Position + Vector(0, -40 * player.SpriteScale.Y)
    local laserTargetPoint = projectileToReflect.Position + Vector(0, projectileToReflect.Height)
    local laserAngle = (laserTargetPoint - laserSpawnPoint):GetAngleDegrees()
    local laserLength = laserSpawnPoint:Distance(laserTargetPoint)

    local laser = EntityLaser.ShootAngle(
        LaserVariant.TRACTOR_BEAM,
        laserSpawnPoint,
        laserAngle,
        11,
        Vector.Zero,
        player
    )
    laser.Color = Color(1.4, 1, 1, 1, 1, 0, 0.7)
    laser:SetMaxDistance(laserLength)
    laser.DepthOffset = -100

    Utilities:SetData(laser, "IsClairvoyanceLaser", true)
    Utilities:SetData(laser, "LinkedProjectile", projectileToReflect)

    Utilities:SetData(projectileToReflect, "ReflectedVelocity", -projectileToReflect.Velocity)
    projectileToReflect.SpawnerEntity = nil
    projectileToReflect.FallingSpeed = 0
    projectileToReflect.FallingAccel = -0.1
    projectileToReflect:AddProjectileFlags(
        ProjectileFlags.CANT_HIT_PLAYER |
        ProjectileFlags.SMART
    )
    projectileToReflect:ClearProjectileFlags(
        ProjectileFlags.SLOWED
    )

    projectileToReflect.CollisionDamage = player.Damage

    local glow = TSIL.EntitySpecific.SpawnEffect(
        enums.Effects.REFLECTED_PROJECTILE_GLOW,
        0,
        projectileToReflect.Position
    )
    glow.SpriteScale = glow.SpriteScale * projectileToReflect.Scale
    glow.Parent = projectileToReflect
    glow.DepthOffset = -20
end


local function FakeCenserEffect(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local doubleEffectPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "ClairvoyanceDoubleEffectPerPlayer"
    )
    local isDoubleEffect = doubleEffectPerPlayer[playerIndex]

    local radius = FAKE_CENSER_RADIUS
    if isDoubleEffect then
        radius = radius * 1.5
    end

    local nearProjectiles = Isaac.FindInRadius(
        player.Position,
        FAKE_CENSER_RADIUS,
        EntityPartition.BULLET
    )

    for _, entity in ipairs(nearProjectiles) do
        local projectile = entity:ToProjectile()

        if not projectile:HasProjectileFlags(
        ProjectileFlags.HIT_ENEMIES |
        ProjectileFlags.CANT_HIT_PLAYER) then
            projectile:AddProjectileFlags(ProjectileFlags.SLOWED)
        end
    end

    local nearEnemies = Isaac.FindInRadius(
        player.Position,
        FAKE_CENSER_RADIUS,
        EntityPartition.ENEMY
    )

    for _, enemy in ipairs(nearEnemies) do
        if not enemy:IsBoss() then
            enemy:AddSlowing(EntityRef(player), 3, 1, Color(1, 1, 1))
        end
    end
end


---@param player EntityPlayer
function SapphireOrb:OnPeffectUpdate(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local clairvoyanceOrbPlayerFrames = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "ClairvoyanceOrbPlayerFrames"
    )
    local playerUsedClairvoyanceFrame = clairvoyanceOrbPlayerFrames[playerIndex]

    if not playerUsedClairvoyanceFrame then return end

    local currentFrame = Game():GetFrameCount()
    local orbDuration = currentFrame - playerUsedClairvoyanceFrame

    if orbDuration >= CLAIRVOYANCE_ORB_DURATION then
        player:TryRemoveNullCostume(enums.Costumes.CLAIRVOYANCE_ORB)
        clairvoyanceOrbPlayerFrames[playerIndex] = nil
        return
    end

    local doubleEffectPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "ClairvoyanceDoubleEffectPerPlayer"
    )
    local isDoubleEffect = doubleEffectPerPlayer[playerIndex]

    local projectileReflectInterval = PROJECTILE_REFLECTION_INTERVAL
    if isDoubleEffect then
        projectileReflectInterval = math.floor(projectileReflectInterval/2)
    end

    if orbDuration % PROJECTILE_REFLECTION_INTERVAL == 0 then
        TryReflectProjectile(player)
    end

    FakeCenserEffect(player)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    SapphireOrb.OnPeffectUpdate
)


function SapphireOrb:OnNewRoom()
    local players = TSIL.Players.GetPlayers()

    TSIL.Utils.Tables.ForEach(players, function (_, player)
        player:TryRemoveNullCostume(enums.Costumes.CLAIRVOYANCE_ORB)
    end)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    SapphireOrb.OnNewRoom
)


---@param effect EntityEffect
function SapphireOrb:OnClairvoyanceAuraUpdate(effect)
    if not effect.Parent then return end

    local player = effect.Parent:ToPlayer()

    if not player then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local clairvoyanceOrbPlayerFrames = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "ClairvoyanceOrbPlayerFrames"
    )
    local playerUsedClairvoyanceFrame = clairvoyanceOrbPlayerFrames[playerIndex]

    if not playerUsedClairvoyanceFrame then
        effect:Remove()
        return
    end

    effect:FollowParent(effect.Parent)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    SapphireOrb.OnClairvoyanceAuraUpdate,
    enums.Effects.CLAIRVOYANCE_AURA
)


---@param laser EntityLaser
function SapphireOrb:OnLaserUpdate(laser)
    if not Utilities:GetData(laser, "IsClairvoyanceLaser") then return end

    local player = laser.SpawnerEntity
    if not player then return end
    ---@type EntityProjectile
    local projectile = Utilities:GetData(laser, "LinkedProjectile")
    local targetVelocity = Utilities:GetData(projectile, "ReflectedVelocity")
    if not targetVelocity then
        laser:Remove()
        return
    end

    if laser.Timeout == 0 then
        projectile.Velocity = targetVelocity
        projectile.FallingAccel = -0.05
        projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
    elseif laser.Timeout > 0 then
        ---@diagnostic disable-next-line: assign-type-mismatch
        projectile.Velocity = TSIL.Utils.Math.Lerp(
            targetVelocity,
            ---@diagnostic disable-next-line: param-type-mismatch
            projectile.Velocity,
            TSIL.Utils.Easings.EaseOutCirc(laser.Timeout/9)
        )
    else
        laser.Color = Color(
            laser.Color.R,
            laser.Color.G,
            laser.Color.B,
            laser.Color.A - 0.2,
            laser.Color.RO,
            laser.Color.GO,
            laser.Color.BO
        )
    end

    local laserSpawnPoint = player.Position + Vector(0, -40 * player.SpriteScale.Y)
    local laserTargetPoint = projectile.Position + Vector(0, projectile.Height)
    local laserAngle = (laserTargetPoint - laserSpawnPoint):GetAngleDegrees()
    local laserLength = laserSpawnPoint:Distance(laserTargetPoint)

    laser.AngleDegrees = laserAngle
    laser:SetMaxDistance(laserLength)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_LASER_UPDATE,
    SapphireOrb.OnLaserUpdate
)


---@param glow EntityEffect
function SapphireOrb:OnReflectedProjectileGlowUpdate(glow)
    if not glow.Parent then
        glow:Remove()
        return
    end

    local projectile = glow.Parent:ToProjectile()
    glow.Position = projectile.Position + Vector(0, projectile.Height)

    if glow:GetSprite():IsFinished("Idle") then
        glow:Remove()
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    SapphireOrb.OnReflectedProjectileGlowUpdate,
    enums.Effects.REFLECTED_PROJECTILE_GLOW
)