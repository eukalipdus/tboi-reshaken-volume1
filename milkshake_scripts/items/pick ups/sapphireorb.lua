local SapphireOrb = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

local SAPPHIRE_ORB_DURATION = 25
local CONDUCTIVITY_TEAR_LIFESPAN = 30
local CONDUCTIVITY_PARASITE_TEAR_LIFESPAN = 4
local SLOT_ELECTROCUTE_RADIUS = 120
local SLOT_ELECTROCUTION_DURATION = 30
local SLOT_MACHINE_VARIANTS = {
    [TSIL.Enums.SlotVariant.SLOT_MACHINE] = true,
    [TSIL.Enums.SlotVariant.BLOOD_DONATION_MACHINE] = true,
    [TSIL.Enums.SlotVariant.CRANE_GAME] = true,
    [TSIL.Enums.SlotVariant.FORTUNE_TELLING_MACHINE] = true,
    [TSIL.Enums.SlotVariant.RESTOCK_MACHINE] = true,
    [TSIL.Enums.SlotVariant.DONATION_MACHINE] = true,
}
local MACHINE_PAYOUTS = {
    [TSIL.Enums.SlotVariant.SLOT_MACHINE] = {
        --For Slot machines
        { chance = 100, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_PENNY,
            weight = 1
        }},
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_HALF,
            weight = 1
        }},
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_FULL,
            weight = 1
        }},
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_BOMB,
            subtype = BombSubType.BOMB_NORMAL,
            weight = 1
        }},
        { chance = 20, value = {
            variant = PickupVariant.PICKUP_KEY,
            subtype = KeySubType.KEY_NORMAL,
            weight = 1
        }},
        { chance = 15, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_DOUBLEPACK,
            weight = 2
        }},
        { chance = 10, value = {
            variant = PickupVariant.PICKUP_BOMB,
            subtype = BombSubType.BOMB_DOUBLEPACK,
            weight = 2
        }},
        { chance = 10, value = {
            variant = PickupVariant.PICKUP_KEY,
            subtype = KeySubType.KEY_DOUBLEPACK,
            weight = 2
        }},
        { chance = 5, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_NICKEL,
            weight = 2
        }},
        { chance = 1, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_DIME,
            weight = 3
        }},
    },
    [TSIL.Enums.SlotVariant.BLOOD_DONATION_MACHINE] = {
        --For blood donation machines
        { chance = 100, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_PENNY,
            weight = 1
        }},
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_HALF,
            weight = 1
        }},
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_FULL,
            weight = 1
        }},
        { chance = 15, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_DOUBLEPACK,
            weight = 2
        }},
        { chance = 5, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_NICKEL,
            weight = 2
        }},
    },
    [TSIL.Enums.SlotVariant.FORTUNE_TELLING_MACHINE] = {
        --For fortune telling machines
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_SOUL,
            weight = 2
        }},
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_HEART,
            subtype = HeartSubType.HEART_BLACK,
            weight = 2
        }},
        { chance = 15, value = {
            variant = PickupVariant.PICKUP_TAROTCARD,
            subtype = 0,
            weight = 3
        }},
        { chance = 5, value = {
            variant = PickupVariant.PICKUP_TRINKET,
            subtype = 0,
            weight = 3
        }},
    },
    [TSIL.Enums.SlotVariant.RESTOCK_MACHINE] = {
        --For restock machines
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_PENNY,
            weight = 2
        }},
        { chance = 15, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_NICKEL,
            weight = 2
        }},
        { chance = 15, value = {
            variant = PickupVariant.PICKUP_TAROTCARD,
            subtype = Card.CARD_DICE_SHARD,
            weight = 3
        }},
    },
    [TSIL.Enums.SlotVariant.DONATION_MACHINE] = {
        --For Donation machines
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_PENNY,
            weight = 2
        }},
        { chance = 15, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_NICKEL,
            weight = 2
        }},
        { chance = 7, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = CoinSubType.COIN_DIME,
            weight = 3
        }},
    },
    [TSIL.Enums.SlotVariant.CRANE_GAME] = {
        --For crane game machines
        { chance = 30, value = {
            variant = PickupVariant.PICKUP_COIN,
            subtype = HeartSubType.COIN_NICKEL,
            weight = 2
        }},
        { chance = 15, value = {
            variant = PickupVariant.PICKUP_TRINKET,
            subtype = 0,
            weight = 3
        }},
        { chance = 5, value = {
            variant = PickupVariant.PICKUP_COLLECTIBLE,
            subtype = 0,
            weight = 6
        }},
    },
}


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "PlayersUsingSapphireOrbFrames",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "PlayerSelfConductivityTear",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "ConductivityTears",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "ConductivityParasiteTears",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "ElectrocutedSlotFrames",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param player EntityPlayer
function SapphireOrb:OnSapphireOrbUse(_, player)
    local playerUsingLyraData = utility:GetTemporaryPlayerData(player, "UsingLyraData")

    if playerUsingLyraData then return end

    local isDoublePower = utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
    utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", nil)

    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingSapphireOrbFrames = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersUsingSapphireOrbFrames"
    )

    local frameCount = Game():GetFrameCount()
    if isDoublePower then
        playersUsingSapphireOrbFrames[tostring(playerIndex)] = frameCount + SAPPHIRE_ORB_DURATION
    else
        playersUsingSapphireOrbFrames[tostring(playerIndex)] = frameCount
    end

    local tear = TSIL.EntitySpecific.SpawnTear(
        TearVariant.BLUE,
        0,
        player.Position,
        player.Velocity,
        player,
        player:GetCardRNG(enums.Cards.SAPPHIRE_ORB)
    )

    tear.Visible = false
    ---@diagnostic disable-next-line: param-type-mismatch
    tear:AddTearFlags(TearFlags.TEAR_JACOBS | TearFlags.TEAR_LASER | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_BOUNCE | TearFlags.TEAR_TURN_HORIZONTAL)
    tear.CollisionDamage = 3.5 * utility:GetCurrentChapter()

    local playerConductivityTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PlayerSelfConductivityTear")
    local ptrHash = GetPtrHash(tear)
    playerConductivityTears[tostring(ptrHash)] = playerIndex
