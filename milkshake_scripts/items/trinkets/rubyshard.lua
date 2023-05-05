local rubyShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function rubyShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.RUBY_SHARD, enums.Orbs.FIRE, gridEntity, 75)
end
milkshakeMod:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, rubyShard.postGridEntityBroken)
return rubyShard
