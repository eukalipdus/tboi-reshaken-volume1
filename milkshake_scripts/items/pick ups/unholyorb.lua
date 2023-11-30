local UnholyOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

UnholyOrb.KillBill = {}

UnholyOrb.DamageMultiplier = 5
UnholyOrb.InvincibleFrames = 90 -- 1.5 sec
UnholyOrb.MaxSpeed = 30
UnholyOrb.MinSpeed = 7
UnholyOrb.MinDistance = 15
UnholyOrb.MaxDistance = 60
UnholyOrb.DarkArtsStack = 60
UnholyOrb.MaxHitPoints = 5

function MilkshakeVol1.API:AddUnholyOrbBeggar(beggarType, datatable)
	UnholyOrb.KillBill[beggarType] = datatable
	--[[
	datatable = {
		-- Count - how many rewards
		-- MinCount - minimal reward --
		Config = {Count = 1, MinCount = 0, CardRune = nil, IncludeRune = nil, OnlyRune = nil, PlayingCard = nil},
		{Type = EntityType , Variant = EntityVariant, SubType = EntitySubType},
		...
		{Type = EntityType , Variant = EntityVariant, SubType = EntitySubType},
	}
	--]]
end

local BeggarTables = {
	[4] = {
		Config = {Count = 3, MinCount = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = 0, SubType = 0},
	},
	[5] = {
		Config = {Count = 3, MinCount = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_BLACK},
	},
	[6] = {
		Config = {Count = 2, MinCount = 2}, --in range(2,4) // range(MinCount, Count)
		{Type = EntityType.ENTITY_PICKUP, Variant = 0, SubType = 0},
	},
	[7] = {
		Config = {Count = 2, MinCount = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_KEY, SubType = 0},
	},
	[9] = {
		Config = {Count = 2, MinCount = 2},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_BOMB, SubType = 0},
	},
	[13] = {
		Config = {Count = 2, MinCount = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_LIL_BATTERY, SubType = 0},
	},
	[15] = {
		Config = {Count = 2, MinCount = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_BLACK},
	},
	[18] = {
		Config = {Count = 2, MinCount = 0},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_BONE},
		{Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_ROTTEN},
	},
}
for key, datatable in pairs(BeggarTables) do
	MilkshakeVol1.API:AddUnholyOrbBeggar(key, datatable)
end

