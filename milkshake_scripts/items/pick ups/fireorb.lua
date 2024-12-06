local RubyOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local INHALING_DURATION = 60
local ANGLE_VARIANCE = 20;
local MAX_ANGLE = 180;
local BLEND_AMOUNT = 0.2;

local NUM_SHOTS = 40;
local NUM_SHOTS_DOUBLE_POWER = NUM_SHOTS * 2
local SHOOT_TIME = 70;
local SHOOT_TIME_DOUBLE_POWER = SHOOT_TIME * 1.5

local SHOT_SPEED = 8;
local SHOT_SPEED_DOUBLE_POWER = 10

--Other Variables
local CLAMP_ANGLE = (MAX_ANGLE / 2) - (ANGLE_VARIANCE / 2);
local SHOT_DELAY = math.floor(SHOOT_TIME / NUM_SHOTS + 0.5);
local SHOT_DELAY_DOUBLE_POWER = math.floor(SHOOT_TIME_DOUBLE_POWER / NUM_SHOTS_DOUBLE_POWER + 0.5)
local ARROW_SPRITE = Sprite()
ARROW_SPRITE:Load("gfx/ruby_orb_arrow.anm2", true)
ARROW_SPRITE:Play("Idle", true)
local VECTOR_PER_SHOOT_ACTION = {
	[ButtonAction.ACTION_SHOOTDOWN] = Vector(0, 1),
	[ButtonAction.ACTION_SHOOTLEFT] = Vector(-1, 0),
	[ButtonAction.ACTION_SHOOTRIGHT] = Vector(1, 0),
	[ButtonAction.ACTION_SHOOTUP] = Vector(0, -1)
}
local VECTOR_PER_SHOOT_ACTION_MIRRORED = {
	[ButtonAction.ACTION_SHOOTDOWN] = Vector(0, 1),
	[ButtonAction.ACTION_SHOOTLEFT] = Vector(1, 0),
	[ButtonAction.ACTION_SHOOTRIGHT] = Vector(-1, 0),
	[ButtonAction.ACTION_SHOOTUP] = Vector(0, -1)
}

---@class RubyOrbInhalingInfo
---@field frame integer
---@field currentDirection number
---@field doublePower boolean

---@class RubyOrbExhalingInfo
---@field angle number
---@field count integer
---@field timer integer
---@field prAng number
---@field doublePower boolean

TSIL.SaveManager.AddPersistentVariable(
	MilkshakeVol1,
	"RubyOrbInhalingInfoPerPlayer",
	{},
	TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)
TSIL.SaveManager.AddPersistentVariable(
	MilkshakeVol1,
	"RubyOrbExhalingInfoPerPlayer",
	{},
	TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param player EntityPlayer
---@param flags UseOrbFlag
local function CreateInhalingInfo(player, flags)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)

	local inhalingInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
		MilkshakeVol1,
		"RubyOrbInhalingInfoPerPlayer"
	)

	inhalingInfoPerPlayer[playerIndex] = {
		frame = Game():GetFrameCount(),
		currentDirection = player:GetAimDirection():GetAngleDegrees(),
		doublePower = TSIL.Utils.Flags.HasFlags(flags, enums.UseOrbFlags.DOUBLE_POWER)
	}
end


---@param player EntityPlayer
---@return RubyOrbInhalingInfo?
local function GetInhalingInfo(player)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)
	local inhalingInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
		MilkshakeVol1,
		"RubyOrbInhalingInfoPerPlayer"
	)

	return inhalingInfoPerPlayer[playerIndex]
end


---@param player EntityPlayer
local function RemoveInhalingInfo(player)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)
	local inhalingInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
		MilkshakeVol1,
		"RubyOrbInhalingInfoPerPlayer"
	)

	inhalingInfoPerPlayer[playerIndex] = nil
end


---@param player EntityPlayer
---@param angle number
---@param doublePower boolean
local function CreateExhalingInfo(player, angle, doublePower)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)
	local exhalingInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
		MilkshakeVol1,
		"RubyOrbExhalingInfoPerPlayer"
	)

	local numShots = NUM_SHOTS
	if doublePower then
		numShots = NUM_SHOTS_DOUBLE_POWER
	end

	exhalingInfoPerPlayer[playerIndex] = {
		angle = angle,
		count = numShots,
		timer = 0,
		prAng = 0,
		doublePower = doublePower
	}
end


---@param player EntityPlayer
---@return RubyOrbExhalingInfo?
local function GetExhalingInfo(player)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)
	local exhalingInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
		MilkshakeVol1,
		"RubyOrbExhalingInfoPerPlayer"
	)

	return exhalingInfoPerPlayer[playerIndex]
end


---@param player EntityPlayer
local function RemoveExhalingInfo(player)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)
	local exhalingInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
		MilkshakeVol1,
		"RubyOrbExhalingInfoPerPlayer"
	)

	exhalingInfoPerPlayer[playerIndex] = false
