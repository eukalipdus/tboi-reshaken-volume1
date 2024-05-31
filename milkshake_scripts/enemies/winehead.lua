local WineHead = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local sfx = SFXManager()

local WINEHEAD_SPEED = .4
local WINE_COLOR = Color(.75, .75, .75, 1, .3, 0, .3)
WINE_COLOR:SetColorize(1, 1, 1, .9)

local function NearSpike(enemy)
    for g = 0, Game():GetRoom():GetGridSize() do
        local grid = Game():GetRoom():GetGridEntity(g)

        if grid and grid:ToSpikes() and grid.State == 0 
        and enemy.Position:Distance(grid.Position) <= 40 then 
            return true
        end
    end
end

---@param enemy Entity
---@return table
local function GetGlassHeadData(enemy)
    local data = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        enemy,
        "GlassHeadData"
    )

    if not data then
        data = {}
        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            enemy,
            "GlassHeadData",
            data
        )
    end

    return data
end

---@param enemy EntityNPC
function WineHead:WineHead_Update(enemy)
    local sprite = enemy:GetSprite()
    local data = GetGlassHeadData(enemy)
    local target = enemy:GetPlayerTarget()
    local rng = enemy:GetDropRNG()
    local room = Game():GetRoom()

    if not data.state then data.state = 1 end
    if not data.gridCountdown then data.gridCountdown = 0 end
    if not data.trigger then data.trigger = rng:RandomInt(100) + 50 end
    if not data.targpos then data.targpos = enemy.Position end

    if data.init and data.state ~= 6 then
        data.init = data.init - 1
        if data.init <= 0 then
            data.init = nil
        end
        enemy.Velocity = enemy.Velocity * .5

        return
    end

    if sprite:GetOverlayAnimation() == "" then 
        sprite:PlayOverlay("HeadIdle") 
    end

    if sprite:IsEventTriggered("Step") then
        sfx:Play(SoundEffect.SOUND_FETUS_LAND, .75, 0, false, 1.5, 0)
    end

    if sprite:GetOverlayAnimation()=="HeadIdle" then
        sprite:PlayOverlay("HeadIdle")

        if sprite:GetOverlayFrame() == 6 then
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, .75, 0, false, 1.5, 0)
        end

        if Game():GetRoom():CheckLine(enemy.Position, target.Position, 3, 0, false, false) then
            data.trigger = data.trigger - 1
        end
        if data.trigger <= 0 then
            data.trigger = 100
            sprite:PlayOverlay("HeadSpinStart")
        end
    elseif sprite:GetOverlayAnimation()=="HeadSpinStart" then
        sprite:PlayOverlay("HeadSpinStart")

        if sprite:IsOverlayFinished("HeadSpinStart") then
            sprite:PlayOverlay("Spin")
        end
    elseif sprite:GetOverlayAnimation()=="Spin" then
        sprite:PlayOverlay("Spin")

        if enemy:IsFrame(10, 0) or rng:RandomInt(15) + 1 == 1 then
            local posOffset = Vector(
                TSIL.Random.GetRandomInt(-10, 10, rng),
                TSIL.Random.GetRandomInt(-10, 10, rng)
            )
            local spawnPos = enemy.Position + posOffset
            local spawnVel = (spawnPos - enemy.Position):Resized(rng:RandomInt(5) + 4)

            -- Projectiles collide with enemy when perma charmed
            --[[local proj = TSIL.EntitySpecific.SpawnProjectile(
                ProjectileVariant.PROJECTILE_NORMAL,
                0,
                spawnPos,
                spawnVel,
                enemy
            )]]

            local proj = enemy:FireBossProjectiles(1, spawnPos, 0, ProjectileParams())
            proj.Velocity = spawnVel

            proj.Scale = (rng:RandomInt(15) + 5) / 12
            proj.FallingSpeed = rng:RandomInt(5) - 20
            proj.FallingAccel = rng:RandomInt(1) + 1
            proj.Height = -40
            proj:AddProjectileFlags(ProjectileFlags.SMART)
            proj.HomingStrength = .5
            GetGlassHeadData(proj).WineHead = true

            local eff = Isaac.Spawn(1000, 2, 6, proj.Position, proj.Velocity * .5, enemy)
            eff.SpriteOffset = Vector(0, proj.Height)
            eff.DepthOffset = 10
            eff:GetSprite().Color = WINE_COLOR

            sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
        end

        if enemy:IsFrame(5, 0) then
            sfx:Play(SoundEffect.SOUND_SHELLGAME, .3, 0, false, .5)
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 1, 0, false, 2, 0)
        end


        data.trigger = data.trigger - 1
        if data.trigger <= 0 then
            data.trigger = nil
            sprite:PlayOverlay("HeadSpinEnd")
        end
    elseif sprite:GetOverlayAnimation()=="HeadSpinEnd" then
        sprite:PlayOverlay("HeadSpinEnd")

        if sprite:IsOverlayFinished("HeadSpinEnd") then
            sprite:PlayOverlay("HeadIdle")
        end
    end


    if data.state ~= 6 then 
        if enemy.Velocity:Length() > .25 then
            if math.abs(enemy.Velocity.Y) > math.abs(enemy.Velocity.X) then
                sprite:Play('WalkVert')
            else
                if enemy.Velocity.X > 0 then
                    sprite:Play('WalkRight')
                else
                    sprite:Play('WalkLeft')
                end
            end
        else
            sprite:SetFrame('WalkVert', 0)
        end
    end

    if data.state == 1 then
        if utility:IsEnemyScared(enemy) then
            data.targpos = enemy.Position + (enemy.Position - target.Position)
        elseif utility:IsEnemyConfused(enemy) then
            if not data.targpos or enemy:IsFrame(25, 0) then
                data.targpos = Game():GetRoom():GetRandomPosition(0)
            end
        elseif enemy.Pathfinder:HasPathToPos(target.Position, false) and 
        not (enemy.Pathfinder:HasPathToPos(target.Position) and room:GetGridPathFromPos(target.Position) > 950) then
            if enemy:IsFrame(30, 0) or (data.targpos and data.targpos:Distance(enemy.Position) < 100) then
                data.targpos = Game():GetRoom():GetClampedPosition(
                target.Position + Vector(rng:RandomInt(50) - 25, rng:RandomInt(50) - 25), 0)
                data.gridCountdown = 50 * (rng:RandomInt(2))
            end
            data.targpos = Game():GetRoom():GetClampedPosition(data.targpos + target.Velocity, 0)
        end

        if ( enemy.Position:Distance(data.targpos) > 60 or enemy.Position:Distance(data.targpos) < 60 and enemy:CollidesWithGrid()) and ( enemy:CollidesWithGrid()
        or data.gridCountdown >= 0 or NearSpike(enemy)) then
            enemy.Pathfinder:FindGridPath(data.targpos, WINEHEAD_SPEED, 1, false)
            if data.gridCountdown <= 0 then
                data.gridCountdown = 60
            else
                data.gridCountdown = data.gridCountdown - 1
            end

            if enemy.Position:Distance(data.targpos) < 60 then 
                data.state = 2 
            end

        else
            local targetvel = (data.targpos - enemy.Position):Resized(WINEHEAD_SPEED * 6)
            ---@diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
            enemy.Velocity = TSIL.Utils.Math.Lerp(enemy.Velocity, targetvel, 0.25)
        end

    elseif data.state == 2 then
        enemy.Velocity = enemy.Velocity * .5
        if enemy.Pathfinder:HasPathToPos(target.Position, false) and room:GetGridPathFromPos(target.Position) < 950 then
            data.state = 1
        end

    elseif data.state == 6 then
        sprite:RemoveOverlay()
        sprite:Play('Death')

        if sprite:IsEventTriggered("Smash") then
            local giantExplosion = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.BLOOD_EXPLOSION,
                TSIL.Enums.BloodExplosionSubType.GIANT,
                enemy.Position + Vector(
                    TSIL.Random.GetRandomInt(-20, 20, rng),
                    TSIL.Random.GetRandomInt(-20, 20, rng)
                ),
                Vector.Zero,
                enemy
            )
            giantExplosion.SpriteScale = Vector(1, 1)
            giantExplosion:GetSprite().Color = WINE_COLOR

            local swirl = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.BLOOD_EXPLOSION,
                TSIL.Enums.BloodExplosionSubType.SWIRL,
                enemy.Position + Vector(
                    TSIL.Random.GetRandomInt(-20, 20, rng),
                    TSIL.Random.GetRandomInt(-20, 20, rng)
                ),
                Vector.Zero,
                enemy
            )
            swirl.SpriteScale = Vector(1.5, 1.5)
            swirl:GetSprite().Color = WINE_COLOR

            --[[local bigCreep = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.CREEP_RED,
                0,
                enemy.Position + Vector(
                    TSIL.Random.GetRandomInt(-20, 20, rng),
                    TSIL.Random.GetRandomInt(-20, 20, rng)
                ),
                Vector.Zero,
                enemy
            )
            bigCreep.SpriteScale = Vector(3.5, 3.5)
            bigCreep:GetSprite().Color = WINE_COLOR
            bigCreep.Timeout = 200
            bigCreep:Update()
            data.creep = bigCreep

            for _ = 1, 3 do
                local dist = rng:RandomInt(40) + 30
                local creep = TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.CREEP_RED,
                    0,
                    enemy.Position + Vector.FromAngle(rng:RandomInt(360)):Resized(dist),
                    Vector.Zero,
                    enemy
                )
                local n = (rng:RandomInt(10) + 10) / 10
                creep.SpriteScale = Vector(n, n)
                creep.Timeout = 200
                creep:GetSprite().Color = WINE_COLOR
                creep:Update()
            end]]

            local baseAngle = (target.Position - enemy.Position):Rotated(rng:RandomInt(50) - 25):GetAngleDegrees()
            local posOffset = Vector.FromAngle(baseAngle):Resized(rng:RandomInt(6) + 15)
            local creep = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.CREEP_RED,
                0,
                enemy.Position + posOffset,
                Vector.Zero,
                enemy
            )
            local n = (rng:RandomInt(3) + 6) / 10
            creep.SpriteScale = Vector(n, n)
            creep.Timeout = 100
            GetGlassHeadData(creep).jamSpread = target.Position
            GetGlassHeadData(creep).trail = rng:RandomInt(3) + 3
            creep:GetSprite().Color = WINE_COLOR
            creep:Update()

            for _ = 1, rng:RandomInt(3) + 2 do
                local mediumExplosion = TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.BLOOD_EXPLOSION,
                    TSIL.Enums.BloodExplosionSubType.MEDIUM,
                    enemy.Position + Vector(
                        TSIL.Random.GetRandomInt(-50, 50, rng),
                        TSIL.Random.GetRandomInt(-50, 50, rng)
                    ),
                    Vector.Zero,
                    enemy
                )
                mediumExplosion:GetSprite().Color = WINE_COLOR
            end

            for _ = 1, rng:RandomInt(3) + 3 do
                local posOffset = Vector(
                    TSIL.Random.GetRandomInt(-20, 20, rng),
                    TSIL.Random.GetRandomInt(-20, 20, rng)
                )
                local spawnPos = enemy.Position + posOffset
                local spawnVel = (target.Position - spawnPos):Rotated(rng:RandomInt(30) - 15):Resized(rng:RandomInt(5) + 4)

                local proj = TSIL.EntitySpecific.SpawnProjectile(
                    ProjectileVariant.PROJECTILE_NORMAL,
                    0,
                    spawnPos,
                    spawnVel,
                    enemy
                )
                proj.Scale = (rng:RandomInt(15) + 5) / 12
                proj.FallingSpeed = rng:RandomInt(10) - 20
                proj.FallingAccel = rng:RandomInt(2) + 1
                GetGlassHeadData(proj).WineHead = true
                GetGlassHeadData(proj).dontSpin = true

                sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
            end

            sfx:Play(enums.Sounds.GLASSHEAD_SHATTER, 4, 0, false, 1, 0)
            sfx:Play(SoundEffect.SOUND_HEARTOUT, .5, 0, false, 1, 0)

            utility:SpawnGlassHeadDeathEffect(enemy)
            enemy:Remove()
        elseif sprite:IsFinished("Death") then
            enemy.CanShutDoors = false
            enemy.DepthOffset = -10

            if not data.creep or not data.creep:Exists() then
                sprite.Color = Color.Lerp(sprite.Color, Color(0,0,0,0,0,0,0), .2)

                if sprite.Color.A < .1 then
                    enemy:Remove()
                end
            end
        end

        enemy.Velocity = enemy.Velocity * .85
    end
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_NPC_UPDATE_FILTER,
    WineHead.WineHead_Update,
    {
        enums.Enemies.GLASS_HEAD,
        enums.GlassHeadVariant.WINE_HEAD,
    }
)

