local innerreflection = {}
local enums = MilkshakeVol1.enums
local game = Game()

local InnerReflectionConfig = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.INNER_REFLECTION)

local BASE_CONTACT_DAMAGE = 1.7

local MIRROR_WORLD_DAMAGE_BONUS = 2.5
local MAX_DAMAGE_MULTIPLIER_INCREASE = 1

local isMirrorDimension = false

--This is only for the function below, don't think about it too much.
local DIRECTIONAL_ANIMATIONS = {"Walk", "Head", "PickupWalk"}
local OPPOSITE_DIRECTIONS = {["Left"] = "Right", ["Up"] = "Down"}
local ANIMATIONS_OPPOSITE_DIRECTION = {}
for _, animation in ipairs(DIRECTIONAL_ANIMATIONS) do
	for direction, opposite in pairs(OPPOSITE_DIRECTIONS) do
		local animName1 = animation .. direction
		local animName2 = animation .. opposite
		ANIMATIONS_OPPOSITE_DIRECTION[animName1] = animName2
		ANIMATIONS_OPPOSITE_DIRECTION[animName2] = animName1
	end
end

local L_ROOM_CENTRE = Vector(580, 420)

local L_ROOM_SHAPES = {
	[RoomShape.ROOMSHAPE_LTL] = true,
	[RoomShape.ROOMSHAPE_LTR] = true,
	[RoomShape.ROOMSHAPE_LBL] = true,
	[RoomShape.ROOMSHAPE_LBR] = true,
}

---@return Vector
local function CoolerGetCenterPos()
	local room = game:GetRoom()
	if L_ROOM_SHAPES[room:GetRoomShape()] then
		return L_ROOM_CENTRE
	else
		return room:GetCenterPos()
	end
end

---If animation is one of the directional ones, makes it head the other direction (e.g. "HeadLeft" becomes "HeadRight")
---@param mainAnimation string
---@return string
local function MirroredAnimation(mainAnimation)
	return ANIMATIONS_OPPOSITE_DIRECTION[mainAnimation] or mainAnimation
end

---@param player EntityPlayer
local function HasFamiliar(player)
	return player:HasCollectible(enums.Collectibles.INNER_REFLECTION) or player:GetEffects():HasCollectibleEffect(enums.Collectibles.INNER_REFLECTION)
end

---@param player EntityPlayer
function innerreflection:EvaluateCacheFamiliars(player)
	if HasFamiliar(player) then
		player:CheckFamiliar(enums.Familiars.INNER_REFLECTION, 1, TSIL.RNG.NewRNG(), InnerReflectionConfig)
	else
		player:CheckFamiliar(enums.Familiars.INNER_REFLECTION, 0, TSIL.RNG.NewRNG(), InnerReflectionConfig)
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, innerreflection.EvaluateCacheFamiliars, CacheFlag.CACHE_FAMILIARS)

---@param player EntityPlayer
function innerreflection:EvaluateCacheDamage(player)
	if HasFamiliar(player) then
		if isMirrorDimension or MilkshakeVol1.API:IsInMirrorRoom() then
			--Capping max damage increase in percent to prevent it getting too stupid with Soy Milk and such.
			local damageBonus = math.min(MIRROR_WORLD_DAMAGE_BONUS, player.Damage*MAX_DAMAGE_MULTIPLIER_INCREASE)
			player.Damage = player.Damage + damageBonus
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, innerreflection.EvaluateCacheDamage, CacheFlag.CACHE_DAMAGE)

---@param familiar EntityFamiliar
function innerreflection:FamiliarInit(familiar)
	familiar.Color = Color(1,1,1,0.5)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, innerreflection.FamiliarInit, enums.Familiars.INNER_REFLECTION)

