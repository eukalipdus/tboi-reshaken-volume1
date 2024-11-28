local SpiritKlin = {}
local enums = MilkshakeVol1.enums

---@class BrendaReward
---@field chance number | fun(player: EntityPlayer, brenda: Entity): number
---@field value fun(slot: Entity, player: EntityPlayer, position: Vector, velocity: Vector)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "SpiritKlinSpawnedGlassTrinkets",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "ShouldCheckUnlockedGlassTrinketsNextRoom",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "BrendasPerFloor",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

local function hasChargedSoulChargeItem(player)
   if (player:HasCollectible(enums.Collectibles.LEVITICUS)
   or player:HasCollectible(enums.Collectibles.LEVITICUS_ALADAR)
   or player:HasCollectible(enums.Collectibles.LEVITICUS_FANCY)
   or player:HasCollectible(CollectibleType.COLLECTIBLE_ALABASTER_BOX))
   and player:GetActiveCharge() + player:GetBatteryCharge() > 0 then return true end

   return false
end

---@param player EntityPlayer
local function isLostForm(player)
    local playerType = player:GetPlayerType()
    local soulHearts = player:GetSoulHearts()
    local allotherhearts = player:GetHearts()  + player:GetBoneHearts() --player:GetRottenHearts()
    local isGhost = player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)

    if (playerType == PlayerType.PLAYER_THELOST
    or playerType == PlayerType.PLAYER_THELOST_B
    or (EclipsedMod and playerType == EclipsedMod.enums.Characters.UnbiddenB))
    or (REPENTOGON and (player:GetHealthType() == HealthType.LOST)) then return true end


    if isGhost and soulHearts == 1 and allotherhearts == 0 then return true end --lost curse checking

    return false
end

---@param brenda Entity
local function GetTrackedBrendaIndex(brenda)
    local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "BrendasPerFloor"
    )

    local currentRoomIdx = Game():GetLevel():GetCurrentRoomIndex()

    if #brendasPerFloor == 0 then
        return -1
    end

    for idx, entry in pairs(brendasPerFloor) do
        if entry.InitSeed == brenda.InitSeed
        and currentRoomIdx == entry.RoomIndex then
            return idx
        end
    end

    return -1
end

---Stores needed information about a given Brenda slot
---@param brenda Entity
local function InitBrendaData(brenda)
    if GetTrackedBrendaIndex(brenda) ~= -1 then
        return
    end

    local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "BrendasPerFloor"
    )

    table.insert(
        brendasPerFloor,
        MilkshakeVol1.utility:GetSlotIndex(brenda)
    )

    local brendaIndex = GetTrackedBrendaIndex(brenda)

    brendasPerFloor[brendaIndex].PaymentsReceived = 0
    brendasPerFloor[brendaIndex].HasDied = false
end

