local amethystShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function amethystShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.AMETHYST_SHARD, enums.Cards.AMETHYST_ORB, gridEntity, 75)
end
milkshakeMod:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, amethystShard.postGridEntityBroken)
return amethystShard
