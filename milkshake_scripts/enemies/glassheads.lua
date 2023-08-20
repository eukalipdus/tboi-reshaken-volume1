local GlassHeads = {}
local enums = MilkshakeVol1.enums
local sfx = SFXManager()

local GLASSHEAD_SPEED = .5
local FLASKHEAD_SPEED = .4
local BEERHEAD_SPEED = .3
local BEERHEAD_SPEED_2 = 1
local WINEHEAD_SPEED = .4

local function lerp(vec1, vec2, percent)
    return vec1 * (1 - percent) + vec2 * percent
end

local function isScared(Enemy) 
    if Enemy:HasEntityFlags(EntityFlag.FLAG_FEAR) or Enemy:HasEntityFlags(EntityFlag.FLAG_SHRINK) then 
        return true
    end
end
local function isConfused(Enemy) 
    if Enemy:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then 
        return true
    end
end


function GlassHeads:GlassHeads_Init(enemy)
    local data = enemy:GetData()
    local rng = enemy:GetDropRNG()

    data.init = rng:RandomInt(15)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_INIT, GlassHeads.GlassHeads_Init, enums.Enemies.GLASS_HEAD)


function GlassHeads:GlassHead_Update(enemy)
    if enemy.Variant~=0 then return end
    local sprite = enemy:GetSprite()
    local data = enemy:GetData()
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
        if isScared(enemy) then 
            data.targpos = enemy.Position + (enemy.Position - target.Position)
        elseif isConfused(enemy) then
            if not data.targpos or enemy:IsFrame(25,0) then
                data.targpos = Game():GetRoom():GetRandomPosition(0)
            end
        else
            data.targpos = target.Position
        end 

        if enemy.Pathfinder:HasPathToPos(data.targpos) or (isScared(enemy) or isConfused(enemy)) then 
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
            creep.SpriteScale = Vector(3,3)
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
    if enemy:GetData().state==6 then
        return false
    end

    if 0 >= enemy.HitPoints - amount then 
        enemy:GetData().state=6
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


-- flask head

function GlassHeads:FlaskHead_Update(enemy)
    if enemy.Variant~=enums.Enemies.FLASK_HEAD or enemy.SubType~=0 then return end
    local sprite = enemy:GetSprite()
    local target = enemy:GetPlayerTarget()   
    local data = enemy:GetData() 
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

    if isScared(enemy) then 
        data.targpos = enemy.Position + (enemy.Position - target.Position)
    else
        if not data.targpos or enemy:IsFrame(50,0) or (data.targpos and data.targpos:Distance(enemy.Position) < 100) or not enemy.Pathfinder:HasPathToPos(data.targpos) then 
            data.targpos = Game():GetRoom():GetRandomPosition(0)
            data.gridCountdown = 300 * (rng:RandomInt(2))
        end
    end 

    if data.state == 1 then
        sprite:PlayOverlay('HeadIdle')

        if sprite:GetOverlayFrame()==18 then
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, .25, 0, false, 4, 0)
        end

        if enemy.Pathfinder:HasPathToPos(data.targpos) or (isScared(enemy) or isConfused(enemy)) then 
            if (enemy:CollidesWithGrid() or data.gridCountdown > 0) and 
            (data.targpos:Length(enemy.Position) > 100 or data.targpos:Length(enemy.Position) < 100 and 
            not Game():GetRoom():CheckLine(enemy.Position, data.targpos, 0, 0, false, false)) then 

                enemy.Pathfinder:FindGridPath(data.targpos, FLASKHEAD_SPEED, 1, false)
                if data.gridCountdown <= 0 then
                    data.gridCountdown = 60
                else
                    data.gridCountdown  = data.gridCountdown - 1
                end 
            else
                local targetvel = (data.targpos - enemy.Position):Resized(FLASKHEAD_SPEED*6)
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

        -- unused head puff
        --   if sprite:GetOverlayFrame()==18 then
            --    local eff = Isaac.Spawn(1000, enums.Effects.FLASK_HEAD_HEAD_PUFF, 0, enemy.Position, enemy.Velocity, enemy)  
            --    eff.SpriteOffset = Vector(0,-40)
            --    eff.Parent = enemy
            --    eff:GetSprite().Color = Color(1,1,1,.75,0,0,0)
        --  end

        if enemy:IsFrame(10,0) then
            local eff = Isaac.Spawn(1000, enums.Effects.FLASK_HEAD_PUFF, 0, enemy.Position + Vector(rng:RandomInt(20)-10, rng:RandomInt(20)-10), enemy.Velocity*-.5, enemy)  
            eff:GetSprite().Color = Color(1,1,1,.75,0,0,0)
            eff.SpriteOffset = Vector(0,-40)
        end

    elseif data.state==6 then
        enemy:GetSprite():RemoveOverlay()
        sprite:Play('Throw')

        if sprite:IsEventTriggered("Throw") then
            local targpos = target.Position + Vector(rng:RandomInt(100)-50, rng:RandomInt(100)-50)
            Isaac.Spawn(enums.Enemies.GLASS_HEAD, enums.Enemies.FLASK_HEAD, enums.Enemies.FLASK_HEAD_PROJECTILE, enemy.Position, (targpos - enemy.Position):Resized(targpos:Distance(enemy.Position)*.075), enemy)
            sfx:Play(SoundEffect.SOUND_SHELLGAME, .5, 0, false, 1, 0)
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 4, 0, false, 2, 0)
        elseif sprite:IsFinished("Throw") then
            enemy.CanShutDoors = false
        end
    
        enemy.Velocity = enemy.Velocity * .85
    end


