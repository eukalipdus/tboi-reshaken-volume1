local goldenShovel = {}
local enums = MilkshakeVol1.enums

local CHEST_VELOCITY_MULTIPLIER = 15
local ACHIEVEMENT_GOLDEN_HEART = 224
local ACHIEVEMENT_GOLD_PILL = 603
local ACHIEVEMENT_GOLDEN_BATTERY = 615
local ACHIEVEMENT_GOLD_BOMB = 226
local ACHIEVEMENT_GOLDEN_TRINKET = 617

local goldPickupBasePrice = {
    [PickupVariant.PICKUP_KEY] = 13,
    [PickupVariant.PICKUP_BOMB] = 15,
    [PickupVariant.PICKUP_LIL_BATTERY] = 20,
    [PickupVariant.PICKUP_PILL] = 15,
    [PickupVariant.PICKUP_HEART] = 5,
}
local goldPickupVariants = {
    PickupVariant.PICKUP_KEY,
    PickupVariant.PICKUP_BOMB,
    PickupVariant.PICKUP_LIL_BATTERY,
    PickupVariant.PICKUP_PILL,
    PickupVariant.PICKUP_HEART
}

local pickupVariantToGoldSubType = {
    [PickupVariant.PICKUP_KEY] = KeySubType.KEY_GOLDEN,
    [PickupVariant.PICKUP_BOMB] = BombSubType.BOMB_GOLDEN,
    [PickupVariant.PICKUP_LIL_BATTERY] = BatterySubType.BATTERY_GOLDEN,
    [PickupVariant.PICKUP_PILL] = PillColor.PILL_GOLD,
    [PickupVariant.PICKUP_HEART] = HeartSubType.HEART_GOLDEN
}

local goldPickupWeights = {
    [PickupVariant.PICKUP_KEY] = 10,
    [PickupVariant.PICKUP_BOMB] = 10,
    [PickupVariant.PICKUP_LIL_BATTERY] = 2,
    [PickupVariant.PICKUP_PILL] = 3,
    [PickupVariant.PICKUP_HEART] = 5
}

local MIN_COIN_SPAWN_COUNT = 2
local MAX_COIN_SPAWN_COUNT = 4
local skipNextShovelUse = false


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "GoldenShovelSecretShopCreated",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "GoldenShovelShopOriginalPrices",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

---Checks if a given pickup is one that is sold in Golden Shovel Shops
---@param pickup EntityPickup
---@return boolean
local function IsSoldGoldenPickup(pickup)
    if (pickup.Variant == PickupVariant.PICKUP_KEY
    and pickup.SubType == KeySubType.KEY_GOLDEN)

    or (pickup.Variant == PickupVariant.PICKUP_BOMB
    and pickup.SubType == BombSubType.BOMB_GOLDEN)

    or (pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY
    and pickup.SubType == BatterySubType.BATTERY_GOLDEN)

    or (pickup.Variant == PickupVariant.PICKUP_PILL
    and pickup.SubType == PillColor.PILL_GOLD)

    or (pickup.Variant == PickupVariant.PICKUP_HEART
    and pickup.SubType == HeartSubType.HEART_GOLDEN) then
        return true
    end
    return false
end

---@param position Vector
---@param shouldBelialSynergy boolean
local function SpawnGoldEffects(position, shouldBelialSynergy)
    local goldColor = Color(0.9, 0.8, 0, 1, 0.8, 0.7, 0)
    local redColor = Color(0.1, 0, 0, 0.5, 0.1, 0, 0)
    local blackColor = Color(0.1, 0, 0, 0.2, 0.1, 0, 0)
    local particle_speed = 4

    local crater = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.BOMB_CRATER,
        0,
        position
    )
    local craterSprite = crater:GetSprite()
    craterSprite.Scale = (Vector.One * 1.5)

    SFXManager():Play(SoundEffect.SOUND_SHOVEL_DIG)

    if shouldBelialSynergy then
        local smallCrater = TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.BOMB_CRATER,
            0,
            position
        )
        local smallCraterSprite = smallCrater:GetSprite()
        smallCraterSprite.Scale = (Vector.One * 0.6)

        crater:SetColor(blackColor, 150, 1, false, false)
        smallCrater:SetColor(redColor, 150, 1, false, false)
        SFXManager():Play(SoundEffect.SOUND_BLACK_POOF)
        Game():SpawnParticles(position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 20, particle_speed)
    else
        crater:SetColor(goldColor, 150, 1, false, false)
        SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
        Game():SpawnParticles(position, EffectVariant.COIN_PARTICLE, 20, particle_speed)
        Game():SpawnParticles(position, EffectVariant.GOLD_PARTICLE, 40, particle_speed)
    end