function WineHead:WineHead_Proj(proj)
    if not GetGlassHeadData(proj).WineHead then return end
    proj:GetSprite().Color = WINE_COLOR

    if not GetGlassHeadData(proj).dontSpin then
        proj.Velocity = proj.Velocity:Rotated(-5)
    end
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, WineHead.WineHead_Proj)


function WineHead:WineHead_Creep(effect)
    if not GetGlassHeadData(effect).jamSpread or not GetGlassHeadData(effect).trail then return end
    local sprite = effect:GetSprite()
    local data = GetGlassHeadData(effect)
    local rng = effect:GetDropRNG()

    if effect.FrameCount >= 1 then
        local posOffset = (data.jamSpread - effect.Position):Resized(20) * 1.2
        local creep = TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.CREEP_RED,
            0,
            effect.Position + posOffset,
            Vector.Zero,
            effect
        )
        creep.Scale = effect.Scale + .1
        GetGlassHeadData(creep).jamSpread = data.jamSpread
        creep:Update()
        creep:GetSprite().Color = sprite.Color
        creep.Timeout = effect.Timeout

        if data.trail > 0 then
            GetGlassHeadData(creep).trail = data.trail - 1
        end

        local largeExplosion = TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.BLOOD_EXPLOSION,
            TSIL.Enums.BloodExplosionSubType.LARGE,
            creep.Position + Vector(
                TSIL.Random.GetRandomInt(-15, 15, rng),
                TSIL.Random.GetRandomInt(-15, 15, rng)
            ),
            Vector.Zero,
            effect
        )
        largeExplosion:GetSprite().Color = sprite.Color
        largeExplosion.DepthOffset = 10

        data.jamSpread = nil
        data.trail = nil
    end
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, WineHead.WineHead_Creep, EffectVariant.CREEP_RED)
