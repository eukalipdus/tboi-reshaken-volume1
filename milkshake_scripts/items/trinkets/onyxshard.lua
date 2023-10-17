local onyxShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function onyxShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.ONYX_SHARD, enums.Orbs.UNDEAD, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, onyxShard.postGridEntityBroken)

function onyxShard:PostEffectRender(effect)
    if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    or effect.Variant ~= enums.Effects.EFFECT_REPLACER
    or not utility:DoesTrinketExist(enums.Trinkets.ONYX_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "onyx")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, onyxShard.PostEffectRender)
return onyxShard
