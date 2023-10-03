local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local RED = Color(141 / 255, 2 / 255, 0, 1, 141 / 255, 2 / 255, 0)
local YELLOW = Color(135 / 255, 140 / 255, 20 / 255, 1, 135 / 255, 140 / 255, 20 / 255)
local GREEN = Color(0, 133 / 255, 2 / 255, 1, 0, 133 / 255, 2 / 255)
local BLUE = Color(4 / 255, 99 / 255, 147 / 255, 1, 4 / 255, 99 / 255, 147 / 255)

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
    redEntity.Color = RED
    yellowEntity.Color = YELLOW
    greenEntity.Color = GREEN
    blueEntity.Color = BLUE
    return splitEntities
end

function prismaticDice:FamiliarUpdate(familiar)
    if familiar.SubType ~= enums.Collectibles.PRISMATIC_DICE then return end
    local tearsInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_TEAR)
    local player = familiar.Player
    for _, tear in ipairs(tearsInRoom) do
        if tear.Position:Distance(familiar.Position, tear.Position) < 10
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

            redTear.Velocity = (redTear.Velocity):Rotated(30)
            yellowTear.Velocity = (yellowTear.Velocity):Rotated(10)
            greenTear.Velocity = (greenTear.Velocity):Rotated(-10)
            blueTear.Velocity = (blueTear.Velocity):Rotated(-30)
        end
    end

    local bombsInRoom = TSIL.Entities.GetEntities(EntityType.ENTITY_BOMB)
    for _, bomb in ipairs(bombsInRoom) do
        if bomb.Position:Distance(familiar.Position, bomb.Position) < 10
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

            redBomb.Velocity = (redBomb.Velocity):Rotated(30)
            yellowBomb.Velocity = (yellowBomb.Velocity):Rotated(10)
            greenBomb.Velocity = (greenBomb.Velocity):Rotated(-10)
            blueBomb.Velocity = (blueBomb.Velocity):Rotated(-30)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, prismaticDice.FamiliarUpdate, FamiliarVariant.WISP)

return prismaticDice