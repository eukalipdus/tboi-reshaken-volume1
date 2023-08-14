local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local SHIFT_RIGHT = 40
local SHIFT_LEFT = -40
local TIMES_CAN_FAIL = 1000
local INITIAL_BREAKFAST_CHECK = 10
local BLACK = Color(0, 0, 0, 1, 0, 0, 0)
local WHITE = Color(1, 1, 1, 1, 255, 255, 255)
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220 / 255, 1, 0, 0, 0)
local SOLID_CYAN = Color(0, 1, 1, 1, 0, 255, 255)
local SOLID_PINK = Color(1, 192 / 255, 203 / 255, 1, 255, 192 / 255, 203 / 255)
local SPLIT_COLOR_FRAMES = 2
local SHATTERED_SOLID_FRAMES = 7
local SHATTERED_COLOR_FRAMES = 20
local SCHEDULE_FRAMES = 2
local TROLL_BOMB_COUNT = 3
local PICKUP_COUNT = 6
local NON_GOLD_PICKUP_COUNT = 5
local MUL_VEC_BY = 4

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

    if not spawnPosition then
        spawnPosition = collectible.Position
    end

    return spawnPosition
end

--- Plays the color flash animations on the newly spawned collectibles
---@param index number
---@param currentCollecible EntityPickup
local function playSplitAnimation(index, currentCollecible)
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
local function splitCollectible(player, collectible, quality, newCollectibleID)
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

                if roomPool == ItemPoolType.POOL_NULL
                or counter >= INITIAL_BREAKFAST_CHECK then
                    roomPool = itemPool:GetPoolForRoom(RoomType.ROOM_TREASURE, seed)
                end

                newCollectibleID = itemPool:GetCollectible(roomPool, false)
                print(newCollectibleID)

                if counter == TIMES_CAN_FAIL
                or newCollectibleID == CollectibleType.COLLECTIBLE_NULL
                or (newCollectibleID == CollectibleType.COLLECTIBLE_BREAKFAST
                    and (itemPool ~= ItemPoolType.POOL_BOSS and itemPool ~= ItemPoolType.POOL_GREED_BOSS))
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
            elseif i == 1 then
                if collectible.OptionsPickupIndex > 0 then
                    shatteredCollectible.OptionsPickupIndex = collectible.OptionsPickupIndex + 1
                else
                    shatteredCollectible.OptionsPickupIndex = 0
                end
            end

            playSplitAnimation(i, shatteredCollectible)

            if shatteredCollectible and collectible:IsShopItem() then
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
                    shatteredCollectible.AutoUpdatePrice = false
                    shatteredCollectible.Price = math.floor(collectible.Price / 2)
                end
            end
        end
    else
        willBreakfast = false
        local rng = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE)
        local seed = rng:GetSeed()
        local roomType = Game():GetRoom():GetType()
        utility:RecycleCollectible(collectible.Position, player, roomType, itemPool, seed, rng, false)
    end
    ::failsafe::
    if willBreakfast == true then
        for i = 0, 1 do
            local splitQuality = quality - 1
            local spawnPosition = getSplitPosition(i, 1, 2, collectible)

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

            playSplitAnimation(i, shatteredCollectible)

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

function prismaticDice:preItemuse(_, _, _, useFlags)
    if useFlags & UseFlag.USE_CARBATTERY ~= 0 then return true end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, prismaticDice.preItemuse, enums.Collectibles.PRISMATIC_DICE)