end
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, GlassHeads.FlaskHead_Update, enums.Enemies.GLASS_HEAD)

function GlassHeads:FlaskHeadProjectile_Init(enemy)
    if enemy.Variant~=enums.Enemies.FLASK_HEAD or enemy.SubType~=enums.Enemies.FLASK_HEAD_PROJECTILE then return end
    local data = enemy:GetData()
    if not data.Height then data.Height = 60 end

    enemy:GetSprite():Play("Throw_Head")
    enemy.SpriteOffset = Vector(0, -data.Height)
    enemy.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    enemy.GridCollisionClass = GridCollisionClass.COLLISION_WALL
    enemy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_INIT, GlassHeads.FlaskHeadProjectile_Init, enums.Enemies.GLASS_HEAD)


function GlassHeads:FlaskHeadProjectile_Update(enemy)
    if enemy.Variant~=enums.Enemies.FLASK_HEAD or enemy.SubType~=enums.Enemies.FLASK_HEAD_PROJECTILE then return end
    local sprite = enemy:GetSprite()
    local data = enemy:GetData()
    local rng = enemy:GetDropRNG()

    if not data.State then 
        if not data.FallingAccel then data.FallingAccel = 1 end
        if not data.FallingSpeed then data.FallingSpeed = -8 end

        data.Height = data.Height - data.FallingSpeed
        data.FallingSpeed = data.FallingSpeed + data.FallingAccel

        if enemy:IsFrame(2,0) then
            local eff = Isaac.Spawn(1000, enums.Effects.FLASK_HEAD_PUFF, 0, enemy.Position + Vector(rng:RandomInt(20)-10, rng:RandomInt(20)-10), enemy.Velocity*-.5, enemy)  
            eff:GetSprite().Color = Color(1,1,1,.75,0,0,0)
            eff.SpriteOffset = Vector(0, -(data.Height+10))
        end

        if data.Height <= 10 then 
            data.FallingAccel = nil
            data.FallingSpeed = nil
            data.Height = nil

            enemy.SpriteOffset = Vector(0, 0)
            if rng:RandomInt(2)+1==1 then 
                sprite.FlipX = true
            end
            data.State = 1

            local color = Color(0,.9,.9,1,0,.75,0)

            local eff = Isaac.Spawn(1000, 2, 4, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1,1)
            eff:GetSprite().Color = color

            local eff = Isaac.Spawn(1000, 2, 5, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1.5,1.5)
            eff:GetSprite().Color = color

            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy):ToEffect()
            creep:GetSprite().Color = color
            creep.SpriteScale = Vector(3,3)
            creep.Timeout = 400
            creep:Update()

            for i=1, 3 do
                local dist = rng:RandomInt(40)+20
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, enemy.Position + Vector.FromAngle(rng:RandomInt(360)):Resized(dist), Vector.Zero, enemy):ToEffect()
                creep:GetSprite().Color = color
                creep.Scale = (rng:RandomInt(10)+10)/10 
                creep.Timeout = 400
                creep:Update()
            end    

            for i=1, rng:RandomInt(3)+2 do
                local eff = Isaac.Spawn(1000, 2, 6, enemy.Position + Vector(rng:RandomInt(100)-50, rng:RandomInt(100)-50), Vector.Zero , enemy)  
                eff.Velocity = (eff.Position - enemy.Position):Resized(rng:RandomInt(5)+3)
                eff:GetSprite().Color = color
            end

            Game():BombExplosionEffects(enemy.Position+Vector(0,10), 20, 0, Color(0,1,0,1,0,0,0), enemy, 1, false, true)

            local smoke = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, enemy.Position, Vector.Zero, enemy):ToEffect()
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
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, GlassHeads.FlaskHeadProjectile_Update, enums.Enemies.GLASS_HEAD)


