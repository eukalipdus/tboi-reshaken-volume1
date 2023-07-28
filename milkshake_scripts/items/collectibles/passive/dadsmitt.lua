local dadsMitt = {}
local enums = MilkshakeVol1.enums

local DEADZONE_ANGLE = 60

local TEAR_MOVEMENT_RATIO = 0.2
local BOMB_MOVEMENT_RATIO = 0.4
local TECHX_MOVEMENT_RATIO = 0.2
local KNIFE_MOVEMENT_RATIO = 0.05
local KNIFE_OFFSET_STRENGTH = 0.01

local LASER_LERP_STRENGTH = 0.03
local LERP_STANDING_MULTIPLIER = 10

local TEARS_MULTIPLIER_BONUS = 0.10
local SHOTSPEED_REDUCTION = 0.2

local A_COMICALLY_SMALL_NUMBER = 0.01
local DEADZONE_RANGE = math.cos(math.rad(DEADZONE_ANGLE/2))

---@param projectile Entity
local function DadsMittOwner(projectile)
    if not projectile.SpawnerEntity then
        return end
    local player = projectile.SpawnerEntity:ToPlayer()
    if not (player and player:HasCollectible(enums.Collectibles.DADS_MITT)) then
        return end
    return player
end

---@param projectile Entity
---@param movementRatio number
local function MovePlayerProjectile(projectile, movementRatio)
    local player = DadsMittOwner(projectile)
    if not player then
        return end
    local projectileToPlayer = (player.Position - projectile.Position):Normalized()
    local playerDirection = player.Velocity:Normalized()

    if projectileToPlayer:Dot(playerDirection) > DEADZONE_RANGE then
        return end

    local itemCount = player:GetCollectibleNum(enums.Collectibles.DADS_MITT)
    projectile.Velocity = projectile.Velocity + player.Velocity*movementRatio*itemCount
end

---@param tear EntityTear
function dadsMitt:PostTearUpdate(tear)
    MovePlayerProjectile(tear, TEAR_MOVEMENT_RATIO)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, dadsMitt.PostTearUpdate)

--Comically large DRY violation go!
--Keeping it like that in case some weird edge cases pop up.
--Codes can have a little humidity.

--Nevermind fixed it.

---@param bomb EntityBomb
function dadsMitt:PostBombUpdate(bomb)
    if not bomb.IsFetus then
        return end
    MovePlayerProjectile(bomb, BOMB_MOVEMENT_RATIO)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, dadsMitt.PostBombUpdate)

---@param laser EntityLaser
function dadsMitt:PostLaserUpdate(laser)
    if laser.Variant == LaserVariant.TRACTOR_BEAM then
        return end
    if laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE then
        return MovePlayerProjectile(laser, TECHX_MOVEMENT_RATIO)
    end

    local player = DadsMittOwner(laser)
    if not player then
        return end

    local lerpMultiplier = 1
    local playerDirection = player.Velocity
    local lerpDirection
    if playerDirection:LengthSquared() > A_COMICALLY_SMALL_NUMBER then
        lerpDirection = playerDirection:Normalized()
    else
        lerpMultiplier = LERP_STANDING_MULTIPLIER
        if player:GetAimDirection():LengthSquared() > A_COMICALLY_SMALL_NUMBER then
            lerpDirection = player:GetAimDirection():Normalized()
        else
            lerpDirection = Vector.FromAngle(laser.StartAngleDegrees)
        end
    end

    local laserDirection = Vector.FromAngle(laser.AngleDegrees)
    local itemCount = player:GetCollectibleNum(enums.Collectibles.DADS_MITT)
---@diagnostic disable-next-line: undefined-field
    laserDirection:Lerp(lerpDirection, lerpMultiplier*LASER_LERP_STRENGTH*itemCount)
    laser.AngleDegrees = laserDirection:GetAngleDegrees()
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, dadsMitt.PostLaserUpdate)

---@param knife EntityKnife
function dadsMitt:PostKnifeUpdate(knife)
    local player = DadsMittOwner(knife)
    if not player then
        return end

    local data = knife:GetData()
    if not knife:IsFlying() then
        data.DadsMittKnife = nil
        return
    end
    if not data.DadsMittKnife then
        data.DadsMittKnife = {Velocity = Vector.Zero, Offset = Vector.Zero}
    end
    local knifeMovement = data.DadsMittKnife
    local knifeDirectionParallel = Vector.FromAngle(knife.Rotation):Rotated(90)
    local parallelPlayerVelocity = knifeDirectionParallel:Normalized() * player.Velocity:Dot(knifeDirectionParallel)*KNIFE_MOVEMENT_RATIO

    knifeMovement.Velocity = knifeMovement.Velocity + parallelPlayerVelocity
    knifeMovement.Offset = knifeMovement.Offset + knifeMovement.Velocity
    knife.Position = knife.Position + (knifeMovement.Offset * knife:GetKnifeDistance() * KNIFE_OFFSET_STRENGTH)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, dadsMitt.PostKnifeUpdate)

---@param player EntityPlayer
---@param flag CacheFlag
function dadsMitt:EvaluateCache(player, flag)
    local itemCount = player:GetCollectibleNum(enums.Collectibles.DADS_MITT)
    if itemCount == 0 then
        return end

    if flag == CacheFlag.CACHE_FIREDELAY then
        local multiplier = 1 + (itemCount*TEARS_MULTIPLIER_BONUS)
        local delay = player.MaxFireDelay
        local tears = 30/(delay+1)
        tears = tears * multiplier
        delay = (30/tears)-1
        player.MaxFireDelay = delay
    elseif flag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed - (SHOTSPEED_REDUCTION*itemCount)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, dadsMitt.EvaluateCache)