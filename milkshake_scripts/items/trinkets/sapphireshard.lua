local sapphireShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function sapphireShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.SAPPHIRE_SHARD, enums.Orbs.WATER, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, sapphireShard.postGridEntityBroken)

return sapphireShard
