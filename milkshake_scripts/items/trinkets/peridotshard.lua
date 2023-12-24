local peridotShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function peridotShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.PERIDOT_SHARD, enums.Orbs.POISON, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, peridotShard.postGridEntityBroken)

return peridotShard
