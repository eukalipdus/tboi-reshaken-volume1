local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local SHIFT_RIGHT = 40
local SHIFT_LEFT = -40
local SHIFT_DOWN = Vector(0, 20)
local TIMES_CAN_FAIL = 1000
local INITIAL_BREAKFAST_CHECK = 10
local WHITE = Color(1, 1, 1, 1, 255, 255, 255)
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220/255, 1, 0, 0, 0)

local RED = Color(141 / 255, 2 / 255, 0, 1, 141 / 255, 2 / 255, 0)
local YELLOW = Color(135 / 255, 140 / 255, 20 / 255, 1, 135 / 255, 140 / 255, 20 / 255)
local BLUE = Color(4 / 255, 99 / 255, 147 / 255, 1, 4 / 255, 99 / 255, 147 / 255)
local SOLID_RED = Color(1, 0, 0, 1, 1, 0, 0)
local SOLID_YELLOW = Color(1, 1, 0, 1, 1, 1, 0)
local SOLID_BLUE = Color(0, 0, 1, 1, 0, 0, 1)
local SOLID_CYAN = Color(0, 1, 1, 1, 0, 255, 255)
local SOLID_PINK = Color(1, 192/255, 203/255, 1, 255, 192/255, 203/255)
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
local function PlaySplitAnimation(index, currentCollecible, colors)
    if index == 0 then
        --SOLID_CYAN:SetColorize(0, 2, 2, 3)
        currentCollecible:SetColor(SOLID_CYAN, SHATTERED_SOLID_FRAMES, 2, false, false)
        local lastCollectible = currentCollecible

        TSIL.Utils.Functions.RunInFramesTemporary(function ()
        --CYAN:SetColorize(0, 2, 2, 3)
        lastCollectible:SetColor(CYAN, SHATTERED_COLOR_FRAMES, 2, true, false)
        end, SHATTERED_SOLID_FRAMES)

    elseif index == 1 then
        --SOLID_PINK:SetColorize(3, 0, (220 / 255) * 3, 1)
        currentCollecible:SetColor(SOLID_PINK, SHATTERED_SOLID_FRAMES, 2, false, false)

        TSIL.Utils.Functions.RunInFramesTemporary(function ()
        --PINK:SetColorize(3, 0, (220 / 255) * 3, 1)
        currentCollecible:SetColor(PINK, SHATTERED_COLOR_FRAMES, 2, true, false)
        end, SHATTERED_SOLID_FRAMES)

    elseif index == 2 then
        currentCollecible:SetColor(SOLID_PINK, SHATTERED_SOLID_FRAMES, 2, false, false)

        TSIL.Utils.Functions.RunInFramesTemporary(function ()
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
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
    collectible:SetColor(colorTwo, SHATTERED_COLOR_FRAMES, 2, true, false)
    end, SHATTERED_SOLID_FRAMES)
end

local function HandleBreakfast(collectible, shatteredCollectible, quality, count)
    for i = 0, count do
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
            
        elseif splitQuality == 4 then
            ---@diagnostic disable-next-line: param-type-mismatch
            shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BINGE_EATER, spawnPosition, Vector(0,0), nil):ToPickup()

        elseif splitQuality == 5 then
            ---@diagnostic disable-next-line: param-type-mismatch
            shatteredCollectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, enums.Collectibles.GOLDEN_BREAKFAST, spawnPosition, Vector(0,0), nil):ToPickup()
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

---Actives the prismatic dice effect of giving you two items for one, of lower quality
---@param player EntityPlayer
---@param collectible EntityPickup
---@param quality number
---@param originalQuality number | nil
function MilkshakeVol1.API:SplitCollectible(player, collectible, quality, originalQuality)
    local newCollectibleID
    local shatteredCollectible
    local itemPool = Game():GetItemPool()
    if quality - 1 >= 0 then
        for i = 0, 1 do
            local counter = 0
            repeat
                counter = counter + 1
                local roomType = Game():GetRoom():GetType()
                local seed = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE):GetSeed()
                local roomPool = itemPool:GetPoolForRoom(roomType, seed)

                if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
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
                or counter == TIMES_CAN_FAIL then
                    local count = 0
                    if i == 1 then
                        count = 0
                    else
                        count = 1
                    end
                    HandleBreakfast(collectible, shatteredCollectible, quality, count)
                    return
                end

            until Isaac.GetItemConfig():GetCollectible(newCollectibleID).Quality == quality - 1

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
        local rng = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE)
        local seed = rng:GetSeed()
        local roomType = Game():GetRoom():GetType()
        local pickupAmount = 1
        if originalQuality then
            pickupAmount = originalQuality - (quality - 1)
        end
        utility:RecycleCollectible(collectible.Position, player, roomType, itemPool, seed, rng, false, pickupAmount)
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

            --local posLeft = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_LEFT)
            --local posRight = Isaac.GetFreeNearPosition(collectible.Position, SHIFT_RIGHT)


            TSIL.Utils.Functions.RunInFramesTemporary(function ()
                
                if collectible.SubType == CollectibleType.COLLECTIBLE_DADS_NOTE then
                    return
                end

                collectible:Remove()

                if collectibleType == CollectibleType.COLLECTIBLE_GODHEAD then
                    local topPosition = Vector((collectible.Position).X, (collectible.Position).Y) + SHIFT_DOWN
                    local leftPosition = Vector((collectible.Position).X, (collectible.Position).Y) + Vector(SHIFT_LEFT, 0)
                    local rightPosition = Vector((collectible.Position).X, (collectible.Position).Y) + Vector(SHIFT_RIGHT, 0)
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_MIND, leftPosition, player), SOLID_YELLOW, YELLOW)
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_SOUL, rightPosition, player), SOLID_BLUE, BLUE)
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_BODY, topPosition, player), SOLID_RED, RED)

                 else
                     collectible:SetColor(WHITE, SPLIT_COLOR_FRAMES, 1, false, false)
                     collectible:Remove()
                    if FiendFolio and player:HasTrinket(FiendFolio.ITEM.TRINKET.ETERNAL_CAR_BATTERY) then
                        local roll = 4 + rng:RandomInt(2)
                        for _ = 1, roll do
                            MilkshakeVol1.API:SplitCollectible(player, collectible, collectibleQuality - roll, collectibleQuality)
                        end

                    elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
                         for _ = 1, 2 do
                            MilkshakeVol1.API:SplitCollectible(player, collectible, collectibleQuality - 1, collectibleQuality)
                         end
                     else
                        MilkshakeVol1.API:SplitCollectible(player, collectible, collectibleQuality, nil)
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