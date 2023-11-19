local RevenanceOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()
local sfx = SFXManager()

RevenanceOrb.SkeletonHP = 20
RevenanceOrb.SkeletonDMG = 3
--also is there way to lower the invincibility frames the tombstones have when hit
--cuz if you have high tearrate and hit it a lot it has a lot of tears that dont damage it
RevenanceOrb.TombTakeDMGCooldown = 5
RevenanceOrb.BoneBridgeGfx = "gfx/grid/bone_bridge_better.png"


RevenanceOrb.Undeads = {
[EntityType.ENTITY_BONY] = true,
}

RevenanceOrb.Anims = {
"Appear0", "Appear1", "Appear2", "Appear3", "Appear4", "Appear5"
}

RevenanceOrb.TombMobs = {
{EntityType.ENTITY_BONY, 0, 0},
{EntityType.ENTITY_BONY, 0, 0}, -- huh?
{EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1},
{EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 1},
}
RevenanceOrb.Timeout = 45

local function SoundParticle(pos)
	sfx:Play(SoundEffect.SOUND_STONE_IMPACT)
	game:SpawnParticles(pos, EffectVariant.TOOTH_PARTICLE, 3, 1, Color(0.5,0.5,0.5), 100000)
end

---gravestone update
function RevenanceOrb:GravestonUpd(gravestone)
	if gravestone.FrameCount <= 1 then
		gravestone:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_BLOOD_SPLASH| EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		gravestone.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_BULLET and EntityGridCollisionClass.GRIDCOLL_GROUND
		gravestone.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	end
	gravestone.Velocity = Vector.Zero
	for _, enemytear in pairs(Isaac.FindInRadius(gravestone.Position, 12, EntityPartition.BULLET)) do
		gravestone:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE, EntityRef(enemytear), 1)
		enemytear:Kill()
	end
	for _, tear in pairs(Isaac.FindInRadius(gravestone.Position, 12, EntityPartition.TEAR)) do
		if tear:ToTear() then
			gravestone:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE, EntityRef(tear), 1)
		elseif tear:ToKnife() and (tear.Variant ~= 0 and tear:ToKnife():IsFlying() or tear.Variant == 0 or tear.Variant == 5) then
			gravestone:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE, EntityRef(tear), 1)
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, RevenanceOrb.GravestonUpd, enums.Enemies.GRAVESTONE) --EntityType.ENTITY_GENERIC_PROP)

function RevenanceOrb:GravestonDMG(entity, amount, damageFlags, source, DamageCountdown) -- no way to change amount, blame someone
	--- do damage effects
	local grbData = entity:GetData()
	if damageFlags & DamageFlag.DAMAGE_EXPLOSION > 0 or damageFlags & DamageFlag.DAMAGE_INVINCIBLE > 0 then
		return true
	elseif source.Entity and source.Entity:ToKnife() or damageFlags & DamageFlag.DAMAGE_LASER > 0 then
		if not grbData.GravetoneTouched or game:GetFrameCount() - grbData.GravetoneTouched > RevenanceOrb.TombTakeDMGCooldown then
			grbData.CustomDamage = false
			grbData.GravetoneTouched = game:GetFrameCount()
			entity:TakeDamage(1, damageFlags, source, DamageCountdown)
			return false
		elseif grbData.GravetoneTouched and not grbData.CustomDamage then
			grbData.CustomDamage = true
			SoundParticle(entity.Position)
			return true
		end
	end
	--return false
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RevenanceOrb.GravestonDMG, enums.Enemies.GRAVESTONE)


function RevenanceOrb:onNewRoom()
	local room = game:GetRoom()
	for gridIndex = 1, room:GetGridSize() do
		local grid = room:GetGridEntity(gridIndex)
		if grid and grid.VarData == 111 then
			grid:GetSprite():ReplaceSpritesheet(1, RevenanceOrb.BoneBridgeGfx)
			grid:GetSprite():LoadGraphics()
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, RevenanceOrb.onNewRoom)


--- gravestone destroyed
function RevenanceOrb:GravestonDeath(gravestone)
	if gravestone.Variant == 1 then return end
	SoundParticle(gravestone.Position)
	local stageCounter = MilkshakeVol1.utility:GetCurrentChapter()
	local dmag = RevenanceOrb.SkeletonDMG + stageCounter
	local skelHP = RevenanceOrb.SkeletonHP + 15*stageCounter
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

function RevenanceOrb:OnRevenanceOrbUse(card, player) -- useFlag
	local room = game:GetRoom()
	local rng = player:GetCardRNG(card)
	game:ShakeScreen(RevenanceOrb.Timeout)
	---get room shape and num of gravestones
	local tombNum = rng:RandomInt(2)+4
	if room:GetRoomShape() > 7 then tombNum = tombNum+2 end
	--- spawn gravestones
	for _ = 1, tombNum do
		--local pos =  Isaac.GetFreeNearPosition(room:GetRandomPosition(0), 10)
		local pos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(0), 0, true)
		local gravestone = Isaac.Spawn(enums.Enemies.GRAVESTONE, 0, 0, pos, Vector.Zero, player)
		gravestone:GetSprite():Play(RevenanceOrb.Anims[rng:RandomInt(#RevenanceOrb.Anims)+1])
		gravestone:GetSprite().FlipX = 0.5 > rng:RandomFloat()
	end
	--- fill pits
	for gridIndex = 1, room:GetGridSize() do
		local grid = room:GetGridEntity(gridIndex)
		if grid and grid:ToPit() and grid.State ~= 1 then
			grid:ToPit():MakeBridge(nil)
			grid:GetSprite():ReplaceSpritesheet(1, RevenanceOrb.BoneBridgeGfx)
			grid:GetSprite():LoadGraphics()
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, grid.Position, Vector.Zero, nil) --- some effects
		end
	end
	--- charm bonies in room
	local undeads = Isaac.FindInRadius(player.Position, 5000, EntityPartition.ENEMY)
	local dmag = RevenanceOrb.SkeletonDMG + MilkshakeVol1.utility:GetCurrentChapter()
	for _, undead in pairs(undeads) do
		if RevenanceOrb.Undeads[undead.Type] then
			undead:GetData().TearDamage = dmag
			undead:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM )
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
		local dmg = source.Entity:GetData().BoneyMShootUPD
		source.Entity:GetData().BoneyMShootUPD = nil
		entity:TakeDamage(dmg, damageFlags, source, DamageCountdown)
		 -- set to nil, so it doesn't loop
		return false
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RevenanceOrb.onEnemyTakesDMG)

function RevenanceOrb:onExit(isContinue)
	local undeads = Isaac.FindInRadius(game:GetRoom():GetCenterPos(), 5000, EntityPartition.ENEMY)
	for _, undead in pairs(undeads) do
		if RevenanceOrb.Undeads[undead.Type] and undead:GetData().TearDamage then
			undead:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM ) -- peak of modding! I guess game combines persistent and friendly flags?
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, RevenanceOrb.onExit)