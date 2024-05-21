--[[
  _________              __                 
 /   _____/____  _____ _/  |______  _____   
 \_____  \\__  \ \__  \\   __\__  \ \__  \  
 /        \/ __ \_/ __ \|  |  / __ \_/ __ \_
/_______  (____  (____  /__| (____  (____  /
        \/     \/     \/          \/     \/

   _____              .___              .__.__ 
  /  _  \   ____    __| _/____     ____ |__|__|
 /  /_\  \ /    \  / __ |\__  \   / ___\|  |  |
/    |    \   |  \/ /_/ | / __ \_/ /_/  >  |  |
\____|__  /___|  /\____ |(____  /\___  /|__|__|
        \/     \/      \/     \//_____/        
]]

local Fire = {}


function Fire:PreEntitySpawn(type, variant, subtype)
    if type ~= 618 or variant ~= 127 or subtype ~= 0 then return end

    local room = Game():GetRoom()
    local centerPos = room:GetCenterPos()

    local screenOverlay = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.FIRE_OVERLAY,
        0,
        centerPos
    )
    screenOverlay.DepthOffset = math.maxinteger

    return {
        1000,
        40,
        0
    }
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_ENTITY_SPAWN,
    Fire.PreEntitySpawn
)


---@param rng RNG
local function SpawnFireParticle(rng)
    local room = Game():GetRoom()

    local index = 120 + rng:RandomInt(15)
    local offset = TSIL.Random.GetRandomFloat(-20, 20, rng)

    local pos = room:GetGridPosition(index) + Vector(offset, 0) + Vector(0, 100)

    local particle = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.FIRE_PARTICLE,
        0,
        pos
    )
    particle:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
    local particleRNG = TSIL.RNG.NewRNG(particle.InitSeed)
    local sprite = particle:GetSprite()
    local frame = TSIL.Random.GetRandomInt(0, 1, particleRNG)
    sprite:SetFrame(frame)
    sprite.Rotation = particleRNG:RandomInt(360)
    particle.DepthOffset = 500
    particle.SpriteScale = Vector(1, 1) * TSIL.Random.GetRandomFloat(0.75, 1, particleRNG)
end


---@param effect EntityEffect
function Fire:OnScreenOverlayUpdate(effect)
    if effect.FrameCount % 20 == 0 then
        SpawnFireParticle(effect:GetDropRNG())
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    Fire.OnScreenOverlayUpdate,
    MilkshakeVol1.enums.Effects.FIRE_OVERLAY
)


---@param particle EntityEffect
function Fire:OnFireParticleUpdate(particle)
    if particle.Position.Y < -100 then
        particle:Remove()
    end

    if Game():IsPaused() then return end

    local yStartFading = particle.InitSeed % 100 + 200
    if particle.Position.Y < yStartFading then
        particle.Color = Color(1, 1, 1, particle.Color.A - 0.03)

        if particle.Color.A <= 0 then
            particle:Remove()
        end
    end

    local maxXOffset = (particle.InitSeed % 2)
    local xOffset = math.sin(particle.FrameCount/5) * maxXOffset

    local maxYOffset = particle.InitSeed % 2
    local yOffset = math.cos(particle.FrameCount/50) * maxYOffset

    local velocity = Vector(xOffset, -3 + yOffset)

    particle.Position = particle.Position + velocity
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_RENDER,
    Fire.OnFireParticleUpdate,
    MilkshakeVol1.enums.Effects.FIRE_PARTICLE
)