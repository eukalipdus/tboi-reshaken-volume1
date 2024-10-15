local prismaticGoggles = {}
local game = Game()

local utility = MilkshakeVol1.utility

local PRISMATIC_GOGGLES = MilkshakeVol1.enums.Collectibles.PRISMATIC_GOGGLES

local BASE_DIFFRACTION_CHANCE = 0.20
local DIFFRACTION_LUCK_INCREASE = 0.025

local MAX_DIFFRACTED_BOSS_HEALTH = 200

local LASER_DAMAGE = 0
local LASER_DAMAGE_SCALING = 1
local LASER_DURATION = 8
local LASER_ONE_HIT = false

local SMART_LASER_TARGET_CHANCE = 0.50

local REFLECTION_ALPHA = 0.2
local REFLECTION_BRIGHTNESS = 0.5

local REFLECTION_SWING_SPEED = 0.05
local REFLECTION_AMPLITUDE = 5

local ROTATION_SPEED = 1

local LASER_ALPHA = 0.5
local LASER_BRIGHTNESS = 1

---Applies the Diffracted debuff to selected enemy.
---@param target EntityNPC
---@param source EntityPlayer?
function MilkshakeVol1.API:AddEnemyDiffraction(target, source)
    source = source or Isaac.GetPlayer()
    utility:SetData(target, "DiffractionSource", source)
end

---Removes the Diffracted debuff from selected enemy. Does nothing if enemy isn't Diffracted.
---@param target EntityNPC
function MilkshakeVol1.API:RemoveEnemyDiffraction(target)
    utility:SetData(target, "DiffractionSource", nil)
end

---Returns a boolean indicating whether target enemy is not Diffracted
---@param target EntityNPC
---@return boolean
function MilkshakeVol1.API:IsEnemyDiffracted(target)
    return utility:GetData(target, "DiffractionSource") ~= nil
end

local TINTS = {
    {1,1,0, REFLECTION_BRIGHTNESS,REFLECTION_BRIGHTNESS,0},
    {0,1,1, 0,REFLECTION_BRIGHTNESS,REFLECTION_BRIGHTNESS},
    {1,0,1, REFLECTION_BRIGHTNESS,0,REFLECTION_BRIGHTNESS},
}

---@param color Color
---@return Color
local function ColorCopy(color)
    return Color(
        color.R,
        color.G,
        color.B,
        color.A,
        color.RO,
        color.GO,
        color.BO
    )
end

---@param entity Entity
local function OffsetVector(entity)
    return Vector(math.sin(entity.FrameCount*REFLECTION_SWING_SPEED)*REFLECTION_AMPLITUDE, 0):Rotated(entity.FrameCount*ROTATION_SPEED)
end

local function GetRandomEnemy()
    local enemies = {}
    
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsEnemy() and entity:IsVulnerableEnemy() and entity:IsActiveEnemy() then
           table.insert(enemies, entity)
        end
    end
    if next(enemies) == nil then return nil end
    
    return enemies[math.random(1, #enemies)] or nil
end

---@param targetNpc EntityNPC
---@param sourcePlayer EntityPlayer
local function TryApplyDiffraction(targetNpc, sourcePlayer)
    local rng = sourcePlayer:GetCollectibleRNG(PRISMATIC_GOGGLES)
    local diffractionChance = (BASE_DIFFRACTION_CHANCE*sourcePlayer:GetCollectibleNum(PRISMATIC_GOGGLES)) + (DIFFRACTION_LUCK_INCREASE * sourcePlayer.Luck)
    if not (targetNpc:IsVulnerableEnemy() and targetNpc:IsActiveEnemy())
        or (targetNpc:IsBoss() and targetNpc.MaxHitPoints >= MAX_DIFFRACTED_BOSS_HEALTH)
        or rng:RandomFloat() > diffractionChance
    then
        return
    end
    MilkshakeVol1.API:AddEnemyDiffraction(targetNpc, sourcePlayer)
end

---@param npc EntityNPC
function prismaticGoggles:NPCInit(npc)
    for index = 0, game:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(index)
        if player:HasCollectible(PRISMATIC_GOGGLES) then
            TryApplyDiffraction(npc, player)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_INIT, prismaticGoggles.NPCInit)

---@param npc EntityNPC
function prismaticGoggles:DiffractionRender(npc)
    if not npc.Visible then return end
    local source = utility:GetData(npc, "DiffractionSource")
    if not source then return end

    local sprite = npc:GetSprite()
    local ogColor = ColorCopy(sprite.Color)

    local offsetVector = OffsetVector(npc)
    for index, tint in ipairs(TINTS) do
        -- I REALLY REALLY wanted to use table.unpack here, but for some reason it wasn't working correctly.
        sprite.Color = Color(tint[1], tint[2], tint[3], REFLECTION_ALPHA, tint[4], tint[5], tint[6])
        local drawPos = Isaac.WorldToScreen(npc.Position + npc.PositionOffset + offsetVector:Rotated(120*index))
        sprite:Render(drawPos)
    end

    sprite.Color = ogColor
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, prismaticGoggles.DiffractionRender)

---@param npc EntityNPC
function prismaticGoggles:LasersOnDeath(npc)
    local source = utility:GetData(npc, "DiffractionSource")
    ---@cast source EntityPlayer
    if not source then return end

    local damage = (LASER_DAMAGE + LASER_DAMAGE_SCALING * MilkshakeVol1.utility:GetCurrentChapter()) + ((source.Damage))
    local offsetVector = Vector(math.random(-1, 1) + math.random(), math.random(-1, 1) + math.random())
    local initialAngle = 0
    for index, tint in ipairs(TINTS) do
        if index == 1 then
            local randomEnemy = GetRandomEnemy()
            if randomEnemy and math.random() < SMART_LASER_TARGET_CHANCE then
                offsetVector = (randomEnemy.Position - npc.Position)
            end

            local laser = EntityLaser.ShootAngle(
            LaserVariant.LIGHT_BEAM,
            npc.Position,
            offsetVector:GetAngleDegrees() + index*120,
            LASER_DURATION,
            npc.SpriteOffset,
            source
            )
            laser.DisableFollowParent = true
            laser.CollisionDamage = damage
            laser.OneHit = LASER_ONE_HIT
            laser:GetSprite().Color = Color(tint[1], tint[2], tint[3], LASER_ALPHA, LASER_BRIGHTNESS, LASER_BRIGHTNESS, LASER_BRIGHTNESS)
        else
            local laser = EntityLaser.ShootAngle(
                LaserVariant.LIGHT_BEAM,
                npc.Position,
                offsetVector:GetAngleDegrees() + index*120,
                LASER_DURATION,
                npc.SpriteOffset,
                source
            )
            laser.DisableFollowParent = true
            laser.CollisionDamage = damage
            laser.OneHit = LASER_ONE_HIT
            laser:GetSprite().Color = Color(tint[1], tint[2], tint[3], LASER_ALPHA, LASER_BRIGHTNESS, LASER_BRIGHTNESS, LASER_BRIGHTNESS)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, prismaticGoggles.LasersOnDeath)