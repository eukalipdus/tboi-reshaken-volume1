local amberShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function amberShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.AMBER_SHARD, enums.Orbs.ROCK, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, amberShard.postGridEntityBroken)

return amberShard
