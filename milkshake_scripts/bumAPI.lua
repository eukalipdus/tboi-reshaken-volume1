local bumAPI = {}
local utility = require("milkshake_scripts.utility")

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



---Custom function to define a familiar variant as a "Bum Familiar"
---@param familiarVariant FamiliarVariant
---@param collectibleType CollectibleType
---@param contributesToSuperBum boolean
---@param pickups table 
---@param drops table
function bumAPI:AddBumFamiliar(familiarVariant, collectibleType, contributesToSuperBum, pickups, drops)
	BumFamiliars[familiarVariant] = {collectibleType, contributesToSuperBum, pickups, drops}
end

---@param familiar EntityFamiliar
local function BumFamiliarInit(_, familiar)
	if (familiar.Variant == bumboVariant) then familiar:Remove()
	elseif (familiar.Variant == bumFriendVariant) then familiar:Remove()
	elseif (familiar.Variant == darkBumVariant) then familiar:Remove()
	elseif (familiar.Variant == keyBumVariant) then familiar:Remove()
	elseif (familiar.Variant == superBumVariant) then familiar:Remove()
	elseif (familiar.Variant == FamiliarVariant.SUPER_BUM) then
		superBumSprite:Play("Main", true)
		Isaac.GetPlayer():UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)
	end

	if (BumFamiliars[familiar.Variant]) then
		local player = familiar.SpawnerEntity
		---@diagnostic disable-next-line: param-type-mismatch
		local BumChain = utility:GetData(player, "BumChain") or (utility:SetData(player, "BumChain", {}) and utility:GetData(player, "BumChain"))
		
		---@diagnostic disable-next-line: assign-type-mismatch
		if #BumChain == 0 then familiar.Parent = player
		else familiar.Parent = BumChain[#BumChain] end

		BumChain[#BumChain+1] = familiar
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, BumFamiliarInit)

---@param familiar EntityFamiliar
local function BumFamiliarUpdate(_, familiar)
	if (familiar:GetSprite():IsFinished("IdleDown")) then familiar:GetSprite():Play("FloatDown", true) end
	if (BumFamiliars[familiar.Variant] and (familiar.Variant ~= FamiliarVariant.BUMBO or familiar.Coins < 6)) then
		local newPos = familiar.Parent.Position - familiar.Position
		if (familiar.Parent:ToPlayer() and newPos:DistanceSquared(Vector.Zero) < 65*65) then newPos = Vector.Zero
		elseif (newPos:DistanceSquared(Vector.Zero) < 40*40) then newPos = Vector.Zero end
		newPos:Resize(3)
		---@diagnostic disable-next-line: assign-type-mismatch
		familiar.Velocity = familiar.Velocity*0.75 + newPos*0.25
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BumFamiliarUpdate)

---@param player EntityPlayer
local function EvaluateCache(_, player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        CollectibleType.COLLECTIBLE_BUMBO,
        FamiliarVariant.BUMBO
    )
	local numBums = 0
	--local superPickups = {}
	--local superDrops = {}
	for familiarType, info in pairs(BumFamiliars) do
		if (info[2] and player:HasCollectible(info[1])) then 
			numBums = numBums + 1
			--superPickups = utility:TableConcat(superPickups, info[3])
			--superDrops = utility:TableConcat(superDrops, info[4])
		end
	end
	if (numBums >= 3) then
		Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SUPER_BUM, 0, player.Position, Vector.Zero, player)
	else
		for familiarType, info in pairs(BumFamiliars) do
			TSIL.Familiars.CheckFamiliarFromCollectibles(
				player,
				info[1],
				familiarType
			)
		end
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateCache, CacheFlag.CACHE_FAMILIARS)

local function Update()
	superBumSprite:Update()
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_UPDATE, Update)


--[[NEXT THREE FUNCTIONS ARE BASICALLY THE DESECRATED CORPSE OF FF's giantbook_manager.lua]]
milkshakeMod:AddCallback(ModCallbacks.MC_INPUT_ACTION, function(_, entity, hook, action)
	---@diagnostic disable-next-line: missing-parameter
	if superBumSprite:IsPlaying() and action ~= ButtonAction.ACTION_CONSOLE then
		return 0
	elseif action == ButtonAction.ACTION_SHOOTDOWN then
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



bumAPI:AddBumFamiliar(FamiliarVariant.BUMBO, CollectibleType.COLLECTIBLE_BUMBO, false, {}, {})
bumAPI:AddBumFamiliar(FamiliarVariant.BUM_FRIEND, CollectibleType.COLLECTIBLE_BUM_FRIEND, true, {}, {})
bumAPI:AddBumFamiliar(FamiliarVariant.DARK_BUM, CollectibleType.COLLECTIBLE_DARK_BUM, true, {}, {})
bumAPI:AddBumFamiliar(FamiliarVariant.KEY_BUM, CollectibleType.COLLECTIBLE_KEY_BUM, true, {}, {})
---@diagnostic disable-next-line: param-type-mismatch
bumAPI:AddBumFamiliar(FamiliarVariant.SUPER_BUM, -1, false, {}, {})

return bumAPI