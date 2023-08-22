local FlaskHead = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local sfx = SFXManager()

local FLASKHEAD_SPEED = .4

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
function FlaskHead:FlaskHeadUpdate(enemy)
    local sprite = enemy:GetSprite()
    local target = enemy:GetPlayerTarget()
    local data = GetGlassHeadData(enemy)
    local rng = enemy:GetDropRNG()

    if not data.state then data.state = 1 end
    if not data.gridCountdown then data.gridCountdown = 0 end

    if data.init and data.state ~= 6 then
        data.init = data.init - 1
        if data.init <= 0 then
            data.init = nil
        end
        enemy.Velocity = enemy.Velocity * .5

        return
    end

    if utility:IsEnemyScared(enemy) then
        data.targpos = enemy.Position + (enemy.Position - target.Position)
    else
        if not data.targpos
            or enemy:IsFrame(50, 0)
            or (
                data.targpos
                and data.targpos:Distance(enemy.Position) < 100)
            or not enemy.Pathfinder:HasPathToPos(data.targpos, false
            ) then
            data.targpos = Game():GetRoom():GetRandomPosition(0)
            data.gridCountdown = 300 * (rng:RandomInt(2))
        end
    end

    if data.state == 1 then
        sprite:PlayOverlay('HeadIdle')

        if sprite:GetOverlayFrame() == 18 then
            SFXManager():Play(enums.Sounds.GLASSHEAD_LIQUID, .25, 0, false, 4, 0)
        end

        if enemy.Pathfinder:HasPathToPos(data.targpos, false)
            or (utility:IsEnemyScared(enemy) or utility:IsEnemyConfused(enemy)) then
            if (enemy:CollidesWithGrid() or data.gridCountdown > 0) and
                (data.targpos:Distance(enemy.Position) > 100 or data.targpos:Distance(enemy.Position) < 100 and
                    not Game():GetRoom():CheckLine(enemy.Position, data.targpos, 0, 0, false, false)) then
                enemy.Pathfinder:FindGridPath(data.targpos, FLASKHEAD_SPEED, 1, false)
                if data.gridCountdown <= 0 then
                    data.gridCountdown = 60
                else
                    data.gridCountdown = data.gridCountdown - 1
                end
            else
                local targetvel = (data.targpos - enemy.Position):Resized(FLASKHEAD_SPEED * 6)
                ---@diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
                enemy.Velocity = TSIL.Utils.Math.Lerp(enemy.Velocity, targetvel, 0.25)
            end

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
            enemy.Velocity = enemy.Velocity * .5
        end

        -- unused head puff
        --   if sprite:GetOverlayFrame()==18 then
        --    local eff = Isaac.Spawn(1000, enums.Effects.FLASK_HEAD_HEAD_PUFF, 0, enemy.Position, enemy.Velocity, enemy)
        --    eff.SpriteOffset = Vector(0,-40)
        --    eff.Parent = enemy
        --    eff:GetSprite().Color = Color(1,1,1,.75,0,0,0)
        --  end

        if enemy:IsFrame(10, 0) then
            local positionOffset = Vector(
                TSIL.Random.GetRandomInt(-10, 10, rng),
                TSIL.Random.GetRandomInt(-10, 10, rng)
            )
            local spawnPos = enemy.Position + positionOffset
            local spawnVel = enemy.Velocity * -.5

            local effect = TSIL.EntitySpecific.SpawnEffect(
                enums.Effects.FLASK_HEAD_PUFF,
                0,
                spawnPos,
                spawnVel,
                enemy
            )
            effect:GetSprite().Color = Color(1, 1, 1, .75, 0, 0, 0)
            effect.SpriteOffset = Vector(0, -40)
        end
    elseif data.state == 6 then
        enemy:GetSprite():RemoveOverlay()
        sprite:Play('Throw')

        if sprite:IsEventTriggered("Throw") then
            local targpos = target.Position + Vector(rng:RandomInt(100) - 50, rng:RandomInt(100) - 50)
            Isaac.Spawn(
                enums.Enemies.GLASS_HEAD,
                enums.GlassHeadVariant.FLASK_HEAD,
                enums.FlaskHeadSubType.HEAD_PROJECTILE,
                enemy.Position,
                (targpos - enemy.Position):Resized(targpos:Distance(enemy.Position) * .075),
                enemy
            )
            sfx:Play(SoundEffect.SOUND_SHELLGAME, .5, 0, false, 1, 0)
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 4, 0, false, 2, 0)
        elseif sprite:IsFinished("Throw") then
            enemy.CanShutDoors = false
        end

        enemy.Velocity = enemy.Velocity * .85
    end
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_NPC_UPDATE_FILTER,
    FlaskHead.FlaskHeadUpdate,
    {
        enums.Enemies.GLASS_HEAD,
        enums.GlassHeadVariant.FLASK_HEAD,
        enums.FlaskHeadSubType.FLASK_HEAD
    }
)

function FlaskHead:FlaskHeadProjectile_Init(enemy)
    local data = GetGlassHeadData(enemy)
    if not data.Height then data.Height = 60 end

    enemy:GetSprite():Play("Throw_Head")
    enemy.SpriteOffset = Vector(0, -data.Height)
    enemy.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    enemy.GridCollisionClass = GridCollisionClass.COLLISION_WALL
    enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_NPC_INIT_FILTER,
    FlaskHead.FlaskHeadProjectile_Init,
    {
        enums.Enemies.GLASS_HEAD,
        enums.GlassHeadVariant.FLASK_HEAD,
        enums.FlaskHeadSubType.HEAD_PROJECTILE
    }
)


