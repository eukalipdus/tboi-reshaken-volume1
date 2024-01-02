local batteryAcid = {}
local enums = MilkshakeVol1.enums

local itemConfig = Isaac.GetItemConfig()
local game = Game()

local CREEP_SCALE_TIMER_MULTIPLIER = 0.002
local CREEP_SCALE_BASE = 0.16
local CREEP_DAMAGE = 1.5
local CREEP_COLOR = Color(0, 0, 0, 1, 0.5, 0.5, 0.1)

local CREEP_DELAY_MIN_SECONDS = 0.3
local CREEP_DELAY_MAX_SECONDS = 0.6
local CREEP_DELAY_STACK_DECREASE_SECONDS = 0.2
local MIN_CREEP_DELAY_SECONDS = 0.2
local CREEP_DURATION_SECONDS = 1.5

local DOUBLE_CHARGE_DELAY = 10

local DRAIN_TIME_SECONDS = 15
local DRAIN_STACK_TIMER_DECREASE_SECONDS = 3
local MIN_DRAIN_TIME_SECONDS = 5

local DRAIN_INCREASE_SECONDS = 5
local DRAIN_PER_ROOM_DECREASE_SECONDS = 2
local MIN_DRAIN_INCREASE_SECONDS = 1

local AFFECTED_SLOTS = {
    ActiveSlot.SLOT_PRIMARY,
    ActiveSlot.SLOT_SECONDARY,
    ActiveSlot.SLOT_POCKET
}

local ONE_SECOND = 30

local LARGE_ROOMS = {
    [RoomShape.ROOMSHAPE_2x2] = true,
    [RoomShape.ROOMSHAPE_LTL] = true,
    [RoomShape.ROOMSHAPE_LTR] = true,
    [RoomShape.ROOMSHAPE_LBL] = true,
    [RoomShape.ROOMSHAPE_LBR] = true,
}

local CREEP_DELAY_MIN = math.floor(CREEP_DELAY_MIN_SECONDS * ONE_SECOND)
local CREEP_DELAY_MAX = math.floor(CREEP_DELAY_MAX_SECONDS * ONE_SECOND)
local CREEP_DELAY_STACK_DECREASE = math.floor(CREEP_DELAY_STACK_DECREASE_SECONDS * ONE_SECOND)
local MIN_CREEP_DELAY = math.floor(MIN_CREEP_DELAY_SECONDS * ONE_SECOND)
local CREEP_DURATION = math.floor(CREEP_DURATION_SECONDS * ONE_SECOND)

local DRAIN_TIME = math.floor(DRAIN_TIME_SECONDS * ONE_SECOND)
local DRAIN_STACK_TIMER_DECREASE = math.floor(DRAIN_STACK_TIMER_DECREASE_SECONDS * ONE_SECOND)
local MIN_DRAIN_TIME = math.floor(MIN_DRAIN_TIME_SECONDS * ONE_SECOND)

local DRAIN_INCREASE = math.floor(DRAIN_INCREASE_SECONDS * ONE_SECOND)
local DRAIN_PER_ROOM_DECREASE = math.floor(DRAIN_PER_ROOM_DECREASE_SECONDS * ONE_SECOND)
local MIN_DRAIN_INCREASE = math.floor(MIN_DRAIN_INCREASE_SECONDS * ONE_SECOND)

local CHARGETYPE_NORMAL = 0
local CHARGETYPE_TIMED = 1
local CHARGETYPE_SPECIAL = 2

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "BatteryAcidData",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN)

---@param player EntityPlayer
---@param slot ActiveSlot
---@return boolean
local function CanBeDischarged(player, slot)
    local item = player:GetActiveItem(slot)
    if item == 0 then
        return false end
    if player:GetActiveCharge(slot) <= 0 then
        return false end
    if itemConfig:GetCollectible(item).ChargeType == CHARGETYPE_SPECIAL then
        return false end
    return true
end

---@param player EntityPlayer
---@return number
local function DrainTime(player)
    local extraItemCount = player:GetCollectibleNum(enums.Collectibles.BATTERY_ACID)-1
    local delay = DRAIN_TIME - DRAIN_STACK_TIMER_DECREASE*extraItemCount
    return math.max(delay, MIN_DRAIN_TIME)
end

---@param player EntityPlayer
---@return number
local function CreepCooldown(player)
    local extraItemCount = player:GetCollectibleNum(enums.Collectibles.BATTERY_ACID)-1
    local rng = player:GetCollectibleRNG(enums.Collectibles.BATTERY_ACID)
    local baseCooldown = rng:RandomInt(CREEP_DELAY_MAX-CREEP_DELAY_MIN) + CREEP_DELAY_MIN
    local cooldown = baseCooldown - CREEP_DELAY_STACK_DECREASE*extraItemCount
    return math.max(cooldown,MIN_CREEP_DELAY)
end

