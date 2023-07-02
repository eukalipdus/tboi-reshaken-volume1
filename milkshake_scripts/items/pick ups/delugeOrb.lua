DelugeOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

DelugeOrb.Force = 50
DelugeOrb.Radius = 600
DelugeOrb.Speed = -1.9
DelugeOrb.WaterSpeed = 5
DelugeOrb.Timeout = 360

--TODO
--Custom Hush Laser?

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
		player.FireDelay = player.MaxFireDelay - 1
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DelugeOrb.onPEffectUpdate)

function DelugeOrb:onNewRoom()
	for playerNum = 0, game:GetNumPlayers()-1 do
		local player = game:GetPlayer(playerNum)
		local data = player:GetData()
		if data.DelugeOrbUsed then
			data.DelugeOrbUsed = nil
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DelugeOrb.onNewRoom)

function DelugeOrb:onWaterfallUpdate(effect)
	local effectData = effect:GetData()
	if effectData.DelugeOrb then
		effect.Target = nil
		game:UpdateStrangeAttractor(effect.Position, DelugeOrb.Force, DelugeOrb.Radius)
	 	local player = effect.Parent:ToPlayer()
		effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
		effect.CollisionDamage = player.Damage * 10
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
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER, 1, room:GetCenterPos(), Vector.Zero, player):ToEffect()
	effect:GetData().DelugeOrb = true
	effect.Parent = player:ToPlayer()
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	effect.Timeout = DelugeOrb.Timeout
	effect:SetDamageSource(EntityType.ENTITY_PLAYER)
	effect.CollisionDamage = player.Damage * 10
	player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	player:EvaluateItems()
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, DelugeOrb.OnDelugeOrbUse, enums.Orbs.WATER)
