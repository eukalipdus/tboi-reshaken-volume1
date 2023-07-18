local batteryAcid = {}
local enums = MilkshakeVol1.enums

local itemConfig = Isaac.GetItemConfig()
local game = Game()

local CREEP_SCALE = 0.5
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
local CHARGETYPE_NORMAL = 0

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "BatteryAcidData",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN)

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
        data[key] = {DrainTimer = DrainTime(player), CreepTimer = CreepCooldown(player)}
    end
    return data[key]
end

---@param player EntityPlayer
---@param chargeToAdd integer
local function AddBatteryAcidCharge(player, chargeToAdd)
    local data = BatteryAcidData(player)
    data.DrainTimer = data.DrainTimer + DRAIN_INCREASE
    for _, slot in ipairs({ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_SECONDARY}) do
        local activeItem = player:GetActiveItem(slot)

        if activeItem ~= 0
        and itemConfig:GetCollectible(activeItem).ChargeType == CHARGETYPE_NORMAL
        and TSIL.Charge.GetChargesAwayFromMax(player, slot) > 0 then
            TSIL.Utils.Functions.RunInFrames(
                TSIL.Charge.AddCharge,
                DOUBLE_CHARGE_DELAY,
                player, slot, chargeToAdd
            )
            return
        end
    end
end

function batteryAcid:preSpawnCleanAward()
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
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, batteryAcid.preSpawnCleanAward)
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GREED_MODE_WAVE, batteryAcid.preSpawnCleanAward)

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
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, batteryAcid.PrePickupCollision, PickupVariant.PICKUP_LIL_BATTERY)


---@param player EntityPlayer
function batteryAcid:postPeffectUpdate(player)
    if not player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
        return end

    local primaryActiveItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
    local secondaryActiveItem = player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)
    local primaryNotSpecial
    local secondaryNotSpecial
    if primaryActiveItem ~= 0 then
        primaryNotSpecial = itemConfig:GetCollectible(primaryActiveItem).ChargeType == CHARGETYPE_NORMAL
    end
    if secondaryActiveItem ~= 0 then
        secondaryNotSpecial = itemConfig:GetCollectible(secondaryActiveItem).ChargeType == CHARGETYPE_NORMAL
    end

    if
    not ((primaryNotSpecial and player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) > 0)
    or secondaryNotSpecial and player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) > 0) then
        return end

    local data = BatteryAcidData(player)

    data.DrainTimer = data.DrainTimer-1
    if data.DrainTimer <= 0 then
        if primaryNotSpecial and player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) > 0 then
            TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_PRIMARY, -1)
        elseif secondaryNotSpecial and player:GetActiveCharge(ActiveSlot.SLOT_SECONDARY) > 0 then
            TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_SECONDARY, -1)
        end
        data.DrainTimer = DrainTime(player)
    end
    data.CreepTimer = data.CreepTimer-1
    if data.CreepTimer <= 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
        creep:ToEffect():SetTimeout(CREEP_DURATION)
        creep.Color = CREEP_COLOR
        creep.CollisionDamage = CREEP_DAMAGE
        creep.Scale = CREEP_SCALE
        creep:Update()
        data.CreepTimer = CreepCooldown(player)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, batteryAcid.postPeffectUpdate)