---@param player EntityPlayer
---@return table
local function BatteryAcidData(player)
    local data = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "BatteryAcidData")
    local key = player:GetCollectibleRNG(1):GetSeed()

    if not data[key] then
        data[key] = {DrainTimer = DrainTime(player), CreepTimer = CreepCooldown(player), RoomsClearedSinceDrain = 0}
    end
    return data[key]
end

---@param player EntityPlayer
local function IncreaseDrainTimer(player)
    local data = BatteryAcidData(player)
    local increase = DRAIN_INCREASE - data.RoomsClearedSinceDrain*DRAIN_PER_ROOM_DECREASE
    increase = math.max(increase, MIN_DRAIN_INCREASE)
    data.DrainTimer = math.max(data.DrainTimer + increase, increase)
    data.RoomsClearedSinceDrain = data.RoomsClearedSinceDrain + 1
end

---@param player EntityPlayer
---@param chargeToAdd integer
local function AddBatteryAcidCharge(player, chargeToAdd)
    IncreaseDrainTimer(player)
    for _, slot in ipairs(AFFECTED_SLOTS) do
        local activeItem = player:GetActiveItem(slot)

        if activeItem ~= 0
        and itemConfig:GetCollectible(activeItem).ChargeType == CHARGETYPE_NORMAL
        and TSIL.Charge.GetChargesAwayFromMax(player, slot) > 0 then
            TSIL.Utils.Functions.RunInFrames(
                TSIL.Charge.AddCharge,
                DOUBLE_CHARGE_DELAY,
                player, slot, chargeToAdd
            )
        end
    end
end

local function TryChargeTimedActive(player, slot)
    local activeItem = player:GetActiveItem(slot)
    if activeItem ~= 0
    and itemConfig:GetCollectible(activeItem).ChargeType == CHARGETYPE_TIMED
    and TSIL.Charge.GetChargesAwayFromMax(player, slot) > 0 then
        TSIL.Charge.AddCharge(player, slot, player:GetCollectibleNum(enums.Collectibles.BATTERY_ACID), false)
    end
end

function batteryAcid:PostRoomClear()
    local chargeToAdd
    local roomShape = game:GetRoom():GetRoomShape()
    if LARGE_ROOMS[roomShape] then
        chargeToAdd = 2
    else
        chargeToAdd = 1
    end

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
            local finalChargeToAdd = chargeToAdd * player:GetCollectibleNum(enums.Collectibles.BATTERY_ACID)
            AddBatteryAcidCharge(player, finalChargeToAdd)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, batteryAcid.PostRoomClear)
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GREED_MODE_WAVE, batteryAcid.PostRoomClear)
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_AMBUSH_WAVE, batteryAcid.PostRoomClear)

---@param collider Entity
function batteryAcid:PrePickupCollision(battery, collider)
    local player = collider:ToPlayer()
    if not (player and player:HasCollectible(enums.Collectibles.BATTERY_ACID)) then
        return end

    if battery:IsShopItem() and battery.Price > player:GetNumCoins() then
        return end

    local data = BatteryAcidData(player)
    data.DrainTimer = DrainTime(player)
end
---@diagnostic disable-next-line: param-type-mismatch
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, batteryAcid.PrePickupCollision, PickupVariant.PICKUP_LIL_BATTERY)


---@param player EntityPlayer
function batteryAcid:PostPeffectUpdate(player)
    if not player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
        return end

    local data = BatteryAcidData(player)
    data.DrainTimer = data.DrainTimer-1

    local hasDischargableItems = false
    for _, slot in ipairs(AFFECTED_SLOTS) do
        TryChargeTimedActive(player, slot)
        if CanBeDischarged(player, slot) then
            hasDischargableItems = true
        end
    end
    if not hasDischargableItems then
        return end

    if data.DrainTimer <= 0 then
        local dischargedSomething = false
        for _, slot in ipairs(AFFECTED_SLOTS) do
            if CanBeDischarged(player, slot) then
                local config = itemConfig:GetCollectible(player:GetActiveItem(slot))
                if config.ChargeType == CHARGETYPE_TIMED then
                    TSIL.Charge.AddCharge(player, slot, -config.MaxCharges)
                else
                    TSIL.Charge.AddCharge(player, slot, -1)
                end
                dischargedSomething = true
            end
        end
        if dischargedSomething then
            data.DrainTimer = DrainTime(player)
            data.RoomsClearedSinceDrain = 0
        end
    end
    data.CreepTimer = data.CreepTimer-1
    if data.CreepTimer <= 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
        creep:ToEffect():SetTimeout(CREEP_DURATION)
        creep.Color = CREEP_COLOR
        creep.CollisionDamage = CREEP_DAMAGE
        creep.Scale = CREEP_SCALE_BASE + math.max(0, data.DrainTimer)*CREEP_SCALE_TIMER_MULTIPLIER
        creep:Update()
        data.CreepTimer = CreepCooldown(player)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, batteryAcid.PostPeffectUpdate)