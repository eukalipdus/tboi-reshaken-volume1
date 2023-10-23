local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local RED = Color(141 / 255, 2 / 255, 0, 1, 141 / 255, 2 / 255, 0)
local YELLOW = Color(135 / 255, 140 / 255, 20 / 255, 1, 135 / 255, 140 / 255, 20 / 255)
local GREEN = Color(0, 133 / 255, 2 / 255, 1, 0, 133 / 255, 2 / 255)
local BLUE = Color(4 / 255, 99 / 255, 147 / 255, 1, 4 / 255, 99 / 255, 147 / 255)
local BRIM_MAX_DISTANCE = 33 -- Azazel's is 77, for reference
local TEAR_COLLISION_RADIUS = 10
local MOVE_LASER_BY = Vector(5,5)

--- Mimicks the effect of Angelic Prism
---@param redEntity Entity
---@param yellowEntity Entity
---@param greenEntity Entity
---@param blueEntity Entity
---@param identifierString string
---@return table
local function CreateAngelicPrismSplit(redEntity, yellowEntity, greenEntity, blueEntity, identifierString)
    local splitEntities = {}
    table.insert(splitEntities, redEntity)
    table.insert(splitEntities, yellowEntity)
    table.insert(splitEntities, greenEntity)
    table.insert(splitEntities, blueEntity)

    for _, entry in ipairs(splitEntities) do
        utility:SetData(entry, identifierString, true)
    end

    if not (redEntity.Type == EntityType.ENTITY_LASER
    and redEntity.Variant == LaserVariant.THIN_RED) then
        redEntity.Color = RED
        yellowEntity.Color = YELLOW
        greenEntity.Color = GREEN
        blueEntity.Color = BLUE
    end

    if redEntity.Type == EntityType.ENTITY_TEAR
    or redEntity.Type == EntityType.ENTITY_BOMB
    or (redEntity.Type == EntityType.ENTITY_LASER and redEntity.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE) then

        redEntity.Velocity = (redEntity.Velocity):Rotated(30)
        yellowEntity.Velocity = (yellowEntity.Velocity):Rotated(10)
        greenEntity.Velocity = (greenEntity.Velocity):Rotated(-10)
        blueEntity.Velocity = (blueEntity.Velocity):Rotated(-30)
    end

    return splitEntities
end

