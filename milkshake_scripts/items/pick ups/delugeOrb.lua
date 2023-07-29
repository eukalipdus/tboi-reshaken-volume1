DelugeOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

DelugeOrb.Force = 52
DelugeOrb.Radius = 260
DelugeOrb.SpeedMultiplier = 1
DelugeOrb.WaterSpeed = 3
DelugeOrb.Timeout = 240
DelugeOrb.DamageTick = 2
DelugeOrb.DamageArea = 57
DelugeOrb.DamageMultiplier = 0.75
DelugeOrb.SplashTick = 8
DelugeOrb.DelayBetweenLasers = 15

--- Written by Zamiel, technique created by im_tem, tweaked
function DelugeOrb.SetBlindfold(player, enabled)
	local data = player:GetData()
	if data.eclipsed and data.eclipsed.BlindCharacter then return end -- eclipsed
	---Blindfold
    local challenge = Isaac.GetChallenge()
    if enabled then
        game.Challenge = Challenge.CHALLENGE_SOLAR_SYSTEM
        player:UpdateCanShoot()
        game.Challenge = challenge
        player:TryRemoveNullCostume(NullItemID.ID_BLINDFOLD)
    else
        game.Challenge = Challenge.CHALLENGE_NULL
        player:UpdateCanShoot()
        game.Challenge = challenge
    end
end

function DelugeOrb.ExtraUse(lasers, double)
	double = double or 1
	for _, laser in pairs(lasers) do
		laser = laser:ToEffect()
		if laser:GetData().DelugeOrb then
			laser:SetTimeout(laser.Timeout + (DelugeOrb.Timeout * double))
			laser:GetSprite():Play("Loop")
		end
	end
end

function DelugeOrb:onPEffectUpdate(player)
	local data = player:GetData()
	if data.DelugeOrbUsed then
		if #Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER_UP) == 0 and #Isaac.FindByType(EntityType.ENTITY_EFFECT, enums.Effects.DELUGE_LASER) == 0 then
			data.DelugeOrbUsed = nil
			DelugeOrb.SetBlindfold(player, false)
			player:TryRemoveNullCostume(enums.Costumes.DELUGE_ORB)
		else
			player.Velocity = player:GetMovementVector()*DelugeOrb.SpeedMultiplier
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, DelugeOrb.onPEffectUpdate)

function DelugeOrb:onWaterfallDownUpdate(effect)
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
	---flush effect
	if effectData.DelugeFlushed and effect.FrameCount == 1 then
		effectData.DelugeFlushed = nil
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
	---magnetite
	game:UpdateStrangeAttractor(effect.Position, DelugeOrb.Force, DelugeOrb.Radius)
	for _, pickup in pairs(Isaac.FindInRadius(effect.Position, DelugeOrb.Radius, EntityPartition.PICKUP)) do
		if pickup:ToPickup() then
			pickup.GridCollisionClass = GridCollisionClass.COLLISION_WALL
		end
	end
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
	effect.Velocity = (effect.Velocity + (player:GetAimDirection()):Resized(DelugeOrb.WaterSpeed)) * 0.9 --
	---water ripple
	if effect.FrameCount % DelugeOrb.SplashTick == 0 then
		local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_RIPPLE, 0, effect.Position, Vector.Zero, effect):ToEffect()
		splash.SpriteScale = Vector.One * 3
	end
	---grid damage
	local grid = game:GetRoom():GetGridEntityFromPos(effect.Position)
	if grid and (grid:ToPoop() or grid:ToTNT()) then
		grid:Hurt(10)
	end
	---npc damage
	if effect.FrameCount % DelugeOrb.DamageTick == 0 then
		local dmg = 1 + (DelugeOrb.DamageMultiplier*MilkshakeVol1.utility:GetCurrentChapter())
		for _, enemy in pairs(Isaac.FindInRadius(effect.Position, DelugeOrb.DamageArea, EntityPartition.ENEMY)) do
			if enemy:ToNPC() then
				enemy:TakeDamage(dmg, DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(player), 1)
			end
		end
	end
	---end of effect
	if effect.Timeout <= 1 then
		effect:GetSprite():Play("End")
		local splash = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_RIPPLE, 0, effect.Position, Vector.Zero, effect):ToEffect()
		splash.SpriteScale = Vector.One * 3
		for _, pickup in pairs(Isaac.FindInRadius(effect.Position, DelugeOrb.Radius, EntityPartition.PICKUP)) do
			if pickup:ToPickup() then
				pickup.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
			end
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, DelugeOrb.onWaterfallDownUpdate, enums.Effects.DELUGE_LASER)

function DelugeOrb:onWaterfallUpUpdate(effect)
	local effectData = effect:GetData()
	if not effectData.DelugeOrb then return end
	if effect.FrameCount == DelugeOrb.DelayBetweenLasers then
		local effectDown = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.DELUGE_LASER, 0, game:GetRoom():GetCenterPos(), Vector.Zero, effect.Parent):ToEffect()
		effectDown:GetData().DelugeOrb = true
		effectDown.Parent = effect.Parent:ToPlayer()
		effectDown.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		effectDown.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		effectDown:SetTimeout(DelugeOrb.Timeout)
		effectDown:SetDamageSource(EntityType.ENTITY_PLAYER)
		effectDown:GetSprite():Play("Start")
		if not game:GetRoom():HasWater() then
			effectDown:GetData().DelugeFlushed = true
			local enemies = Isaac.FindInRadius(effect.Position, 5000, EntityPartition.ENEMY)
			for _, enemy in pairs(enemies) do
				if enemy:ToNPC() and enemy:IsVulnerableEnemy() and enemy:IsActiveEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
					enemy:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
					enemy:GetData().DelugeFlushed = true
				end
			end
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, DelugeOrb.onWaterfallUpUpdate, EffectVariant.HUSH_LASER_UP)

function DelugeOrb:OnDelugeOrbUse(_, player) -- useFlag
	local data = player:GetData()
	data.DelugeOrbUsed = true
	local laserUp = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER_UP)
	local laserDown = Isaac.FindByType(EntityType.ENTITY_EFFECT, enums.Effects.DELUGE_LASER)
	if #laserDown > 0 then
		DelugeOrb.ExtraUse(laserUp, 2)
		DelugeOrb.ExtraUse(laserDown)
	else
		DelugeOrb.SetBlindfold(player, true)
		player:AddNullCostume(enums.Costumes.DELUGE_ORB)
		local effectUp = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUSH_LASER_UP, 0, player.Position, Vector.Zero, player):ToEffect()
		effectUp:GetData().DelugeOrb = true
		effectUp.Parent = player
		effectUp:FollowParent(player)
		effectUp.ParentOffset = Vector(0, -32*player.SpriteScale.Y)
		effectUp:SetTimeout(2*DelugeOrb.Timeout)
		effectUp.DepthOffset = 100
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, DelugeOrb.OnDelugeOrbUse, enums.Orbs.WATER)
