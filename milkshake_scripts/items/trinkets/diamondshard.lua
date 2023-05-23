local diamondShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function diamondShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.DIAMOND_SHARD, enums.Orbs.SALVATION, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, diamondShard.postGridEntityBroken)
return diamondShard
