local goldenShovel = {}
local enums = MilkshakeVol1.enums

local CHEST_VELOCITY_MULTIPLIER = 15
local ACHIEVEMENT_GOLDEN_HEART = 224
local ACHIEVEMENT_GOLD_PILL = 603
local ACHIEVEMENT_GOLDEN_BATTERY = 615
local ACHIEVEMENT_GOLD_BOMB = 226
local ACHIEVEMENT_GOLDEN_TRINKET = 617

local goldPickupPriceIncrease = {
    [PickupVariant.PICKUP_BOMB] = 8,
    [PickupVariant.PICKUP_KEY] = 7,
    [PickupVariant.PICKUP_PILL] = 15,
    [PickupVariant.PICKUP_LIL_BATTERY] = 20,
    [PickupVariant.PICKUP_HEART] = 0,
}

local MIN_COIN_SPAWN_COUNT = 2
local MAX_COIN_SPAWN_COUNT = 4
--local skipNextShovelUse = false


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "GoldenShovelSecretShopCreated",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_FLOOR
)

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
    --skipNextShovelUse = true
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

---@param pickup EntityPickup
local function SetGoldenPrice(pickup)
    local newPickupPrice = goldPickupPriceIncrease[pickup.Variant]
    if newPickupPrice then
        pickup.AutoUpdatePrice = false
        local steamSaleCount = 1
        for i = 0, Game():GetNumPlayers() - 1 do
            if Isaac.GetPlayer(i) then
                steamSaleCount = steamSaleCount + Isaac.GetPlayer(i):GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE)
            end
        end
        pickup.Price = math.floor(pickup.Price + (newPickupPrice/steamSaleCount))
    end
end

---Replaces the cheapest pickup for sale with a Golden Key
local function ReplaceCheapestWithGoldenKey()
    local pickups = TSIL.EntitySpecific.GetPickups()
    local cheapestPickup

    pickups = TSIL.Utils.Tables.Filter(pickups, function (_, currentPickup)
        return currentPickup:IsShopItem()
    end)

    for _, currentPickup in pairs(pickups) do
        if not cheapestPickup then
            cheapestPickup = currentPickup
        elseif currentPickup.Price < cheapestPickup.Price then
            cheapestPickup = currentPickup
        end
    end

    if cheapestPickup then
        cheapestPickup:Remove()

        local goldenKey = TSIL.PickupSpecific.SpawnKey(
            KeySubType.KEY_GOLDEN,
            cheapestPickup.Position,
            Vector.Zero
        )

        goldenKey.AutoUpdatePrice = false
        goldenKey.Price = cheapestPickup.Price
        SetGoldenPrice(goldenKey)
        goldenKey.Price = math.min(goldenKey.Price, 14)
    end
end

---Checks if the current room is a secret shop, and Golden Shovel has been used
local function IsGoldenShovelShop()
    local goldenShovelShopCreated = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "GoldenShovelSecretShopCreated")
    local room = Game():GetRoom()
    local isSecretShop = room:GetType() == RoomType.ROOM_SHOP and room:GetBackdropType() == BackdropType.SECRET
    print(room:GetBackdropType())
    return goldenShovelShopCreated and isSecretShop
end

-- ---@param pickup EntityPickup
function goldenShovel:PostPickupUpdate(pickup)
    if not IsGoldenShovelShop()
    or not pickup:IsShopItem() then
        return
    end
    local newPickup
    local goldenHeartUnlocked = MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLDEN_HEART)

    if pickup.Variant == PickupVariant.PICKUP_HEART then
        if pickup.SubType == HeartSubType.HEART_BLACK
        and goldenHeartUnlocked then
            newPickup = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN}

        elseif pickup.SubType == HeartSubType.HEART_ETERNAL then

            if MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLD_PILL) then
                newPickup = {PickupVariant.PICKUP_PILL, PillColor.PILL_GOLD}
            else
                newPickup = {PickupVariant.PICKUP_PILL, PillColor.PILL_GOLD}--RANDOM POILL
            end

        elseif pickup.SubType == HeartSubType.HEART_ROTTEN then
            if goldenHeartUnlocked then
                newPickup = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN}
            else
                newPickup = {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
            end

        elseif pickup.SubType == HeartSubType.HEART_BONE then
            if MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLDEN_BATTERY) then
                newPickup = {PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_GOLDEN}
            else
                newPickup = {PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL}
            end
        end

    elseif pickup.Variant == PickupVariant.PICKUP_TAROTCARD then
        if pickup.SubType <= 31 or (pickup.SubType >= 40 and pickup.SubType <= 77) then--Is a card
            newPickup = {PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN}

        elseif (pickup.SubType >= 32 and pickup.SubType <= 41) --Is a rune
        or (pickup.SubType >= 81 and pickup.SubType <= 97) then-- Is a soulstone

            if MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLD_BOMB) then
                newPickup = {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN}
            else
                newPickup = {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
            end

        else
            newPickup = {PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN}
        end
    end

    if newPickup then
        pickup:Morph(
            EntityType.ENTITY_PICKUP,
            newPickup[1],
            newPickup[2],
            true
        )

    elseif pickup.Variant == PickupVariant.PICKUP_TRINKET
    and not TSIL.Trinkets.IsGoldenTrinket(pickup.SubType)
    and MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ACHIEVEMENT_GOLDEN_TRINKET) then
        pickup:Morph(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TRINKET,
            TSIL.Trinkets.GetGoldenTrinketType(pickup.SubType),
            true
        )
    else
        return
    end

    SetGoldenPrice(pickup)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, goldenShovel.PostPickupUpdate)


---@param rng RNG
---@param player EntityPlayer
function goldenShovel:onUse(_, rng, player)
    --[[if skipNextShovelUse then
        skipNextShovelUse = false
        return
    end]]

    if not player then return end

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

return goldenShovel