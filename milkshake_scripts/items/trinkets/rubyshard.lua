local rubyShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function rubyShard:onPlayerUpdate(player)
    if not player then return end
    if player:HasTrinket(enums.Trinkets.RUBY_SHARD) then
        utility:shardTrinkets(enums.Trinkets.RUBY_SHARD, player)
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, rubyShard.onPlayerUpdate)
return rubyShard