end

---@param position Vector
---@param shouldBelialSynergy boolean
local function SpawnDirtPile(position, shouldBelialSynergy)
    local pit = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.DIRT_PILE,
        1,
        position
    )
    pit:SetTimeout(1000)
    if shouldBelialSynergy then
        pit:GetSprite().Color = Color(0.7, 0, 0.1, 1, 0, 0, 0)
    else
        pit:GetSprite().Color = Color(0.7, 0.6, 0, 1, 0, 0, 0)
    end
end

---@param rng RNG
---@param position Vector
---@param shouldBelialSynergy boolean
local function SpawnChest(rng, position, shouldBelialSynergy)
    local room = Game():GetRoom()
    local spawnPos = room:FindFreePickupSpawnPosition(position, 10, true, false)

    if shouldBelialSynergy then
        for idx = 1, 2 do
            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_REDCHEST,
                ChestSubType.CHEST_CLOSED,
                spawnPos,
                (RandomVector() * CHEST_VELOCITY_MULTIPLIER):Rotated(45 * idx)
            ):ToPickup()
        end

        TSIL.PickupSpecific.SpawnHeart(
            HeartSubType.HEART_BLACK,
            spawnPos,
            RandomVector()
        )
    else
        --for idx = 1, 2 do
        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_LOCKEDCHEST,
            ChestSubType.CHEST_CLOSED,
            spawnPos,
            (RandomVector() * CHEST_VELOCITY_MULTIPLIER)
            )
        --end

        local coinSpawnCount = TSIL.Random.GetRandomInt(MIN_COIN_SPAWN_COUNT, MAX_COIN_SPAWN_COUNT, rng)

        for idx = 1, coinSpawnCount do
            TSIL.PickupSpecific.SpawnCoin(
                CoinSubType.COIN_PENNY,
                spawnPos,
                (RandomVector() * 2):Rotated(45 * idx)
            )
        end
    end
end

---@param position Vector
---@return boolean
local function TrySpawnSecretMemberShop(position)
    local room = Game():GetRoom()
    local gridEntity = room:GetGridEntityFromPos(position)

    if not gridEntity or gridEntity:GetType() ~= GridEntityType.GRID_DECORATION then return false end

    --Because we update the room, the Use Item callback will trigger again
    --We need to use a flag to keep track of this
    skipNextShovelUse = true
    TSIL.GridEntities.SpawnGridEntity(
        GridEntityType.GRID_STAIRS,
        TSIL.Enums.CrawlSpaceVariant.SECRET_SHOP,
        position,
        true
    )

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "GoldenShovelSecretShopCreated",
        true
    )

    return true
end

---Stores the original price of a pickup, if it doesn't exist in the table
---@param pickup EntityPickup
local function SaveGoldenShovelPickup(pickup)
    local savedPickups = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "GoldenShovelShopOriginalPrices"
    )

    local strId = tostring(pickup.ShopItemId)

    if not savedPickups[strId] then
        savedPickups[strId] = pickup.Price
    end
end

---Stores the original price of a pickup, updates it if it already exists in the table
---@param pickup EntityPickup
local function UpdateGoldenShovelPickup(pickup)
    local savedPickups = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "GoldenShovelShopOriginalPrices"
    )

    local strId = tostring(pickup.ShopItemId)
    savedPickups[strId] = pickup.Price
end