end

milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, SapphireOrb.OnSapphireOrbUse, enums.Cards.SAPPHIRE_ORB)


---@param player EntityPlayer
---@param rng RNG
local function SpawnConductiveTear(player, rng)
    local velocity = Vector.FromAngle(TSIL.Random.GetRandomInt(0, 360, rng)) * TSIL.Random.GetRandomFloat(8, 12, rng)

    local tear = TSIL.EntitySpecific.SpawnTear(
        TearVariant.BLUE,
        0,
        player.Position,
        velocity,
        player,
        rng
    )

    tear.Visible = false
    ---@diagnostic disable-next-line: param-type-mismatch
    tear:AddTearFlags(TearFlags.TEAR_JACOBS | TearFlags.TEAR_LASER | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_BOUNCE | TearFlags.TEAR_TURN_HORIZONTAL)

    tear.CollisionDamage = TSIL.Stage.GetEffectiveStage() * 3.5

    local conductivityTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ConductivityTears")
    local ptrHash = GetPtrHash(tear)
    conductivityTears[tostring(ptrHash)] = true
end

---@param slot Entity
---@return boolean
local function isSlotMachine(slot)
    return SLOT_MACHINE_VARIANTS[slot.Variant] ~= nil
end

---@param player EntityPlayer
---@param rng RNG
local function ElectrocuteSlots(player, rng)
    if rng:RandomFloat() <= 0.05 then return end

    local electrocutedSlotFrames = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ElectrocutedSlotFrames")

    local entitiesInRadius = Isaac.FindInRadius(player.Position, SLOT_ELECTROCUTE_RADIUS)
    local slotsInRadius = TSIL.Utils.Tables.Filter(entitiesInRadius, function(_, entity)
        local entityPtr = GetPtrHash(entity)

        if electrocutedSlotFrames[tostring(entityPtr)] then
            return false
        end

        return entity.Type == EntityType.ENTITY_SLOT and
            isSlotMachine(entity) and
            entity.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND
    end)

    if #slotsInRadius == 0 then return end

    local slotToElectrocute = TSIL.Random.GetRandomElementsFromTable(slotsInRadius, 1, rng)[1]
    slotToElectrocute:GetSprite():Play("Wiggle", true)

    local ptrHash = GetPtrHash(slotToElectrocute)
    local frameCount = Game():GetFrameCount()

    electrocutedSlotFrames[tostring(ptrHash)] = frameCount