local gemtrinkets = {
    enums.Trinkets.AMETHYST_SHARD,
    enums.Trinkets.RUBY_SHARD,
    enums.Trinkets.TOURMALINE_SHARD,
    enums.Trinkets.EMERALD_SHARD,
    enums.Trinkets.PERIDOT_SHARD,
    enums.Trinkets.GARNET_SHARD,
    enums.Trinkets.ONYX_SHARD,
    enums.Trinkets.DIAMOND_SHARD,
    enums.Trinkets.SAPPHIRE_SHARD,
    enums.Trinkets.AMBER_SHARD
}
local soulStones = {
    Card.CARD_SOUL_ISAAC,
    Card.CARD_SOUL_MAGDALENE,
    Card.CARD_SOUL_CAIN,
    Card.CARD_SOUL_JUDAS,
    Card.CARD_SOUL_BLUEBABY,
    Card.CARD_SOUL_EVE,
    Card.CARD_SOUL_SAMSON,
    Card.CARD_SOUL_AZAZEL,
    Card.CARD_SOUL_LAZARUS,
    Card.CARD_SOUL_EDEN,
    Card.CARD_SOUL_LOST,
    Card.CARD_SOUL_LILITH,
    Card.CARD_SOUL_KEEPER,
    Card.CARD_SOUL_APOLLYON,
    Card.CARD_SOUL_FORGOTTEN,
    Card.CARD_SOUL_BETHANY,
    Card.CARD_SOUL_JACOB
}
---@type table<Card, fun(): boolean>
local IsUnlockedPerSoulStone = {}
local glassTrinkets = {
    enums.Trinkets.SAPPHIRE_SHARD,
    enums.Trinkets.ONYX_SHARD,
    enums.Trinkets.RUBY_SHARD,
    enums.Trinkets.GARNET_SHARD,
    enums.Trinkets.DIAMOND_SHARD,
    enums.Trinkets.EMERALD_SHARD,
    enums.Trinkets.PERIDOT_SHARD,
    enums.Trinkets.AMETHYST_SHARD,
    enums.Trinkets.TOURMALINE_SHARD,
    TrinketType.TRINKET_TEARDROP_CHARM,
    TrinketType.TRINKET_CRYSTAL_KEY
}
---@type table<TrinketType, fun(): boolean>
local IsUnlockedPerGlassTrinket = {}
---@type BrendaReward[]
local brendaRewards = {}
local possibleWisps = {
    enums.Collectibles.SPECIAL_BRENDA_FIRE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_PSYCHIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_NATURE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_ELECTRIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_WATER_WISP,
    enums.Collectibles.SPECIAL_BRENDA_POISON_WISP,
    enums.Collectibles.SPECIAL_BRENDA_HOLY_WISP,
    enums.Collectibles.SPECIAL_BRENDA_UNHOLY_WISP,
    enums.Collectibles.SPECIAL_BRENDA_UNDEAD_WISP,
    enums.Collectibles.SPECIAL_BRENDA_TERRA_WISP,
}

local COLLECTIBLE_PAYMENT_CHANCE = 1.2
local MIN_PAYMENTS_FOR_COLLECTIBLE = 7

---Plays Brenda's death animation and removes the given Brenda
---@param brenda Entity
local function KillBrenda(brenda)
    brenda:Remove()
    SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
    Game():ShakeScreen(10)
    Game():MakeShockwave(brenda.Position, 0.03, 0.025, 10)

    local dustCloud = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.DUST_CLOUD,
        1,
        brenda.Position
    )
    dustCloud.SpriteScale = Vector(1.5, 1.5)
    dustCloud:SetTimeout(15)

    local rng = TSIL.RNG.NewRNG(brenda.InitSeed)
    local numParticles = TSIL.Random.GetRandomInt(10, 16, rng)

    for _ = 1, numParticles, 1 do
        local angle = rng:RandomInt(360)
        local velocity = TSIL.Random.GetRandomFloat(6, 8, rng)
        local spawnVel = Vector.FromAngle(angle):Resized(velocity)

        TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.ROCK_PARTICLE,
            0,
            brenda.Position,
            spawnVel
        )
    end
end

---Pays out with a random Glass pool item
---@param brenda Entity
local function BrendaCollectiblePayout(brenda)
    KillBrenda(brenda)

    local collectible = TSIL.CustomItemPools.GetCollectible(
        enums.ItemPools.GLASS,
        true,
        brenda:GetDropRNG(),
        enums.Collectibles.MILKSHAKE
    )
    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_COLLECTIBLE,
        collectible,
        brenda.Position
    )
end

