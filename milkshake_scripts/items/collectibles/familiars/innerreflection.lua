local innerreflection = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

local actionDelay = 50
local appearLength = 20

local wasRoomClear = false;
local isNewRoom = false;

---@param player EntityPlayer
function innerreflection:EvaluateCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.INNER_REFLECTION,
        enums.Familiars.INNER_REFLECTION
    )
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, innerreflection.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
function innerreflection:PostFamiliarUpdate(familiar)
	local player = familiar.Player
	---@type {frame : integer, actionList : table}
	local reflectionData = utility:GetData(familiar, "Reflection")

	if (not reflectionData or isNewRoom or (wasRoomClear and not Game():GetRoom():IsClear())) then
		reflectionData = {
			frame = 0,
			actionList = {}
		}
	elseif (Game():GetRoom():IsClear()) then
		if (reflectionData.frame > actionDelay) then reflectionData.frame = actionDelay+1 end
		reflectionData.frame = reflectionData.frame - 1
	else
		if (reflectionData.frame < 0) then reflectionData.frame = -1 end
		reflectionData.frame = reflectionData.frame + 1
	end
	reflectionData.actionList[#reflectionData.actionList+1] = {
		Anm=player:GetSprite():GetAnimation(),
		OAnm=player:GetSprite():GetOverlayAnimation(),
		Frame=player:GetSprite():GetFrame(),
		OFrame=player:GetSprite():GetOverlayFrame(),
		Pos=player.Position
	}
	wasRoomClear = Game():GetRoom():IsClear()
	utility:SetData(familiar, "Reflection", reflectionData)
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, innerreflection.PostFamiliarUpdate, enums.Familiars.INNER_REFLECTION)

---@param familiar EntityFamiliar
function innerreflection:PostFamiliarRender(familiar)
	---@type {frame : integer, actionList : table}
	local reflectionData = utility:GetData(familiar, "Reflection")
	familiar.Color = Color(1,1,1,0.5)
	if (reflectionData) then
		local frame = reflectionData.frame-actionDelay
		local curAction = reflectionData.actionList[math.max(frame, 1)]
		
		if (frame > 0) then
			familiar.Position = curAction.Pos
			familiar:GetSprite():SetFrame(curAction.Anm, curAction.Frame)
			familiar:GetSprite():SetOverlayFrame(curAction.OAnm, curAction.OFrame)
		elseif (frame >= -appearLength) then
			if (not Game():GetRoom():IsClear()) then familiar.Position = curAction.Pos end
			familiar:GetSprite():SetFrame("CelesteAppear", frame+appearLength)
			familiar:GetSprite():SetOverlayFrame("CelesteAppear", 0)
		else
			familiar.Position = Vector(-1000, -1000)
		end
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, innerreflection.PostFamiliarRender, enums.Familiars.INNER_REFLECTION)

---@param familiar EntityFamiliar
---@param collider Entity
function innerreflection:Collision(familiar, collider)
	if (collider:ToPlayer() == familiar.Player) then
		print("aa")
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, innerreflection.Collision, enums.Familiars.INNER_REFLECTION)

milkshakeMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	isNewRoom = true
end)
milkshakeMod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
	if isNewRoom then isNewRoom = false end
end)