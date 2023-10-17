local shardRockOverlay = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local shardTrinkets = {
    enums.Trinkets.AMBER_SHARD,
}

function shardRockOverlay:PostNewRoom()
    for _, trinket in ipairs(shardTrinkets) do
         if utility:DoesTrinketExist(trinket) then
            TSIL.EntitySpecific.SpawnEffect(enums.Effects.EFFECT_REPLACER, 0, Vector.Zero, Vector.Zero, Isaac.GetPlayer(0), Random() + 1)
            break
         end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, shardRockOverlay.PostNewRoom)

return shardRockOverlay