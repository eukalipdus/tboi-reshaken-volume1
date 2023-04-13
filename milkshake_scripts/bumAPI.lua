local bumAPI = {}

local BumFamiliars = {}
local superBumSprite = Sprite()
superBumSprite:Load("gfx/ui/giantbook/giantbook_superbumcustom.anm2", true)

local bumboVariant = FamiliarVariant.BUMBO
local bumFriendVariant = FamiliarVariant.BUM_FRIEND
local darkBumVariant = FamiliarVariant.DARK_BUM
local keyBumVariant = FamiliarVariant.KEY_BUM
local superBumVariant = FamiliarVariant.SUPER_BUM
FamiliarVariant.BUMBO = Isaac.GetEntityVariantByName("Bumbo Familiar")
FamiliarVariant.BUM_FRIEND = Isaac.GetEntityVariantByName("Bum Friend Familiar")
FamiliarVariant.DARK_BUM = Isaac.GetEntityVariantByName("Dark Bum Familiar")
FamiliarVariant.KEY_BUM = Isaac.GetEntityVariantByName("Key Bum Familiar")
FamiliarVariant.SUPER_BUM = Isaac.GetEntityVariantByName("Super Bum Familiar")

---@class bumPickups
---@field reward integer
---@field value integer[]
---@field spawn nil | integer

---@class bumPayouts
---@field chance number
---@field value integer[]

---@class bumInfo
---@field collectible CollectibleType
---@field superBum boolean
---@field cost number
---@field pickups bumPickups[]
---@field payouts bumPayouts[]

---Custom function to define a familiar variant as a "Bum Familiar"
---@param familiarVariant FamiliarVariant
---@param collectibleType CollectibleType
---@param contributesToSuperBum boolean
---@param payoutCost number 
---@param pickups bumPayouts[]
---@param payouts bumPickups[]
function bumAPI:AddBumFamiliar(familiarVariant, collectibleType, contributesToSuperBum, payoutCost, pickups, payouts)
	BumFamiliars[familiarVariant] = {collectible=collectibleType, superBum=contributesToSuperBum, cost=payoutCost, pickups=pickups, payouts=payouts}
end

---@param familiar EntityFamiliar
local function BumFamiliarInit(_, familiar)
	--print(familiar.Type, familiar.Variant)
	if (familiar.Variant == bumboVariant) then familiar:Remove() return
	elseif (familiar.Variant == bumFriendVariant) then familiar:Remove() return
	elseif (familiar.Variant == darkBumVariant) then familiar:Remove() return
	elseif (familiar.Variant == keyBumVariant) then familiar:Remove() return
	elseif (familiar.Variant == superBumVariant) then familiar:Remove() return
	end

	if (BumFamiliars[familiar.Variant]) then
		local player = familiar.SpawnerEntity
		---@diagnostic disable-next-line: param-type-mismatch
		--local BumChain = utility:GetData(player, "BumChain") or (utility:SetData(player, "BumChain", {}) and utility:GetData(player, "BumChain"))
		
		local aa = player
		---@diagnostic disable-next-line: need-check-nil
		while aa.Child ~= nil do
			---@diagnostic disable-next-line: need-check-nil
			aa = aa.Child
		end
		---@diagnostic disable-next-line: assign-type-mismatch
		familiar.Parent = aa
		aa.Child = familiar
	end
	--print("a")
	if (familiar.Variant == FamiliarVariant.SUPER_BUM) then
		superBumSprite:Play("Main", true)
		--Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)
		--I have no idea why i can't do this here but when i try i get C-stack size errors
	end
	--print("b")
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BumFamiliarInit)

