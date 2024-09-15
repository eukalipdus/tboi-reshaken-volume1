local prismaticGoggles = {}
local game = Game()

local utility = MilkshakeVol1.utility

local PRISMATIC_GOGGLES = MilkshakeVol1.enums.Collectibles.PRISMATIC_GOGGLES

local BASE_DIFFRACTION_CHANCE = 0.25
local DIFFRACTION_LUCK_INCREASE = 0.025
local DIFFRACTION_CAP = 5

local LASER_DAMAGE = 8
local LASER_DAMAGE_SCALING = 2
local LASER_ONE_HIT = true

local REFLECTION_ALPHA = 0.2
local REFLECTION_BRIGHTNESS = 0.5

local REFLECTION_SWING_SPEED = 0.05
local REFLECTION_AMPLITUDE = 5

local ROTATION_SPEED = 1

local LASER_ALPHA = 0.5
local LASER_BRIGHTNESS = 1

---Applies the Diffracted debuff to selected enemy.
---@param target EntityNPC
---@param source Entity?
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
    {1,0,0, REFLECTION_BRIGHTNESS,0,0},
    {0,1,0, 0,REFLECTION_BRIGHTNESS,0},
    {0,0,1, 0,0,REFLECTION_BRIGHTNESS},
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

---@param player EntityPlayer
local function ApplyDiffraction(player)
    local rng = player:GetCollectibleRNG(PRISMATIC_GOGGLES)
    local cap = player:GetCollectibleNum(PRISMATIC_GOGGLES) * DIFFRACTION_CAP
    local currentCap = 0

    local diffractionChance = (BASE_DIFFRACTION_CHANCE*player:GetCollectibleNum(PRISMATIC_GOGGLES)) + (DIFFRACTION_LUCK_INCREASE * player.Luck)
    print(diffractionChance)
    for _,entity in ipairs(Isaac.GetRoomEntities()) do
        if not entity:IsVulnerableEnemy()
       -- or entity:IsBoss() Replace with max health + is boss check (return if is boss and health >200)
        or utility:GetData(entity, "DiffractionSource")
        or rng:RandomFloat() > diffractionChance
        then
            goto continue
        end
        currentCap = currentCap + 1
        utility:SetData(entity, "DiffractionSource", player)
        if currentCap > cap then
            return
        end
        ::continue::
    end
end

---@param npc EntityNPC
function prismaticGoggles:DiffractionRender(npc)
    local source = utility:GetData(npc, "DiffractionSource")
    if not source then return end

    local sprite = npc:GetSprite()
    local ogColor = ColorCopy(sprite.Color)

    local offsetVector = OffsetVector(npc)
    for index, tint in ipairs(TINTS) do
        -- I REALLY REALLY wanted to use table.unpack here, but for some reason it wasn't working correctly.
        sprite.Color = Color(tint[1], tint[2], tint[3], REFLECTION_ALPHA, tint[4], tint[5], tint[6])
        local drawPos = Isaac.WorldToScreen(npc.Position + offsetVector:Rotated(120*index))
        sprite:Render(drawPos)
    end

    sprite.Color = ogColor
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, prismaticGoggles.DiffractionRender)

---@param npc EntityNPC
function prismaticGoggles:LasersOnDeath(npc)
    local source = utility:GetData(npc, "DiffractionSource")
    if not source then return end

    local damage = LASER_DAMAGE + LASER_DAMAGE_SCALING * game:GetLevel():GetAbsoluteStage()
    local offsetVector = OffsetVector(npc)
    for index, tint in ipairs(TINTS) do
        local laser = EntityLaser.ShootAngle(
            LaserVariant.LIGHT_BEAM,
            npc.Position,
            offsetVector:GetAngleDegrees() + index*120,
            8,
            npc.SpriteOffset,
            source
        )
        laser.DisableFollowParent = true
        laser.CollisionDamage = damage
        laser.OneHit = LASER_ONE_HIT
        laser:GetSprite().Color = Color(tint[1], tint[2], tint[3], LASER_ALPHA, LASER_BRIGHTNESS, LASER_BRIGHTNESS, LASER_BRIGHTNESS)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, prismaticGoggles.LasersOnDeath)

function prismaticGoggles:PostNewRoom()
    for index = 0, game:GetNumPlayers()-1 do
        local player = Isaac.GetPlayer(index)
        if player:HasCollectible(PRISMATIC_GOGGLES) then
            ApplyDiffraction(player)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, prismaticGoggles.PostNewRoom)