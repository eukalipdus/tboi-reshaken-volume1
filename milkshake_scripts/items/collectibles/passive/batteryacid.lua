local batteryAcid = {}
local enums = MilkshakeVol1.enums

local itemConfig = Isaac.GetItemConfig()
local game = Game()

local CREEP_SCALE = 0.5
local CREEP_DAMAGE = 1.5
local CREEP_COLOR = Color(0, 0, 0, 1, 0.5, 0.5, 0.1)
local CREEP_DELAY_MIN_SECONDS = 0.3
local CREEP_DELAY_MAX_SECONDS = 0.6
local CREEP_DURATION_SECONDS = 1.5
local DRAIN_TIME_SECONDS = 15

local ONE_SECOND = 30
local CREEP_DELAY_MIN = CREEP_DELAY_MIN_SECONDS * ONE_SECOND
local CREEP_DELAY_MAX = CREEP_DELAY_MAX_SECONDS * ONE_SECOND
local CREEP_DURATION = CREEP_DURATION_SECONDS * ONE_SECOND
local DRAIN_TIME = DRAIN_TIME_SECONDS * ONE_SECOND
local CHARGETYPE_NORMAL = 0

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "BatteryAcidData",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN)

---@param player EntityPlayer
---@return table
local function BatteryAcidData(player)
    local data = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "BatteryAcidData")
    local key = player:GetCollectibleRNG(1):GetSeed()

    if not data[key] then
        data[key] = {DrainTimer = DRAIN_TIME, CreepTimer = CREEP_DELAY_MAX}
    end
    return data[key]
end

function batteryAcid:preSpawnCleanAward()
    local chargeToAdd
    local roomShape = game:GetRoom():GetRoomShape()
    if roomShape == RoomShape.ROOMSHAPE_2x2
    or roomShape == RoomShape.ROOMSHAPE_LTL
    or roomShape == RoomShape.ROOMSHAPE_LTR
    or roomShape == RoomShape.ROOMSHAPE_LBL
    or roomShape == RoomShape.ROOMSHAPE_LBR then
        chargeToAdd = 2
    else
        chargeToAdd = 1
    end

    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
            local finalChargeToAdd = chargeToAdd * player:GetCollectibleNum(enums.Collectibles.BATTERY_ACID)
            local data = BatteryAcidData(player)
            data.DrainTimer = DRAIN_TIME
            local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
            if activeItem ~= 0 and itemConfig:GetCollectible(activeItem).ChargeType == CHARGETYPE_NORMAL then
                TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_PRIMARY, finalChargeToAdd)
            end
            local secondItem = player:GetActiveItem(ActiveSlot.SLOT_SECONDARY)
            if secondItem ~= 0 and itemConfig:GetCollectible(secondItem).ChargeType == CHARGETYPE_NORMAL then
                TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_SECONDARY, finalChargeToAdd)
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, batteryAcid.preSpawnCleanAward)
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GREED_MODE_WAVE, batteryAcid.preSpawnCleanAward)


---@param player EntityPlayer
function batteryAcid:postPeffectUpdate(player)
    if not player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
        return end
    if player:GetActiveCharge() <= 0 then
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
        if primaryNotSpecial then
            TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_PRIMARY, -1)
        end
        if secondaryNotSpecial then
            TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_SECONDARY, -1)
        end
        data.DrainTimer = DRAIN_TIME
    end
    data.CreepTimer = data.CreepTimer-1
    if data.CreepTimer <= 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()
        creep:ToEffect():SetTimeout(CREEP_DURATION)
        creep.Color = CREEP_COLOR
        creep.CollisionDamage = CREEP_DAMAGE
        creep.Scale = CREEP_SCALE
        creep:Update()
        local rng = player:GetCollectibleRNG(enums.Collectibles.BATTERY_ACID)
        local creepCooldown = rng:RandomInt(CREEP_DELAY_MAX-CREEP_DELAY_MIN) + CREEP_DELAY_MIN
        data.CreepTimer = creepCooldown
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, batteryAcid.postPeffectUpdate)