function GlassHeads:FlaskHead_HeadPuff_Init(effect)
    local rng = effect:GetDropRNG()
    local sprite = effect:GetSprite()

    sprite:Play("HeadPoof")
    if rng:RandomInt(2)+1==1 then 
        sprite.FlipX = true
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, GlassHeads.FlaskHead_HeadPuff_Init, enums.Effects.FLASK_HEAD_HEAD_PUFF)


function GlassHeads:FlaskHead_HeadPuff_Update(effect)
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
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, GlassHeads.FlaskHead_HeadPuff_Update, enums.Effects.FLASK_HEAD_HEAD_PUFF)


function GlassHeads:FlaskHead_Puff_Init(effect)
    local rng = effect:GetDropRNG()
    local sprite = effect:GetSprite()
    local data = effect:GetData()

    if rng:RandomInt(2)+1==1 then 
        sprite.FlipX = true
    end
    data.anim = rng:RandomInt(2)+1
    sprite:Play("Poof"..data.anim)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, GlassHeads.FlaskHead_Puff_Init, enums.Effects.FLASK_HEAD_PUFF)


function GlassHeads:FlaskHead_Puff_Update(effect)
    local rng = effect:GetDropRNG()
    local sprite = effect:GetSprite()
    local data = effect:GetData()

    sprite:Play("Poof"..data.anim)
    if sprite:IsFinished("Poof"..data.anim) then 
        effect:Remove()
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, GlassHeads.FlaskHead_Puff_Update, enums.Effects.FLASK_HEAD_PUFF)


-- roo beer
local BeerColor = Color(.5,.5,.5,1,1,.5,0)
local BeerProjColor = Color(1,1,1,1,1,.5,0)
BeerProjColor:SetColorize(1,.9,.75,.8)


