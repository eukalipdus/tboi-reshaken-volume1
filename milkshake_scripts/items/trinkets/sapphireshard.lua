local sapphireShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function sapphireShard:postGridEntityBroken(gridEntity)
    utility:shardTrinkets(enums.Trinkets.SAPPHIRE_SHARD, enums.Cards.SAPPHIRE_ORB, gridEntity, 75)
end
milkshakeMod:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, sapphireShard.postGridEntityBroken)
return sapphireShard