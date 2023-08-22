local GlassHeads = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local sfx = SFXManager()

local GLASSHEAD_SPEED = .5

local function lerp(vec1, vec2, percent)
    return vec1 * (1 - percent) + vec2 * percent
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
function GlassHeads:GlassHeads_Init(enemy)
    local data = GetGlassHeadData(enemy)
    local rng = TSIL.RNG.NewRNG(enemy.InitSeed)

    data.init = rng:RandomInt(15)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NPC_INIT,
    GlassHeads.GlassHeads_Init,
    enums.Enemies.GLASS_HEAD
)


---@param enemy EntityNPC
function GlassHeads:GlassHead_Update(enemy)
    if enemy.Variant~=0 then return end
    local sprite = enemy:GetSprite()
    local data = GetGlassHeadData(enemy)
    local target = enemy:GetPlayerTarget()
    local rng = enemy:GetDropRNG()

    if not data.state then data.state = 1 end
    if not data.gridCountdown then data.gridCountdown = 0 end 

    if data.init and data.state~=6 then 
        data.init = data.init - 1
        if data.init <= 0 then 
            data.init = nil
        end
        enemy.Velocity = enemy.Velocity * .5

        return
    end

    if sprite:IsEventTriggered("Step") then
        sfx:Play(SoundEffect.SOUND_FETUS_LAND, .5, 0, false, 1, 0)
        sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, .25, 0, false, 1, 0)
    end

    if data.state == 1 then
        if utility:IsEnemyScared(enemy) then 
            data.targpos = enemy.Position + (enemy.Position - target.Position)
        elseif utility:IsEnemyConfused(enemy) then
            if not data.targpos or enemy:IsFrame(25,0) then
                data.targpos = Game():GetRoom():GetRandomPosition(0)
            end
        else
            data.targpos = target.Position
        end 

        if enemy.Pathfinder:HasPathToPos(data.targpos) or (utility:IsEnemyScared(enemy) or utility:IsEnemyConfused(enemy)) then 
            if (enemy:CollidesWithGrid() or data.gridCountdown > 0) and 
            (data.targpos:Length(enemy.Position) > 100 or data.targpos:Length(enemy.Position) < 100 and 
            not Game():GetRoom():CheckLine(enemy.Position, data.targpos, 0, 0, false, false)) then 

                enemy.Pathfinder:FindGridPath(data.targpos, GLASSHEAD_SPEED, 1, false)
                if data.gridCountdown <= 0 then
                    data.gridCountdown = 60
                else
                    data.gridCountdown  = data.gridCountdown - 1
                end 
            else
                local targetvel = (data.targpos - enemy.Position):Resized(GLASSHEAD_SPEED*6)
                enemy.Velocity = lerp(enemy.Velocity, targetvel, 0.25)
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

    elseif data.state==6 then
        sprite:Play('Death')

        if sprite:IsEventTriggered("Smash") then
            local eff = Isaac.Spawn(1000, 2, 4, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1,1)

            local eff = Isaac.Spawn(1000, 2, 5, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1.5,1.5)

            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy):ToEffect()
            creep.SpriteScale = Vector(4,4)
            creep.Timeout = 300
            creep:Update()

            for i=1, 3 do
                local dist = rng:RandomInt(40)+20
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, enemy.Position + Vector.FromAngle(rng:RandomInt(360)):Resized(dist), Vector.Zero, enemy):ToEffect()
                local n = (rng:RandomInt(10)+10)/10 
                creep.SpriteScale = Vector(n,n)
                creep.Timeout = 300
                creep:Update()
            end    

            for i=1, rng:RandomInt(3)+2 do
                Isaac.Spawn(1000, 2, 6, enemy.Position + Vector(rng:RandomInt(100)-50, rng:RandomInt(100)-50), Vector.Zero , enemy)  
            end

            for i=1, rng:RandomInt(5)+3 do
                local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy):ToProjectile()
                proj.Velocity = (proj.Position - enemy.Position):Resized(rng:RandomInt(5)+4)
                proj.Scale = (rng:RandomInt(15)+5)/12 
                proj.FallingSpeed = rng:RandomInt(5)-15 
                proj.FallingAccel= rng:RandomInt(1)+2 
                sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
            end

            sfx:Play(enums.Sounds.GLASSHEAD_SHATTER, 4, 0, false, 1, 0)
            sfx:Play(SoundEffect.SOUND_HEARTOUT, 1, 0, false, 1, 0)

        elseif sprite:IsFinished("Death") then
            enemy.CanShutDoors = false
            enemy.DepthOffset = -10
        end

        enemy.Velocity = enemy.Velocity * .85
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, GlassHeads.GlassHead_Update, enums.Enemies.GLASS_HEAD)


function GlassHeads:GlassHeads_Dmg(enemy, amount, flags, source, _)
    if (amount > 0 and (flags == flags | DamageFlag.DAMAGE_FIRE or flags == flags | DamageFlag.DAMAGE_POOP)) then
        return false
    end
    if GetGlassHeadData(enemy).state==6 then
        return false
    end

    if 0 >= enemy.HitPoints - amount then 
        GetGlassHeadData(enemy).state=6
        enemy.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        enemy.Velocity = -enemy.Velocity:Resized(5)

        if enemy.Velocity.X < 0 then 
            enemy:GetSprite().FlipX = true
        end

        if enemy.Variant==enums.Enemies.BEER_HEAD then
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 4, 0, false, .25, 0)
        else
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 2, 0, false, .75, 0)
        end
        if enemy.Variant==enums.Enemies.WINE_HEAD then
            sfx:Play(SoundEffect.SOUND_SHELLGAME, .5, 0, false, .6)
        end

        return false 
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GlassHeads.GlassHeads_Dmg, enums.Enemies.GLASS_HEAD)