---Adds a custom character's soul stone to the Spirit Klin's reward pool.
---@param card Card
---@param isUnlocked? fun(): boolean
function MilkshakeVol1.API:AddSoulStone(card, isUnlocked)
    soulStones[#soulStones + 1] = card
    if isUnlocked ~= nil then
        IsUnlockedPerSoulStone[card] = isUnlocked
    end
end

---Adds a trinket to the Spirit Klin's glass trinket pool.
---@param trinket TrinketType
---@param isUnlocked? fun(): boolean
function MilkshakeVol1.API:AddGlassTrinkets(trinket, isUnlocked)
    glassTrinkets[#glassTrinkets + 1] = trinket
    IsUnlockedPerGlassTrinket[trinket] = isUnlocked
end

---Adds a new reward possibility to the Spirit Klin.
---
---The weight can just be a regular integer or a function that will get called when the machine is trying to pay out.
---@param weight number | fun(player: EntityPlayer, brenda: Entity): number
---@param rewardFun fun(slot: Entity, player: EntityPlayer, position: Vector, velocity: Vector)
function MilkshakeVol1.API:AddSpiritKlinReward(weight, rewardFun)
    brendaRewards[#brendaRewards + 1] = {
        chance = weight,
        value = rewardFun
    }
end

--Spawn soul stone
MilkshakeVol1.API:AddSpiritKlinReward(function()
        local itemConfig = Isaac.GetItemConfig()
        local availableSoulStones = TSIL.Utils.Tables.Filter(soulStones, function(_, soulStone)
            local isUnlocked = IsUnlockedPerSoulStone[soulStone]

            if isUnlocked then
                return isUnlocked()
            else
                local cardInfo = itemConfig:GetCard(soulStone)
                return cardInfo:IsAvailable()
            end
        end)

        --The weight for this reward depends on the number of soul stones unlocked
        return math.sqrt(#availableSoulStones * 2)
    end,
    function(slot, _, position, velocity)
        local rng = slot:GetDropRNG()
        local itemConfig = Isaac.GetItemConfig()
        local availableSoulStones = TSIL.Utils.Tables.Filter(soulStones, function(_, soulStone)
            local isUnlocked = IsUnlockedPerSoulStone[soulStone]

            if isUnlocked then
                return isUnlocked()
            else
                local cardInfo = itemConfig:GetCard(soulStone)
                return cardInfo:IsAvailable()
            end
        end)
        local soulStone = TSIL.Random.GetRandomElementsFromTable(availableSoulStones, 1, rng)[1]

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_TAROTCARD,
            soulStone,
            position,
            velocity,
            slot
        )
    end)


--Spawn orb
MilkshakeVol1.API:AddSpiritKlinReward(10, function(slot, _, position, velocity)
    local rng = slot:GetDropRNG()
    local orb = MilkshakeVol1.utility:GetRandomSpiritOrb(0, rng)

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        orb,
        position,
        velocity,
        slot
    )
end)


--Spawn glass trinket
MilkshakeVol1.API:AddSpiritKlinReward(function(_)
    local spawnedTrinkets = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinSpawnedGlassTrinkets"
    )
    local availableTrinkets = TSIL.Utils.Tables.Filter(glassTrinkets, function(_, trinket)
        return spawnedTrinkets[trinket] ~= true
    end)

    if #availableTrinkets == 0 then
        return 0
    end

    return 1
end, function(slot, _, position, velocity)
    local rng = slot:GetDropRNG()
    local spawnedTrinkets = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinSpawnedGlassTrinkets"
    )
    local availableTrinkets = TSIL.Utils.Tables.Filter(glassTrinkets, function(_, trinket)
        return spawnedTrinkets[trinket] ~= true
    end)
    local trinket = TSIL.Random.GetRandomElementsFromTable(availableTrinkets, 1, rng)[1]

    spawnedTrinkets[trinket] = true
    local itemPool = Game():GetItemPool()
    itemPool:RemoveTrinket(trinket)

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TRINKET,
        trinket,
        position,
        velocity,
        slot
    )
end)


-- --Smelt player trinkets
-- MilkshakeVol1.API:AddSpiritKlinReward(function(player)
--     if player:GetTrinket(0) ~= 0 then
--         return 3
--     end

--     return 0
-- end, function(_, player)
--     player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)

--     TSIL.EntitySpecific.SpawnEffect(
--         EffectVariant.POOF01,
--         0,
--         player.Position
--     )
--     SFXManager():Play(SoundEffect.SOUND_BEAST_FIRE_RING)
-- end)


