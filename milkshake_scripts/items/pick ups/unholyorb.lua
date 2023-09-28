local UnholyOrb = {}

local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

UnholyOrb.KillBill = {
	[4] = true,
	[5] = true,
	[6] = true,
	[7] = true,
	[9] = true,
	[13] = true,
	[15] = true,
	[18] = true,
}

--[[
If Epiphany then
local Converter = Isaac.GetEntityTypeByName('Converter Beggar)
UnholyOrb.KillBill[Converter.Variant] = true
end
--]]

--[[
if FF then
local Hug = Isaac.GetEntityTypeByName('Hug Beggar)
UnholyOrb.KillBill[Hug.Variant] = true
local Evil = Isaac.GetEntityTypeByName('Evil Beggar)
UnholyOrb.KillBill[Evil.Variant] = true
local Zodiacc = Isaac.GetEntityTypeByName('Zodiacc Beggar)
UnholyOrb.KillBill[Zodiacc.Variant] = true
local Cell = Isaac.GetEntityTypeByName('Cell Game)
UnholyOrb.KillBill[Cell.Variant] = true
local Fake = Isaac.GetEntityTypeByName('Fake Beggar)
UnholyOrb.KillBill[Fake.Variant] = true
end
--]]

UnholyOrb.DamageMultiplier = 5
UnholyOrb.InvincibleFrames = 90 -- 1.5 sec
UnholyOrb.MaxSpeed = 30
UnholyOrb.MinSpeed = 7
UnholyOrb.MinDistance = 15
UnholyOrb.MaxDistance = 60
UnholyOrb.DarkArtsStack = 60

local function BeggarRewards(collider)
	local rng = collider:GetDropRNG()
	if collider.Variant == 4 then -- beggar
		for _ = 0, rng:RandomInt(3) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, collider.Position, RandomVector()*3, nil)
		end
	elseif collider.Variant == 5 then -- devil
		if rng:RandomFloat() < 0.5 then
			local card = Game():GetItemPool():GetCard(collider.InitSeed, true, false, false)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, collider.Position, RandomVector()*3, nil)
		else
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, collider.Position, RandomVector()*3, nil)
		end
	elseif collider.Variant == 6 then -- shell
		for _ = 0, rng:RandomInt(2)+2 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, collider.Position, RandomVector()*3, nil)
		end
	elseif collider.Variant == 7 then -- key
		for _ = 0, rng:RandomInt(2) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, collider.Position, RandomVector()*3, nil)
		end
	elseif collider.Variant == 9 then -- bomb
		for _ = 0, rng:RandomInt(2)+2 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, collider.Position, RandomVector()*3, nil)
		end
	elseif collider.Variant == 13 then -- battery
		for _ = 0, rng:RandomInt(2) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0, collider.Position, RandomVector()*3, nil)
		end
	elseif collider.Variant == 15 then -- hell
		if rng:RandomFloat() < 0.5 then
			for _ = 0, 1 do
				local card = Game():GetItemPool():GetCard(collider.InitSeed, true, false, false)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, collider.Position, RandomVector()*3, nil)
			end
		else
			for _ = 0, 1 do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, collider.Position, RandomVector()*3, nil)
			end
		end
	elseif collider.Variant == 18 then -- rotten
		for _ = 0, rng:RandomInt(2) do
			local randHeart = rng:RandomInt(2)+11 -- bone or rotten
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, randHeart, collider.Position, RandomVector()*3, nil)
		end
	end
end

local function GetTargets()
	--- get near enemy's position, else return basePos position
	local positionsTable = {}
	for _, enemy in pairs(Isaac.FindInRadius(Game():GetRoom():GetCenterPos(), 5000, EntityPartition.ENEMY)) do
		if enemy:ToNPC() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and (enemy.Type == EntityType.ENTITY_SHOPKEEPER or (enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy())) then
			table.insert(positionsTable, enemy)
        end
	end
	for _, slot in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT)) do
		if UnholyOrb.KillBill[slot.Variant] then
			table.insert(positionsTable, slot)
		end
	end
	positionsTable = utility:Shuffle(positionsTable, Game():GetSeeds():GetStartSeed()) -- shuffle table
	return positionsTable
end

local function Massacre()
	SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL, 2)
	Game():ShakeScreen(10)
	for _, enemy in pairs(Isaac.FindInRadius(Game():GetRoom():GetCenterPos(), 5000, EntityPartition.ENEMY)) do
		if enemy:ToNPC() and enemy:GetData().UnholyOrbFlag then
			local damage = UnholyOrb.DamageMultiplier + utility:GetCurrentChapter()
			enemy:TakeDamage(damage, DamageFlag.DAMAGE_CRUSH, EntityRef(enemy), 1)
			enemy:AddEntityFlags(EntityFlag.FLAG_BRIMSTONE_MARKED | EntityFlag.FLAG_BLEED_OUT | EntityFlag.FLAG_EXTRA_GORE)
			if enemy.Type == EntityType.ENTITY_SHOPKEEPER then
				enemy:Kill()
				for _ = 1, 2 do
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, enemy.Position, RandomVector()*3, nil)
				end
				enemy:GetData().UnholyOrbFlag = nil
			end
			if not enemy:HasMortalDamage() then
				enemy:GetData().UnholyOrbFlag = nil
			end
        end
	end
	for _, slot in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT)) do
		if UnholyOrb.KillBill[slot.Variant] and slot:GetData().UnholyOrbFlag then
			slot:Kill()
			slot:Remove()
			BeggarRewards(slot)
			slot:GetData().UnholyOrbFlag = nil
		end
	end