function FlaskHead:FlaskHeadProjectile_Update(enemy)
    local sprite = enemy:GetSprite()
    local data = GetGlassHeadData(enemy)
    local rng = enemy:GetDropRNG()

    if not data.State then
        if not data.FallingAccel then data.FallingAccel = 1 end
        if not data.FallingSpeed then data.FallingSpeed = -8 end

        data.Height = data.Height - data.FallingSpeed
        data.FallingSpeed = data.FallingSpeed + data.FallingAccel

        if enemy:IsFrame(2, 0) then
            local positionOffset = Vector(
                TSIL.Random.GetRandomInt(-10, 10, rng),
                TSIL.Random.GetRandomInt(-10, 10, rng)
            )
            local spawnPos = enemy.Position + positionOffset
            local spawnVel = enemy.Velocity * -.5

            local effect = TSIL.EntitySpecific.SpawnEffect(
                enums.Effects.FLASK_HEAD_PUFF,
                0,
                spawnPos,
                spawnVel,
                enemy
            )

            effect:GetSprite().Color = Color(1, 1, 1, .75, 0, 0, 0)
            effect.SpriteOffset = Vector(0, -(data.Height + 10))
        end

        if data.Height <= 10 then
            data.FallingAccel = nil
            data.FallingSpeed = nil
            data.Height = nil

            enemy.SpriteOffset = Vector(0, 0)
            if rng:RandomInt(2) + 1 == 1 then
                sprite.FlipX = true
            end
            data.State = 1

            local color = Color(0, .9, .9, 1, 0, .75, 0)

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
            giantExplosion:GetSprite().Color = color

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
            swirl:GetSprite().Color = color

            local creep = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.CREEP_RED,
                0,
                enemy.Position + Vector(
                    TSIL.Random.GetRandomInt(-20, 20, rng),
                    TSIL.Random.GetRandomInt(-20, 20, rng)
                ),
                Vector.Zero,
                enemy
            )
            creep:GetSprite().Color = color
            creep.SpriteScale = Vector(3, 3)
            creep.Timeout = 400
            creep:Update()

            for _ = 1, 3 do
                local dist = rng:RandomInt(40) + 20
                local smallCreep = TSIL.EntitySpecific.SpawnEffect(
                    EffectVariant.CREEP_RED,
                    0,
                    enemy.Position + Vector.FromAngle(rng:RandomInt(360)):Resized(dist),
                    Vector.Zero,
                    enemy
                )

                smallCreep:GetSprite().Color = color
                smallCreep.Scale = (rng:RandomInt(10) + 10) / 10
                smallCreep.Timeout = 400
                smallCreep:Update()
            end

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
                mediumExplosion.Velocity = (mediumExplosion.Position - enemy.Position):Resized(rng:RandomInt(5) + 3)
                mediumExplosion:GetSprite().Color = color
            end

            Game():BombExplosionEffects(
                enemy.Position + Vector(0, 10),
                20,
                TearFlags.TEAR_NORMAL,
                Color(0, 1, 0, 1, 0, 0, 0),
                enemy,
                1,
                false,
                true
            )

            local smoke = TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.SMOKE_CLOUD,
                0,
                enemy.Position,
                Vector.Zero,
                enemy
            )
            smoke.Timeout = 600

            sfx:Play(enums.Sounds.GLASSHEAD_SHATTER, 4, 0, false, 1, 0)
            sfx:Play(SoundEffect.SOUND_HEARTOUT, 1, 0, false, 1, 0)
        else
            sprite:Play("Throw_Head")
            enemy.SpriteOffset = Vector(0, -data.Height)
        end
        enemy.Velocity = enemy.Velocity * .95
    else
        sprite:Play("Death")
        enemy.Velocity = Vector.Zero
    end
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_NPC_UPDATE_FILTER,
    FlaskHead.FlaskHeadProjectile_Update,
    {
        enums.Enemies.GLASS_HEAD,
        enums.GlassHeadVariant.FLASK_HEAD,
        enums.FlaskHeadSubType.HEAD_PROJECTILE
    }
)


function FlaskHead:FlaskHead_HeadPuff_Init(effect)
    local rng = effect:GetDropRNG()
    local sprite = effect:GetSprite()

    sprite:Play("HeadPoof")
    if rng:RandomInt(2) + 1 == 1 then
        sprite.FlipX = true
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_INIT,
    FlaskHead.FlaskHead_HeadPuff_Init,
    enums.Effects.FLASK_HEAD_HEAD_PUFF
)


function FlaskHead:FlaskHead_HeadPuff_Update(effect)
    local sprite = effect:GetSprite()

    if effect.Parent then
        effect.Position = effect.Parent.Position
        effect.Velocity = effect.Parent.Velocity
    end


    sprite:Play("HeadPoof")
    if sprite:IsFinished("HeadPoof") then
        effect:Remove()
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    FlaskHead.FlaskHead_HeadPuff_Update,
    enums.Effects.FLASK_HEAD_HEAD_PUFF
)


function FlaskHead:FlaskHead_Puff_Init(effect)
    local rng = effect:GetDropRNG()
    local sprite = effect:GetSprite()
    local data = GetGlassHeadData(effect)

    if rng:RandomInt(2) + 1 == 1 then
        sprite.FlipX = true
    end
    data.anim = rng:RandomInt(2) + 1
    sprite:Play("Poof" .. data.anim)
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_INIT,
    FlaskHead.FlaskHead_Puff_Init,
    enums.Effects.FLASK_HEAD_PUFF
)


function FlaskHead:FlaskHead_Puff_Update(effect)
    local sprite = effect:GetSprite()
    local data = GetGlassHeadData(effect)

    sprite:Play("Poof" .. data.anim)
    if sprite:IsFinished("Poof" .. data.anim) then
        effect:Remove()
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    FlaskHead.FlaskHead_Puff_Update,
    enums.Effects.FLASK_HEAD_PUFF
)
