local RubyOrb = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

--[[Customisation]]
local angleVariance = 20;
local maxAngle = 180;
local blendAmount = 0.2;

local numShots = 35;
local shootTime = 70;

local shotSpeed = 7;

--Other Variables
local clampAngle = (maxAngle/2) - (angleVariance/2);
local shotDelay = shootTime/numShots;

function RubyOrb:UseCard(_, player, flags)
	local playerUsingLyraData = utility:GetTemporaryPlayerData(player, "UsingLyraData")

    if playerUsingLyraData then return end

	local isDoublePower = utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
	utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", nil)

	local aimDir = player:GetAimDirection()
	local angle = aimDir:GetAngleDegrees()
	if (aimDir:Length() == 0) then angle = 90.0 end

	utility:SetData(player, "RubyOrb", {
		angle = angle,
		count = (utility:GetData(player, "RubyOrb") and utility:GetData(player, "RubyOrb").count or 0) + numShots,
		timer = 0,
		prAng = 0,
	})
	SFXManager():Play(SoundEffect.SOUND_GHOST_ROAR)
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, RubyOrb.UseCard, enums.Cards.RUBY_ORB)

function RubyOrb:PostNewRoom()
	for i = 0, Game():GetNumPlayers() do
		utility:SetData(Isaac.GetPlayer(i), "RubyOrb", {
			angle = 0,
			count = 0,
			timer = 0,
			prAng = 0,
		})
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, RubyOrb.PostNewRoom)

function RubyOrb:PostPEffectUpdate(player)
	local info = utility:GetData(player, "RubyOrb")
	if (not info or info.count <= 0) then return end
	info.timer  = info.timer - 1
	if (info.timer > 0) then return end
	info.count = info.count - 1
	info.timer = shotDelay

    local rng = player:GetCardRNG(enums.Cards.RUBY_ORB)

	local aimDir = player:GetAimDirection()
	local angle = aimDir:GetAngleDegrees()
	if (aimDir:Length() == 0) then angle = info.angle end
	angle = ((angle + 540 - info.angle)%360) - 180
	angle = math.min(math.max(angle, -clampAngle), clampAngle)

	angle = TSIL.Utils.Math.Lerp(info.prAng, angle, blendAmount)
	info.prAng = angle

	angle = angle + rng:RandomInt(angleVariance+1) - (angleVariance/2)
	---@diagnostic disable-next-line: param-type-mismatch
	local flame = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_FIRE, 0, player.Position, shotSpeed * Vector.FromAngle(angle+info.angle), player):ToProjectile()
	flame.Height = player.TearHeight
	--flame.CollisionDamage = 5 + 3*player.Damage
	flame.CollisionDamage = 5 * utility:GetCurrentChapter()
	flame.ProjectileFlags = flame.ProjectileFlags | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER |ProjectileFlags.DECELERATE  | ProjectileFlags.NO_WALL_COLLIDE
	utility:SetData(
		flame,
		"IsRubyOrbFireProjectile",
		true
	)
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, RubyOrb.PostPEffectUpdate)

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

	local isRubyOrbProjectile = utility:GetData(
		sourceEntity,
		"IsRubyOrbFireProjectile"
	)

	if not isRubyOrbProjectile then return end

	isTakingBossArmorDamage = true
	entity:TakeDamage(amount, flags | DamageFlag.DAMAGE_IGNORE_ARMOR, source, countdownFrames)
	isTakingBossArmorDamage = false

	return false
end
milkshakeMod:AddCallback(
	ModCallbacks.MC_ENTITY_TAKE_DMG,
	RubyOrb.OnEntityTakeDamage
)