function GlassHeads:BeerHead_Update(enemy)
    if enemy.Variant~=enums.Enemies.BEER_HEAD then return end
    local sprite = enemy:GetSprite()
    local data = enemy:GetData()
    local target = enemy:GetPlayerTarget()    
    local rng = enemy:GetDropRNG()

    if not data.state then data.state = 1 end 
    if not data.gridCountdown then data.gridCountdown = 0 end 
    if not data.trigger then data.trigger = rng:RandomInt(100)+100 end 

    if data.init and data.state~=6 then 
        data.init = data.init - 1
        if data.init <= 0 then 
            data.init = nil
        end
        enemy.Velocity = enemy.Velocity * .5

        return
    end

    
    if data.state==1 or data.state==3 then
        if target.Position:Length(enemy.Position) < 100 then 
            data.trigger = data.trigger - 2
        else
            data.trigger = data.trigger - 1
        end

        if data.trigger <= 0 then 
            if data.state == 1 then 
                data.trigger = nil
                data.state = 2
            else
                data.trigger = rng:RandomInt(250)+50
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


        if data.state==3 then
            if not data.targpos or enemy:IsFrame(50,0) or (data.targpos and data.targpos:Distance(enemy.Position) < 100) or not enemy.Pathfinder:HasPathToPos(data.targpos) then 
                data.targpos = Game():GetRoom():GetRandomPosition(0)
                data.gridCountdown = 300 * (rng:RandomInt(2))
            end
            Speed = BEERHEAD_SPEED_2

        elseif isScared(enemy) then 
            data.targpos = enemy.Position + (enemy.Position - target.Position)

        elseif isConfused(enemy) then
            if not data.targpos or enemy:IsFrame(25,0) then
                data.targpos = Game():GetRoom():GetRandomPosition(0)
            end
        else
            data.targpos = target.Position
        end


        if enemy.Pathfinder:HasPathToPos(data.targpos) or (isScared(enemy) or isConfused(enemy)) then 
            if (enemy:CollidesWithGrid() or data.gridCountdown > 0) and 
            (data.targpos:Length(enemy.Position) > 100 or data.targpos:Length(enemy.Position) < 100 and 
            not Game():GetRoom():CheckLine(enemy.Position, data.targpos, 0, 0, false, false)) then 

                enemy.Pathfinder:FindGridPath(data.targpos, Speed, 1, false)
                if data.gridCountdown <= 0 then
                    data.gridCountdown = 60
                else
                    data.gridCountdown  = data.gridCountdown - 1
                end 
            else
                local targetvel = (data.targpos - enemy.Position):Resized(Speed*6)
                enemy.Velocity = lerp(enemy.Velocity, targetvel, 0.25)
            end

            if data.state==1 then
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
            end

            if data.state==3 then
                local tab = 
                {["WalkDown_Rush"] = Vector(0,-1),
                ["WalkUp_Rush"] = Vector(0,1),
                ["WalkRight_Rush"] = Vector(-1,0),
                ["WalkLeft_Rush"] = Vector(1,0)}

                if enemy:IsFrame(2,0) then
                    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, enemy.Position + Vector(rng:RandomInt(10)-5, rng:RandomInt(10)-5) + (tab[sprite:GetAnimation()]*30), Vector.Zero, enemy):ToEffect()
                    local n = (rng:RandomInt(8)+5)/10 
                    creep:GetData().BeerHead = true
                    creep.SpriteScale = Vector(n,n) 
                    creep.Timeout = 200
                    creep:Update()
                end    

                if enemy:IsFrame(4,0) then 
                    local eff = Isaac.Spawn(1000, 2, 6, enemy.Position + (tab[sprite:GetAnimation()]*30) + Vector(rng:RandomInt(20)-10, rng:RandomInt(20)-10), enemy.Velocity*-.5, enemy)  
                    eff:GetSprite().Color = BeerColor
                    sfx:Play(SoundEffect.SOUND_ROTTEN_HEART, .25, 0, false, 1)
                end

                if enemy:IsFrame(10,0) then
                    sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 4, 0, false, 1.5, 0)
                end

                if rng:RandomInt(5)+1==1 then 
                    local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0,enemy.Position + (tab[sprite:GetAnimation()]*30) + Vector(rng:RandomInt(20)-10, rng:RandomInt(20)-10), Vector.Zero, enemy):ToProjectile()
                    proj.Velocity = (proj.Position - enemy.Position):Resized(rng:RandomInt(5)+4)
                    proj.Scale = (rng:RandomInt(15)+5)/12 
                    proj.FallingSpeed = rng:RandomInt(5)-15 
                    proj.FallingAccel= rng:RandomInt(1)+2 
                    proj:GetSprite().Color = BeerProjColor

                    sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
                end
            end
        else
            sprite:SetFrame('WalkVert', 0)
            enemy.Velocity = enemy.Velocity * .5
        end

    elseif data.state==2 then 
        sprite:Play("Activate")

        enemy.Velocity = enemy.Velocity * .5
        if sprite:IsFinished("Activate") then 
            data.state=3
        end

    elseif data.state==4 then 
        sprite:Play("Deactivate")

        enemy.Velocity = enemy.Velocity * .5
        if sprite:IsFinished("Deactivate") then 
            data.state=1
        end

    elseif data.state==6 then
        sprite:Play('Death')

        if sprite:IsEventTriggered("Smash") then
            local eff = Isaac.Spawn(1000, 2, 4, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1,1)
            eff:GetSprite().Color = BeerColor

            local eff = Isaac.Spawn(1000, 2, 5, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1.5,1.5)
            eff:GetSprite().Color = BeerColor

            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy):ToEffect()
            creep.SpriteScale = Vector(3.5,3.5)
            creep:GetData().BeerHead = true
            creep.Timeout = 300
            creep:Update()

            for i=1, 5 do
                local dist = rng:RandomInt(40)+30
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, enemy.Position + Vector.FromAngle(rng:RandomInt(360)):Resized(dist), Vector.Zero, enemy):ToEffect()
                local n = (rng:RandomInt(10)+10)/10 
                creep.SpriteScale = Vector(n,n)
                creep.Timeout = 300
                creep:GetData().BeerHead = true
                creep:Update()
            end    

            for i=1, rng:RandomInt(3)+2 do
                local eff = Isaac.Spawn(1000, 2, 6, enemy.Position + Vector(rng:RandomInt(100)-50, rng:RandomInt(100)-50), Vector.Zero , enemy)  
                eff:GetSprite().Color = BeerColor
            end

            for i=1, rng:RandomInt(3)+3 do
                local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy):ToProjectile()
                proj.Velocity = (proj.Position - enemy.Position):Resized(rng:RandomInt(5)+4)
                proj.Scale = (rng:RandomInt(15)+5)/12 
                proj.FallingSpeed = rng:RandomInt(5)-15 
                proj.FallingAccel= rng:RandomInt(1)+2 
                proj:GetSprite().Color = BeerProjColor

                sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
            end

            sfx:Play(enums.Sounds.GLASSHEAD_SHATTER, 1, 0, false, 1, 0)
            sfx:Play(SoundEffect.SOUND_HEARTOUT, 1, 0, false, 1, 0)

        elseif sprite:IsFinished("Death") then
            enemy.CanShutDoors = false
            enemy.DepthOffset = -10
        end

        enemy.Velocity = enemy.Velocity * .85
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, GlassHeads.BeerHead_Update, enums.Enemies.GLASS_HEAD)

