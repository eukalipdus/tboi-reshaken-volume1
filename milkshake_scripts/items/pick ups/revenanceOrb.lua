local RevenanceOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()
local sfx = SFXManager()

--RevenanceOrb.TombHP = 3
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

local function SoundParticle(pos)
	sfx:Play(SoundEffect.SOUND_STONE_IMPACT)
	game:SpawnParticles(pos, EffectVariant.TOOTH_PARTICLE, 3, 1, Color(0.5,0.5,0.5), 100000)
end

local function DamageTombstone(gravestone)
	gravestone.HitPoints = gravestone.HitPoints - 1
	gravestone:SetColor(Color(0.5,0,0),10,1, true, false)
	SoundParticle(gravestone.Position)
end

local function CollisionTombstone(gravestone, collider, checkFrame)
	local colData = collider:GetData()
	local grbData = gravestone:GetData()
	if (not grbData.GravetoneTouched or game:GetFrameCount() - grbData.GravetoneTouched > checkFrame) or (not colData.GravetoneTouched or game:GetFrameCount() - colData.GravetoneTouched > checkFrame) then
		grbData.GravetoneTouched = game:GetFrameCount()
		colData.GravetoneTouched = game:GetFrameCount()
		if collider.CollisionDamage > 0 then
			DamageTombstone(gravestone)
		end
	end
end

---gravestone update
function RevenanceOrb:GravestonUpd(gravestone)
	if gravestone.FrameCount <= 1 then
		gravestone:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
		gravestone.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		gravestone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
	--[[
	if gravestone.Variant ~= enums.ENTITY_GENERIC_PROP.GRAVESTONE then return end

	local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
	local mamaMega = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION)
	local lasers = Isaac.FindByType(EntityType.ENTITY_LASER)
	local enemytears =Isaac.FindInRadius(gravestone.Position, 25, EntityPartition.BULLET)
	gravestone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	--
	for _, laser in pairs(lasers) do
		laser = laser:ToLaser()
		local vectors = laser:GetNonOptimizedSamples()
		
		for i=0, #vectors-1 do
			local pos = vectors:Get(i)
			if pos:Distance(gravestone.Position) <= 40 and laser.CollisionDamage > 0 and ((not gravestone:GetData().GravetoneTouched or game:GetFrameCount() - gravestone:GetData().GravetoneTouched > 5) or (not laser:GetData().GravetoneTouched or game:GetFrameCount() - laser:GetData().GravetoneTouched > 5)) then
				gravestone:GetData().GravetoneTouched = game:GetFrameCount()
				laser:GetData().GravetoneTouched = game:GetFrameCount()
				DamageTombstone(gravestone)
			end
		end
	end
	
	for _, enemytear in pairs(enemytears) do
		if (not gravestone:GetData().GravetoneTouched or game:GetFrameCount() - gravestone:GetData().GravetoneTouched > 15) then
			gravestone:GetData().GravetoneTouched = game:GetFrameCount()
			DamageTombstone(gravestone)
			enemytear:Kill()
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
	SoundParticle(gravestone.Position)
	local stageCounter = MilkshakeVol1.utility:GetCurrentChapter()
	local dmag = RevenanceOrb.SkeletonDMG + stageCounter
	local skelHP = RevenanceOrb.SkeletonHP + 4*stageCounter
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
	--]]
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, RevenanceOrb.GravestonUpd, enums.Enemies.GRAVESTONE) --EntityType.ENTITY_GENERIC_PROP)

function RevenanceOrb:GravestonDMG(entity, amount, damageFlags, source, DamageCountdown) -- no way to change amount, blame someone
	--- do damage effects
	 SoundParticle(entity.Position)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RevenanceOrb.GravestonDMG, enums.Enemies.GRAVESTONE)

--- gravestone destroyed
function RevenanceOrb:GravestonDeath(gravestone)
	SoundParticle(gravestone.Position)
	local stageCounter = MilkshakeVol1.utility:GetCurrentChapter()
	local dmag = RevenanceOrb.SkeletonDMG + stageCounter
	local skelHP = RevenanceOrb.SkeletonHP + 4*stageCounter
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
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, RevenanceOrb.GravestonDeath, enums.Enemies.GRAVESTONE) --E

