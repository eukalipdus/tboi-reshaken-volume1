local emeraldShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function emeraldShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.EMERALD_SHARD, enums.Orbs.NATURE, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, emeraldShard.postGridEntityBroken)

return emeraldShard
