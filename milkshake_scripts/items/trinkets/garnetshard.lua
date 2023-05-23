local garnetShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function garnetShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.GARNET_SHARD, enums.Orbs.UNHOLY, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, garnetShard.postGridEntityBroken)
return garnetShard
