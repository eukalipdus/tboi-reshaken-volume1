local emeraldShard = {}
local enums = require("milkshake_scripts.enums")
local utility = require("milkshake_scripts.utility")

function emeraldShard:onPlayerUpdate(player)
    if not player then return end
    if player:HasTrinket(enums.Trinkets.EMERALD_SHARD) then
        utility:shardTrinkets(enums.Trinkets.EMERALD_SHARD, player)
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, emeraldShard.onPlayerUpdate)
return emeraldShard