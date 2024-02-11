local laChancla = {}
local enums = MilkshakeVol1.enums

local SPEED_UP = 0.3
local MOM_FOOT_VARIANT = 10

local stompers = {
    EntityType.ENTITY_SATAN,
    EntityType.ENTITY_DADDYLONGLEGS,
    EntityType.ENTITY_DELIRIUM
}

local function IsStomper(entity)
    local effect, variant
    if entity.Entity:ToEffect() then
        effect = entity.Entity:ToEffect()
        variant = effect.Variant
    end

    if (entity.Type == EntityType.ENTITY_MOM and entity.Variant == MOM_FOOT_VARIANT)
    or TSIL.Utils.Tables.IsIn(stompers, entity.Type)
    or (effect and variant == EffectVariant.MOM_FOOT_STOMP) then
        return true
    else
        return false
    end
end

function laChancla:EvaluateCache(player, cacheFlag)
    if player:HasCollectible(enums.Collectibles.LA_CHANCLA) then
        if cacheFlag == CacheFlag.CACHE_SPEED then
            local increase = player:GetCollectibleNum(enums.Collectibles.LA_CHANCLA, true)
            player.MoveSpeed = player.MoveSpeed + (SPEED_UP * increase)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, laChancla.EvaluateCache)

function laChancla:EntityTakeDmg(entity, _, flags, source)
    local player = entity:ToPlayer()

    if player:HasCollectible(enums.Collectibles.LA_CHANCLA) then
        if not source or not source.Entity then return end

        if (TSIL.Utils.Flags.HasFlags(DamageFlag.DAMAGE_CRUSH, flags))
        and IsStomper(source)
        then
            return false
        end
    end
end
if REPENTOGON then
    MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, laChancla.EntityTakeDmg)
else
    MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, laChancla.EntityTakeDmg, EntityType.ENTITY_PLAYER)
end

return laChancla