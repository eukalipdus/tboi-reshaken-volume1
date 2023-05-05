local emeraldShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function emeraldShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.EMERALD_SHARD, enums.Orbs.NATURE, gridEntity, 75)
end
milkshakeMod:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, emeraldShard.postGridEntityBroken)
return emeraldShard
