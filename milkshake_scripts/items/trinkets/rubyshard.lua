local rubyShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function rubyShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.RUBY_SHARD, enums.Orbs.FIRE, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, rubyShard.postGridEntityBroken)

return rubyShard
