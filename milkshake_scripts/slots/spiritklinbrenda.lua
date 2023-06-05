local SpiritKlin = {}
local enums = MilkshakeVol1.enums

---@class BrendaReward
---@field chance integer | fun(player: EntityPlayer): integer
---@field value fun(slot: Entity, player: EntityPlayer, position: Vector, velocity: Vector)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "SpiritKlinGlassTrinketsPool",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "SpiritKlinAvailableSoulStones",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)


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
local isUnlockedPerSoulStone = {}
local glassTrinkets = {
    enums.Trinkets.SAPPHIRE_SHARD,
    enums.Trinkets.ONYX_SHARD,
    enums.Trinkets.RUBY_SHARD,
    enums.Trinkets.GARNET_SHARD,
    enums.Trinkets.DIAMOND_SHARD,
    enums.Trinkets.EMERALD_SHARD,
    enums.Trinkets.PERIDOT_SHARD,
    enums.Trinkets.AMETHYST_SHARD,
    enums.Trinkets.TOURMALINE_SHARD
}
---@type BrendaReward[]
local brendaRewards = {}

---Adds a custom character's soul stone to the Spirit Klin's reward pool.
---@param card Card
---@param isUnlocked? fun(): boolean
function MilkshakeVol1.API.AddSoulStone(card, isUnlocked)
    soulStones[#soulStones+1] = card
    if isUnlocked ~= nil then
        isUnlockedPerSoulStone[card] = isUnlocked
    end
end


---Adds a trinket to the Spirit Klin's glass trinket pool.
---
---This function can take multiple arguments.
---@param ... TrinketType
function MilkshakeVol1.API.AddGlassTrinkets(...)
    for _, card in ipairs({...}) do
        glassTrinkets[#glassTrinkets+1] = card
    end
end


---Adds a new reward possibility to the Spirit Klin.
---
---The weight can just be a regular integer or a function that will get called when the machine is trying to pay out.
---@param weight integer | fun(player: EntityPlayer): integer
---@param rewardFun fun(slot: Entity, player: EntityPlayer, position: Vector, velocity: Vector)
function MilkshakeVol1.API.AddSpiritKlinReward(weight, rewardFun)
    brendaRewards[#brendaRewards+1] = {
        chance = weight,
        value = rewardFun
    }
end


--Spawn soul stone
MilkshakeVol1.API.AddSpiritKlinReward(function ()
    local availableSoulStones = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinAvailableSoulStones"
    )

    --The weight for this reward depends on the number of soul stones unlocked
    return #availableSoulStones * 1.1
end,
function (slot, _, position, velocity)
    local rng = slot:GetDropRNG()
    local availableSoulStones = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinAvailableSoulStones"
    )
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
MilkshakeVol1.API.AddSpiritKlinReward(10, function (slot, _, position, velocity)
    local rng = slot:GetDropRNG()
    local orb = MilkshakeVol1.utility:GetRandomSpiritOrb(true, rng)

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        orb,
        position,
        velocity,
        slot
    )
end)


--Spawn glass trinket
MilkshakeVol1.API.AddSpiritKlinReward(7, function (slot, _, position, velocity)
    local rng = slot:GetDropRNG()
    local trinketPool = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinGlassTrinketsPool"
    )
    local chosenIndex = TSIL.Random.GetRandomInt(1, #trinketPool, rng)
    local trinket = table.remove(trinketPool, chosenIndex)

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TRINKET,
        trinket,
        position,
        velocity,
        slot
    )
end)


--Smelt player trinkets
MilkshakeVol1.API.AddSpiritKlinReward(function (player)
    if player:GetTrinket(0) ~= 0 then
        return 3
    end

    return 0
end, function (_, player)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)

    TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.POOF01,
        0,
        player.Position
    )
    SFXManager():Play(SoundEffect.SOUND_BEAST_FIRE_RING)
end)


local function CheckAvailableSoulStones()
    local itemConfig = Isaac.GetItemConfig()
    local availableSoulStones = TSIL.Utils.Tables.Filter(soulStones, function (_, soulStone)
        local isUnlocked = isUnlockedPerSoulStone[soulStone]

        if isUnlocked ~= nil then
            return isUnlocked()
        end

        local card = itemConfig:GetCard(soulStone)
        return card:IsAvailable()
    end)

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinAvailableSoulStones",
        availableSoulStones
    )
end


function SpiritKlin:OnGameStart(isContinue)
    if isContinue then return end

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "SpiritKlinGlassTrinketsPool",
        TSIL.Utils.Tables.Copy(glassTrinkets)
    )

    CheckAvailableSoulStones()
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_GAME_STARTED_REORDERED,
    SpiritKlin.OnGameStart
)


---@param brenda Entity
function SpiritKlin:OnBrendaUpdate(brenda)
    local sprite = brenda:GetSprite()

    if brenda.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        sprite:Play("Broken", false)
        return
    end

    if sprite:IsFinished("Wiggle") then
        sprite:Play("Prize", true)
    end

    if sprite:IsFinished("Prize") then
        sprite:Play("Idle")
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
    if soulCharge < 1 and soulHearts < 1 then return end

    if soulCharge >= 1 then
        player:AddSoulCharge(-1)
    else
        player:AddSoulHearts(-1)
    end

    sprite:Play("Wiggle", true)
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        brenda,
        "PlayerIndexUsingSlot",
        TSIL.Players.GetPlayerIndex(player)
    )
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

    local rewards = TSIL.Utils.Tables.Map(brendaRewards, function (_, reward)
        local endChance = reward.chance
        if type(endChance) == "function" then
            endChance = reward.chance(player)
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