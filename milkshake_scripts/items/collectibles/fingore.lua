local fingore = {}
local enums = require("milkshake_scripts.enums")
local utility = require("milkshake_scripts.utility")

local offset = Vector(0, -100)
local entranceSpeed = 0.05
local exitSpeed = 0.01

local isNewRoom = false;

---@param player EntityPlayer
function fingore:EvaluateCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.FINGORE,
        enums.Familiars.FINGORE
    )
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, fingore.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
function fingore:FamiliarInit(familiar)
	local finger = Sprite()
	finger:Load("gfx/familiar_fingore.anm2", true)
	finger:Play("Point", true)

	local fingoreData = {
		sprite = finger,
		target = nil,
		escape = Vector.FromAngle(familiar:GetDropRNG():RandomInt(360))*1000,
		cleared = true,
		emoted = false,
		temp = false
	}
	utility:SetData(familiar, "Fingore", fingoreData)
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, fingore.FamiliarInit, enums.Familiars.FINGORE)

---@param familiar EntityFamiliar
function fingore:FamiliarUpdate(familiar)
    familiar.DepthOffset = 90
	---@type {sprite : Sprite, target : Entity, escape : Vector, cleared : boolean, emoted : boolean, temp : boolean}
	local fingoreData = utility:GetData(familiar, "Fingore")
	if isNewRoom then
		local rng = familiar:GetDropRNG()
		local entities = TSIL.Utils.Tables.Filter(Isaac.GetRoomEntities(), function (_, npc)
			return npc:IsVulnerableEnemy()
		end)
		local target = entities[rng:RandomInt(#entities)]
		local escape = Vector.FromAngle(rng:RandomInt(360))*1000
		familiar.Position = Vector.FromAngle(rng:RandomInt(360))*1000
		
		if target then target:AddEntityFlags(EntityFlag.FLAG_BAITED) end
		fingoreData.sprite:Play("Point", true)

		fingoreData.target = target
		fingoreData.escape = (target and escape) or familiar.Position
		fingoreData.cleared = false
		fingoreData.emoted = false
		fingoreData.temp = false
	end
	if fingoreData.sprite:IsFinished("Nuh") or fingoreData.sprite:IsFinished("Thumbs") then
		fingoreData.sprite:Play("Point", true)
	elseif fingoreData.target and fingoreData.target:Exists() then
		---@diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
		familiar.Position = TSIL.Utils.Math.Lerp(familiar.Position, fingoreData.target.Position + offset, entranceSpeed)
		if (familiar.Position:Distance(fingoreData.target.Position + offset) < 64 and not fingoreData.emoted) then
			fingoreData.sprite:Play("Nuh", true)
			fingoreData.emoted = true
		end
	elseif not fingoreData.cleared then
		fingoreData.cleared = true
		fingoreData.sprite:Play("Thumbs", true)
	elseif not (fingoreData.sprite:IsPlaying("Nuh") or fingoreData.sprite:IsPlaying("Thumbs")) then
		---@diagnostic disable-next-line: param-type-mismatch, assign-type-mismatch
		familiar.Position = TSIL.Utils.Math.Lerp(familiar.Position, familiar.SpawnerEntity.Position + fingoreData.escape, exitSpeed)
	end
	fingoreData.sprite:Update()
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, fingore.FamiliarUpdate, enums.Familiars.FINGORE)

---@param familiar EntityFamiliar
function fingore:PostFamiliarRender(familiar)
	---@type {sprite : Sprite, target : Entity, escape : Vector, cleared : boolean, emoted : boolean, temp : boolean}
	local fingoreData = utility:GetData(familiar, "Fingore")

	if fingoreData.sprite:IsPlaying("Nuh") or fingoreData.sprite:IsPlaying("Thumbs") then
		fingoreData.sprite.Rotation = 0
	elseif fingoreData.target and fingoreData.target:Exists() then
		fingoreData.sprite.Rotation = (fingoreData.target.Position - familiar.Position):GetAngleDegrees()
	elseif fingoreData.cleared then
		fingoreData.sprite.Rotation = (familiar.SpawnerEntity.Position + fingoreData.escape - familiar.Position):GetAngleDegrees()
	end
	fingoreData.sprite:Render(Isaac.WorldToScreen(familiar.Position))
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, fingore.PostFamiliarRender, enums.Familiars.FINGORE)

milkshakeMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	isNewRoom = true
end)
milkshakeMod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if isNewRoom then isNewRoom = false end
end)

return fingore