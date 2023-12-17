local BeerHead = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local sfx = SFXManager()

local BEERHEAD_SPEED = .3
local BEERHEAD_DASH_SPEED = 1
local BEER_COLOR = Color(.5, .5, .5, 1, 1, .5, 0)
local BEER_PROJECTILE_COLOR = Color(1, 1, 1, 1, 1, .5, 0)
BEER_PROJECTILE_COLOR:SetColorize(1, .9, .75, .8)

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
function BeerHead:BeerHead_Update(enemy)
    local sprite = enemy:GetSprite()
    local data = GetGlassHeadData(enemy)
    local target = enemy:GetPlayerTarget()
    local rng = enemy:GetDropRNG()
    local room = Game():GetRoom()

    if not data.state then data.state = 1 end
    if not data.gridCountdown then data.gridCountdown = 0 end
    if not data.trigger then data.trigger = rng:RandomInt(100) + 100 end

    if data.init and data.state ~= 6 then
        data.init = data.init - 1
        if data.init <= 0 then
            data.init = nil
        end
        enemy.Velocity = enemy.Velocity * .5

        return
    end

    if data.state ~= 2 and data.state ~= 4 and data.state ~= 6 then
        if data.state == 3 then
            if math.abs(enemy.Velocity.Y) > math.abs(enemy.Velocity.X) then
                if enemy.Velocity.Y > 0 then
                    sprite:Play('WalkDown_Rush')
                else
                    sprite:Play('WalkUp_Rush')
                end
            else
                if enemy.Velocity.X > 0 then
                    sprite:Play('WalkRight_Rush')
                else
                    sprite:Play('WalkLeft_Rush')
                end
            end
        else
            if enemy.Velocity:Length() > .1 then
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
    end

    if data.state == 1 or data.state == 3 then
        if target.Position:Distance(enemy.Position) < 100 then
            data.trigger = data.trigger - 2
        else
            data.trigger = data.trigger - 1
        end

        if data.trigger <= 0 then
            if data.state == 1 then
                data.trigger = nil
                data.state = 2
            else
                data.trigger = rng:RandomInt(250) + 50
                data.state = 4
            end
            data.targpos = nil
            data.gridCountdown = 0
            return
        end

        if sprite:IsEventTriggered("Step") then
            sfx:Play(SoundEffect.SOUND_FETUS_LAND, .75, 0, false, .75, 0)
        elseif sprite:IsEventTriggered("Shlosh") then
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, .5, 0, false, .5, 0)
        end

        local Speed = BEERHEAD_SPEED

        if data.state == 3 then
            if not data.targpos or enemy:IsFrame(50, 0) or (data.targpos and data.targpos:Distance(enemy.Position) < 100) or not enemy.Pathfinder:HasPathToPos(data.targpos, false) then
                data.targpos = Game():GetRoom():GetRandomPosition(0)
                data.gridCountdown = 300 * (rng:RandomInt(2))
            end
            Speed = BEERHEAD_DASH_SPEED
        elseif utility:IsEnemyScared(enemy) then
            data.targpos = enemy.Position + (enemy.Position - target.Position)
        elseif utility:IsEnemyConfused(enemy) then
            if not data.targpos or enemy:IsFrame(25, 0) then
                data.targpos = Game():GetRoom():GetRandomPosition(0)
            end
        else
            if enemy.Pathfinder:HasPathToPos(target.Position, false) or not data.targpos then
                data.targpos = target.Position
            end
        end
    
        if (enemy:CollidesWithGrid() or data.gridCountdown > 0 or NearSpike(enemy)) and
            (data.targpos:Distance(enemy.Position) > 100 or data.targpos:Distance(enemy.Position) < 100 and
                not room:CheckLine(enemy.Position, data.targpos, 0, 0, false, false)) then
            enemy.Pathfinder:FindGridPath(data.targpos, Speed, 1, false)
            if data.gridCountdown <= 0 then
                data.gridCountdown = 60
            else
                data.gridCountdown = data.gridCountdown - 1
            end

            if data.state==1 and data.gridCountdown % 50 == 0 and (not enemy.Pathfinder:HasPathToPos(target.Position) or 
            (enemy.Pathfinder:HasPathToPos(target.Position) and room:GetGridPathFromPos(target.Position) > 950)) then -- over rocks next to enemy
                data.state = 5 
            end

        else
            local targetvel = (data.targpos - enemy.Position):Resized(Speed * 6)
            ---@diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
            enemy.Velocity = TSIL.Utils.Math.Lerp(enemy.Velocity, targetvel, 0.25)
        end

        if data.state == 3 then
            local tab = {
                ["WalkDown_Rush"] = Vector(0, -1),
                ["WalkUp_Rush"] = Vector(0, 1),
                ["WalkRight_Rush"] = Vector(-1, 0),
                ["WalkLeft_Rush"] = Vector(1, 0)
            }

            if enemy:IsFrame(2, 0) then
                local creep = TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.CREEP_SLIPPERY_BROWN,
                    0,
                    enemy.Position + Vector(
                        TSIL.Random.GetRandomInt(-5, 5, rng),
                        TSIL.Random.GetRandomInt(-5, 5, rng)
                    ),
                    Vector.Zero,
                    enemy
                )
                local n = (rng:RandomInt(8) + 5) / 10
                GetGlassHeadData(creep).BeerHead = true
                creep.SpriteScale = Vector(n, n)
                creep.Timeout = 200
                creep:Update()
            end

            if enemy:IsFrame(4, 0) then
                local posOffset = Vector(
                    TSIL.Random.GetRandomInt(-10, 10, rng),
                    TSIL.Random.GetRandomInt(-10, 10, rng)
                )
                posOffset = posOffset + tab[sprite:GetAnimation()] * 30

                local beerExplosion = TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.BLOOD_EXPLOSION,
                    TSIL.Enums.BloodExplosionSubType.LARGE,
                    enemy.Position + posOffset,
                    enemy.Velocity * -.5,
                    enemy
                )
                beerExplosion:GetSprite().Color = BEER_COLOR
                sfx:Play(SoundEffect.SOUND_ROTTEN_HEART, .25, 0, false, 1)
            end

            if enemy:IsFrame(10, 0) then
                sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 4, 0, false, 1.5, 0)
            end

            if rng:RandomInt(5) + 1 == 1 then
                local posOffset = Vector(
                    TSIL.Random.GetRandomInt(-10, 10, rng),
                    TSIL.Random.GetRandomInt(-10, 10, rng)
                )
                posOffset = posOffset + tab[sprite:GetAnimation()] * 30
                local spawnPos = enemy.Position + posOffset
                local spawnVel = (spawnPos - enemy.Position):Resized(rng:RandomInt(5) + 4)

                local projectile = TSIL.EntitySpecific.SpawnProjectile(
                    ProjectileVariant.PROJECTILE_NORMAL,
                    0,
                    spawnPos,
                    spawnVel,
                    enemy
                )

                projectile.Scale = (rng:RandomInt(15) + 5) / 12
                projectile.FallingSpeed = rng:RandomInt(5) - 15
                projectile.FallingAccel = rng:RandomInt(1) + 2
                projectile:GetSprite().Color = BEER_PROJECTILE_COLOR

                sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
            end
        end

    elseif data.state==5 then 

        enemy.Velocity = enemy.Velocity * .75
        if enemy.Pathfinder:HasPathToPos(target.Position, false) and room:GetGridPathFromPos(target.Position) < 950 then
            data.state = 1
        end

    elseif data.state == 2 then
        sprite:Play("Activate")

        enemy.Velocity = enemy.Velocity * .5
        if sprite:IsFinished("Activate") then
            data.state = 3
        end
    elseif data.state == 4 then
        sprite:Play("Deactivate")

        enemy.Velocity = enemy.Velocity * .5
        if sprite:IsFinished("Deactivate") then
            data.state = 1
        end
    elseif data.state == 6 then
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
            giantExplosion:GetSprite().Color = BEER_COLOR

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
            swirl:GetSprite().Color = BEER_COLOR

            local creep = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.CREEP_SLIPPERY_BROWN,
                0,
                enemy.Position + Vector(
                    TSIL.Random.GetRandomInt(-20, 20, rng),
                    TSIL.Random.GetRandomInt(-20, 20, rng)
                ),
                Vector.Zero,
                enemy
            )
            creep.SpriteScale = Vector(7, 7)
            creep.Scale = 1.5
            GetGlassHeadData(creep).BeerHead = true
            creep.Timeout = 300
            creep:Update()
            data.creep = creep

            for _ = 1, 5 do
                local dist = rng:RandomInt(40) + 40
                local smallCreep = TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.CREEP_SLIPPERY_BROWN,
                    0,
                    enemy.Position + Vector.FromAngle(rng:RandomInt(360)):Resized(dist),
                    Vector.Zero,
                    enemy
                )

                local n = (rng:RandomInt(10) + 10) / 10
                smallCreep.SpriteScale = Vector(n, n)
                smallCreep.Timeout = 300
                GetGlassHeadData(smallCreep).BeerHead = true
                smallCreep:Update()
            end

            for _ = 1, rng:RandomInt(3) + 2 do
                local mediumExplosion = TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.BLOOD_EXPLOSION,
                    TSIL.Enums.BloodExplosionSubType.MEDIUM,
                    enemy.Position + Vector(
                        TSIL.Random.GetRandomInt(-20, 20, rng),
                        TSIL.Random.GetRandomInt(-20, 20, rng)
                    ),
                    Vector.Zero,
                    enemy
                )
                mediumExplosion:GetSprite().Color = BEER_COLOR
            end

            for _ = 1, rng:RandomInt(3) + 3 do
                local posOffset = Vector(
                    TSIL.Random.GetRandomInt(-20, 20, rng),
                    TSIL.Random.GetRandomInt(-20, 20, rng)
                )
                local spawnPos = enemy.Position + posOffset
                local spawnVel = (spawnPos - enemy.Position):Resized(rng:RandomInt(5) + 4)

                local projectile = TSIL.EntitySpecific.SpawnProjectile(
                    ProjectileVariant.PROJECTILE_NORMAL,
                    0,
                    spawnPos,
                    spawnVel,
                    enemy
                )
                projectile.Scale = (rng:RandomInt(15) + 5) / 12
                projectile.FallingSpeed = rng:RandomInt(5) - 15
                projectile.FallingAccel = rng:RandomInt(1) + 2
                projectile:GetSprite().Color = BEER_PROJECTILE_COLOR

                sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
            end

            sfx:Play(enums.Sounds.GLASSHEAD_SHATTER, 1, 0, false, 1, 0)
            sfx:Play(SoundEffect.SOUND_HEARTOUT, 1, 0, false, 1, 0)

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
    BeerHead.BeerHead_Update,
    {
        enums.Enemies.GLASS_HEAD,
        enums.GlassHeadVariant.BEER_HEAD,
    }
)

function BeerHead:BeerHead_Creep(effect)
    if not GetGlassHeadData(effect).BeerHead then return end
    local sprite = effect:GetSprite()
    sprite:SetFrame(0)
    if effect.Timeout > 0 then
        sprite.Color = BEER_COLOR
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    BeerHead.BeerHead_Creep,
    EffectVariant.CREEP_SLIPPERY_BROWN
)
