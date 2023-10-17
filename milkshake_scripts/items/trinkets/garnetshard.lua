local garnetShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function garnetShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.GARNET_SHARD, enums.Orbs.UNHOLY, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, garnetShard.postGridEntityBroken)

function garnetShard:PostEffectRender(effect)
    if effect.Variant ~= enums.Effects.EFFECT_REPLACER then return end
    if not utility:DoesTrinketExist(enums.Trinkets.GARNET_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "garnet")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, garnetShard.PostEffectRender)
return garnetShard
