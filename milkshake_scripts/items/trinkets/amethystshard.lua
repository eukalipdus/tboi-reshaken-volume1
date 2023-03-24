local amethystShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function amethystShard:onPlayerUpdate(player)
    if not player then return end
    if player:HasTrinket(enums.Trinkets.AMETHYST_SHARD) then
        utility:shardTrinkets(player, player:GetTrinketRNG(enums.Trinkets.AMETHYST_SHARD))
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, amethystShard.onPlayerUpdate)
return amethystShard