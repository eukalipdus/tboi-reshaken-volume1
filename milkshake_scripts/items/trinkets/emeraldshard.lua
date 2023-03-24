local emeraldShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function emeraldShard:onPlayerUpdate(player)
    if not player then return end
    if player:HasTrinket(enums.Trinkets.EMERALD_SHARD) then
        utility:shardTrinkets(player, player:GetTrinketRNG(enums.Trinkets.EMERALD_SHARD))
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, emeraldShard.onPlayerUpdate)
return emeraldShard