local function BeggarRewards(collider)
	local rng = collider:GetDropRNG()
	local data = UnholyOrb.KillBill[collider.Variant]
	local rewardsNum = data.Config.Count
	local rewardsMin = data.Config.MinCount
	local reward = 1 -- #data
	for _ = 0, rng:RandomInt(rewardsNum) + rewardsMin do
		reward = rng:RandomInt(#data)+1
		local rewardItem = data[reward]
		local rewardType = rewardItem.Type
		local rewardVariant = rewardItem.Variant
		local rewardSubype = rewardItem.SubType
		if rewardVariant == PickupVariant.PICKUP_TAROTCARD and (data.Config.CardRune or data.Config.OnlyRune) then
			--:GetCard(Seed, Playing, Rune, OnlyRunes)
			rewardSubype = Game():GetItemPool():GetCard(rng:GetSeed(), data.Config.Playing, data.Config.IncludeRune, data.Config.OnlyRune)
		end
		Isaac.Spawn(rewardType, rewardVariant, rewardSubype, collider.Position, RandomVector()*3, nil)
	end
end


--[[
local function BeggarRewards(collider)
	local rng = collider:GetDropRNG()
	if collider.Variant == 4 then -- beggar
		for _ = 0, rng:RandomInt(3) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, collider.Position, RandomVector()*3, nil)
		end
		return
	elseif collider.Variant == 5 then -- devil
		if rng:RandomFloat() < 0.5 then
			local card = Game():GetItemPool():GetCard(collider.InitSeed, true, false, false)
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, collider.Position, RandomVector()*3, nil)
		else
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, collider.Position, RandomVector()*3, nil)
		end
		return
	elseif collider.Variant == 6 then -- shell
		for _ = 0, rng:RandomInt(2)+2 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, collider.Position, RandomVector()*3, nil)
		end
		return
	elseif collider.Variant == 7 then -- key
		for _ = 0, rng:RandomInt(2) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, collider.Position, RandomVector()*3, nil)
		end
		return
	elseif collider.Variant == 9 then -- bomb
		for _ = 0, rng:RandomInt(2)+2 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, collider.Position, RandomVector()*3, nil)
		end
		return
	elseif collider.Variant == 13 then -- battery
		for _ = 0, rng:RandomInt(2) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, 0, collider.Position, RandomVector()*3, nil)
		end
		return
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
		return
	elseif collider.Variant == 18 then -- rotten
		for _ = 0, rng:RandomInt(2) do
			local randHeart = rng:RandomInt(2)+11 -- bone or rotten
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, randHeart, collider.Position, RandomVector()*3, nil)
		end
		return
	end
	if UnholyOrb.FiendFolio then
		if collider.Variant == FiendFolio.FF.HugBeggar.Var then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, collider.Position, RandomVector()*3, nil)
			return
		elseif collider.Variant == FiendFolio.FF.EvilBeggar.Var then
			for _ = 0, rng:RandomInt(2)+1 do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, collider.Position, RandomVector()*3, nil)
			end
			--idk where is half black and immortal harts
			return
		elseif collider.Variant == FiendFolio.FF.ZodiacBeggar.Var then
			for _ = 0, rng:RandomInt(2) do
				local rune = Game():GetItemPool():GetCard(rng:GetSeed(), false, false, true)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, collider.Position, RandomVector()*3, nil)
			end
			return
		elseif collider.Variant == FiendFolio.FF.CellGame.Var then
			for _ = 0, rng:RandomInt(2)+2 do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, collider.Position, RandomVector()*3, nil)
			end
			return
		elseif collider.Variant == FiendFolio.FF.FakeBeggar.Var then
			Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, collider.Position, RandomVector()*3, nil)
			return
		end
	end
	if UnholyOrb.Epiphany then
		if collider.Variant == UnholyOrb.Epiphany.ConvertBegga then
			for _ = 0, rng:RandomInt(2)+1 do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, collider.Position, RandomVector()*3, nil)
			end
			return
		end
	end
	if UnholyOrb.Eclipsed then
		if collider.Variant == EclipsedMod.enums.Slots.MongoBeggar then
			for _ = 0, rng:RandomInt(2)+2 do
				Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC, 0, collider.Position, RandomVector()*5, nil)
			end
			return
		elseif collider.Variant == EclipsedMod.enums.Slots.DeliriumBeggar then
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, UnholyOrb.Eclipsed.DeliVariants[collider:GetDropRNG():RandomInt(#UnholyOrb.Eclipsed.DeliVariants)+1], collider.Position, RandomVector()*5, nil)
			return
		end
	end
end
--]]


local function GetTargets(player)
	local positionsTable = {}
	for _, enemy in pairs(Isaac.FindInRadius(Game():GetRoom():GetCenterPos(), 5000, EntityPartition.ENEMY)) do
		if enemy:ToNPC() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and (enemy.Type == EntityType.ENTITY_SHOPKEEPER or (enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy())) then
			table.insert(positionsTable, {entity=enemy, distance=enemy.Position:Distance(player.Position)})
			enemy:AddEntityFlags(EntityFlag.FLAG_FREEZE)
			enemy:GetData().UnholyFreeze = true
        end
	end
	for _, slot in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT)) do
		if UnholyOrb.KillBill[slot.Variant] then
			table.insert(positionsTable, {entity=slot, distance=slot.Position:Distance(player.Position)})
			--table.insert(positionsTable, slot)
		end
	end
	--positionsTable = utility:Shuffle(positionsTable, Game():GetSeeds():GetStartSeed()) -- shuffle table
	table.sort(positionsTable, function(a, b) return a.distance < b.distance end)

	local sortedEntities = {}
	for _, data in ipairs(positionsTable) do
		table.insert(sortedEntities, data.entity)
	end
	return sortedEntities
end

--[[
local function Massacre()
	SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL, 2)
	Game():ShakeScreen(10)
	for _, enemy in pairs(Isaac.FindInRadius(Game():GetRoom():GetCenterPos(), 5000, EntityPartition.ENEMY)) do
		if enemy:ToNPC() and enemy:GetData().UnholyOrbFlag then
			local damage = UnholyOrb.DamageMultiplier + UnholyOrb.DamageMultiplier*utility:GetCurrentChapter()
			enemy:TakeDamage(damage, DamageFlag.DAMAGE_CRUSH, EntityRef(enemy), 1)
			enemy:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT | EntityFlag.FLAG_EXTRA_GORE)
			if enemy.Type == EntityType.ENTITY_SHOPKEEPER then
				enemy:Kill()
				for _ = 1, 2 do
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, enemy.Position, RandomVector()*3, nil)
				end
				enemy:GetData().UnholyOrbFlag = nil
			end
			enemy:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
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
--]]

