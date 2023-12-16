local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local SHIFT_RIGHT = 40
local SHIFT_LEFT = -40
local TIMES_CAN_FAIL = 1000
local INITIAL_BREAKFAST_CHECK = 10
local WHITE = Color(1, 1, 1, 1, 255, 255, 255)
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220 / 255, 1, 0, 0, 0)
local SOLID_CYAN = Color(0, 1, 1, 1, 0, 255, 255)
local SOLID_PINK = Color(1, 192 / 255, 203 / 255, 1, 255, 192 / 255, 203 / 255)
local SPLIT_COLOR_FRAMES = 2
local SHATTERED_SOLID_FRAMES = 7
local SHATTERED_COLOR_FRAMES = 20
local SCHEDULE_FRAMES = 2
local JUDAS_REROLL_CHANCE = 30

--- Gets a spawn position for a split collectible
---@param index number
---@param first number
---@param second number
---@param collectible EntityPickup
---@return Vector
local function GetSplitPosition(index, first, second, collectible)
    local spawnPosition
    
    if index == first then
        spawnPosition = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_LEFT)
    elseif index == second then
        spawnPosition = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_RIGHT)
    end

    if not spawnPosition then
        spawnPosition = collectible.Position
    end

    return spawnPosition
end

--- Plays the color flash animations on the newly spawned collectibles
---@param index number
---@param currentCollecible EntityPickup
local function PlaySplitAnimation(index, currentCollecible)
    if index == 0 then
        --SOLID_CYAN:SetColorize(0, 2, 2, 3)
        currentCollecible:SetColor(SOLID_CYAN, SHATTERED_SOLID_FRAMES, 2, false, false)
        local lastCollectible = currentCollecible

        TSIL.Utils.Functions.RunInFrames(function ()
        --CYAN:SetColorize(0, 2, 2, 3)
        lastCollectible:SetColor(CYAN, SHATTERED_COLOR_FRAMES, 2, true, false)
        end, SHATTERED_SOLID_FRAMES)

    elseif index == 1 then
        --SOLID_PINK:SetColorize(3, 0, (220 / 255) * 3, 1)
        currentCollecible:SetColor(SOLID_PINK, SHATTERED_SOLID_FRAMES, 2, false, false)

        TSIL.Utils.Functions.RunInFrames(function ()
        --PINK:SetColorize(3, 0, (220 / 255) * 3, 1)
        currentCollecible:SetColor(PINK, SHATTERED_COLOR_FRAMES, 2, true, false)
        end, SHATTERED_SOLID_FRAMES)

    elseif index == 2 then
        currentCollecible:SetColor(SOLID_PINK, SHATTERED_SOLID_FRAMES, 2, false, false)

        TSIL.Utils.Functions.RunInFrames(function ()
        --PINK:SetColorize(3, 0, (220 / 255) * 3, 1)
        currentCollecible:SetColor(PINK, SHATTERED_COLOR_FRAMES, 2, true, false)
        end, SHATTERED_SOLID_FRAMES)
    end
end

--- Plays a color flash animation for a spawned collectible
---@param collectible EntityPickup
---@param colorOne Color
---@param colorTwo Color
local function SplitAnimationSingle(collectible, colorOne, colorTwo)
    collectible:SetColor(colorOne, SHATTERED_SOLID_FRAMES, 2, false, false)
    TSIL.Utils.Functions.RunInFrames(function ()
    collectible:SetColor(colorTwo, SHATTERED_COLOR_FRAMES, 2, true, false)
    end, SHATTERED_SOLID_FRAMES)
end

