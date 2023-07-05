RevenanceOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

RevenanceOrb.SkeletonHP = 1
RevenanceOrb.SkeletonDMG = 1

RevenanceOrb.Undeads = {
[EntityType.ENTITY_BONY] = true,
}

RevenanceOrb.TombMobs = {
{EntityType.ENTITY_BONY, 0, 0},
{EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1},
{EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 1},
}
RevenanceOrb.Timeout = 45

--TODO
--TombEffect stones

function RevenanceOrb:OnRevenanceOrbUse(card, player) -- useFlag
	local room = game:GetRoom()
	local rng = player:GetCardRNG(card)
	game:ShakeScreen(RevenanceOrb.Timeout)
	local bony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, player.Position, Vector.Zero, nil):ToNPC()

	bony.MaxHitPoints = RevenanceOrb.SkeletonHP
	bony:GetData().TearDamage = RevenanceOrb.SkeletonDMG
	bony:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
	print(bony:GetData().TearDamage)

	local tombNum = rng:RandomInt(2)+4
	if room:GetRoomShape() > 7 then tombNum = tombNum+2 end

	for _ = 1, tombNum do
		local randMob = RevenanceOrb.TombMobs[rng:RandomInt(#RevenanceOrb.TombMobs)+1]
		local mob = Isaac.Spawn(randMob[1], randMob[2], randMob[3], room:GetRandomPosition(1), Vector.Zero, player)
		if mob.Type ~= EntityType.ENTITY_EFFECT then
			mob.MaxHitPoints = RevenanceOrb.SkeletonHP
			mob:GetData().TearDamage = RevenanceOrb.SkeletonDMG
			mob:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
			print(mob:GetData().TearDamage)
		else
			mob:ToEffect():SetTimeout(180)
		end
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
			--print(undead:GetData().TearDamage)
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
	if source.Entity:ToProjectile() and source.Entity:GetData().BoneyMShootUPD then
		source.Entity:GetData().BoneyMShootUPD = nil
		entity:TakeDamage(RevenanceOrb.SkeletonDMG, damageFlags, source, DamageCountdown)
		return false
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RevenanceOrb.onEnemyTakesDMG)