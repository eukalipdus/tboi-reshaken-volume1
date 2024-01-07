-- placeholder item

local ironKnight = {}
local enums = MilkshakeVol1.enums

ironKnight.Speed = 1.5

function ironKnight:EvaluateStats(player, cacheFlag)
	if not player:HasCollectible(enums.Collectibles.IRON_KNIGHT) then return end
	if cacheFlag == CacheFlag.CACHE_SPEED and player.MoveSpeed < ironKnight.Speed then
		player.MoveSpeed = ironKnight.Speed
	end
	if cacheFlag == CacheFlag.CACHE_FLYING then
		player.CanFly = true
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ironKnight.EvaluateStats)

function ironKnight:UseItem(_, _, player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_MIMIC)
	return false
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, ironKnight.UseItem, enums.Collectibles.IRON_KNIGHT)

