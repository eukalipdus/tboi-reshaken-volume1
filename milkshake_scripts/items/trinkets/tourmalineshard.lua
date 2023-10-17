local tourmalineShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function tourmalineShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.TOURMALINE_SHARD, enums.Orbs.ELECTRIC, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, tourmalineShard.postGridEntityBroken)

function tourmalineShard:PostEffectRender(effect)
    if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    or effect.Variant ~= enums.Effects.EFFECT_REPLACER
    or not utility:DoesTrinketExist(enums.Trinkets.TOURMALINE_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "tourmaline")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, tourmalineShard.PostEffectRender)
return tourmalineShard
