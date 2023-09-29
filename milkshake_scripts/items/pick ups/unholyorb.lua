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
UnholyOrb.Speed = 14

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
		if enemy:ToNPC() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and enemy.Type ~= EntityType.ENTITY_FIREPLACE and enemy:IsVulnerableEnemy() then
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

function UnholyOrb:onPEffectUpdate(player)
	if not utility:GetData(player, "UnholyTargetPositions") then return end
	player:SetColor(Color(1,0.3,0.3,0.5), 1, 1, false, true)
	player:SetMinDamageCooldown(1)
	player:AddControlsCooldown(1) -- ? idk if it would work
	local TargetPositions = utility:GetData(player, "UnholyTargetPositions")
	if Game():GetRoom():GetFrameCount() == 1 then
		utility:SetData(player, "UnholyTargetPositions", nil)
		utility:SetData(player, "UnholyPlayerPosition", nil)
	elseif #TargetPositions <= 0 then
		player.Velocity = (utility:GetData(player, "UnholyPlayerPosition") - player.Position):Resized(UnholyOrb.Speed)
		player:SetMinDamageCooldown(UnholyOrb.InvincibleFrames)
		utility:SetData(player, "UnholyPlayerPosition", nil)
		utility:SetData(player, "UnholyTargetPositions", nil)
	elseif #TargetPositions > 0 then
		player.Velocity = (player.Position - TargetPositions[1].Position):Resized(UnholyOrb.Speed)
		if not TargetPositions[1] or not TargetPositions[1]:Exists() or TargetPositions[1]:GetData().UnholyOrbFlag then
			table.remove(TargetPositions, 1)
			utility:SetData(player, "UnholyTargetPositions", TargetPositions)
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, UnholyOrb.onPEffectUpdate)


function UnholyOrb:enemyUpd(enemy)
	if not enemy:GetData().UnholyOrbFlag then return end
	if enemy.Type == EntityType.ENTITY_FIREPLACE then return end
	if enemy.Type == EntityType.ENTITY_SHOPKEEPER then
		enemy:Kill()
		for _ = 1, 2 do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, enemy.Position, RandomVector()*3, nil)
		end
	end
	if enemy:HasMortalDamage() then
		--blood tears
		--placeholder creep
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, enemy.Position, Vector.Zero, nil):ToEffect()
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, UnholyOrb.enemyUpd)
--]]

function UnholyOrb:onPlayerCollision(player, collider)
	if not utility:GetData(player, "UnholyPlayerPosition") then return end
	if collider:ToNPC() and not collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		local enemy = collider:ToNPC()
		Game():ShakeScreen(UnholyOrb.DamageMultiplier)
		local damage = UnholyOrb.DamageMultiplier + UnholyOrb.DamageMultiplier*utility:GetCurrentChapter()
		enemy:TakeDamage(damage, DamageFlag.DAMAGE_CRUSH, EntityRef(player), 1)
		enemy:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT | EntityFlag.FLAG_BRIMSTONE_MARKED | EntityFlag.FLAG_EXTRA_GORE)
		enemy:GetData().UnholyOrbFlag = true
	elseif collider.Type == EntityType.ENTITY_SLOT then
		collider:Kill()
		Game():ShakeScreen(5)
		BeggarRewards(collider)
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, UnholyOrb.onPlayerCollision)

function UnholyOrb:PentaUpdate(effect)
	if effect:GetData().UnholyOrbFlag then
		local player = effect.SpawnerEntity
		if not utility:GetData(player, "UnholyPlayerPosition") then
			effect:SetTimeout(1)
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, UnholyOrb.PentaUpdate, EffectVariant.PENTAGRAM_BLACKPOWDER)

---@param player EntityPlayer
function UnholyOrb:OnUnholyOrbUse(_, player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS)
    local TargetPositions = GetTargets() -- table of npc and slot position
	if #TargetPositions > 0 then
		utility:SetData(player, "UnholyTargetPositions", TargetPositions)
		utility:SetData(player, "UnholyPlayerPosition", player.Position)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_MIMIC)
		local pentagram = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PENTAGRAM_BLACKPOWDER, 0, Game():GetRoom():GetCenterPos(), Vector.Zero, player):ToEffect()
		pentagram:GetData().UnholyOrbFlag = true -- remove after dash
		pentagram:SetTimeout(-1)
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, UnholyOrb.OnUnholyOrbUse, enums.Orbs.UNHOLY)