function GlassHeads:BeerHead_Creep(effect)
    if not effect:GetData().BeerHead then return end
    local sprite = effect:GetSprite()
    sprite:SetFrame(0)
    sprite.Color = BeerColor
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, GlassHeads.BeerHead_Creep, EffectVariant.CREEP_SLIPPERY_BROWN)


-- wine 
local WineColor = Color(.75,.75,.75,1,.3,0,.3)
WineColor:SetColorize(1,1,1,.9)

function GlassHeads:WineHead_Update(enemy)
    if enemy.Variant~=enums.Enemies.WINE_HEAD then return end
    local sprite = enemy:GetSprite()
    local data = enemy:GetData()
    local target = enemy:GetPlayerTarget()    
    local rng = enemy:GetDropRNG()

    if not data.state then data.state = 1 end 
    if not data.gridCountdown then data.gridCountdown = 0 end 
    if not data.trigger then data.trigger = rng:RandomInt(200)+100 end 

    if data.init and data.state~=6 then 
        data.init = data.init - 1
        if data.init <= 0 then 
            data.init = nil
        end
        enemy.Velocity = enemy.Velocity * .5

        return
    end

    if sprite:IsEventTriggered("Step") then
        sfx:Play(SoundEffect.SOUND_FETUS_LAND, .75, 0, false, 1.5, 0)
    end

    if data.state==1 then
        sprite:PlayOverlay("HeadIdle")

        if sprite:GetOverlayFrame()==6 then 
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, .75, 0, false, 1.5, 0)
        end

        if Game():GetRoom():CheckLine(enemy.Position, target.Position, 0, 0, false, false) then 
            data.trigger = data.trigger - 1
        end
        if data.trigger <= 0 then 
            data.trigger = 100
            data.state = 2
        end

    elseif data.state==2 then 
        sprite:PlayOverlay("HeadSpinStart")

        if sprite:IsOverlayFinished("HeadSpinStart") then 
            data.state=3
        end

    elseif data.state==3 then 
        sprite:PlayOverlay("Spin")

        if enemy:IsFrame(10,0) or rng:RandomInt(20)+1==1 then 
            local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0,enemy.Position + Vector(rng:RandomInt(20)-10, rng:RandomInt(20)-10), Vector.Zero, enemy):ToProjectile()
            proj.Velocity = (proj.Position - enemy.Position):Resized(rng:RandomInt(5)+4)
            proj.Scale = (rng:RandomInt(15)+5)/12 
            proj.FallingSpeed = rng:RandomInt(5)-20 
            proj.FallingAccel= rng:RandomInt(1)+1
            proj.Height = -40
            proj:AddProjectileFlags(ProjectileFlags.SMART)
            proj.HomingStrength = .5
            proj:GetData().WineHead = true

            local eff = Isaac.Spawn(1000, 2, 6, proj.Position, proj.Velocity*.5, enemy) 
            eff.SpriteOffset = Vector(0, proj.Height) 
            eff.DepthOffset = 10
            eff:GetSprite().Color = WineColor
            
            sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
        end

        if enemy:IsFrame(5,0) then
            sfx:Play(SoundEffect.SOUND_SHELLGAME, .3, 0, false, .5)
            sfx:Play(enums.Sounds.GLASSHEAD_LIQUID, 1, 0, false, 2, 0)
        end


        data.trigger = data.trigger - 1
        if data.trigger <= 0 then 
            data.trigger = nil
            data.state = 4
        end

    elseif data.state==4 then 
        sprite:PlayOverlay("HeadSpinEnd")

        if sprite:IsOverlayFinished("HeadSpinEnd") then 
            data.state=1
        end
    end
    

    if data.state~=6 then
        if isScared(enemy) then 
            data.targpos = enemy.Position + (enemy.Position - target.Position)

        elseif isConfused(enemy) then
            if not data.targpos or enemy:IsFrame(25,0) then
                data.targpos = Game():GetRoom():GetRandomPosition(0)
            end
        else
            if not data.targpos or enemy:IsFrame(20,0) or (data.targpos and data.targpos:Distance(enemy.Position) < 100) or not enemy.Pathfinder:HasPathToPos(data.targpos) then 
                data.targpos = Game():GetRoom():GetClampedPosition(target.Position+Vector(rng:RandomInt(50)-25,rng:RandomInt(50)-25), 0)
                data.gridCountdown = 50 * (rng:RandomInt(2))
            end
        end
        data.targpos = Game():GetRoom():GetClampedPosition(data.targpos + target.Velocity, 0)

        if enemy.Pathfinder:HasPathToPos(data.targpos) or (isScared(enemy) or isConfused(enemy)) then 
            if (enemy:CollidesWithGrid() or data.gridCountdown > 0) and 
            (data.targpos:Length(enemy.Position) > 100 or data.targpos:Length(enemy.Position) < 100 and 
            not Game():GetRoom():CheckLine(enemy.Position, data.targpos, 0, 0, false, false)) then 

                enemy.Pathfinder:FindGridPath(data.targpos, WINEHEAD_SPEED, 1, false)
                if data.gridCountdown <= 0 then
                    data.gridCountdown = 60
                else
                    data.gridCountdown  = data.gridCountdown - 1
                end 
            else
                local targetvel = (data.targpos - enemy.Position):Resized(WINEHEAD_SPEED*6)
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
    else
        sprite:RemoveOverlay()
        sprite:Play('Death')

        if sprite:IsEventTriggered("Smash") then
            local eff = Isaac.Spawn(1000, 2, 4, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1,1)
            eff:GetSprite().Color = WineColor

            local eff = Isaac.Spawn(1000, 2, 5, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy)  
            eff.SpriteScale = Vector(1.5,1.5)
            eff:GetSprite().Color = WineColor

            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy):ToEffect()
            creep.SpriteScale = Vector(3.5,3.5)
            creep:GetSprite().Color = WineColor
            creep.Timeout = 200
            creep:Update()

            for i=1, 3 do
                local dist = rng:RandomInt(40)+30
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, enemy.Position + Vector.FromAngle(rng:RandomInt(360)):Resized(dist), Vector.Zero, enemy):ToEffect()
                local n = (rng:RandomInt(10)+10)/10 
                creep.SpriteScale = Vector(n,n)
                creep.Timeout = 200
                creep:GetSprite().Color = WineColor
                creep:Update()
            end    

            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED,  0, enemy.Position, Vector.Zero, enemy):ToEffect()
            local off = (Vector.FromAngle((target.Position - enemy.Position):Rotated(rng:RandomInt(50)-25):GetAngleDegrees())):Resized(rng:RandomInt(6)+15)
            creep.Position = creep.Position + off
            local n = (rng:RandomInt(3)+6)/10
            creep.SpriteScale = Vector(n,n)
            creep.Timeout = 100
            creep:GetData().jamSpread = target.Position
            creep:GetData().trail = rng:RandomInt(3)+3
            creep:GetSprite().Color = WineColor
            creep:Update()


            for i=1, rng:RandomInt(3)+2 do
                local eff = Isaac.Spawn(1000, 2, 6, enemy.Position + Vector(rng:RandomInt(100)-50, rng:RandomInt(100)-50), Vector.Zero , enemy)  
                eff:GetSprite().Color = WineColor
            end

            for i=1, rng:RandomInt(3)+3 do
                local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, enemy.Position + Vector(rng:RandomInt(40)-20, rng:RandomInt(40)-20), Vector.Zero, enemy):ToProjectile()
                proj.Velocity = (target.Position - proj.Position):Rotated(rng:RandomInt(30)-15):Resized(rng:RandomInt(5)+4)
                proj.Scale = (rng:RandomInt(15)+5)/12 
                proj.FallingSpeed = rng:RandomInt(10)-20 
                proj.FallingAccel= rng:RandomInt(2)+1 
                proj:GetData().WineHead = true
                proj:GetData().dontSpin = true

                sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1, 0, false, 1)
            end

            sfx:Play(enums.Sounds.GLASSHEAD_SHATTER, 4, 0, false, 1, 0)
            sfx:Play(SoundEffect.SOUND_HEARTOUT, .5, 0, false, 1, 0)

        elseif sprite:IsFinished("Death") then
            enemy.CanShutDoors = false
            enemy.DepthOffset = -10
        end

        enemy.Velocity = enemy.Velocity * .85
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, GlassHeads.WineHead_Update, enums.Enemies.GLASS_HEAD)