function prismaticDice:onUse(_, _, player)
    --local collectibleCount = getCollectibleCount()
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
                
                -- if collectibleType == CollectibleType.COLLECTIBLE_TWISTED_PAIR then
                --     SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_INCUBUS, posLeft, player), SOLID_CYAN, CYAN)
                --     SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_SUCCUBUS, posRight, player), SOLID_PINK, PINK)

                if collectibleType == CollectibleType.COLLECTIBLE_GODHEAD then
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_MIND, posLeft, player), SOLID_CYAN, CYAN)
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_BODY, posRight, player), SOLID_PINK, PINK)
                    SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_SOUL, Isaac.GetFreeNearPosition(posRight, SHIFT_RIGHT), player), SOLID_PINK, PINK) -- Yellow

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_HALO_OF_FLIES then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_FRIEND_ZONE, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_FRIEND_FINDER then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_MY_SHADOW, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_JUDAS_SHADOW, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_QUINTS then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_BROTHER_BOBBY, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_SISTER_MAGGY, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_EVERYTHING_JAR then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_JAR_OF_FLIES, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_JAR_OF_WISPS, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_DOLLAR then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_QUARTER, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_QUARTER, posRight, player), SOLID_PINK, PINK)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_QUARTER, Isaac.GetFreeNearPosition(posRight, SHIFT_RIGHT), player), SOLID_CYAN, CYAN) -- Yellow
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_QUARTER, Isaac.GetFreeNearPosition(posRight, SHIFT_RIGHT * 2), player), SOLID_PINK, PINK) -- New color

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_FREE_LEMONADE then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_LEMON_MISHAP, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_THE_JAR, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_DEAD_CAT then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_GUPPYS_TAIL, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_GUPPYS_HEAD, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_GLITCHED_CROWN then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_TMTRAINER, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_BINGE_EATER then
            --         SplitAnimationSingle(SpawnCollectible(enums.Collectibles.HEARTY_BREAKFAST, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(enums.Collectibles.HEARTY_BREAKFAST, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_MEGA_BLAST then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_SULFUR, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_NECRONOMICON then
            --         local missingPage = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_MISSING_PAGE, posLeft, Vector.Zero, player):ToPickup()
            --         SplitAnimationSingle(missingPage, SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_MISSING_PAGE_2, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER then
            --         for _ = 1, TROLL_BOMB_COUNT do
            --             SplitAnimationSingle(TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_BOMB, BombSubType.BOMB_TROLL, posLeft, RandomVector() * MUL_VEC_BY, player):ToPickup(), SOLID_CYAN, CYAN)
            --         end
            --         utility:RecycleCollectible(posLeft, player, Game():GetRoom():GetType(), Game():GetItemPool(), seed, rng, true)
            --         SplitAnimationSingle(TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_TAROTCARD, Card.CARD_TOWER, posRight, Vector.Zero, player):ToPickup(), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_TORN_PHOTO then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_POLAROID, posLeft, player), WHITE, WHITE)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_NEGATIVE, posRight, player), BLACK, BLACK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_EPIC_FETUS then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_DR_FETUS, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_DOCTORS_REMOTE, posRight, player), SOLID_PINK, PINK)

            --     elseif collectibleType == CollectibleType.COLLECTIBLE_RED_STEW then
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO, posLeft, player), SOLID_CYAN, CYAN)
            --         SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_DINNER, posRight, player), SOLID_PINK, PINK)


            --      elseif collectibleType == CollectibleType.COLLECTIBLE_YUM_HEART then
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART, posLeft, player), SOLID_CYAN, CYAN)
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_ISAACS_HEART, posRight, player), SOLID_PINK, PINK)

            --    elseif collectibleType == CollectibleType.COLLECTIBLE_ISAACS_HEART then
            --        for _ = 1, PICKUP_COUNT do
            --            TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, posLeft, RandomVector() * MUL_VEC_BY, player)
            --        end
            --        utility:RecycleCollectible(posLeft, player, Game():GetRoom():GetType(), Game():GetItemPool(), seed, rng, true)

            --    elseif collectibleType == CollectibleType.COLLECTIBLE_SHARP_KEY then
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_1, posLeft, player), SOLID_CYAN, CYAN)
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_KEY_PIECE_2, posRight, player), SOLID_PINK, PINK)

            --    elseif collectibleType == CollectibleType.COLLECTIBLE_KEY_PIECE_1 or collectibleType == CollectibleType.COLLECTIBLE_KEY_PIECE_2 then
            --        for _ = 1, NON_GOLD_PICKUP_COUNT do
            --            TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, posLeft, RandomVector() * MUL_VEC_BY, player)
            --        end
            --        TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, posLeft, Vector.Zero, player)
            --        utility:RecycleCollectible(posLeft, player, Game():GetRoom():GetType(), Game():GetItemPool(), seed, rng, true)


            --    elseif collectibleType == CollectibleType.COLLECTIBLE_MR_BOOM then
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_BOOM, posLeft, player), SOLID_CYAN, CYAN)
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_BOOM, posRight, player), SOLID_PINK, PINK)

            --    elseif collectibleType == CollectibleType.COLLECTIBLE_BOOM then
            --        for _ = 1, NON_GOLD_PICKUP_COUNT do
            --            TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, posLeft, RandomVector() * MUL_VEC_BY, player)
            --        end
            --        TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, posLeft, Vector.Zero, player)
            --        utility:RecycleCollectible(posLeft, player, Game():GetRoom():GetType(), Game():GetItemPool(), seed, rng, true)


            --    elseif collectibleType == CollectibleType.COLLECTIBLE_WOODEN_NICKEL then
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_PAGEANT_BOY, posLeft, player), SOLID_CYAN, CYAN)
            --        SplitAnimationSingle(SpawnCollectible(CollectibleType.COLLECTIBLE_PAGEANT_BOY, posRight, player), SOLID_PINK, PINK)

            --    elseif collectibleType == CollectibleType.COLLECTIBLE_PAGEANT_BOY then
            --        for _ = 1, NON_GOLD_PICKUP_COUNT do
            --            TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, posLeft, RandomVector() * MUL_VEC_BY, player)
            --        end
            --        TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, posLeft, Vector.Zero, player)
            --        utility:RecycleCollectible(posLeft, player, Game():GetRoom():GetType(), Game():GetItemPool(), seed, rng, true)
                   
            --    elseif collectibleType == CollectibleType.COLLECTIBLE_POOP then
            --        for _ = 1, PICKUP_COUNT do
            --            TSIL.EntitySpecific.SpawnPickup(PickupVariant.PICKUP_POOP, PoopPickupSubType.POOP_SMALL, posLeft, RandomVector() * MUL_VEC_BY, player)
            --        end
            --        utility:RecycleCollectible(posLeft, player, Game():GetRoom():GetType(), Game():GetItemPool(), seed, rng, true)

                 else
                     collectible:SetColor(WHITE, SPLIT_COLOR_FRAMES, 1, false, false)
                     collectible:Remove()
                     local newCollectibleID
                     if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
                         for _ = 1, 2 do
                             splitCollectible(player, collectible, collectibleQuality - 1, newCollectibleID)
                         end
                     else
                         splitCollectible(player, collectible, collectibleQuality, newCollectibleID)
                     end
                 end
    
                SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
            end, SCHEDULE_FRAMES)
        end
    end
    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, prismaticDice.onUse, enums.Collectibles.PRISMATIC_DICE)
return prismaticDice