---@param familiar EntityFamiliar
function innerreflection:PostFamiliarUpdate(familiar)
	local player = familiar.Player

	local centre = CoolerGetCenterPos()

	local centreToPlayer = player.Position-centre
	local targetPos = centre - centreToPlayer
	if game:GetRoom():GetFrameCount() == 0 then	--Fixes familiar jumping across the room when entering it.
		familiar.Position = targetPos
		familiar.Velocity = Vector.Zero
	else
		familiar.Velocity = targetPos - familiar.Position
	end

	local familiarMultiplier =
	player:GetCollectibleNum(enums.Collectibles.INNER_REFLECTION)
	+ player:GetEffects():GetCollectibleEffectNum(enums.Collectibles.INNER_REFLECTION)

	familiar.SpriteScale = player.SpriteScale
	familiar.SizeMulti = player.SpriteScale
	familiar.CollisionDamage = BASE_CONTACT_DAMAGE * familiarMultiplier

	local pSprite = player:GetSprite()
	local fSprite = familiar:GetSprite()
	fSprite:SetFrame(MirroredAnimation(pSprite:GetAnimation()), pSprite:GetFrame())
	if pSprite:GetOverlayAnimation() == "" then
		fSprite:RemoveOverlay()
	else
		fSprite:SetOverlayFrame(MirroredAnimation(pSprite:GetOverlayAnimation()), pSprite:GetOverlayFrame())
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, innerreflection.PostFamiliarUpdate, enums.Familiars.INNER_REFLECTION)

function innerreflection:PostNewRoom()
	if game:GetRoom():IsMirrorWorld() == isMirrorDimension then
		return end
	isMirrorDimension = not isMirrorDimension
	local badelinesActive = false
	for index = 0, game:GetNumPlayers()-1 do
		local player = Isaac.GetPlayer(index)
		if not isMirrorDimension then
			--I really wanna make sure it doesn't linger for whole run if player loses the item in mirror world or something.
			player:TryRemoveNullCostume(enums.Costumes.CELESTIAL_MIRROR_ALT)
		end
		if HasFamiliar(player) then
			if isMirrorDimension then
				player:AddNullCostume(enums.Costumes.CELESTIAL_MIRROR_ALT)
			end
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
			badelinesActive = true
		end
	end
	if badelinesActive then
		local newSpriteName
		if isMirrorDimension then
			newSpriteName = "familiar_innerreflection_mirror"
		else
			newSpriteName = "familiar_innerreflection"
		end
		local spritePath = "gfx/familiar/" .. newSpriteName .. ".png"
		for _, badeline in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, enums.Familiars.INNER_REFLECTION)) do
			local sprite = badeline:GetSprite()
			for layer = 0, 14 do
				sprite:ReplaceSpritesheet(layer, spritePath)
			end
			sprite:LoadGraphics()
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, innerreflection.PostNewRoom)

---@param player EntityPlayer
function innerreflection:PlayerDie(player)
	if not player:HasCollectible(enums.Collectibles.INNER_REFLECTION) then return end
	--if math.random() > 0.1 then return end
	local sprite = player:GetSprite()

	if not player:IsDead() then return end
	if sprite:GetFrame() ~= 1 then return end

	SFXManager():Play(enums.Sounds.CELESTE_DEATH)

	TSIL.Utils.Functions.RunInFrames(function ()
		local DeathEffect = TSIL.EntitySpecific.SpawnEffect(
			enums.Effects.CELESTE_DEATH,
			0,
			player.Position + (Vector(0, -30))
		)
		DeathEffect.SpriteScale = Vector(2, 2)
		player:SetColor(Color(1, 1, 1, 0, 1, 1, 1) , 50, 1, false, false)

	end, 10)

	player:SetColor(Color(1, 1, 1, 1, 1, 1, 1) , 55, 1, false, false)
	player:SetColor(Color(1, 1, 1, 1, 1, 1, 1) , 70, 1, true, false)
	player.Velocity = Vector(15, -15)
end


function innerreflection:PostUpdate()
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
        innerreflection:PlayerDie(player)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_UPDATE, innerreflection.PostUpdate)

---@param effect EntityEffect
function innerreflection:CelesteDeathEffectUpdate(effect)
    local sprite = effect:GetSprite()

    if effect.Variant == enums.Effects.CELESTE_DEATH and 
	sprite:IsFinished("Idle") then
        effect:Remove()
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    innerreflection.CelesteDeathEffectUpdate
)