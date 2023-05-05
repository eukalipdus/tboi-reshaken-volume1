local sapphireShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function sapphireShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.SAPPHIRE_SHARD, enums.Orbs.ELECTRIC, gridEntity, 75)
end
milkshakeMod:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, sapphireShard.postGridEntityBroken)
return sapphireShard
