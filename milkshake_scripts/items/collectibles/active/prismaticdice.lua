local prismaticDice = {}
local enums = milkshakeMod.enums

local SHIFT_RIGHT = 40
local SHIFT_LEFT = -40
local PICKUPS_TO_SPAWN = 6
local TIMES_CAN_FAIL = 100
local RANDOM_PICKUPS_NOCOL = 2
local INITIAL_BREAKFAST_CHECK = 10
local FINAL_BREAKFAST_CHECK = 50

---Returns the amount of collectibles in the current room 
---@return number
-- local function getCollectibleCount()
--     local collectibleCount = 0
--     for i, entity in pairs(Isaac.GetRoomEntities()) do
--         if entity.Type == EntityType.ENTITY_PICKUP
--         and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
--             collectibleCount = collectibleCount + 1
--         end
--     end
--     return collectibleCount
-- end

--- Gets a spawn position for a split collectible
---@param index number
---@param first number
---@param second number
---@param collectible EntityPickup
---@return Vector
local function getSplitPosition(index, first, second, collectible)
    local spawnPosition
    if index == first then
        spawnPosition = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_LEFT)
    elseif index == second then
        spawnPosition = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_RIGHT)
    end
    return spawnPosition
end

---Actives the prismatic dice effect of giving you two items for one, of lower quality
---@param player EntityPlayer
---@param collectible EntityPickup
---@param quality number
---@param newCollectibleID number
local function splitCollectible(player, collectible, quality, newCollectibleID)
    local shatteredCollectible
    local willBreakfast = true
    local itemPool = Game():GetItemPool()
    if quality - 1 >= 0 then
        for i = 0, 1 do
            local counter = 0
            local breakfasts = 0
            repeat
                counter = counter + 1
                local roomType = Game():GetRoom():GetType()
                local seed = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE):GetSeed()
                local roomPool = itemPool:GetPoolForRoom(roomType, seed)

                if roomPool == ItemPoolType.POOL_NULL
                or breakfasts == INITIAL_BREAKFAST_CHECK then
                    roomPool = ItemPoolType.POOL_TREASURE
                end

                newCollectibleID = itemPool:GetCollectible(roomPool, false)

                if newCollectibleID == CollectibleType.COLLECTIBLE_BREAKFAST then
                    breakfasts = breakfasts + 1
                end

                if counter == TIMES_CAN_FAIL
                or newCollectibleID == 0 -- Null collectible is rolled, shouldn't happen
                or breakfasts == FINAL_BREAKFAST_CHECK -- Pool is breakfasted
                or counter == TIMES_CAN_FAIL then goto failsafe
                end

            until Isaac.GetItemConfig():GetCollectible(newCollectibleID).Quality == quality - 1

            willBreakfast = false

            local spawnPosition = getSplitPosition(i, 0, 1, collectible)

            ---@diagnostic disable-next-line: param-type-mismatch
            shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectibleID, spawnPosition, Vector(0,0), nil):ToPickup()
            itemPool:RemoveCollectible(newCollectibleID)

            if i == 0 then
                shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex
            elseif i == 1 and collectible.OptionsPickupIndex > 0 then
                shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex + 1
            end
        end
    else
        willBreakfast = false
        for i = 1, PICKUPS_TO_SPAWN do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, RANDOM_PICKUPS_NOCOL, collectible.Position, RandomVector(), player)
        end
    end
    ::failsafe::
    if willBreakfast == true then
        for i = 1, 2 do
            local splitQuality = quality - 1
            local spawnPosition = getSplitPosition(i, 1, 2, collectible)

            if splitQuality == 0 then
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.SPOILED_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            
            elseif splitQuality == 1 then
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            
            elseif splitQuality == 2 then
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.BALANCED_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            
            elseif splitQuality == 3 then
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.HEARTY_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            end

            if i == 1 then
                shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex
            elseif i == 2 and collectible.OptionsPickupIndex > 0 then
                shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex + 1
            end

        end
    end
    
    if collectible:IsShopItem() then
        shatteredCollectible.AutoUpdatePrice = false
        shatteredCollectible.Price = math.floor(collectible.Price / 2)
    end
end

function prismaticDice:preItemuse(_, _, _, useFlags)
    if useFlags & UseFlag.USE_CARBATTERY ~= 0 then return true end
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, prismaticDice.preItemuse, enums.Collectibles.PRISMATIC_DICE)

function prismaticDice:onUse(_, _, player)
    --local collectibleCount = getCollectibleCount()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local collectible = entity:ToPickup()

            local collectibleQuality = Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality
            collectible:Remove()

            local newCollectibleID
            if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
                for i = 1, 2 do
                    splitCollectible(player, collectible, collectibleQuality - 1, newCollectibleID)
                end
            else
                splitCollectible(player, collectible, collectibleQuality, newCollectibleID)
            end

            SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
        end
    end
    return true
end

milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, prismaticDice.onUse, enums.Collectibles.PRISMATIC_DICE)
return prismaticDice