---@param pickup EntityPickup
local function SetGoldenPrice(pickup, rng)
    if not goldPickupBasePrice[pickup.Variant] then
        return
    end

    --[[local savedPickups = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "GoldenShovelShopOriginalPrices"
    )]]

    --local originalPrice = savedPickups[tostring(pickup.ShopItemId)] or 0
    local priceModifier = TSIL.Random.GetRandomInt(-10, 10, rng)
    local newPickupPrice = math.floor(goldPickupBasePrice[pickup.Variant] / priceModifier)

    if newPickupPrice < 1 then
        newPickupPrice = goldPickupBasePrice[pickup.Variant]
    end

    if newPickupPrice then
        pickup.AutoUpdatePrice = false
        local steamSaleCount = 1
        for i = 0, Game():GetNumPlayers() - 1 do
            if Isaac.GetPlayer(i) then
                steamSaleCount = steamSaleCount + Isaac.GetPlayer(i):GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE)
            end
        end

        local finalPrice = math.floor(newPickupPrice + (newPickupPrice/steamSaleCount))
        print(finalPrice)
        pickup.Price = finalPrice
        --SaveGoldenShovelPickup(pickup)
    end
end

---Replaces the cheapest pickup for sale with a Golden Key
local function ReplaceCheapestWithGoldenKey()
    local pickups = TSIL.EntitySpecific.GetPickups()
    local cheapestPickup

    pickups = TSIL.Utils.Tables.Filter(pickups, function (_, currentPickup)
        return currentPickup:IsShopItem() and currentPickup.Variant ~= PickupVariant.PICKUP_TRINKET
    end)

    for _, currentPickup in pairs(pickups) do
        if not cheapestPickup then
            cheapestPickup = currentPickup
        elseif currentPickup.Price < cheapestPickup.Price then
            cheapestPickup = currentPickup
        end
    end

    if cheapestPickup then
        cheapestPickup:Morph(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_KEY,
            KeySubType.KEY_GOLDEN
        )

        cheapestPickup.AutoUpdatePrice = false
        cheapestPickup.Price = goldPickupBasePrice[PickupVariant.PICKUP_KEY]

        local rng = TSIL.RNG.NewRNG(cheapestPickup.InitSeed)
        SetGoldenPrice(cheapestPickup, rng)
    end
end

---Checks if the current room is a secret shop, and Golden Shovel has been used
---@return boolean
local function IsGoldenShovelShop()
    local goldenShovelShopCreated = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "GoldenShovelSecretShopCreated")
    local room = Game():GetRoom()
    local isSecretShop = room:GetType() == RoomType.ROOM_SHOP and room:GetBackdropType() == BackdropType.SECRET
    return goldenShovelShopCreated and isSecretShop
end

---@param pickup EntityPickup
function goldenShovel:PostPickupInit(pickup)
    if not IsGoldenShovelShop()
    or not pickup:IsShopItem()
    or pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        return
    end

    if pickup.Variant == PickupVariant.PICKUP_TRINKET then
        if MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLDEN_TRINKET) then
            pickup:Morph(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TRINKET,
                TSIL.Trinkets.GetGoldenTrinketType(pickup.SubType),
                true
            )
            return
        else
            return
        end
    end

    local newPickup
    local rng = TSIL.RNG.NewRNG(pickup.InitSeed)
    local goldBombUnlocked = MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLD_BOMB)
    local goldenBatteryUnlocked = MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLDEN_BATTERY)
    local goldenPillUnlocked = MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLD_PILL)
    local goldenHeartUnlocked = MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLDEN_HEART)

    local achievementToVariant = {
        true,
        goldBombUnlocked,
        goldenBatteryUnlocked,
        goldenPillUnlocked,
        goldenHeartUnlocked
    }

    local roomPickups = TSIL.EntitySpecific.GetPickups()
    local pickupVariantsNotToSell = {}
    local weightedGoldPickups = {}

    for _, currentPickup in pairs(roomPickups) do
        if currentPickup:IsShopItem()
        and IsSoldGoldenPickup(currentPickup) then
            table.insert(pickupVariantsNotToSell, currentPickup.Variant)
        end
    end

    for idx, pickupVariant in pairs(goldPickupVariants) do
        if not TSIL.Utils.Tables.IsIn(pickupVariantsNotToSell, pickupVariant)
        and achievementToVariant[idx] then
           table.insert(
            weightedGoldPickups,
            {
                chance = goldPickupWeights[pickupVariant],
                value = {pickupVariant, pickupVariantToGoldSubType[pickupVariant]}
            }
           )
        end
    end

    if #weightedGoldPickups == 0 then
        return

    elseif #weightedGoldPickups == 1 then
        newPickup = weightedGoldPickups[1].value

    else
        newPickup = TSIL.Random.GetRandomElementFromWeightedList(rng, weightedGoldPickups)
    end

    if newPickup then
        pickup:Morph(
            EntityType.ENTITY_PICKUP,
            newPickup[1],
            newPickup[2],
            true
        )

        --UpdateGoldenShovelPickup(pickup)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, goldenShovel.PostPickupInit)


