local batteryAcid = {}
local enums = MilkshakeVol1.enums

local itemConfig = Isaac.GetItemConfig()
local game = Game()

local CREEP_COLOR = Color(0, 0, 0, 1, 0.5, 0.5, 0.1)
local CREEP_DELAY_MIN_SECONDS = 0.3
local CREEP_DELAY_MAX_SECONDS = 0.6
local CREEP_DURATION_SECONDS = 1.5
local DISCHARGE_TIME_SECONDS = 15

local ONE_SECOND = 30
local CREEP_DELAY_MIN = CREEP_DELAY_MIN_SECONDS * ONE_SECOND
local CREEP_DELAY_MAX = CREEP_DELAY_MAX_SECONDS * ONE_SECOND
local CREEP_DURATION = CREEP_DURATION_SECONDS * ONE_SECOND
local DISCHARGE_TIME = DISCHARGE_TIME_SECONDS * ONE_SECOND
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
        data[key] = {DrainTimer = DISCHARGE_TIME, CreepTimer = CREEP_DELAY_MAX}
    end
    return data[key]
end

function batteryAcid:preSpawnCleanAward()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
            local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
            if itemConfig:GetCollectible(activeItem).ChargeType == CHARGETYPE_NORMAL then
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
                chargeToAdd = chargeToAdd * player:GetCollectibleNum(enums.Collectibles.BATTERY_ACID)
                TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_PRIMARY, chargeToAdd)
                local data = BatteryAcidData(player)
                data.DrainTimer = DISCHARGE_TIME
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
    local activeItem = player:GetActiveItem()
    if activeItem == 0 or itemConfig:GetCollectible(activeItem).ChargeType ~= CHARGETYPE_NORMAL then
        return end

    local data = BatteryAcidData(player)

    data.DrainTimer = data.DrainTimer-1
    if data.DrainTimer <= 0 then
        TSIL.Charge.AddCharge(player, ActiveSlot.SLOT_PRIMARY, -1)
        data.DrainTimer = DISCHARGE_TIME
    end
    data.CreepTimer = data.CreepTimer-1
    if data.CreepTimer <= 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, player.Position, Vector.Zero, player)
        creep:ToEffect():SetTimeout(CREEP_DURATION)
        creep.Color = CREEP_COLOR
        local rng = player:GetCollectibleRNG(enums.Collectibles.BATTERY_ACID)
        local creepCooldown = rng:RandomInt(CREEP_DELAY_MAX-CREEP_DELAY_MIN) + CREEP_DELAY_MIN
        data.CreepTimer = creepCooldown
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, batteryAcid.postPeffectUpdate)