--Add random element wisp
MilkshakeVol1.API:AddSpiritKlinReward(function(player)
    local familiarPlayers = TSIL.Familiars.GetPlayerFamiliars(player)
    local wisps = TSIL.Utils.Tables.Filter(familiarPlayers, function(_, familiar)
        return familiar.Variant == FamiliarVariant.WISP and familiar.OrbitLayer == 8
    end)

    if #wisps >= 8 then
        return 0
    end

    return 15
end, function(slot, player, position)
    local rng = slot:GetDropRNG()
    local wispToAdd = TSIL.Random.GetRandomElementsFromTable(possibleWisps, 1, rng)[1]

    player:AddWisp(wispToAdd, position)
end)

MilkshakeVol1.API:AddSpiritKlinReward(function (_, brenda)
    local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "BrendasPerFloor"
    )
    local brendaIndex = GetTrackedBrendaIndex(brenda)

    if brendasPerFloor[brendaIndex].PaymentsReceived >= MIN_PAYMENTS_FOR_COLLECTIBLE then
        return COLLECTIBLE_PAYMENT_CHANCE * brendasPerFloor[brendaIndex].PaymentsReceived - (MIN_PAYMENTS_FOR_COLLECTIBLE - 1)
    else
        return 0
    end

end, function (slot)
    local collectible = TSIL.CustomItemPools.GetCollectible(
        enums.ItemPools.GLASS,
        true,
        slot:GetDropRNG()
    )

    BrendaCollectiblePayout(slot)
end)


local function RemoveRecentRewards(pos)
    for _, pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        if pickup.FrameCount <= 1 and pickup.SpawnerType == EntityType.ENTITY_NULL
        and pickup.Position:DistanceSquared(pos) <= 400 then
            pickup:Remove()
        end
    end
    for _, trollbomb in ipairs(Isaac.FindByType(EntityType.ENTITY_BOMB)) do
        if (trollbomb.Variant == BombVariant.BOMB_TROLL or trollbomb.Variant == BombVariant.BOMB_SUPERTROLL)
        and trollbomb.FrameCount <= 1 and trollbomb.SpawnerType == EntityType.ENTITY_NULL
        and trollbomb.Position:DistanceSquared(pos) <= 400 then
            trollbomb:Remove()
        end
    end
end


---@param slot Entity
---@param skipDeathAnimation? boolean
local function OnSlotBroken(slot, skipDeathAnimation)
    RemoveRecentRewards(slot.Position)
    local pickups = TSIL.EntitySpecific.GetPickups()
    local slotPosLastFrame = slot.Position - slot.Velocity
    local rewardPickups = TSIL.Utils.Tables.Filter(pickups, function(_, pickup)
        local pickupPosLastFrame = pickup.Position - pickup.Velocity
        return pickup.FrameCount == 1
            and TSIL.Vector.VectorFuzzyEquals(slotPosLastFrame, pickupPosLastFrame)
    end)
    for _, pickup in ipairs(rewardPickups) do
        pickup:Remove()
    end
    local newSlot = TSIL.EntitySpecific.SpawnSlot(
        enums.Slots.SPIRIT_KLIN_BRENDA,
        0,
        slot.Position - slot.Velocity,
        Vector.Zero,
        slot.SpawnerEntity
    )

    newSlot:AddEntityFlags(slot:GetEntityFlags())
    newSlot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

    local oldData = slot:GetData()
    local newData = newSlot:GetData()
    --Im not letting GetData mess with my code
    if type(oldData) == "table" and type(newData) == "table" then
        for key, value in pairs(oldData) do
            newData[key] = value
        end
    end

    local oldSprite = slot:GetSprite()
    local newSprite = newSlot:GetSprite()

    if not skipDeathAnimation then
        SFXManager():Play(enums.Sounds.BRENDA_HURT)

        if oldSprite:IsPlaying("Inactive") then
            newSprite:Play("Death")
        else
            newSprite:Play("Death")
            if oldSprite:IsPlaying("Death") then
                newSprite:Play("Inactive")
                --newSprite:SetFrame(oldSprite:GetFrame())
            end
        end
    else
        newSprite:Play("Inactive")
    end
    slot:Remove()

    local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "BrendasPerFloor"
    )

    InitBrendaData(newSlot)

    local oldBrendaIndex = GetTrackedBrendaIndex(slot)
    local newBrendaIndex = GetTrackedBrendaIndex(newSlot)

    if not brendasPerFloor[oldBrendaIndex].HasDied then
        local gemTrinket = TSIL.Random.GetRandomElementsFromTable(gemtrinkets, 1, slot:GetDropRNG())[1]
        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_TRINKET,
            gemTrinket,
            slot.Position,
            RandomVector(),
            slot
        )
        --KillBrenda(slot)
    end
    brendasPerFloor[newBrendaIndex].HasDied = true
    if brendasPerFloor[oldBrendaIndex].DeathReapplied then
        brendasPerFloor[newBrendaIndex].DeathReapplied = true
    end
