local emeraldShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function emeraldShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.EMERALD_SHARD, enums.Orbs.NATURE, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, emeraldShard.postGridEntityBroken)

function emeraldShard:PostEffectRender(effect)
    if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    or effect.Variant ~= enums.Effects.EFFECT_REPLACER
    or not utility:DoesTrinketExist(enums.Trinkets.EMERALD_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "emerald")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, emeraldShard.PostEffectRender)
return emeraldShard