function UnholyOrb:onPEffectUpdate(player)
	if not utility:GetData(player, "UnholyTargetPositions") then return end
	player:SetColor(Color(0,0,0,0.5, 0.7), 12, 1, true, true)
	player.Velocity = player.Velocity * 0.77
	player:SetMinDamageCooldown(2)
	if player.ControlsEnabled then player.ControlsEnabled = false end
	player:AddControlsCooldown(2) -- ? idk if it would work -- it works (Paralysis)
	player.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE --EntityGridCollisionClass.GRIDCOLL_WALLS
	player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	local TargetPositions = utility:GetData(player, "UnholyTargetPositions")
	local playerStartPos = utility:GetData(player, "UnholyPlayerPosition")
	Game():SpawnParticles(player.Position, EffectVariant.HAEMO_TRAIL, 3, 1)
	if Game():GetRoom():GetFrameCount() == 1 then
		utility:SetData(player, "UnholyTargetPositions", nil)
		utility:SetData(player, "UnholyPlayerPosition", nil)
		utility:SetData(player, "UnholyDouble", nil)
		player.GridCollisionClass = utility:GetData(player, "UnholyPlayerGridCollision")
		player.EntityCollisionClass = utility:GetData(player, "UnholyPlayerEntityCollision")
	elseif #TargetPositions <= 0 then
		if player.Position:Distance(playerStartPos) < UnholyOrb.MinDistance then
			player:SetMinDamageCooldown(UnholyOrb.InvincibleFrames)
			utility:SetData(player, "UnholyPlayerPosition", nil)
			utility:SetData(player, "UnholyTargetPositions", nil)
			player.GridCollisionClass = utility:GetData(player, "UnholyPlayerGridCollision")
			player.EntityCollisionClass = utility:GetData(player, "UnholyPlayerEntityCollision")
			player.Velocity = Vector.Zero
			--SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL, 2)
			Game():ShakeScreen(10)
			local doubler = false
			for _, enemy in pairs(Isaac.FindInRadius(Game():GetRoom():GetCenterPos(), 5000, EntityPartition.ENEMY)) do
				if enemy:ToNPC() and enemy:GetData().UnholyOrbFlag then
					enemy:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
					enemy:GetData().UnholyOrbFlag = nil
					enemy:GetData().UnholyFreeze = nil
					doubler = true
		        end
			end
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, player.Position, Vector.Zero, player)
			poof:SetColor(Color(0,0,0,1,0.7),-1,1, false, false)
			local ppff = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, player.Position, Vector.Zero, player):ToEffect()
			ppff:SetColor(Color(0,0,0,1,0.7),-1,1, false, false)
			Game():GetRoom():EmitBloodFromWalls(5, 10)
			if utility:GetData(player, "UnholyDouble") and doubler then
				MilkshakeVol1:UseSpiritOrb(enums.Orbs.UNHOLY, player, enums.UseOrbFlags.NO_SOUND)
			end
			utility:SetData(player, "UnholyDouble", nil)
		elseif player.Position:Distance(playerStartPos) < UnholyOrb.MaxDistance then
			player.Velocity = (playerStartPos - player.Position):Resized(UnholyOrb.MinSpeed)
		else
			player.Velocity = (playerStartPos - player.Position):Resized(UnholyOrb.MaxSpeed)
		end
	elseif #TargetPositions > 0 then
		if TargetPositions[1]:Exists() then
			if player.Position:Distance(TargetPositions[1].Position) < UnholyOrb.MinDistance then
				player.Velocity = Vector.Zero
				Game():ShakeScreen(2)
				SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL, 2)
				local enemy = table.remove(TargetPositions, 1)
				local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 2, enemy.Position, Vector.Zero, nil)
				poof:SetColor(Color(0,0,0,1,0.7),-1,1, false, false)
				enemy:BloodExplode()
				utility:SetData(player, "UnholyTargetPositions", TargetPositions) -- idk if necessary
				if enemy:ToNPC() then
					if enemy.Type == EntityType.ENTITY_SHOPKEEPER then
						enemy:Kill()
						for _ = 1, 2 do
							Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, enemy.Position, RandomVector()*3, nil)
						end
					else
						enemy:GetData().UnholyOrbFlag = player
						enemy:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT| EntityFlag.FLAG_EXTRA_GORE)
						enemy:AddEntityFlags(EntityFlag.FLAG_BRIMSTONE_MARKED)
						enemy:SetColor(Color(1,0.5,0.5), -1, 1, true, true)
						local damage = UnholyOrb.DamageMultiplier + UnholyOrb.DamageMultiplier*utility:GetCurrentChapter()
						enemy:TakeDamage(damage, DamageFlag.DAMAGE_CRUSH, EntityRef(enemy), 1)
					end
				else
					enemy:Kill()
					enemy:Remove()
					BeggarRewards(enemy)
				end
			elseif player.Position:Distance(TargetPositions[1].Position) < UnholyOrb.MaxDistance then

				player.Velocity = (TargetPositions[1].Position - player.Position):Resized(UnholyOrb.MinSpeed)
			else
				player.Velocity = (TargetPositions[1].Position - player.Position):Resized(UnholyOrb.MaxSpeed)
			end
		else
			table.remove(TargetPositions, 1)
			utility:SetData(player, "UnholyTargetPositions", TargetPositions) -- idk if necessary
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, UnholyOrb.onPEffectUpdate)

