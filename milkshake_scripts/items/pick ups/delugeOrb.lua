DelugeOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

DelugeOrb.Force = 10
DelugeOrb.Radius = 250
DelugeOrb.Speed = -1.9
DelugeOrb.MaxFireDelay = -1
DelugeOrb.WaterSpeed = 5
DelugeOrb.Timeout = 600

function DelugeOrb:onCache(player, cacheFlag)
	player = player:ToPlayer()
	local data = player:GetData()
	if data.DelugeOrbUsed and cacheFlag == CacheFlag.CACHE_SPEED then
		player.MoveSpeed = player.MoveSpeed + DelugeOrb.Speed
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DelugeOrb.onCache)

function DelugeOrb:onPEffectUpdate(player)
	local data = player:GetData()
	if data.DelugeOrbUsed then
		player.FireDelay = DelugeOrb.MaxFireDelay
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DelugeOrb.onPEffectUpdate)

function DelugeOrb:onWaterfallUpdate(effect)
	local effectData = effect:GetData()
	if effectData.DelugeOrb then
		game:UpdateStrangeAttractor(waterfall.Position, DelugeOrb.Force, DelugeOrb.Radius)
	 	local player = effect.Parent
		effect.Velocity = player:GetShootingInput() * player.ShotSpeed * DelugeOrb.WaterSpeed
		if effect.Timeout <= 1 then
			player:GetData().DelugeOrbUsed = nil
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, DelugeOrb.onWaterfallUpdate, EffectVariant.HUSH_LASER)


function DelugeOrb:OnDelugeOrbUse(card, player) -- useFlag
	local room = game:GetRoom()
	local data = player:GetData()
	data.DelugeOrbUsed = true
	local waterfall = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER, 0, room:GetCenterPos(), Vector.Zero, player):ToEffect()
	waterfall:GetData().DelugeOrb = true
	waterfall.Parent = player
	waterfall.Timeout = DelugeOrb.Timeout
	player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	player:EvaluateItems()
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, DelugeOrb.OnDelugeOrbUse, enums.Orbs.WATER)
