local enums = milkshakeMod.enums
local leviticus = {}





local usedLeviticus = 0

local LEVITICUS_MAX_CHARGES = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.LEVITICUS).MaxCharges

local VANILLA_SOUL_HEARTS = {
    [HeartSubType.HEART_SOUL] = true, 
    [HeartSubType.HEART_BLACK] = true,
    [HeartSubType.HEART_BLENDED] = true,
    [HeartSubType.HEART_HALF_SOUL] = true
  }
if FiendFolio then
local FF_SOUL_HEARTS = {
    [FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART] = true,
    [FiendFolio.PICKUP.VARIANT.IMMORAL_HEART] = true,
    [FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART] = true,
    [FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART] = true,
    [FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART] = true,
    
}
end

function leviticus:onLeviticusUse(item, _, player)
    player:AddEternalHearts(1)
    SFXManager():Play(SoundEffect.SOUND_SUPERHOLY)
    usedLeviticus = 1
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end
--heartTypes: 2 = HEART_SOUL, 4 = HEART_BLACK, 10 = PICKUP_IMMORAL_HEART
function leviticus:addSoulCharges(player, charges, heartType)
    for i = 0, charges-1, 1 do
        local leviticus_slot = leviticus:checkActiveSlot(player)

        if player:GetActiveCharge(leviticus_slot) < LEVITICUS_MAX_CHARGES then
        player:SetActiveCharge(player:GetActiveCharge(leviticus_slot) + 1, leviticus_slot)
        else
            if heartType == 2 then player:AddSoulHearts(1) end
            if heartType == 4 then player:AddBlackHearts(1) end
            if heartType == 10 then FiendFolio:AddImmoralHearts(player, 1) end
        end
    end
end

function leviticus:checkActiveSlot(player)
for i = 0, 4, 1 do
    if player:GetActiveItem(i) == enums.Collectibles.LEVITICUS and player:GetActiveCharge(i) < LEVITICUS_MAX_CHARGES then
        return i
    end
end
return nil
end

function leviticus:removePickup(pickup)
    pickup = pickup:ToPickup()
    
    local sprite = pickup:GetSprite()
    sprite:RemoveOverlay()
    sprite:Play("Collect", true)
    pickup:Die()
end

