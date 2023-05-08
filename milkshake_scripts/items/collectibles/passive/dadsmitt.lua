local dadsMitt = {}
local enums = milkshakeMod.enums

local TEAR_MOVEMENT_RATIO = 0.2
local TEAR_DEADZONE_ANGLE = 30

local BOMB_MOVEMENT_RATIO = 0.4
local BOMB_DEADZONE_ANGLE = 30

local LASER_LERP_STRENGTH = 0.02

local TEARS_MULTIPLIER_BONUS = 0.10
local SHOTSPEED_REDUCTION = 0.2

local TRACTOR_BEAM_VARIANT = 7
local A_COMICALLY_SMALL_NUMBER = 0.01
local TEAR_DEADZONE_RANGE = math.cos(math.rad(TEAR_DEADZONE_ANGLE))
local BOMB_DEADZONE_RANGE = math.cos(math.rad(BOMB_DEADZONE_ANGLE))

function dadsMitt:PostTearUpdate(tear)
    if not tear.SpawnerEntity then
        return end
    local player = tear.SpawnerEntity:ToPlayer()
    if not (player and player:HasCollectible(enums.Collectibles.DADS_MITT)) then
        return end
    local tearToPlayer = (player.Position - tear.Position):Normalized()
    local playerDirection = player.Velocity:Normalized()

    if tearToPlayer:Dot(playerDirection) > TEAR_DEADZONE_RANGE then
        return end

    local itemCount = player:GetCollectibleNum(enums.Collectibles.DADS_MITT)
    tear.Velocity = tear.Velocity + player.Velocity*TEAR_MOVEMENT_RATIO*itemCount
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, dadsMitt.PostTearUpdate)

function dadsMitt:PostBombUpdate(bomb)
    if not bomb.IsFetus then
        return end
    if not bomb.SpawnerEntity then
        return end
    local player = bomb.SpawnerEntity:ToPlayer()
    if not (player and player:HasCollectible(enums.Collectibles.DADS_MITT)) then
        return end
    local bombToPlayer = (player.Position - bomb.Position):Normalized()
    local playerDirection = player.Velocity:Normalized()

    if bombToPlayer:Dot(playerDirection) > BOMB_DEADZONE_RANGE then
        return end

    local itemCount = player:GetCollectibleNum(enums.Collectibles.DADS_MITT)
    bomb.Velocity = bomb.Velocity + player.Velocity*BOMB_MOVEMENT_RATIO*itemCount
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, dadsMitt.PostBombUpdate)

function dadsMitt:PostLaserUpdate(laser)
    if not laser.SpawnerEntity then
        return end
    local player = laser.SpawnerEntity:ToPlayer()
    if not (player and player:HasCollectible(enums.Collectibles.DADS_MITT)) then
        return end
    if laser.Variant == TRACTOR_BEAM_VARIANT then
        return end

    local playerDirection = player.Velocity
    local lerpDirection
    if playerDirection:LengthSquared() > A_COMICALLY_SMALL_NUMBER then
        lerpDirection = playerDirection:Normalized()
    else
        if player:GetAimDirection():LengthSquared() > A_COMICALLY_SMALL_NUMBER then
            lerpDirection = player:GetAimDirection():Normalized()
        else
            lerpDirection = Vector.FromAngle(laser.StartAngleDegrees)
        end
    end

    local laserDirection = Vector.FromAngle(laser.AngleDegrees)
    local itemCount = player:GetCollectibleNum(enums.Collectibles.DADS_MITT)
---@diagnostic disable-next-line: undefined-field
    laserDirection:Lerp(lerpDirection, LASER_LERP_STRENGTH*itemCount)
    laser.AngleDegrees = laserDirection:GetAngleDegrees()
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, dadsMitt.PostLaserUpdate)

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
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, dadsMitt.EvaluateCache)