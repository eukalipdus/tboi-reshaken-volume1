local prismaticDice = {}
local enums = milkshakeMod.enums

local SHIFT_RIGHT = 40
local SHIFT_LEFT = -40
local PICKUPS_TO_SPAWN = 6
local TIMES_CAN_FAIL = 50
local RANDOM_PICKUPS_NOCOL = 2

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

---Actives the prismatic dice effect of giving you two items for one, of lower quality
---@param player EntityPlayer
---@param collectible EntityPickup
---@param quality number
---@param newCollectibleID number
local function splitCollectible(player, collectible, quality, newCollectibleID)
    local willBreakfast = true
    local itemPool = Game():GetItemPool()
    if quality - 1 >= 0 then
        for i = 0, 1 do
            local counter = 0
            repeat
                counter = counter + 1
                local roomType = Game():GetRoom():GetType()
                local seed = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE):GetSeed()
                local roomPool = itemPool:GetPoolForRoom(roomType, seed)
                newCollectibleID = itemPool:GetCollectible(roomPool, false)

                if newCollectibleID == CollectibleType.COLLECTIBLE_BREAKFAST -- Might be temporary
                and player:GetCollectibleNum(CollectibleType.COLLECTIBLE_BREAKFAST, true) > 0
                and counter == TIMES_CAN_FAIL then goto failsafe
                elseif counter == TIMES_CAN_FAIL then goto failsafe
                end
            until Isaac.GetItemConfig():GetCollectible(newCollectibleID).Quality == quality - 1

            willBreakfast = false

            local spawnPosition

            if i == 0 then
                spawnPosition = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_LEFT)
            elseif i == 1 then
                spawnPosition = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_RIGHT)
            end

            ---@diagnostic disable-next-line: param-type-mismatch
            local shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectibleID, spawnPosition, Vector(0,0), nil):ToPickup()
            itemPool:RemoveCollectible(newCollectibleID)

            if collectible.Price then
                shatteredCollectible.AutoUpdatePrice = false
                shatteredCollectible.Price = math.floor(collectible.Price / 2)
            end

            if i == 0 then
                shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex
            elseif i == 1 then
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
        if quality == 0 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.SPOILED_BREAKFAST, collectible.Position, Vector(0,0), nil)
        elseif quality == 2 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.BALANCED_BREAKFAST, collectible.Position, Vector(0,0), nil)
        elseif quality == 3 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.HEARTY_BREAKFAST, collectible.Position, Vector(0,0), nil)
        end
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