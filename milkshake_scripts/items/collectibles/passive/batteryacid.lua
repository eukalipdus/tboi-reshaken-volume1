local batteryAcid = {}
local enums = milkshakeMod.enums

function batteryAcid:preSpawnCleanAward()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
            local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
            local itemConfig = Isaac.GetItemConfig()
            local maxCharge = itemConfig:GetCollectible(activeItem).MaxCharges
            
            if player:GetBatteryCharge() > 0 then
                
            end

            local newCharge = player:GetActiveCharge() + 1
            player:SetActiveCharge(newCharge)
        end
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, batteryAcid.preSpawnCleanAward)

function batteryAcid:entityTakeDmg(player)
    if player:HasCollectible(enums.Collectibles.BATTERY_ACID) then
        local newCharge = player:GetActiveCharge() + player:GetBatteryCharge() - 3
        player:SetActiveCharge(newCharge)
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, batteryAcid.entityTakeDmg, EntityType.ENTITY_PLAYER)