end

---@param player EntityPlayer
function SapphireOrb:OnPeffectUpdate(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local playersUsingSapphireOrbFrames = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersUsingSapphireOrbFrames"
    )

    local frameUsedSapphireOrb = playersUsingSapphireOrbFrames[tostring(playerIndex)]

    if not frameUsedSapphireOrb then return end

    local currentFrame = Game():GetFrameCount()

    if currentFrame - frameUsedSapphireOrb >= SAPPHIRE_ORB_DURATION then
        playersUsingSapphireOrbFrames[tostring(playerIndex)] = nil
    end

    local rng = player:GetCardRNG(enums.Cards.SAPPHIRE_ORB)

    SpawnConductiveTear(player, rng)

    ElectrocuteSlots(player, rng)
end

milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SapphireOrb.OnPeffectUpdate)


local function SpawnFakeParasiteTear(tear, velocity)
    local parasiteTear = TSIL.EntitySpecific.SpawnTear(
        TearVariant.BLUE,
        0,
        tear.Position,
        velocity,
        tear.SpawnerEntity,
        tear.InitSeed
    )

    parasiteTear.Visible = false
    ---@diagnostic disable-next-line: param-type-mismatch
    parasiteTear:AddTearFlags(TearFlags.TEAR_JACOBS | TearFlags.TEAR_LASER | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_BOUNCE | TearFlags.TEAR_TURN_HORIZONTAL)

    local conductivityTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ConductivityParasiteTears")
    local ptrHash = GetPtrHash(parasiteTear)
    conductivityTears[tostring(ptrHash)] = true
end

---@param tear EntityTear
function SapphireOrb:OnTearUpdate(tear)
    local playerConductivityTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PlayerSelfConductivityTear")
    local conductivityTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ConductivityTears")
    local conductivityParasiteTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ConductivityParasiteTears")
    local ptrHash = GetPtrHash(tear)

    if playerConductivityTears[tostring(ptrHash)] then
        local playerIndex = playerConductivityTears[tostring(ptrHash)]

        local player = TSIL.Players.GetPlayerByIndex(playerIndex)
        if not player or tear.FrameCount >= SAPPHIRE_ORB_DURATION then
            playerConductivityTears[tostring(ptrHash)] = nil
            tear:Remove()
            return
        end

        tear.FallingAcceleration = -0.1
        tear.FallingSpeed = 0
        tear.Position = player.Position
        tear.Velocity = player.Velocity

        return
    end

    if conductivityParasiteTears[tostring(ptrHash)] then
        if tear.FrameCount <= CONDUCTIVITY_PARASITE_TEAR_LIFESPAN then return end
        conductivityParasiteTears[tostring(ptrHash)] = nil
        tear:Remove()
        return
    end

    if not conductivityTears[tostring(ptrHash)] then return end
    if tear.FrameCount <= CONDUCTIVITY_TEAR_LIFESPAN then return end

    if tear:GetDropRNG():RandomFloat() < 0.7 then
        SpawnFakeParasiteTear(tear, tear.Velocity:Normalized():Rotated(90) * 15)
        SpawnFakeParasiteTear(tear, tear.Velocity:Normalized():Rotated(-90) * 15)
    end

    tear:Remove()
    conductivityTears[tostring(ptrHash)] = nil