function leviticus:onPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end

    if not player:HasCollectible(enums.Collectibles.LEVITICUS) then return end

    local leviticus_slot = leviticus:checkActiveSlot(player)
    if leviticus_slot == nil then return end

    if player:CanPickSoulHearts() and (player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B and player:GetPlayerType() ~= PlayerType.PLAYER_THELOST) then return end

    if not (VANILLA_SOUL_HEARTS[pickup.SubType] or (FiendFolio and FF_SOUL_HEARTS[pickup.Variant])) then return end
        if pickup:IsShopItem() and pickup.Price > player:GetNumCoins() then return 
        elseif pickup:IsShopItem() and pickup.Price <= player:GetNumCoins() then
            player:AddCoins(-1 * pickup.Price)
        end

    if pickup.SubType == HeartSubType.HEART_SOUL then
        leviticus:addSoulCharges(player, 2, 2)
        SFXManager():Play(SoundEffect.SOUND_HOLY)
        leviticus:removePickup(pickup)
        return false
    elseif pickup.SubType == HeartSubType.HEART_HALF_SOUL then
        leviticus:addSoulCharges(player, 1, 2)
        SFXManager():Play(SoundEffect.SOUND_HOLY)
        leviticus:removePickup(pickup)
        return false
        elseif pickup.SubType == HeartSubType.HEART_BLENDED then
            local redHeartsToAdd = math.min(2, player:GetMaxHearts() - player:GetHearts())
            if redHeartsToAdd >= 2 then return
            elseif redHeartsToAdd == 1 then player:AddHearts(1)
                SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
                leviticus:addSoulCharges(player, 1, 2)
                leviticus:removePickup(pickup)
                SFXManager():Play(SoundEffect.SOUND_HOLY)
                return false
            elseif redHeartsToAdd == 0 then
                leviticus:addSoulCharges(player, 2, 2)
                leviticus:removePickup(pickup)
                SFXManager():Play(SoundEffect.SOUND_HOLY)
                return false
            end

        elseif pickup.SubType == HeartSubType.HEART_BLACK then
            leviticus:addSoulCharges(player, 2, 4)
            SFXManager():Play(SoundEffect.SOUND_UNHOLY)
            leviticus:removePickup(pickup)
            return false
        
        elseif (FiendFolio and pickup.Variant == FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART) then
            leviticus:addSoulCharges(player, 1, 4)
            SFXManager():Play(SoundEffect.SOUND_UNHOLY)
            leviticus:removePickup(pickup)
            return false
        elseif (FiendFolio and pickup.Variant == FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART) then
            local redHeartsToAdd = math.min(2, player:GetMaxHearts() - player:GetHearts())
            if redHeartsToAdd >= 2 then return
            elseif redHeartsToAdd == 1 then player:AddHearts(1)
                SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
                leviticus:addSoulCharges(player, 1, 4)
                leviticus:removePickup(pickup)
                SFXManager():Play(SoundEffect.SOUND_UNHOLY)
                return false
            elseif redHeartsToAdd == 0 then
                leviticus:addSoulCharges(player, 2, 4)
                leviticus:removePickup(pickup)
                SFXManager():Play(SoundEffect.SOUND_UNHOLY)
                return false
            end

        elseif (FiendFolio and pickup.Variant == FiendFolio.PICKUP.VARIANT.IMMORAL_HEART) then
            leviticus:addSoulCharges(player, 2, 10)
            SFXManager():Play(FiendFolio.Sounds.FiendHeartPickup, 1, 0, false, 1)
            leviticus:removePickup(pickup)
            return false
        elseif (FiendFolio and pickup.Variant == FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART) then
            leviticus:addSoulCharges(player, 1, 10)
            SFXManager():Play(FiendFolio.Sounds.FiendHeartPickup, 1, 0, false, 1)
            leviticus:removePickup(pickup)
            return false
        elseif (FiendFolio and pickup.Variant == FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART) then
            local redHeartsToAdd = math.min(2, player:GetMaxHearts() - player:GetHearts())
            if redHeartsToAdd >= 2 then return
            elseif redHeartsToAdd == 1 then player:AddHearts(1)
                SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
                leviticus:addSoulCharges(player, 1, 10)
                leviticus:removePickup(pickup)
                SFXManager():Play(FiendFolio.Sounds.FiendHeartPickup, 1, 0, false, 1)
                return false
            elseif redHeartsToAdd == 0 then
                leviticus:addSoulCharges(player, 2, 10)
                leviticus:removePickup(pickup)
                SFXManager():Play(FiendFolio.Sounds.FiendHeartPickup, 1, 0, false, 1)
                return false
            end
    end

end
function leviticus:onItemSpawn(itemPoolType, decrease, _)

    local roomType = Game():GetRoom():GetType()
    if roomType ~= RoomType.ROOM_BOSS then
        return
    end
    if itemPoolType ~= ItemPoolType.POOL_BOSS then
        return
    end
    if usedLeviticus == 0 then
        return
    end

    local ItemPool = Game():GetItemPool()

    local randomAngelItemID = ItemPool:GetCollectible(ItemPoolType.POOL_ANGEL, false)

    return randomAngelItemID

end

function leviticus:OnHealthChanged(player, healthType, old, new)

    if not player:HasCollectible(enums.Collectibles.LEVITICUS) then return end
    local leviticus_slot = leviticus:checkActiveSlot(player)
    if leviticus_slot == nil then return end
    if healthType ~= TSIL.Enums.HealthType.SOUL and healthType ~= TSIL.Enums.HealthType.BLACK then
        return
    end

    local heartsAdded = new - old
    if heartsAdded < 0 then
        return
    end
    print(healthType)
    print(heartsAdded)
    if (healthType == 4) then
        player:AddBlackHearts(-1 * heartsAdded)
        leviticus:addSoulCharges(player, heartsAdded, healthType)
    elseif (healthType == 2) then
        player:AddSoulHearts(-1 * heartsAdded)
        leviticus:addSoulCharges(player, heartsAdded, healthType)
    end
    

end
function leviticus:newFloor()
    usedLeviticus = 0
    return 0
end

milkshakeMod:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_HEALTH_CHANGED, leviticus.OnHealthChanged)

milkshakeMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, leviticus.onPickupCollision)

milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, leviticus.onLeviticusUse, enums.Collectibles.LEVITICUS)

milkshakeMod:AddCallback(ModCallbacks.MC_PRE_GET_COLLECTIBLE, leviticus.onItemSpawn)

milkshakeMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, leviticus.newFloor)