end


---@param slot Entity
local function CheckCollisionWithChaosCard(slot)
    local chaosCards = TSIL.EntitySpecific.GetTears(TearVariant.CHAOS_CARD)
    chaosCards = TSIL.Utils.Tables.Filter(chaosCards, function(_, tear)
        return tear.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE
    end)

    return TSIL.Utils.Tables.Some(chaosCards, function(tear)
        if slot.SizeMulti.X ~= slot.SizeMulti.Y then
            return (
                    math.abs(slot.Position.X - tear.Position.X) ^ 2
                    <= (slot.Size * slot.SizeMulti.X + tear.Size) ^ 2
                )
                and (
                    math.abs(slot.Position.Y - tear.Position.Y) ^ 2
                    <= (slot.Size * slot.SizeMulti.Y + tear.Size) ^ 2
                )
        else
            return slot.Position:DistanceSquared(tear.Position) <= (slot.Size + tear.Size) ^ 2
        end
    end)
end


---@param brenda Entity
function SpiritKlin:OnBrendaUpdate(brenda)
    if CheckCollisionWithChaosCard(brenda) then
        BrendaCollectiblePayout(brenda)
    end

    local sprite = brenda:GetSprite()

    if brenda.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "BrendasPerFloor"
        )

        local brendaIndex = GetTrackedBrendaIndex(brenda)

        if brendasPerFloor[brendaIndex].HasDied then
            OnSlotBroken(brenda, true)
        else
            OnSlotBroken(brenda, false)
        end
        return
    end

    brenda.SizeMulti = Vector(2.2, 1)

    if sprite:IsFinished("Prize") then
        sprite:Play("Idle")
    end

    if sprite:IsFinished("Death") then
        sprite:Play("Inactive")
    end
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_SLOT_UPDATE,
    SpiritKlin.OnBrendaUpdate,
    enums.Slots.SPIRIT_KLIN_BRENDA
)

---@param brenda Entity
---@param player EntityPlayer
function SpiritKlin:OnBrendaCollision(brenda, player)
    local sprite = brenda:GetSprite()
    if sprite:GetAnimation() ~= "Idle" then return end

    local soulCharge = player:GetSoulCharge()
    local soulHearts = player:GetSoulHearts()
    local allotherhearts = player:GetHearts() + player:GetBoneHearts() -- + player:GetRottenHearts()

    if isLostForm(player) and (not hasChargedSoulChargeItem(player)) and soulCharge < 1 then return end
    if soulCharge + soulHearts == 0 and (not hasChargedSoulChargeItem(player)) then return end
    if isLostForm(player) then
        if soulCharge >= 1 then player:AddSoulCharge(-1)
        elseif hasChargedSoulChargeItem(player) then
            player:SetActiveCharge(player:GetActiveCharge() + player:GetBatteryCharge() - 1)
        end
    else
        if soulCharge >= 1 then
            player:AddSoulCharge(-1)
        elseif hasChargedSoulChargeItem(player) then
            player:SetActiveCharge(player:GetActiveCharge() + player:GetBatteryCharge() - 1)
        elseif allotherhearts == 0 and soulHearts == 1 then
                player:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE|DamageFlag.DAMAGE_NO_MODIFIERS|DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(player), 1)
        else
                player:AddSoulHearts(-1)
        end
    end

    SFXManager():Play(enums.Sounds.BRENDA_ACTIVATE)
    SFXManager():Play(enums.Sounds.SOULHEART_LOSE, 0.7)

    sprite:Play("Prize", true)
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        brenda,
        "PlayerIndexUsingSlot",
        TSIL.Players.GetPlayerIndex(player)
    )

    local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "BrendasPerFloor"
    )

    local brendaIndex = GetTrackedBrendaIndex(brenda)
    local prevPayments = brendasPerFloor[brendaIndex].PaymentsReceived
    brendasPerFloor[brendaIndex].PaymentsReceived = prevPayments + 1
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.PRE_SLOT_COLLISION,
    SpiritKlin.OnBrendaCollision,
    enums.Slots.SPIRIT_KLIN_BRENDA
)