end


---@param player EntityPlayer
---@param angle number
---@param doublePower boolean
local function SpawnFireProjectile(player, angle, doublePower)
	local rng = player:GetCardRNG(enums.Orbs.FIRE)
	local shotSpeed = SHOT_SPEED
	if doublePower then
		shotSpeed = SHOT_SPEED_DOUBLE_POWER
	end

	local flame = TSIL.EntitySpecific.SpawnTear(
		TearVariant.FIRE,
		0,
		player.Position,
		shotSpeed * Vector.FromAngle(angle),
		player
	)
	flame:AddTearFlags(TearFlags.TEAR_SPECTRAL)
	TSIL.Entities.SetEntityData(
		MilkshakeVol1,
		flame,
		"RubyOrbProjectileDamage",
		5 + 5 * utility:GetCurrentChapter()
	)
	flame.CollisionDamage = 5 + 5 * utility:GetCurrentChapter()

	local sprite = flame:GetSprite()
	sprite:ReplaceSpritesheet(0, "gfx/Effects/Effect_005_Fire.png")
	sprite:LoadGraphics()

	TSIL.Entities.SetEntityData(
		MilkshakeVol1,
		flame,
		"IsRubyOrbFireProjectile",
		true
	)
end


---@param player EntityPlayer
function RubyOrb:UseCard(_, player, doublePower)
	CreateInhalingInfo(player, doublePower)
	local data = player:GetData()
	if not data.FireOrbLastDir ~= nil then data.FireOrbLastDir = 90 end
	SFXManager():Play(SoundEffect.SOUND_LOW_INHALE)
end
MilkshakeVol1:AddCallback(
	enums.Callbacks.ON_ORB_USE,
	RubyOrb.UseCard,
	enums.Orbs.FIRE
)


---@param player EntityPlayer
function CheckInhaling(player)
	local inhalingInfo = GetInhalingInfo(player)

	if not inhalingInfo then return end

	local aimDir = Vector(0, 0)
	local shootActions = TSIL.Input.GetShootActions()
	for _, shootAction in ipairs(shootActions) do
		local shootValue = Input.GetActionValue(shootAction, player.ControllerIndex)
		if Game():GetRoom():IsMirrorWorld() or MilkshakeVol1.API:IsInMirrorRoom() then
			aimDir = aimDir + VECTOR_PER_SHOOT_ACTION_MIRRORED[shootAction] * shootValue
		else
			aimDir = aimDir + VECTOR_PER_SHOOT_ACTION[shootAction] * shootValue
		end
	end

	local angle = aimDir:GetAngleDegrees()

	local data = player:GetData()
	if not data.FireOrbLastDir then data.FireOrbLastDir = 90 end
	if aimDir:Length() == 0 then
		angle = data.FireOrbLastDir
	else
		data.FireOrbLastDir = angle
	end

	inhalingInfo.currentDirection = angle

	local currentFrame = Game():GetFrameCount()
	local difference = currentFrame - inhalingInfo.frame

	if difference < INHALING_DURATION then return end

	RemoveInhalingInfo(player)
	CreateExhalingInfo(player, angle, inhalingInfo.doublePower)

	utility:SetBlindfold(player, true)
	player:AddNullCostume(enums.Costumes.INFERNO_ORB)

	SFXManager():Play(SoundEffect.SOUND_GHOST_ROAR)
end


---@param player EntityPlayer
function CheckExhaling(player)
	local info = GetExhalingInfo(player)
	if not info then return end

	info.timer = info.timer - 1
	if info.timer > 0 then return end

	info.count = info.count - 1
	if info.doublePower then
		info.timer = SHOT_DELAY_DOUBLE_POWER
	else
		info.timer = SHOT_DELAY
	end

	local rng = player:GetCardRNG(enums.Orbs.FIRE)

	local aimDir = player:GetAimDirection()
	local angle = aimDir:GetAngleDegrees()
	if (aimDir:Length() == 0) then angle = info.angle end
	angle = ((angle + 540 - info.angle) % 360) - 180
	angle = math.min(math.max(angle, -CLAMP_ANGLE), CLAMP_ANGLE)

	angle = TSIL.Utils.Math.Lerp(info.prAng, angle, BLEND_AMOUNT)
	info.prAng = angle

	angle = angle + rng:RandomInt(ANGLE_VARIANCE + 1) - (ANGLE_VARIANCE / 2)

	SpawnFireProjectile(player, angle + info.angle, info.doublePower)

	if info.count == 0 then
		RemoveExhalingInfo(player)
		player:TryRemoveNullCostume(enums.Costumes.INFERNO_ORB)
		utility:SetBlindfold(player, false)
	end
end


---@param player EntityPlayer
function RubyOrb:PostPEffectUpdate(player)