end

function UnholyOrb:onPEffectUpdate(player)

	if not utility:GetData(player, "UnholyTargetPositions") then return end
	player:SetColor(Color(0,0,0,0.5, 0.7), 12, 1, true, true)
	player.Velocity = player.Velocity * 0.77
	player:SetMinDamageCooldown(2)
	player:AddControlsCooldown(2) -- ? idk if it would work -- it works
	player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE --EntityGridCollisionClass.GRIDCOLL_WALLS
	player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	local TargetPositions = utility:GetData(player, "UnholyTargetPositions")
	local playerStartPos = utility:GetData(player, "UnholyPlayerPosition")
	Game():SpawnParticles(player.Position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 3, 1, Color(0,0,0,1, 0.7))
	if Game():GetRoom():GetFrameCount() == 1 then
		utility:SetData(player, "UnholyTargetPositions", nil)
		utility:SetData(player, "UnholyPlayerPosition", nil)
		player.GridCollisionClass = utility:GetData(player, "UnholyPlayerGridCollision")
		player.EntityCollisionClass = utility:GetData(player, "UnholyPlayerEntityCollision")
	elseif #TargetPositions <= 0 then
		if player.Position:Distance(playerStartPos) < UnholyOrb.MinDistance then
			--[[
			if player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS) then
				player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS, UnholyOrb.DarkArtsStack)
			end
			--]]
			--player.Position = utility:GetData(player, "UnholyPlayerPosition")
			player:SetMinDamageCooldown(UnholyOrb.InvincibleFrames)
			utility:SetData(player, "UnholyPlayerPosition", nil)
			utility:SetData(player, "UnholyTargetPositions", nil)
			player.GridCollisionClass = utility:GetData(player, "UnholyPlayerGridCollision")
			player.EntityCollisionClass = utility:GetData(player, "UnholyPlayerEntityCollision")
			player.Velocity = Vector.Zero
			Massacre()
			player:BloodExplode()
		elseif player.Position:Distance(playerStartPos) < UnholyOrb.MaxDistance then
			player.Velocity = (playerStartPos - player.Position):Resized(UnholyOrb.MinSpeed)
		else
			player.Velocity = (playerStartPos - player.Position):Resized(UnholyOrb.MaxSpeed)
		end
	elseif #TargetPositions > 0 then
		--[[
		if not player:GetEffects():GetCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS) then
			player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS, true, 1)
		end
		--]]
		if player.Position:Distance(TargetPositions[1].Position) < UnholyOrb.MinDistance then

			local enemy = TargetPositions[1]
			enemy:GetData().UnholyOrbFlag = player

			player.Velocity = Vector.Zero
			table.remove(TargetPositions, 1)
			utility:SetData(player, "UnholyTargetPositions", TargetPositions)
		elseif player.Position:Distance(TargetPositions[1].Position) < UnholyOrb.MaxDistance then
			player.Velocity = (TargetPositions[1].Position - player.Position):Resized(UnholyOrb.MinSpeed)
		else
			player.Velocity = (TargetPositions[1].Position - player.Position):Resized(UnholyOrb.MaxSpeed)
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, UnholyOrb.onPEffectUpdate)

function UnholyOrb:enemyUpd(enemy)
	if not enemy:GetData().UnholyOrbFlag then return end
	if enemy:HasMortalDamage() then
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, enemy.Position, Vector.Zero, nil):ToTear()
		tear.CollisionDamage = UnholyOrb.DamageMultiplier + utility:GetCurrentChapter()
		tear:AddTearFlags(TearFlags.TEAR_BURSTSPLIT)
		tear.Scale = 1.5
		tear.FallingAcceleration = 10
		tear.FallingSpeed = 10
		--local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, enemy.Position, Vector.Zero, nil):ToEffect()
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, UnholyOrb.enemyUpd)

function UnholyOrb:OnUnholyOrbUse(_, player)
    local TargetPositions = GetTargets() -- table of npc and slot position
	if #TargetPositions > 0 then

		utility:SetData(player, "UnholyPlayerGridCollision", player.GridCollisionClass)
		utility:SetData(player, "UnholyPlayerEntityCollision", player.EntityCollisionClass)
		utility:SetData(player, "UnholyTargetPositions", TargetPositions)
		utility:SetData(player, "UnholyPlayerPosition", player.Position)
		--player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS, true, UnholyOrb.DarkArtsStack)
		local pentagram = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HERETIC_PENTAGRAM, 0, Game():GetRoom():GetCenterPos(), Vector.Zero, player):ToEffect()
		pentagram:GetData().UnholyOrbFlag = true
		--pentagram.CollisionDamage = 0
		pentagram.Color = Color(1,0.1,0.1)
		pentagram:SetTimeout(10)
	else
		player:UseActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS)
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, UnholyOrb.OnUnholyOrbUse, enums.Orbs.UNHOLY)

function UnholyOrb:PentaUpdate(effect)
	if effect:GetData().UnholyOrbFlag then
		effect:SetTimeout(10)
		if not utility:GetData(effect.SpawnerEntity, "UnholyPlayerPosition") then
			effect:SetTimeout(0)
			effect:GetData().UnholyOrbFlag = nil
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, UnholyOrb.PentaUpdate, EffectVariant.HERETIC_PENTAGRAM)