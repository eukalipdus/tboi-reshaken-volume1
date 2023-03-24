local sapphireShard = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

function sapphireShard:onPlayerUpdate(player)
    if not player then return end
    if player:HasTrinket(enums.Trinkets.SAPPHIRE_SHARD) then
        utility:shardTrinkets(player, player:GetTrinketRNG(enums.Trinkets.SAPPHIRE_SHARD))
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, sapphireShard.onPlayerUpdate)
return sapphireShard