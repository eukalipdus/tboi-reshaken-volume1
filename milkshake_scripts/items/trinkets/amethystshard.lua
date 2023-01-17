local amethystShard = {}
local enums = require("milkshake_scripts.enums")
local utility = require("milkshake_scripts.utility")

function amethystShard:onPlayerUpdate(player)
    if not player then return end
    if player:HasTrinket(enums.Trinkets.AMETHYST_SHARD) then
        utility:shardTrinkets(enums.Trinkets.AMETHYST_SHARD, player)
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, amethystShard.onPlayerUpdate)
return amethystShard