--[[
function RevenanceOrb:GravestonCollision(gravestone, collider)
	if gravestone.Variant ~= enums.ENTITY_GENERIC_PROP.GRAVESTONE then return end
	if collider:ToTear() then
		CollisionTombstone(gravestone, collider, 15)
	elseif collider:ToKnife() then
		CollisionTombstone(gravestone, collider, 5)
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, RevenanceOrb.GravestonCollision, EntityType.ENTITY_GENERIC_PROP)
--]]

--[[
function RevenanceOrb:OnNewRoom()
	local gravestones = Isaac.FindByType(EntityType.ENTITY_GENERIC_PROP, enums.ENTITY_GENERIC_PROP.GRAVESTONE)
	for _, gravestone in pairs(gravestones) do
		gravestone:Remove()
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, RevenanceOrb.OnNewRoom)
--]]

function RevenanceOrb:OnRevenanceOrbUse(card, player) -- useFlag
	local room = game:GetRoom()
	local rng = player:GetCardRNG(card)
	game:ShakeScreen(RevenanceOrb.Timeout)
	---get room shape and num of gravestones
	local tombNum = rng:RandomInt(2)+4
	if room:GetRoomShape() > 7 then tombNum = tombNum+2 end
	--- spawn gravestones
	for _ = 1, tombNum do
		local pos =  Isaac.GetFreeNearPosition(room:GetRandomPosition(0), 10)
		local gravestone = Isaac.Spawn(EntityType.ENTITY_GENERIC_PROP, enums.ENTITY_GENERIC_PROP.GRAVESTONE, 0, pos, Vector.Zero, player)
		gravestone:GetSprite():Play(RevenanceOrb.Anims[rng:RandomInt(#RevenanceOrb.Anims)+1])
		gravestone:GetSprite().FlipX = 0.5 > rng:RandomFloat()
		--gravestone.MaxHitPoints = RevenanceOrb.TombHP
		--gravestone.HitPoints = gravestone.MaxHitPoints
		--gravestone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
	--- fill pits
	for gridIndex = 1, room:GetGridSize() do
		local grid = room:GetGridEntity(gridIndex)
		if grid and grid:ToPit() and grid.State ~= 1 then
			grid:ToPit():MakeBridge(nil)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, grid.Position, Vector.Zero, nil) --- some effects
		end
	end
	--- charm bonies in room
	local undeads = Isaac.FindInRadius(player.Position, 5000, EntityPartition.ENEMY)
	local dmag = RevenanceOrb.SkeletonDMG + MilkshakeVol1.utility:GetCurrentChapter()
	for _, undead in pairs(undeads) do
		if RevenanceOrb.Undeads[undead.Type] then
			undead:GetData().TearDamage = dmag
			undead:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		end
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, RevenanceOrb.OnRevenanceOrbUse, enums.Orbs.UNDEAD)


function RevenanceOrb:OnBoneyMShoot(tear)
	--- mark that charmed boney shoot bone
	if tear.SpawnerEntity and RevenanceOrb.Undeads[tear.SpawnerEntity.Type] and tear.SpawnerEntity:GetData().TearDamage and not tear:GetData().BoneyMShootUPD then
		tear:GetData().BoneyMShootUPD = tear.SpawnerEntity:GetData().TearDamage
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, RevenanceOrb.OnBoneyMShoot, ProjectileVariant.PROJECTILE_BONE)

function RevenanceOrb:onEnemyTakesDMG(entity, amount, damageFlags, source, DamageCountdown) -- no way to change amount, blame someone
	--- reapply damage
	if source.Entity and source.Entity:ToProjectile() and source.Entity:GetData().BoneyMShootUPD then
		entity:TakeDamage(source.Entity:GetData().BoneyMShootUPD, damageFlags, source, DamageCountdown)
		source.Entity:GetData().BoneyMShootUPD = nil -- set to nil, so it doesn't loop
		return false
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RevenanceOrb.onEnemyTakesDMG)