function GlassHeads:WineHead_Proj(proj)
    if not proj:GetData().WineHead then return end
    proj:GetSprite().Color = WineColor

    if not proj:GetData().dontSpin then
        proj.Velocity = proj.Velocity:Rotated(-5)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, GlassHeads.WineHead_Proj)


function GlassHeads:WineHead_Creep(effect) 
    if not effect:GetData().jamSpread or not effect:GetData().trail then return end
    local sprite = effect:GetSprite()
    local data = effect:GetData()
    local rng = effect:GetDropRNG()

    if effect.FrameCount >= 1 then 
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, effect.Position, Vector.Zero, effect):ToEffect()
        local off = ((data.jamSpread-effect.Position):Resized(20))*1.2
        creep.Position = creep.Position + off + Vector(rng:RandomInt(10)-5, rng:RandomInt(10)-5)
        creep.Scale = effect.Scale + .1
        creep:GetData().jamSpread = data.jamSpread
        creep:Update()
        creep:GetSprite().Color = sprite.Color
        creep.Timeout = effect.Timeout

        if data.trail > 0 then 
            creep:GetData().trail = data.trail - 1
        end

        local eff = Isaac.Spawn(1000, 2, 10, creep.Position + Vector(rng:RandomInt(30)-15, rng:RandomInt(30)-15), Vector.Zero , effect)  
        eff:GetSprite().Color = sprite.Color
        eff.DepthOffset = 10

        data.jamSpread = nil
        data.trail = nil
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, GlassHeads.WineHead_Creep, EffectVariant.CREEP_RED)
