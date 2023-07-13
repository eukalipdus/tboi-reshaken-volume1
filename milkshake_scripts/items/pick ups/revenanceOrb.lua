RevenanceOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()
local sfx = SFXManager()
--
RevenanceOrb.TombHP = 3
RevenanceOrb.SkeletonHP = 1
RevenanceOrb.SkeletonDMG = 3

RevenanceOrb.Undeads = {
[EntityType.ENTITY_BONY] = true,
}

RevenanceOrb.Anims = {
"Appear0", "Appear1", "Appear2", "Appear3", "Appear4", "Appear5"
}

RevenanceOrb.TombMobs = {
{EntityType.ENTITY_BONY, 0, 0},
{EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1},
{EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 1},
}
RevenanceOrb.Timeout = 45

local function DamageTombstone(gravestone)
	gravestone.HitPoints = gravestone.HitPoints - 1
	gravestone:SetColor(Color(0.5,0,0),10,1, true, false)
	sfx:Play(SoundEffect.SOUND_STONE_IMPACT)
	game:SpawnParticles(gravestone.Position, EffectVariant.TOOTH_PARTICLE, 3, 1, Color(0.5,0.5,0.5), 100000)
end

function RevenanceOrb:GravestonUpd(gravestone)
	if gravestone.Variant ~= enums.ENTITY_GENERIC_PROP.GRAVESTONE then return end

	local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
	local mamaMega = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION)
	local lasers = Isaac.FindByType(EntityType.ENTITY_LASER)

	for _, laser in pairs(lasers) do
		if laser.Position:Distance(gravestone.Position) <= 25 and laser.CollisionDamage > 0 and (not laser:GetData().GravetoneTouched or game:GetFrameCount() - laser:GetData().GravetoneTouched > 5) then
			laser:GetData().GravetoneTouched = game:GetFrameCount()
			DamageTombstone(gravestone)
		end
	end

	if #mamaMega > 0 then
		gravestone.HitPoints = 0
	elseif #explosions > 0 then
		for _, explos in pairs(explosions) do
			if explos:GetSprite():GetFrame() < 3 and explos.Position:Distance(gravestone.Position) <= 90 * explos.SpriteScale.X then
				gravestone.HitPoints = 0
			end
		end
	end

	if gravestone.HitPoints > 0 then return end
	local level = game:GetLevel()
	local stageCounter = level:GetAbsoluteStage()
	local dmag = RevenanceOrb.SkeletonDMG + stageCounter
	local skelHP = RevenanceOrb.SkeletonHP
	for _ = 1, stageCounter do
		skelHP = skelHP +4
	end
	local rng = gravestone:GetDropRNG()
	local randMob = RevenanceOrb.TombMobs[rng:RandomInt(#RevenanceOrb.TombMobs)+1]
	local mob = Isaac.Spawn(randMob[1], randMob[2], randMob[3], gravestone.Position, Vector.Zero, gravestone.SpawnerEntity)
	if mob.Type ~= EntityType.ENTITY_EFFECT then

		mob.MaxHitPoints = skelHP
		mob:GetData().TearDamage = dmag
		mob:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
	else
		mob:ToEffect():SetTimeout(180)
	end
	gravestone:Remove()
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, RevenanceOrb.GravestonUpd, EntityType.ENTITY_GENERIC_PROP)


function RevenanceOrb:GravestonCollision(gravestone, collider)
	if gravestone.Variant ~= enums.ENTITY_GENERIC_PROP.GRAVESTONE then return end
	local damaged = false

	if (collider:ToTear() or collider:ToProjectile()) and (not collider:GetData().GravetoneTouched or game:GetFrameCount() - collider:GetData().GravetoneTouched > 15) then
		collider:GetData().GravetoneTouched = game:GetFrameCount()
		if collider.CollisionDamage > 0 then
			damaged = true
		end
	elseif collider:ToKnife() and (not collider:GetData().GravetoneTouched or game:GetFrameCount() - collider:GetData().GravetoneTouched > 5) then
		collider:GetData().GravetoneTouched = game:GetFrameCount()
		if collider.CollisionDamage > 0 then
			damaged = true
		end
	--elseif collider:ToLaser() then
	--	print('LASER TOMB COLLIDED')
	--	damaged = true
	end

	if damaged then
		DamageTombstone(gravestone)
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, RevenanceOrb.GravestonCollision, EntityType.ENTITY_GENERIC_PROP)


function RevenanceOrb:OnNewRoom()
	local gravestones = Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP, enums.ENTITY_GENERIC_PROP.GRAVESTONE)
	for _, gravestone in pairs(gravestones) do
		gravestone:Remove()
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, RevenanceOrb.OnNewRoom)

function RevenanceOrb:OnRevenanceOrbUse(card, player) -- useFlag
	local room = game:GetRoom()
	local rng = player:GetCardRNG(card)
	game:ShakeScreen(RevenanceOrb.Timeout)
	
	local tombNum = rng:RandomInt(2)+4
	if room:GetRoomShape() > 7 then tombNum = tombNum+2 end

	for _ = 1, tombNum do
		local pos =  Isaac.GetFreeNearPosition(room:GetRandomPosition(0), 10)
		local gravestone = Isaac.Spawn(EntityType.ENTITY_GENERIC_PROP, enums.ENTITY_GENERIC_PROP.GRAVESTONE, 0, pos, Vector.Zero, player)
		gravestone:GetSprite():Play(RevenanceOrb.Anims[rng:RandomInt(#RevenanceOrb.Anims)+1])
		gravestone.MaxHitPoints = RevenanceOrb.TombHP
		gravestone.HitPoints = gravestone.MaxHitPoints
		gravestone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end

	for gridIndex = 1, room:GetGridSize() do
		local grid = room:GetGridEntity(gridIndex)
		if grid and grid:ToPit() and grid.State ~= 1 then
			grid:ToPit():MakeBridge(nil)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, grid.Position, Vector.Zero, nil)
		end
	end

	local undeads = Isaac.FindInRadius(player.Position, 5000, EntityPartition.ENEMY)
	for _, undead in pairs(undeads) do
		if RevenanceOrb.Undeads[undead.Type] then
			undead.MaxHitPoints = RevenanceOrb.SkeletonHP
			undead:GetData().TearDamage = RevenanceOrb.SkeletonDMG
			undead:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		end
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, RevenanceOrb.OnRevenanceOrbUse, enums.Orbs.UNDEAD)


function RevenanceOrb:OnBoneyMShoot(tear)
	if tear.SpawnerEntity and RevenanceOrb.Undeads[tear.SpawnerEntity.Type] and tear.SpawnerEntity:GetData().TearDamage and not tear:GetData().BoneyMShootUPD then
		tear:GetData().BoneyMShootUPD = tear.SpawnerEntity:GetData().TearDamage
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, RevenanceOrb.OnBoneyMShoot, ProjectileVariant.PROJECTILE_BONE)

function RevenanceOrb:onEnemyTakesDMG(entity, _, damageFlags, source, DamageCountdown) -- no way to change amount, blame someone
	if source.Entity and source.Entity:ToProjectile() and source.Entity:GetData().BoneyMShootUPD then
		source.Entity:GetData().BoneyMShootUPD = nil
		entity:TakeDamage(RevenanceOrb.SkeletonDMG, damageFlags, source, DamageCountdown)
		return false
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RevenanceOrb.onEnemyTakesDMG)
