local amethystShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function amethystShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.AMETHYST_SHARD, enums.Orbs.PSYCHIC, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, amethystShard.postGridEntityBroken)

function amethystShard:PostEffectRender(effect)
    if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
    or effect.Variant ~= enums.Effects.EFFECT_REPLACER
    or not utility:DoesTrinketExist(enums.Trinkets.AMETHYST_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "amethyst")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, amethystShard.PostEffectRender)
return amethystShard
