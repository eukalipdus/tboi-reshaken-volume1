local sapphireShard = {}
local enums = require("milkshake_scripts.enums")
local utility = require("milkshake_scripts.utility")

function sapphireShard:onPlayerUpdate(player)
    if not player then return end
    if player:HasTrinket(enums.Trinkets.SAPPHIRE_SHARD) then
        utility:shardTrinkets(enums.Trinkets.SAPPHIRE_SHARD, player)
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, sapphireShard.onPlayerUpdate)
return sapphireShard