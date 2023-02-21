local prismaticDice = {}
local enums = milkshakeMod.enums

local SHIFT_RIGHT = Vector(40, 0)
local SHIFT_LEFT = Vector(-40, 0)
local PICKUPS_TO_SPAWN = 6

local function getCollectibleCount()
    local collectibleCount = 0
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            collectibleCount = collectibleCount + 1
        end
    end
    return collectibleCount
end


function prismaticDice:onUse(collectible, rng, player)
    local collectibleCount = getCollectibleCount()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local collectible = entity:ToPickup()
            local collectibleQuality =  Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality
            collectible:Remove()

            local newCollectibleID
            if collectibleQuality - 1 >= 0 then
                for i = 0, 1 do
                    
                    repeat
                        local itemPool = Game():GetItemPool()
                        newCollectibleID = itemPool:GetCollectible(itemPool:GetLastPool())
                    until Isaac.GetItemConfig():GetCollectible(newCollectibleID).Quality == collectibleQuality - 1

                    local spawnPosition

                    if i == 0 then
                        spawnPosition = collectible.Position + SHIFT_LEFT
                    elseif i == 1 then
                        spawnPosition = collectible.Position + SHIFT_RIGHT
                    end
        
					---@diagnostic disable-next-line: param-type-mismatch
                    local shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectibleID, spawnPosition, Vector(0,0), nil):ToPickup()
                    
                    if i == 0 then
                        shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex
                    elseif i == 1 then
                        shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex + 1
                    end
                end
            else
                for i = 1, PICKUPS_TO_SPAWN do
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, collectible.Position, RandomVector(), player)
                end
            end
        end
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, prismaticDice.onUse, enums.Collectibles.PRISMATIC_DICE)
return prismaticDice