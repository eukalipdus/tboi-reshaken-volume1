local rubyShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function rubyShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.RUBY_SHARD, enums.Orbs.FIRE, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, rubyShard.postGridEntityBroken)

function rubyShard:PostEffectRender(effect)
    if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    or Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    or effect.Variant ~= enums.Effects.EFFECT_REPLACER then return end
    if not utility:DoesTrinketExist(enums.Trinkets.RUBY_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "ruby")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, rubyShard.PostEffectRender)
return rubyShard