-- 	local info = GetExhalingInfo(player)
-- 	if not info then return end
--
-- 	-- new room fire orb cancel
-- 	if Game():GetRoom():GetFrameCount() == 0 then
-- 		RemoveExhalingInfo(player)
-- 		player:TryRemoveNullCostume(enums.Costumes.INFERNO_ORB)
-- 		utility:SetBlindfold(player, false)
-- 		return
-- 	end

	CheckInhaling(player)

	CheckExhaling(player)
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, RubyOrb.PostPEffectUpdate)

local isTakingBossArmorDamage = false

---@param entity Entity
---@param amount integer
---@param flags DamageFlag
---@param source EntityRef
---@param countdownFrames integer
function RubyOrb:OnEntityTakeDamage(entity, amount, flags, source, countdownFrames)
	if isTakingBossArmorDamage then return end

	local sourceEntity = source.Entity

	if not sourceEntity then return end

	local isRubyOrbProjectile = TSIL.Entities.GetEntityData(
		MilkshakeVol1,
		sourceEntity,
		"IsRubyOrbFireProjectile"
	)

	if not isRubyOrbProjectile then return end

	local fixedDamage = TSIL.Entities.GetEntityData(
		MilkshakeVol1,
		sourceEntity,
		"RubyOrbProjectileDamage"
	)
	isTakingBossArmorDamage = true
	entity:TakeDamage(fixedDamage, flags | DamageFlag.DAMAGE_IGNORE_ARMOR, source, countdownFrames)
	isTakingBossArmorDamage = false

	return false
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_ENTITY_TAKE_DMG,
	RubyOrb.OnEntityTakeDamage
)


-- Returns the shortest distance to an angle
local function ShortAngleDis(from, to)
	local maxAngle = 360
	local disAngle = (to - from) % maxAngle

	return ((2 * disAngle) % maxAngle) - disAngle
end


-- Lerps the angle and returns the result
local function LerpAngle(from, to, fraction)
	return from + ShortAngleDis(from, to) * fraction
end


---@param player EntityPlayer
local function OnPlayerRender(player)
	local inhalingInfo = GetInhalingInfo(player)
	if not inhalingInfo then return end

	local renderPos = Isaac.WorldToScreen(player.Position)

	local newRotation = inhalingInfo.currentDirection - 90
	ARROW_SPRITE.FlipX = Game():GetRoom():IsMirrorWorld()
	ARROW_SPRITE.Rotation = LerpAngle(ARROW_SPRITE.Rotation, newRotation, 0.35)
	ARROW_SPRITE:Render(renderPos)
end


function RubyOrb:OnRender()
	for _, player in ipairs(TSIL.Players.GetPlayers()) do
		OnPlayerRender(player)
	end
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_POST_RENDER,
	RubyOrb.OnRender
)


---@param tear EntityTear
function RubyOrb:OnTearUpdate(tear)
	local isRubyOrbProjectile = TSIL.Entities.GetEntityData(
		MilkshakeVol1,
		tear,
		"IsRubyOrbFireProjectile"
	)
	if not isRubyOrbProjectile then return end

	local shopKeepers = Isaac.FindByType(EntityType.ENTITY_SHOPKEEPER)
	local radius = tear.Size + 20
	for _, shopKeeper in ipairs(shopKeepers) do
		if shopKeeper.Position:DistanceSquared(tear.Position) < radius^2 then
			shopKeeper:Kill()
		end
	end
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_POST_TEAR_UPDATE,
	RubyOrb.OnTearUpdate,
	TearVariant.FIRE
)


---@param entity Entity
function RubyOrb:OnTearRemove(entity)
	if TSIL.Rooms.IsLeavingRoom() then return end

	local isFireProjectile = TSIL.Entities.GetEntityData(
		MilkshakeVol1,
		entity,
		"IsRubyOrbFireProjectile"
	)
	if not isFireProjectile then return end

	local poof = TSIL.EntitySpecific.SpawnEffect(
		EffectVariant.POOF01,
		1,
		entity.Position
	)
	poof.Color = Color(1, 0.6, 0.5, 0.5, 0.5, 0.25, 0)
	poof.SpriteScale = Vector(0.6, 0.6)
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_POST_ENTITY_REMOVE,
	RubyOrb.OnTearRemove,
	EntityType.ENTITY_TEAR
)

--[
function RubyOrb:OnNewRoomEarly()
	for _, player in ipairs(TSIL.Players.GetPlayers()) do
		if GetInhalingInfo(player) or GetExhalingInfo(player) then
			RemoveInhalingInfo(player)
			RemoveExhalingInfo(player)
			player:TryRemoveNullCostume(enums.Costumes.INFERNO_ORB)
			utility:SetBlindfold(player, false)
		end
	end
end
MilkshakeVol1:AddPriorityCallback(
	TSIL.Enums.CustomCallback.POST_NEW_ROOM_EARLY,
	math.mininteger,
	RubyOrb.OnNewRoomEarly
)
--]