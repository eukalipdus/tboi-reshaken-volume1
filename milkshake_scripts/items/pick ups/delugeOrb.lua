DelugeOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

DelugeOrb.Force = 50
DelugeOrb.Radius = 600
DelugeOrb.Speed = -1.9
DelugeOrb.WaterSpeed = 5
DelugeOrb.Timeout = 360
DelugeOrb.DamageTick = 5
DelugeOrb.DamageArea = 40
DelugeOrb.DamageMultiplier = 5

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
		if game:GetFrameCount() - data.DelugeOrbUsed > DelugeOrb.Timeout then
			player:AddCacheFlags(CacheFlag.CACHE_SPEED)
			player:EvaluateItems()
			player:TryRemoveNullCostume(enums.Costumes.DELUGE_ORB)
			data.DelugeOrbUsed = nil
		else
			player.FireDelay = player.MaxFireDelay - 1
		end
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
			player:TryRemoveNullCostume(enums.Costumes.DELUGE_ORB)
			
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DelugeOrb.onNewRoom)

function DelugeOrb:onWaterfallUpdate(effect)
	local effectData = effect:GetData()
	if not effectData.DelugeOrb then return end
	if effect:GetSprite():IsFinished("End") then
		effect:Remove()
	end
	if effect:GetSprite():IsPlaying("End") then return end
	if effect:GetSprite():IsFinished("Start") then
		effect:GetSprite():Play("Loop")
	end
	local player = effect.Parent:ToPlayer()
	if effect.FrameCount == 1 then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_FLUSH, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_MIMIC)
		SFXManager():Stop(SoundEffect.SOUND_FLUSH)
		local enemies = Isaac.FindInRadius(player.Position, 5000, EntityPartition.ENEMY)
		for _, enemy in pairs(enemies) do
			if enemy:GetData().DelugeFlushed then
				enemy:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY)
				enemy:GetData().DelugeFlushed = nil
			end
		end
	end
	game:UpdateStrangeAttractor(effect.Position, DelugeOrb.Force, DelugeOrb.Radius)
	for _, pickup in pairs(Isaac.FindInRadius(effect.Position, DelugeOrb.Radius, EntityPartition.PICKUP)) do
		if pickup:ToPickup() then
			pickup.GridCollisionClass = GridCollisionClass.COLLISION_WALL
		end
	end
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	effect.Velocity = player:GetShootingInput() * player.ShotSpeed
	effect.Position = effect.Position + effect.Velocity:Resized(DelugeOrb.WaterSpeed) 
	if effect.FrameCount % DelugeOrb.DamageTick == 0 then
		for _, enemy in pairs(Isaac.FindInRadius(effect.Position, DelugeOrb.DamageArea, EntityPartition.ENEMY)) do
			if enemy:ToNPC() then
				enemy:TakeDamage(player.Damage * DelugeOrb.DamageMultiplier, DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 1)
			end
		end
	end
	if effect.Timeout <= 1 then
		effect:GetSprite():Play("End")
		for _, pickup in pairs(Isaac.FindInRadius(effect.Position, DelugeOrb.Radius, EntityPartition.PICKUP)) do
			if pickup:ToPickup() then
				pickup.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
			end
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, DelugeOrb.onWaterfallUpdate, enums.Effects.DELUGE_LASER)


function DelugeOrb:OnDelugeOrbUse(card, player) -- useFlag
	local room = game:GetRoom()
	local data = player:GetData()
	data.DelugeOrbUsed = game:GetFrameCount()
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.DELUGE_LASER, 0, room:GetCenterPos(), Vector.Zero, player):ToEffect()
	effect:GetData().DelugeOrb = true
	effect.Parent = player:ToPlayer()
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	effect.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	effect.Timeout = DelugeOrb.Timeout
	effect:SetDamageSource(EntityType.ENTITY_PLAYER)
	player:AddCacheFlags(CacheFlag.CACHE_SPEED)
	player:EvaluateItems()
	player:AddNullCostume(enums.Costumes.DELUGE_ORB)
	effect:GetSprite():Play("Start")
	if not room:HasWater() then
		local enemies = Isaac.FindInRadius(player.Position, 5000, EntityPartition.ENEMY)
		for _, enemy in pairs(enemies) do
			if enemy:ToNPC() and enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
				enemy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
				enemy:GetData().DelugeFlushed = true
			end
		end
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, DelugeOrb.OnDelugeOrbUse, enums.Orbs.WATER)