function UnholyOrb:enemyUpd(enemy)
	if enemy:GetData().UnholyFreeze and not enemy:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
		enemy:AddEntityFlags(EntityFlag.FLAG_FREEZE)
	end
	if not enemy:GetData().UnholyOrbFlag then return end
	if enemy:HasMortalDamage() and enemy.MaxHitPoints >= UnholyOrb.MaxHitPoints then
		enemy:GetData().UnholyOrbFlag = nil
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, enemy.Position, Vector.Zero, nil):ToTear()
		tear.CollisionDamage = UnholyOrb.DamageMultiplier + utility:GetCurrentChapter()
		tear:AddTearFlags(TearFlags.TEAR_BURSTSPLIT)
		tear.Scale = 1.6
		tear.FallingAcceleration = 10
		tear.FallingSpeed = 10
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, UnholyOrb.enemyUpd)

function UnholyOrb:OnUnholyOrbUse(_, player, flags)
    local TargetPositions = GetTargets(player) -- table of npc and slot position
	if #TargetPositions > 0 then
		utility:SetData(player, "UnholyDouble", flags & enums.UseOrbFlags.DOUBLE_POWER > 0)
		utility:SetData(player, "UnholyPlayerGridCollision", player.GridCollisionClass)
		utility:SetData(player, "UnholyPlayerEntityCollision", player.EntityCollisionClass)
		utility:SetData(player, "UnholyTargetPositions", TargetPositions)
		utility:SetData(player, "UnholyPlayerPosition", player.Position)
		--player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS, true, UnholyOrb.DarkArtsStack)
		--player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
		local pentagram = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HERETIC_PENTAGRAM, 0, Game():GetRoom():GetCenterPos(), Vector.Zero, player):ToEffect()
		pentagram:GetData().UnholyOrbFlag = true
		--pentagram.CollisionDamage = 0
		pentagram.Color = Color(1,0.1,0.1)
		pentagram:SetTimeout(10)
		local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
		poof:SetColor(Color(0,0,0,1,0.7),-1,1, false, false)
		local sptr = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, player.Position, Vector.Zero, player):ToEffect()
		sptr:SetColor(Color(0,0,0,1,0.7),-1,1, false, false)
		--sptr.SpriteScale = sptr.SpriteScale * 2
		sptr.Parent = player
		sptr:FollowParent(player)
		sptr:GetData().UnholyOrbFlag = true
	else
		player:UseActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS)
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, UnholyOrb.OnUnholyOrbUse, enums.Orbs.UNHOLY)

function UnholyOrb:TrailUpdate(effect)
	if effect:GetData().UnholyOrbFlag then
		if not utility:GetData(effect.SpawnerEntity, "UnholyPlayerPosition") then
			effect:GetData().UnholyOrbFlag = nil
			effect:Remove()
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, UnholyOrb.TrailUpdate, EffectVariant.SPRITE_TRAIL)
--]]

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