---@param familiar EntityFamiliar
local function BumFamiliarUpdate(_, familiar)
	---@type bumInfo
	local bumInfo = BumFamiliars[familiar.Variant]
	if (bumInfo and (familiar.Variant ~= FamiliarVariant.BUMBO or familiar.Coins < 6)) then
		if (familiar:GetSprite():IsFinished("IdleDown")) then familiar:GetSprite():Play("FloatDown", true) end
		local newPos = familiar.Parent.Position - familiar.Position
		local closestDist = 10000000000000000
		local closestEnt = nil
		for _, entity in pairs(TSIL.Entities.GetEntities(nil, nil, nil, nil)) do
			for _, pickup in pairs(bumInfo.pickups) do
				if entity:Exists() and not entity:IsDead() and entity:ToPickup() and entity:ToPickup().Price == 0 and entity.Type == pickup.value[1] and entity.Variant == pickup.value[2] and entity.SubType == pickup.value[3] then
					if (entity.Position - familiar.Position):LengthSquared() < closestDist then
						closestEnt = entity:ToPickup()
						closestDist = (entity.Position - familiar.Position):LengthSquared()
					end
				end
			end
		end

		if familiar:GetSprite():IsPlaying("PreSpawn") or familiar:GetSprite():IsPlaying("Spawn") then
			newPos = Vector.Zero
		elseif familiar:GetSprite():IsFinished("PreSpawn") then
			familiar:GetSprite():Play("Spawn")
			local reward = TSIL.Random.GetRandomElementFromWeightedList(familiar:GetDropRNG(), bumInfo.payouts)
			Isaac.Spawn(reward[1], reward[2], reward[3], familiar.Position, Vector.Zero, familiar)
			familiar.Coins = familiar.Coins - bumInfo.cost
			newPos = Vector.Zero
		elseif familiar:GetSprite():IsFinished("Spawn") then
			familiar:GetSprite():Play("FloatDown")
			newPos = Vector.Zero
		elseif closestEnt then
			for _, pickup in pairs(bumInfo.pickups) do
				if closestEnt.Type == pickup.value[1] and closestEnt.Variant == pickup.value[2] and closestEnt.SubType == pickup.value[3] then
					newPos = closestEnt.Position - familiar.Position
					if (newPos:LengthSquared() < 100 and pickup.reward > 0) then 
						familiar.Coins = familiar.Coins + pickup.reward
						if (pickup.spawn) then Isaac.Spawn(pickup.spawn[1], pickup.spawn[2], pickup.spawn[3], familiar.Position, Vector.Zero, familiar) end
						closestEnt:PlayPickupSound()
						closestEnt.Velocity = Vector(0, 0)
						closestEnt.EntityCollisionClass = 0
						closestEnt:GetSprite():Play("Collect", true)
						closestEnt:Die()
						-- local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, closestEnt.Position, Vector.Zero, closestEnt):ToEffect()
						-- effect.Timeout = closestEnt.Timeout
						-- local sprite = effect:GetSprite()
						-- sprite:Load(closestEnt:GetSprite():GetFilename(), true)
						--sprite:Play("Collect", true)
						--Mod:KillChoice(closestEnt) -- get rid of pickups with same options index
						--closestEnt:Remove()
						--print("Picked up")
					end
					break
				end
			end
		elseif (familiar.Coins >= bumInfo.cost and familiar.Position:DistanceSquared(familiar.SpawnerEntity.Position) < 65*65) 
				and not (familiar:GetSprite():IsPlaying("PreSpawn") or familiar:GetSprite():IsPlaying("Spawn"))  then
			familiar:GetSprite():Play("PreSpawn", true)
			newPos = Vector.Zero
		elseif (familiar.Parent:ToPlayer() and newPos:DistanceSquared(Vector.Zero) < 65*65) then
			newPos = Vector.Zero
		elseif (newPos:DistanceSquared(Vector.Zero) < 40*40) then
			newPos = Vector.Zero
		end

		newPos:Resize(3)
		---@diagnostic disable-next-line: assign-type-mismatch, param-type-mismatch
		familiar.Velocity = TSIL.Utils.Math.Lerp(familiar.Velocity, newPos, 0.25)
		--print(GetPtrHash(familiar), familiar.Coins)
		--print(Game():GetFrameCount())
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BumFamiliarUpdate)

---@param player EntityPlayer
local function EvaluateCache(_, player)
	--print("c")
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        CollectibleType.COLLECTIBLE_BUMBO,
        FamiliarVariant.BUMBO
    )
	local numBums = 0
	--local superPickups = {}
	--local superDrops = {}
	for familiarType, _ in pairs(BumFamiliars) do
		---@type bumInfo
		local bumInfo = BumFamiliars[familiarType]
		if (bumInfo.superBum and player:HasCollectible(bumInfo.collectible)) then 
			numBums = numBums + 1
			--superPickups = utility:TableConcat(superPickups, bumInfo[3])
			--superDrops = utility:TableConcat(superDrops, bumInfo[4])
		end
	end
	if (numBums >= 3) then
		local hasSuper = false
		for _, familiar in pairs(TSIL.Familiars.GetPlayerFamiliars(player)) do
			---@type bumInfo
			local bumFamiliar = BumFamiliars[familiar.Variant]
			if (bumFamiliar and bumFamiliar.superBum) then
				familiar.Parent.Child = familiar.Child
				if (familiar.Child) then familiar.Child.Parent = familiar.Parent end
				familiar:Remove()
			elseif (bumFamiliar and familiar.Variant == FamiliarVariant.SUPER_BUM) then
				hasSuper = true
			end
		end
		if not hasSuper then Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SUPER_BUM, 0, player.Position, Vector.Zero, player) end
	else
		for familiarType, _ in pairs(BumFamiliars) do
			---@type bumInfo
			local bumInfo = BumFamiliars[familiarType]
			TSIL.Familiars.CheckFamiliarFromCollectibles(
				player,
				bumInfo.collectible,
				familiarType
			)
		end
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateCache, CacheFlag.CACHE_FAMILIARS)

