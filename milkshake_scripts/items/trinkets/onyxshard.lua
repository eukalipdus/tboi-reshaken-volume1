local onyxShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function onyxShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.ONYX_SHARD, enums.Orbs.UNDEAD, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, onyxShard.postGridEntityBroken)

return onyxShard
