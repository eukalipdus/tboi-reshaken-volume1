DelugeOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

DelugeOrb.Force = 52
DelugeOrb.Radius = 260
DelugeOrb.SpeedMultiplier = 1
DelugeOrb.WaterSpeed = 6.8
DelugeOrb.Timeout = 240
DelugeOrb.DamageTick = 2
DelugeOrb.DamageArea = 57
DelugeOrb.DamageMultiplier = 0.75
DelugeOrb.SplashTick = 8

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
	--print(player:GetName(), enabled)
end

function DelugeOrb:onPEffectUpdate(player)
	local data = player:GetData()
	if data.DelugeOrbUsed then
		if game:GetFrameCount() - data.DelugeOrbUsed > DelugeOrb.Timeout then
			data.DelugeOrbUsed = nil
			DelugeOrb.SetBlindfold(player, false)
			player:TryRemoveNullCostume(enums.Costumes.DELUGE_ORB)
		else
			player.Velocity = player:GetMovementVector()*DelugeOrb.SpeedMultiplier
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
	effect.Velocity = player:GetShootingInput() * player.ShotSpeed
	effect.Position = effect.Position + effect.Velocity:Resized(DelugeOrb.WaterSpeed)
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
	DelugeOrb.SetBlindfold(player, true)
	effect:SetDamageSource(EntityType.ENTITY_PLAYER)
	player:AddNullCostume(enums.Costumes.DELUGE_ORB)
	effect:GetSprite():Play("Start")
	if not room:HasWater() then
		effect:GetData().DelugeFlushed = true
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
