local shardRockOverlay = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local shardTrinkets = {
    enums.Trinkets.AMBER_SHARD,
}

function shardRockOverlay:PostGridEntityInit()
    local emptyEffects = TSIL.EntitySpecific.GetEffects(enums.Effects.EFFECT_REPLACER)
    if #emptyEffects > 1 then return end
    for _, trinket in ipairs(shardTrinkets) do
         if utility:DoesTrinketExist(trinket) then
            TSIL.EntitySpecific.SpawnEffect(enums.Effects.EFFECT_REPLACER, 0, Vector.Zero, Vector.Zero, Isaac.GetPlayer(0), Random() + 1)
            break
         end
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_INIT, shardRockOverlay.PostGridEntityInit)

return shardRockOverlay