--- Used to see if a laser is colliding with a Prismatic Dice wisp
---@param laser EntityLaser
local function ShouldLaserSplit(laser)
    local wispsInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, enums.Collectibles.PRISMATIC_DICE)
    local samples = laser:GetNonOptimizedSamples()
    for _, wisp in ipairs(wispsInRoom) do
        for i = 0, #samples - 1 do
            ---@diagnostic disable-next-line: undefined-field
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
        and not utility:GetData(tear, "PrismaticWispTear") then
            tear:Remove()

            local redTear = player:FireTear(familiar.Position, tear.Velocity, true, false, false):ToTear()
            local yellowTear = player:FireTear(familiar.Position, tear.Velocity, true, false, false):ToTear()
            local greenTear = player:FireTear(familiar.Position, tear.Velocity, true, false, false):ToTear()
            local blueTear = player:FireTear(familiar.Position, tear.Velocity, true, false, false):ToTear()
            local splitTears = CreateAngelicPrismSplit(redTear,
                                    yellowTear,
                                    greenTear,
                                    blueTear,
                                    "PrismaticWispTear")

            for _, entry in ipairs(splitTears) do
                if entry.Variant ~= tear.Variant then
                    entry:ChangeVariant(tear.Variant)
                end
            end
        end
    end

    local bombsInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_BOMB)
    for _, bomb in ipairs(bombsInRoom) do
        bomb = bomb:ToBomb()
        if bomb.Position:Distance(familiar.Position) < TEAR_COLLISION_RADIUS
        and bomb.IsFetus
        and not utility:GetData(bomb, "PrismaticWispBomb") then
            bomb:Remove()

            local redBomb = player:FireBomb(familiar.Position, bomb.Velocity):ToBomb()
            local yellowBomb = player:FireBomb(familiar.Position, bomb.Velocity):ToBomb()
            local greenBomb = player:FireBomb(familiar.Position, bomb.Velocity):ToBomb()
            local blueBomb = player:FireBomb(familiar.Position, bomb.Velocity):ToBomb()

            CreateAngelicPrismSplit(redBomb,
                                    yellowBomb,
                                    greenBomb,
                                    blueBomb,
                                    "PrismaticWispBomb")
        end
    end

    local lasersInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_LASER)
    for _, laser in ipairs(lasersInRoom) do
        laser = laser:ToLaser()
        if ShouldLaserSplit(laser) then
            if (laser.Parent).Type == EntityType.ENTITY_PLAYER
            and not (utility:GetData(laser, "PrismaticDiceWispLaser") or utility:GetData(laser, "PrismaticDiceWispRingLaser")) then
                utility:SetData(laser, "PrismaticDiceWispLaser", true)
                if (laser.Variant == LaserVariant.THICK_RED and laser.SubType ~= LaserSubType.LASER_SUBTYPE_RING_PROJECTILE)
                or laser.Variant == LaserVariant.BRIM_TECH and laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR
                or (laser.Variant == LaserVariant.THIN_RED and laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR) then
                    utility:SetData(laser, "OrigMaxDistance", laser.MaxDistance)
                    local origMaxDistance = utility:GetData(laser, "OrigMaxDistance")
                    laser.MaxDistance = BRIM_MAX_DISTANCE

                    local redLaser = EntityLaser.ShootAngle(laser.Variant, familiar.Position, laser.Angle, laser.Timeout, Vector.Zero, player)
                    local yellowLaser = EntityLaser.ShootAngle(laser.Variant, familiar.Position, laser.Angle, laser.Timeout, Vector.Zero, player)
                    local greenLaser = EntityLaser.ShootAngle(laser.Variant, familiar.Position, laser.Angle, laser.Timeout, Vector.Zero, player)
                    local blueLaser = EntityLaser.ShootAngle(laser.Variant, familiar.Position, laser.Angle, laser.Timeout, Vector.Zero, player)

                    local splitLasers = CreateAngelicPrismSplit(redLaser,
                                                                yellowLaser,
                                                                greenLaser,
                                                                blueLaser,
                                                                "PrismaticDiceWispLaser")

                    utility:SetData(laser, "WispLaserChildren", splitLasers)

                    for _, currentLaser in ipairs(splitLasers) do
                        currentLaser.Position = currentLaser.Position + MOVE_LASER_BY
                        currentLaser.MaxDistance = origMaxDistance
                    end

                    redLaser.Angle = redLaser.Angle + 30
                    yellowLaser.Angle = yellowLaser.Angle + 10
                    greenLaser.Angle = greenLaser.Angle - 10
                    blueLaser.Angle = blueLaser.Angle - 30
                
                elseif laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE then
                    laser:Remove()
                    local velocity = laser.Velocity

                    local redLaser = player:FireTechXLaser(laser.Position, velocity, laser.Radius, player)
                    local yellowLaser = player:FireTechXLaser(laser.Position, velocity, laser.Radius, player)
                    local greenLaser = player:FireTechXLaser(laser.Position, velocity, laser.Radius, player)
                    local blueLaser = player:FireTechXLaser(laser.Position, velocity, laser.Radius, player)

                    CreateAngelicPrismSplit(redLaser, yellowLaser, greenLaser, blueLaser, "PrismaticDiceWispRingLaser")
                end
            end
        end
    end

    local knivesInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_KNIFE)
    for _, knife in ipairs(knivesInRoom) do
        knife = knife:ToKnife()
        if knife.Position:Distance(familiar.Position) < TEAR_COLLISION_RADIUS
        and knife:IsFlying()
        and not utility:GetData(knife, "PrismaticWispKnife") then
            knife:Remove()
            local redKnife = player:FireKnife(player, knife.RotationOffset)
            local yellowKnife = player:FireKnife(player, knife.RotationOffset)
            local greenKnife = player:FireKnife(player, knife.RotationOffset)
            local blueKnife = player:FireKnife(player, knife.RotationOffset)
            

            CreateAngelicPrismSplit(redKnife, yellowKnife, greenKnife, blueKnife, "PrismaticWispKnife")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, prismaticDice.FamiliarUpdate, FamiliarVariant.WISP)

function prismaticDice:PostLaserUpdate(laser)
    if not utility:GetData(laser, "WispLaserChildren") then return end
    if not ShouldLaserSplit(laser) then
        for _, splitLaser in ipairs(utility:GetData(laser, "WispLaserChildren")) do
            splitLaser:Remove()
        end
        laser.MaxDistance = utility:GetData(laser, "OrigMaxDistance")
        utility:SetData(laser, "WispLaserChildren", nil)
        utility:SetData(laser, "PrismaticDiceWispLaser", false)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, prismaticDice.PostLaserUpdate)

return prismaticDice