end

milkshakeMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, SapphireOrb.OnTearUpdate)


---@param tear EntityTear
function SapphireOrb:OnTearCollision(tear)
    local conductivityTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ConductivityTears")
    local conductivityParasiteTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ConductivityParasiteTears")
    local ptrHash = GetPtrHash(tear)

    if not conductivityTears[tostring(ptrHash)] and not conductivityParasiteTears[tostring(ptrHash)] then return end

    return true
end

milkshakeMod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, SapphireOrb.OnTearCollision)


---@param spawnPos Vector
---@param rng RNG
local function SpawnSlotElectrocutionPayouts(spawnPos, rng, slot)
    local maxWeight = TSIL.Random.GetRandomInt(2, 4, rng)
    local currentWeight = 0
    local ActualPayoutTable = MACHINE_PAYOUTS[slot.Variant] or MACHINE_PAYOUTS[1]
    while currentWeight < maxWeight do
        local rewardToSpawn = TSIL.Random.GetRandomElementFromWeightedList(rng, ActualPayoutTable)
        currentWeight = currentWeight + rewardToSpawn.weight

        local velocity = Vector.FromAngle(rng:RandomInt(360)) * TSIL.Random.GetRandomFloat(5, 7, rng)
        if rewardToSpawn.variant == PickupVariant.PICKUP_COLLECTIBLE then
            spawnPos = Isaac.GetFreeNearPosition (spawnPos,5)
            rewardToSpawn.subtype = Game():GetItemPool():GetCollectible(
                ItemPoolType.POOL_CRANE_GAME,
                true,
                rng:Next(),
                CollectibleType.COLLECTIBLE_NULL
            )
        end
        TSIL.EntitySpecific.SpawnPickup(
            rewardToSpawn.variant,
            rewardToSpawn.subtype,
            spawnPos,
            velocity
        )
    end
end


---@param slot Entity
function SapphireOrb:OnSlotUpdate(slot)
    local electrocutedSlotFrames = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ElectrocutedSlotFrames")
    local ptrHash = GetPtrHash(slot)

    local slotElectrocutionFrame = electrocutedSlotFrames[tostring(ptrHash)]

    if not slotElectrocutionFrame then return end

    local slotSpr = slot:GetSprite()

    local frameCount = Game():GetFrameCount()
    local currentDuration = frameCount - slotElectrocutionFrame

    if currentDuration >= SLOT_ELECTROCUTION_DURATION then
        electrocutedSlotFrames[tostring(ptrHash)] = nil

        TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.BOMB_EXPLOSION,
            0,
            slot.Position
        )
        slotSpr:Play("Broken", true)

        Game():BombExplosionEffects(
            slot.Position,
            0,
            nil,
            nil,
            nil,
            0.0001
        )

        SFXManager():Stop(SoundEffect.SOUND_EXPLOSION_WEAK)

        return
    end

    if currentDuration % 15 ~= 0 then return end

    SpawnSlotElectrocutionPayouts(slot.Position, slot:GetDropRNG(),slot)
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_SLOT_UPDATE,
    SapphireOrb.OnSlotUpdate
)


function SapphireOrb:OnSlotCollision(slot)
    local electrocutedSlotFrames = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "ElectrocutedSlotFrames")
    local ptrHash = GetPtrHash(slot)

    local slotElectrocutionFrame = electrocutedSlotFrames[tostring(ptrHash)]

    if slotElectrocutionFrame then
        return true
    end
end
milkshakeMod:AddPriorityCallback(
    TSIL.Enums.CustomCallback.PRE_SLOT_COLLISION,
    CallbackPriority.IMPORTANT,
    SapphireOrb.OnSlotCollision
)
