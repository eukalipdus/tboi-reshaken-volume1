local RubyOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local INHALING_DURATION = 60
local ANGLE_VARIANCE = 28;
local MAX_ANGLE = 180;
local BLEND_AMOUNT = 0.4;

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
---@param doublePower boolean
local function CreateInhalingInfo(player, doublePower)
	local playerIndex = TSIL.Players.GetPlayerIndex(player)

	local inhalingInfoPerPlayer = TSIL.SaveManager.GetPersistentVariable(
		MilkshakeVol1,
		"RubyOrbInhalingInfoPerPlayer"
	)

	inhalingInfoPerPlayer[playerIndex] = {
		frame = Game():GetFrameCount(),
		currentDirection = player:GetAimDirection():GetAngleDegrees(),
		doublePower = doublePower
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

	local aimDir = player:GetAimDirection()
	local angle = aimDir:GetAngleDegrees()
	if aimDir:Length() == 0 then
		angle = 90.0
	end

	inhalingInfo.currentDirection = angle

	local currentFrame = Game():GetFrameCount()
	local difference = currentFrame - inhalingInfo.frame

	if difference < INHALING_DURATION then return end

	RemoveInhalingInfo(player)
	CreateExhalingInfo(player, angle, inhalingInfo.doublePower)

	utility:SetCanShoot(player, false)
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
		utility:SetCanShoot(player, true)
	end
end


---@param player EntityPlayer
function RubyOrb:PostPEffectUpdate(player)
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

	isTakingBossArmorDamage = true
	entity:TakeDamage(amount, flags | DamageFlag.DAMAGE_IGNORE_ARMOR, source, countdownFrames)
	isTakingBossArmorDamage = false

	return false
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_ENTITY_TAKE_DMG,
	RubyOrb.OnEntityTakeDamage
)


---@param player EntityPlayer
function RubyOrb:OnPlayerRender(player)
	local inhalingInfo = GetInhalingInfo(player)
	if not inhalingInfo then return end

	if not player:IsExtraAnimationFinished() then return end

	local renderPos = Isaac.WorldToScreen(player.Position)

	ARROW_SPRITE.Rotation = inhalingInfo.currentDirection - 90
	ARROW_SPRITE:Render(renderPos)
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_POST_PLAYER_RENDER,
	RubyOrb.OnPlayerRender
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
		0,
		entity.Position
	)
	poof.Color = Color(1, 1, 1, 0.5)
	poof.SpriteScale = Vector(0.6, 0.6)
end
MilkshakeVol1:AddCallback(
	ModCallbacks.MC_POST_ENTITY_REMOVE,
	RubyOrb.OnTearRemove,
	EntityType.ENTITY_TEAR
)