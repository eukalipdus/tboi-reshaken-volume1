local enums = milkshakeMod.enums

local PENNY_TYPE_COUNT = 11

local pennyTypes = {
    ROTTEN = 1,
    FLAT = 2,
    BURNT = 3,
    BUTT = 4,
    CHARGED = 5,
    CURSED = 6,
    BLOODY = 7,
    BLESSED = 8,
    COUNTERFEIT = 9,
    POISONED = 10,
    CRYSTAL = 11
}

local spritePaths = {
    [1] = "gfx/items/pick ups/rottenpenny_pickup.png",
    [2] = "gfx/items/pick ups/flatpenny_pickup.png",
    [3] = "gfx/items/pick ups/burntpenny_pickup.png",
    [4] = "gfx/items/pick ups/buttpenny_pickup.png",
    [5] = "gfx/items/pick ups/chargedpenny_pickup.png",
    [6] = "gfx/items/pick ups/cursedpenny_pickup.png",
    [7] = "gfx/items/pick ups/bloodypenny_pickup.png",
    [8] = "gfx/items/pick ups/blessedpenny_pickup.png",
    [9] = "gfx/items/pick ups/counterfeitpenny_pickup.png",
    [10] = "gfx/items/pick ups/acidpenny_pickup.png",
    [11] = "gfx/items/pick ups/crystalpenny_pickup.png"
}

local pennyData = {}

local function getPotPennyVariant(pickup)
    for i = 1, #pennyData do
        if Game():GetLevel():GetCurrentRoomDesc().ListIndex == pennyData[i].ROOM_LIST_INDEX
        and GetPtrHash(pickup) == pennyData[i].PTR_HASH
        and pickup.InitSeed == pennyData[i].INIT_SEED
        then
            return pennyData[i].POT_PENNY_VARIANT
        end
    end
end

function milkshakeMod:onPlayerEffectUpdate(player)
    if not player then return end
    if player:HasCollectible(enums.Collectibles.POT_OF_GOLD) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity.Type == EntityType.ENTITY_PICKUP then
                local pickup = entity:ToPickup()
                if (pickup.Variant == PickupVariant.PICKUP_KEY or pickup.Variant == PickupVariant.PICKUP_BOMB) then
                    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, false, true, true)
                    local rng = player:GetCollectibleRNG(enums.Collectibles.POT_OF_GOLD)
                    local roll = rng:RandomInt(PENNY_TYPE_COUNT) + 1
                    pickup:GetSprite():ReplaceSpritesheet(0, spritePaths[roll])
                    pickup:GetSprite():LoadGraphics()
                    local pennyTable = {
                        ROOM_LIST_INDEX = Game():GetLevel():GetCurrentRoomDesc().ListIndex,
                        PTR_HASH = GetPtrHash(pickup),
                        INIT_SEED = pickup.InitSeed,
                        POT_PENNY_VARIANT = roll
                    }
                    table.insert(pennyData, pennyTable)
                end
            end
        end
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, milkshakeMod.onPlayerEffectUpdate)

function milkshakeMod:onPickupInit()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP then
            local pickup = entity:ToPickup()
            local potPennyVariant = getPotPennyVariant(pickup)
            if not potPennyVariant then return end
            pickup:GetSprite():ReplaceSpritesheet(0, potPennyVariant)
            pickup:GetSprite():LoadGraphics()
        end
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, milkshakeMod.onPickupInit)

function milkshakeMod:onPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end
    local spawnPos = Isaac.GetFreeNearPosition(player.Position, 20)

    local potPennyVariant = getPotPennyVariant(pickup)
    if not potPennyVariant then return end

    if potPennyVariant == pennyTypes.ROTTEN then
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, spawnPos, Vector.Zero, nil)
        
    elseif potPennyVariant == pennyTypes.FLAT then
        player:AddKeys(1)

    elseif potPennyVariant == pennyTypes.BURNT then
        player:AddBombs(1)

    elseif potPennyVariant == pennyTypes.BUTT then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, player.Position, Vector.Zero, nil)

    elseif potPennyVariant == pennyTypes.CHARGED then
        player:SetActiveCharge(player:GetActiveCharge() + 1)
        SFXManager():Play(SoundEffect.SOUND_BATTERYCHARGE)
        
    elseif potPennyVariant == pennyTypes.CURSED then
        player:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE, EntityRef(pickup), 0)
        player:AddCoins(1)

    elseif potPennyVariant == pennyTypes.BLOODY then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, spawnPos, Vector.Zero, nil)

    elseif potPennyVariant == pennyTypes.BLESSED then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, spawnPos, Vector.Zero, nil)

    elseif potPennyVariant == pennyTypes.COUNTERFEIT then
        player:AddCoins(1)
    
    elseif potPennyVariant == pennyTypes.POISONED then
        local randomPill = Game():GetItemPool():GetPill(Random() + 1)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, randomPill, spawnPos, Vector.Zero, nil)

    elseif potPennyVariant == pennyTypes.CRYSTAL then
        local randomCard = Game():GetItemPool():GetCard(Random() + 1, true, true, false)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, randomCard, spawnPos, Vector.Zero, nil)
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, milkshakeMod.onPickupCollision)