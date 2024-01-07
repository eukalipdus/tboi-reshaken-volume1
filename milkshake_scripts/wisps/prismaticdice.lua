local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local RED = Color(141 / 255, 2 / 255, 0, 1, 141 / 255, 2 / 255, 0)
local YELLOW = Color(135 / 255, 140 / 255, 20 / 255, 1, 135 / 255, 140 / 255, 20 / 255)
local GREEN = Color(0, 133 / 255, 2 / 255, 1, 0, 133 / 255, 2 / 255)
local BLUE = Color(4 / 255, 99 / 255, 147 / 255, 1, 4 / 255, 99 / 255, 147 / 255)
local TEAR_COLLISION_RADIUS = 10
local VEL_MULTIPLIER = 8

--- Mimicks the effect of Angelic Prism
---@param player EntityPlayer - The owner of the wisp
---@param familiar EntityFamiliar - The Prismatic Dice wisp being collided with
---@param entity Entity - The collider
---@return table
local function SpawnBonusTears(player, familiar, entity)
    utility:SetData(entity, "PrismaticDiceBonusApplied", true)
    local velocity = Vector.Zero
    if entity.Type ~= EntityType.ENTITY_TEAR then
        velocity = TSIL.Direction.DirectionToVector(player:GetHeadDirection()) * Vector(VEL_MULTIPLIER, VEL_MULTIPLIER)
    else
        velocity = entity.Velocity
    end
    local redTear = player:FireTear(familiar.Position, velocity, true, false, false):ToTear()
    local yellowTear = player:FireTear(familiar.Position, velocity, true, false, false):ToTear()
    local greenTear = player:FireTear(familiar.Position, velocity, true, false, false):ToTear()
    local blueTear = player:FireTear(familiar.Position, velocity, true, false, false):ToTear()
    local splitEntities = {}
    table.insert(splitEntities, redTear)
    table.insert(splitEntities, yellowTear)
    table.insert(splitEntities, greenTear)
    table.insert(splitEntities, blueTear)

    for _, entry in ipairs(splitEntities) do
        utility:SetData(entry, "PrismaticDiceBonusApplied", true)
    end

    redTear.Color = RED
    yellowTear.Color = YELLOW
    greenTear.Color = GREEN
    blueTear.Color = BLUE

    redTear.Velocity = (redTear.Velocity):Rotated(30)
    yellowTear.Velocity = (yellowTear.Velocity):Rotated(10)
    greenTear.Velocity = (greenTear.Velocity):Rotated(-10)
    blueTear.Velocity = (blueTear.Velocity):Rotated(-30)
    return splitEntities
end

--- Used to see if a laser is colliding with a Prismatic Dice wisp
---@param laser EntityLaser
local function ShouldLaserSplit(laser)
    local wispsInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, enums.Collectibles.PRISMATIC_DICE)
    local samples = laser:GetNonOptimizedSamples()
    for _, wisp in ipairs(wispsInRoom) do
        for i = 0, #samples - 1 do
            local point = samples:Get(i)
            if point:Distance(wisp.Position, laser.Position) < TEAR_COLLISION_RADIUS then
                return true
            end
        end
    end
end

function prismaticDice:FamiliarUpdate(familiar)
    if familiar.SubType ~= enums.Collectibles.PRISMATIC_DICE then return end
    local tearsInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_TEAR)
    local player = familiar.Player
    for _, tear in ipairs(tearsInRoom) do
        if tear.Position:Distance(familiar.Position) < TEAR_COLLISION_RADIUS
        and not utility:GetData(tear, "PrismaticDiceBonusApplied") then
            SpawnBonusTears(player, familiar, tear)
        end
    end

    local lasersInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_LASER)
    for _, laser in ipairs(lasersInRoom) do
        laser = laser:ToLaser()
        if ShouldLaserSplit(laser) then
            if (laser.Parent).Type == EntityType.ENTITY_PLAYER
            and not utility:GetData(laser, "PrismaticDiceBonusApplied") then
                SpawnBonusTears(player, familiar, laser)
            end
        end
    end

    local bombsInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_BOMB)
    for _, bomb in ipairs(bombsInRoom) do
        bomb = bomb:ToBomb()
        if bomb.Position:Distance(familiar.Position) < TEAR_COLLISION_RADIUS
        and bomb.IsFetus
        and not utility:GetData(bomb, "PrismaticDiceBonusApplied") then
            SpawnBonusTears(player, familiar, bomb)
        end
    end

    local knivesInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_KNIFE)
    for _, knife in ipairs(knivesInRoom) do
        knife = knife:ToKnife()
        if knife.Position:Distance(familiar.Position) < TEAR_COLLISION_RADIUS
        and knife:IsFlying()
        and not utility:GetData(knife, "PrismaticDiceBonusApplied") then
            SpawnBonusTears(player, familiar, knife)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, prismaticDice.FamiliarUpdate, FamiliarVariant.WISP)

function prismaticDice:PostKnifeUpdate(knife)
    if not knife:IsFlying()
    and utility:GetData(knife, "PrismaticDiceBonusApplied") then
        utility:SetData(knife, "PrismaticDiceBonusApplied", false)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, prismaticDice.PostKnifeUpdate)

return prismaticDice