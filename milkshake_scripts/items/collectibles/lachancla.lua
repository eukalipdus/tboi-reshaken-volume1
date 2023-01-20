local laChancla = {}
local enums = require("milkshake_scripts.enums")

local SPEED_UP = 0.3

function laChancla:onCache(player, cacheFlag)
    if player:HasCollectible(enums.Collectibles.LA_CHANCLA) then
        if cacheFlag == CacheFlag.CACHE_SPEED then
            local increase = player:GetCollectibleNum(enums.Collectibles.LA_CHANCLA, true)
            player.MoveSpeed = player.MoveSpeed + (SPEED_UP * increase)
        end
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, laChancla.onCache)

function laChancla:onHit(entity, amount, flags, source)
    local effect, variant
    local player = entity:ToPlayer()
    if not player then return end

    if player:HasCollectible(enums.Collectibles.LA_CHANCLA) then
        if source.Entity:ToEffect() then -- High priestess card
            effect = source.Entity:ToEffect()
            variant = effect.Variant
        end


        if (flags & DamageFlag.DAMAGE_CRUSH == 0)
        and (variant == EffectVariant.MOM_FOOT_STOMP or source.Entity.Type == EntityType.ENTITY_MOM or source.Entity.Type == EntityType.ENTITY_SATAN) == false
        then return end
        
        return false
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, laChancla.onHit, EntityType.ENTITY_PLAYER)
return laChancla