local function Update()
	---@diagnostic disable-next-line: missing-parameter
	if (superBumSprite:IsPlaying()) then Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM) end
	superBumSprite:Update()
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_UPDATE, Update)


--[[NEXT THREE FUNCTIONS ARE BASICALLY THE DESECRATED CORPSE OF FF's giantbook_manager.lua]]
milkshakeMod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
	---@diagnostic disable-next-line: missing-parameter
	if superBumSprite:IsPlaying() and action ~= ButtonAction.ACTION_CONSOLE then
		return 0
	---@diagnostic disable-next-line: missing-parameter
	elseif superBumSprite:IsFinished("Main") and action == ButtonAction.ACTION_SHOOTDOWN then
		return 0.75
	end
end, InputHook.GET_ACTION_VALUE)

local function doRender()
	---@diagnostic disable-next-line: missing-parameter
	if superBumSprite:IsPlaying() then
		superBumSprite:Render(Vector(Isaac:GetScreenWidth()/2, Isaac:GetScreenHeight()/2), Vector.Zero, Vector.Zero)

		---@diagnostic disable-next-line: missing-parameter
		if superBumSprite:IsFinished() then
			superBumSprite:Stop()
		end
	end
end

---@diagnostic disable-next-line: undefined-global
if StageAPI then
	milkshakeMod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, shaderName) -- Hijack the existance of the StageAPI shader to render over the hud
		if shaderName == "StageAPI-RenderAboveHUD" then
			doRender()
		end
	end)
else
	milkshakeMod:AddCallback(ModCallbacks.MC_POST_RENDER, doRender)
end



bumAPI:AddBumFamiliar(FamiliarVariant.BUMBO, CollectibleType.COLLECTIBLE_BUMBO, false, 5, {
	{reward = 1, value = {5, 20, 1}},
	{reward = 5, value = {5, 20, 2}},
	{reward = 10,value = {5, 20, 3}},
	{reward = 2, value = {5, 20, 4}},
	{reward = 1, value = {5, 20, 5}},
	{reward = -1,value = {5, 20, 6}},
	{reward = 1, value = {5, 20, 7}}
}, {
	{chance = 100, value = {5, 20, 2}},
})
bumAPI:AddBumFamiliar(FamiliarVariant.BUM_FRIEND, CollectibleType.COLLECTIBLE_BUM_FRIEND, true, 5, {
	{reward = 1, value = {5, 20, 1}},
	{reward = 5, value = {5, 20, 2}},
	{reward = 10,value = {5, 20, 3}},
	{reward = 2, value = {5, 20, 4}},
	{reward = 1, value = {5, 20, 5}},
	{reward = 1, value = {5, 20, 7}}
}, {
	{chance = 100, value = {5, 20, 2}},
})
bumAPI:AddBumFamiliar(FamiliarVariant.DARK_BUM, CollectibleType.COLLECTIBLE_DARK_BUM, true, 3, {
	{reward = 2, value = {5, 10, 1}},
	{reward = 1, value = {5, 10, 2}},
	{reward = 4, value = {5, 10, 5}},
	{reward = 2, value = {5, 10, 9}},
}, {
	{chance = 40, value = {5, 10, 6}},
	{chance = 20, value = {5, 300, -1}},
	{chance = 20, value = {5, 70, -1}},
	{chance = 10, value = {3, 73, 0}},
	{chance = 10, value = {85, 0, 0}},
})
bumAPI:AddBumFamiliar(FamiliarVariant.KEY_BUM, CollectibleType.COLLECTIBLE_KEY_BUM, true, 1, {
	{reward = 1, value = {5, 30, 1}},
	{reward = 2, value = {5, 30, 3}},
	{reward = 1, value = {5, 30, 4}, spawn = {5, 90, 1}},
}, {
	{chance = 40, value = {5, 50, 0}},
	{chance = 30, value = {5, 360, 0}},
	{chance = 20, value = {5, 60, 0}},
	{chance = 10, value = {5, 69, 1}},
})
---@diagnostic disable-next-line: param-type-mismatch
bumAPI:AddBumFamiliar(FamiliarVariant.SUPER_BUM, -1, false, 1, {}, {})

return bumAPI