---Actives the prismatic dice effect of giving you two items for one, of lower quality
---@param player EntityPlayer
---@param collectible EntityPickup
---@param quality number
---@param newCollectibleID number
---@param originalQuality number | nil
local function SplitCollectible(player, collectible, quality, newCollectibleID, originalQuality)
    local shatteredCollectible
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

                if utility:IsJudasBirthright(player) then
                    local roll = TSIL.Random.GetRandomInt(1, 100)
                    if roll <= JUDAS_REROLL_CHANCE then
                        roomPool = ItemPoolType.POOL_DEVIL
                    end
                end

                if roomPool == ItemPoolType.POOL_NULL
                or counter >= INITIAL_BREAKFAST_CHECK then
                    roomPool = itemPool:GetPoolForRoom(RoomType.ROOM_TREASURE, seed)
                end

                newCollectibleID = itemPool:GetCollectible(roomPool, false)

                if counter == TIMES_CAN_FAIL
                or newCollectibleID == CollectibleType.COLLECTIBLE_NULL
                or (newCollectibleID == CollectibleType.COLLECTIBLE_BREAKFAST
                    and (itemPool ~= ItemPoolType.POOL_BOSS and itemPool ~= ItemPoolType.POOL_GREED_BOSS))
                or counter == TIMES_CAN_FAIL then goto failsafe
                end

            until Isaac.GetItemConfig():GetCollectible(newCollectibleID).Quality == quality - 1

            willBreakfast = false

            local spawnPosition = GetSplitPosition(i, 0, 1, collectible)

            ---@diagnostic disable-next-line: param-type-mismatch
            shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectibleID, spawnPosition, Vector(0,0), nil):ToPickup()
            itemPool:RemoveCollectible(newCollectibleID)


            if i == 0 then
                shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex
            elseif i == 1 then
                if collectible.OptionsPickupIndex > 0 then
                    shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex + 1
                else
                    shatteredCollectible.OptionsPickupIndex = 0
                end
            end

            PlaySplitAnimation(i, shatteredCollectible)

            if shatteredCollectible and collectible:IsShopItem() then
                shatteredCollectible.AutoUpdatePrice = false

                if collectible.Price == PickupPrice.PRICE_THREE_SOULHEARTS then
                    shatteredCollectible.Price = PickupPrice.PRICE_TWO_SOUL_HEARTS

                elseif collectible.Price == PickupPrice.PRICE_ONE_SOUL_HEART
                or collectible.Price == PickupPrice.PRICE_TWO_SOUL_HEARTS then
                    shatteredCollectible.Price = PickupPrice.PRICE_ONE_SOUL_HEART

                elseif collectible.Price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
                or collectible.Price == PickupPrice.PRICE_TWO_HEARTS
                or collectible.Price == PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART
                or collectible.Price == PickupPrice.PRICE_ONE_HEART then
                    shatteredCollectible.Price = PickupPrice.PRICE_ONE_HEART
                
                else
                    shatteredCollectible.Price = math.floor(collectible.Price / 2)
                end
            end
        end
    else
        willBreakfast = false
        local rng = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE)
        local seed = rng:GetSeed()
        local roomType = Game():GetRoom():GetType()
        local pickupAmount = 1
        if originalQuality then
            pickupAmount = originalQuality - (quality - 1)
        end
        utility:RecycleCollectible(collectible.Position, player, roomType, itemPool, seed, rng, false, pickupAmount)
    end
    ::failsafe::
    if willBreakfast == true then
        for i = 0, 1 do
            local splitQuality = quality - 1
            local spawnPosition = GetSplitPosition(i, 1, 2, collectible)

            if splitQuality == 0 then
                ---@diagnostic disable-next-line: param-type-mismatch
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.SPOILED_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            
            elseif splitQuality == 1 then
                ---@diagnostic disable-next-line: param-type-mismatch
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            
            elseif splitQuality == 2 then
                ---@diagnostic disable-next-line: param-type-mismatch
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.BALANCED_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            
            elseif splitQuality == 3 then
                ---@diagnostic disable-next-line: param-type-mismatch
                shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.HEARTY_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
            end

            if i == 0 then
                shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex
            elseif i == 1 then
                if collectible.OptionsPickupIndex > 0 then
                    shatteredCollectible.OptionsPickupIndex = shatteredCollectible.OptionsPickupIndex + 1
                end
            end

            PlaySplitAnimation(i, shatteredCollectible)

        end
    end
end

--- Spawns a collectible but only allows you to modify the SubType and position
---@param collectibleType integer
---@param position Vector
---@param player EntityPlayer
local function SpawnCollectible(collectibleType, position, player)
    return Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectibleType, position, Vector.Zero, player):ToPickup()
end

function prismaticDice:UseItem(_, rng, player, useFlags)
    if useFlags & UseFlag.USE_CARBATTERY ~= 0 then return true end
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE
        and entity.SubType ~= CollectibleType.COLLECTIBLE_NULL then
            local collectible = entity:ToPickup()
            local collectibleType = collectible.SubType
            local collectibleQuality = Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality

            local posLeft = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_LEFT)
            local posRight = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_RIGHT)


            TSIL.Utils.Functions.RunInFrames(function ()
                
                if collectible.SubType == CollectibleType.COLLECTIBLE_DADS_NOTE then
                    return
                end

                collectible:Remove()

                if collectibleType == CollectibleType.COLLECTIBLE_GODHEAD then
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_MIND, posLeft, player), SOLID_CYAN, CYAN)
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_BODY, posRight, player), SOLID_PINK, PINK)
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_SOUL, Isaac.GetFreeNearPosition(posRight, SHIFT_RIGHT), player), SOLID_PINK, PINK) -- Yellow

                 else
                     collectible:SetColor(WHITE, SPLIT_COLOR_FRAMES, 1, false, false)
                     collectible:Remove()
                     local newCollectibleID
                    if FiendFolio and player:HasTrinket(FiendFolio.ITEM.TRINKET.ETERNAL_CAR_BATTERY) then
                        local roll = 4 + rng:RandomInt(2)
                        for _ = 1, roll do
                            SplitCollectible(player, collectible, collectibleQuality - roll, newCollectibleID, collectibleQuality)
                        end

                    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
                         for _ = 1, 2 do
                            SplitCollectible(player, collectible, collectibleQuality - 1, newCollectibleID, collectibleQuality)
                         end
                     else
                         SplitCollectible(player, collectible, collectibleQuality, newCollectibleID, nil)
                     end
                 end
    
                SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
            end, SCHEDULE_FRAMES)
        end
    end
    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, prismaticDice.UseItem, enums.Collectibles.PRISMATIC_DICE)

return prismaticDice