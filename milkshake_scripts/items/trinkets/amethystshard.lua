local amethystShard = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

function amethystShard:postGridEntityBroken(gridEntity)
    utility:ShardTrinkets(enums.Trinkets.AMETHYST_SHARD, enums.Orbs.PSYCHIC, gridEntity, 75)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_BROKEN, amethystShard.postGridEntityBroken)

function amethystShard:PostGridEntityInit(gridEntity)
    if gridEntity:GetType() ~= GridEntityType.GRID_ROCKT then return end
    utility:RenderCrystalRockSprite(gridEntity, "amethyst")
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_INIT, amethystShard.PostGridEntityInit)
return amethystShard
