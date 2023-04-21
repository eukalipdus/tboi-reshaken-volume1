local specialPennies = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function specialPennies:prePickupCollision(pickup, collider)
    if pickup.Type == EntityType.ENTITY_PICKUP
    and pickup.Variant == PickupVariant.PICKUP_COIN
    and utility:HasValue(enums.Coins, pickup.SubType)
    and collider.Type == EntityType.ENTITY_PLAYER then
        
        pickup:Die()
        local player = collider:ToPlayer()
        local spawnPos = Isaac.GetFreeNearPosition(player.Position, 20)

        if pickup.SubType == enums.Coins.ROTTEN_PENNY then
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, spawnPos, Vector.Zero, nil)
                    
        elseif pickup.SubType == enums.Coins.FLAT_PENNY then
            player:AddKeys(1)
            SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
                --SoundEffect.SOUND_KEY_DROP0
            
        elseif pickup.SubType == enums.Coins.BURNT_PENNY then
            player:AddBombs(1)
            SFXManager():Play(SoundEffect.SOUND_FETUS_FEET)
            
        elseif pickup.SubType == enums.Coins.BUTT_PENNY then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, UseFlag.USE_NOANIM)
            
        elseif pickup.SubType == enums.Coins.CHARGED_PENNY then
            player:SetActiveCharge(player:GetActiveCharge() + 1)
            SFXManager():Play(SoundEffect.SOUND_BEEP)
                    
        elseif pickup.SubType == enums.Coins.CURSED_PENNY then
            -- SoundEffect.SOUND_GOOATTACH0 (spike)
            player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT, UseFlag.USE_NOANIM)
            
        elseif pickup.SubType == enums.Coins.BLOODY_PENNY then
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, spawnPos, Vector.Zero, nil)
            player:AddHearts(1)
            SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
            
        elseif pickup.SubType == enums.Coins.BLESSED_PENNY then
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, spawnPos, Vector.Zero, nil)
            player:AddSoulHearts(1)
            SFXManager():Play(SoundEffect.SOUND_HOLY)
            
        elseif pickup.SubType == enums.Coins.COUNTERFEIT_PENNY then
            player:AddCoins(1)
            SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
                
        elseif pickup.SubType == enums.Coins.ACID_PENNY then
            local randomPill = Game():GetItemPool():GetPill(Random() + 1)
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, randomPill, spawnPos, Vector.Zero, nil)
            player:AddPill(randomPill)
            SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
            
        elseif pickup.SubType == enums.Coins.CRYSTAL_PENNY then
            local randomCard = Game():GetItemPool():GetCard(Random() + 1, true, true, false)
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, randomCard, spawnPos, Vector.Zero, nil)
            player:AddCard(randomCard)
            SFXManager():Play(SoundEffect.SOUND_MENU_NOTE_APPEAR)
        end
        pickup.SubType = 1 -- This stops the pennies from giving 99 cents
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, specialPennies.prePickupCollision)
return specialPennies