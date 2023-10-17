local diamondShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function diamondShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.DIAMOND_SHARD, enums.Orbs.HOLY, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, diamondShard.postGridEntityBroken)

function diamondShard:PostEffectRender()
    if not utility:DoesTrinketExist(enums.Trinkets.DIAMOND_SHARD) then return end
    local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
    for _, gridEntity in ipairs(tintedRocks) do
        if gridEntity.State ~= 2 then
            utility:RenderCrystalRockSprite(gridEntity, "diamond")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, diamondShard.PostEffectRender)
return diamondShard