---@param brenda Entity
function SpiritKlin:OnBrendaPrize(brenda)
    local playerIndex = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        brenda,
        "PlayerIndexUsingSlot"
    )
    local player = TSIL.Players.GetPlayerByIndex(playerIndex)

    if not player then return end

    local rng = brenda:GetDropRNG()
    local rewardSpawnPos = brenda.Position + Vector(0, 5 * brenda.SpriteScale.Y)

    local velAngle = TSIL.Random.GetRandomInt(0, 180, rng)
    local speed = TSIL.Random.GetRandomFloat(5, 7, rng)
    local rewardSpawnVel = Vector.FromAngle(velAngle):Resized(speed)

    local rewards = TSIL.Utils.Tables.Map(brendaRewards, function(_, reward)
        local endChance = reward.chance
        if type(endChance) == "function" then
            endChance = reward.chance(player, brenda)
        end

        return {
            chance = endChance,
            value = reward.value
        }
    end)
    local reward = TSIL.Random.GetRandomElementFromWeightedList(rng, rewards)
    reward(brenda, player, rewardSpawnPos, rewardSpawnVel)
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_SLOT_PRIZE,
    SpiritKlin.OnBrendaPrize,
    enums.Slots.SPIRIT_KLIN_BRENDA
)


---@param brenda Entity
function SpiritKlin:PostSlotInit(brenda)
    InitBrendaData(brenda)

    local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "BrendasPerFloor"
    )

    local brendaIndex = GetTrackedBrendaIndex(brenda)

    if brendasPerFloor[brendaIndex].HasDied
    and not brendasPerFloor[brendaIndex].DeathReapplied then
        brendasPerFloor[brendaIndex].DeathReapplied = true
        OnSlotBroken(brenda, true)
    end
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_SLOT_INIT,
    SpiritKlin.PostSlotInit,
    enums.Slots.SPIRIT_KLIN_BRENDA
)



---@param trinket TrinketType
---@return boolean
local function DefaultIsTrinketUnlocked(trinket)
    local itemConfig = Isaac.GetItemConfig()
    local trinketInfo = itemConfig:GetTrinket(trinket)

    return trinketInfo:IsAvailable()
end


function SpiritKlin:OnGameStart(isContinue)
    if isContinue then return end

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "ShouldCheckUnlockedGlassTrinketsNextRoom",
        true
    )
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    SpiritKlin.OnGameStart
)


function SpiritKlin:OnNewRoom()
    local brendasPerFloor = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "BrendasPerFloor"
    )

    for _, currentBrendaData in pairs(brendasPerFloor) do
        currentBrendaData.DeathReapplied = false
    end

    local shouldCheck = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "ShouldCheckUnlockedGlassTrinketsNextRoom"
    )
    if not shouldCheck then return end

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "ShouldCheckUnlockedGlassTrinketsNextRoom",
        false
    )

    local spawnedTrinkets = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinSpawnedGlassTrinkets"
    )

    for _, trinket in ipairs(glassTrinkets) do
        local isUnlocked = IsUnlockedPerGlassTrinket[trinket]

        if not DefaultIsTrinketUnlocked(trinket) or (isUnlocked and not isUnlocked()) then
            spawnedTrinkets[trinket] = true
        end
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    SpiritKlin.OnNewRoom
)
