local specialPennies = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function specialPennies:prePlayerCollision(pickup, collider)
    if pickup.EntityType == EntityType.ENTITY_PICKUP
    and pickup.Variant == PickupVariant.PICKUP_COIN
    and utility:hasValue(enums.Coins, pickup.SubType)
    and collider.EntityType == EntityType.ENTITY_PLAYER then
        SFXManager():Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1)
        pickup:Remove()
        local player = collider:ToPlayer()

        local spawnPos = Isaac.GetFreeNearPosition(player.Position, 20)

        if collider.SubType == enums.Coins.ROTTEN_PENNY then
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0, spawnPos, Vector.Zero, nil)
                    
        elseif collider.SubType == enums.Coins.FLAT_PENNY then
            player:AddKeys(1)
            SFXManager():Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET)
                --SoundEffect.SOUND_KEY_DROP0
            
        elseif collider.SubType == enums.Coins.BURNT_PENNY then
            player:AddBombs(1)
            SFXManager():Play(SoundEffect.SOUND_FETUS_FEET)
            
        elseif collider.SubType == enums.Coins.BUTT_PENNY then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_BUTTER_BEAN, UseFlag.USE_NOANIM)
            
        elseif collider.SubType == enums.Coins.CHARGED_PENNY then
            player:SetActiveCharge(player:GetActiveCharge() + 1)
            SFXManager():Play(SoundEffect.SOUND_BEEP)
                    
        elseif collider.SubType == enums.Coins.CURSED_PENNY then
            -- SoundEffect.SOUND_GOOATTACH0 (spike)
            player:UseActiveItem(CollectibleType.COLLECTIBLE_TELEPORT, UseFlag.USE_NOANIM)
            
        elseif collider.SubType == enums.Coins.BLOODY_PENNY then
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, spawnPos, Vector.Zero, nil)
            player:AddHearts(1)
            SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
            
        elseif collider.SubType == enums.Coins.BLESSED_PENNY then
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, spawnPos, Vector.Zero, nil)
            player:AddSoulHearts(1)
            SFXManager():Play(SoundEffect.SOUND_HOLY)
            
        elseif collider.SubType == enums.Coins.COUNTERFEIT_PENNY then
            player:AddCoins(1)
            SFXManager():Play(SoundEffect.SOUND_CASH_REGISTER)
                
        elseif collider.SubType == enums.Coins.ACID_PENNY then
            local randomPill = Game():GetItemPool():GetPill(Random() + 1)
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, randomPill, spawnPos, Vector.Zero, nil)
            player:AddPill(randomPill)
            SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
            
        elseif collider.SubType == enums.Coins.CRYSTAL_PENNY then
            local randomCard = Game():GetItemPool():GetCard(Random() + 1, true, true, false)
            --Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, randomCard, spawnPos, Vector.Zero, nil)
            player:AddCard(randomCard)
            SFXManager():Play(SoundEffect.SOUND_MENU_NOTE_APPEAR)
        end
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, specialPennies.prePlayerCollision)
return specialPennies