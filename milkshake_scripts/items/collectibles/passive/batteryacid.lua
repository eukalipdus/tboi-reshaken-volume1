local batteryAcid = {}
local enums = MilkshakeVol1.enums

local itemConfig = Isaac.GetItemConfig()
local game = Game()

local CHARGETYPE_NORMAL = 0

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
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, batteryAcid.preSpawnCleanAward)
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GREED_MODE_WAVE, batteryAcid.preSpawnCleanAward)

function batteryAcid:entityTakeDmg(entity)
    local player = entity:ToPlayer()
    if player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
        local newCharge = player:GetActiveCharge() + player:GetBatteryCharge() - 3
        player:SetActiveCharge(newCharge)
    end
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, batteryAcid.entityTakeDmg, EntityType.ENTITY_PLAYER)