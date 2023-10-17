local sapphireShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function sapphireShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.SAPPHIRE_SHARD, enums.Orbs.WATER, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, sapphireShard.postGridEntityBroken)

function sapphireShard:PostEffectRender(effect)
    if effect.Variant ~= enums.Effects.EFFECT_REPLACER then return end
    if not utility:DoesTrinketExist(enums.Trinkets.SAPPHIRE_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "sapphire")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, sapphireShard.PostEffectRender)
return sapphireShard