---@param rng RNG
---@param player EntityPlayer
function goldenShovel:onUse(_, rng, player, useFlags)
    if useFlags & UseFlag.USE_CARBATTERY ~= 0 then return end

    if skipNextShovelUse then
        skipNextShovelUse = false
        return {
            Discharge = false
        }
    end

    if not player then
        return
    end

    local shouldBelialSynergy = player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)
    SpawnGoldEffects(player.Position, shouldBelialSynergy)

    if not TrySpawnSecretMemberShop(player.Position) then
        SpawnDirtPile(player.Position, shouldBelialSynergy)
        SpawnChest(
            rng,
            player.Position,
            shouldBelialSynergy
        )
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
        SpawnDirtPile(player.Position, shouldBelialSynergy)
        SpawnChest(
            rng,
            player.Position,
            shouldBelialSynergy
        )
    end

    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, goldenShovel.onUse, enums.Collectibles.GOLDEN_SHOVEL)

function goldenShovel:PostNewRoom()
    local room = Game():GetRoom()
    if IsGoldenShovelShop()
    and room:IsFirstVisit() then
        local restockMachines = Isaac.FindByType(
            EntityType.ENTITY_SLOT,
            TSIL.Enums.SlotVariant.RESTOCK_MACHINE
        )
        local goldenKeys = Isaac.FindByType(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_KEY,
            KeySubType.KEY_GOLDEN
        )


        if #restockMachines + #goldenKeys == 0 then
            ReplaceCheapestWithGoldenKey()
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, goldenShovel.PostNewRoom)

---@param pickup EntityPickup
function goldenShovel:PostPickupUpdate(pickup)
    if not IsGoldenShovelShop()
    or not pickup:IsShopItem() then
        return
    end

    if not TSIL.Players.DoesAnyPlayerHasTrinket(TrinketType.TRINKET_STORE_CREDIT) then
        local rng = TSIL.RNG.NewRNG(pickup.InitSeed)
        SetGoldenPrice(pickup, rng)
    else
        pickup.AutoUpdatePrice = true
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, goldenShovel.PostPickupUpdate)

---@param gridEntity GridEntity
function goldenShovel:PostGridEntityUpdate(gridEntity)
    if not IsGoldenShovelShop() then
        return
    end

    if gridEntity:GetType() == GridEntityType.GRID_ROCK then
        gridEntity:SetType(GridEntityType.GRID_ROCK_GOLD)
        local seed = gridEntity.Desc.SpawnSeed
        gridEntity:Init(seed)

    elseif gridEntity:GetType() == GridEntityType.GRID_POOP
    and gridEntity:GetVariant() == TSIL.Enums.PoopGridEntityVariant.NORMAL then
        gridEntity:SetVariant(TSIL.Enums.PoopGridEntityVariant.GOLDEN)
        local seed = gridEntity.Desc.SpawnSeed
        gridEntity:Init(seed)
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_INIT, goldenShovel.PostGridEntityUpdate)

return goldenShovel