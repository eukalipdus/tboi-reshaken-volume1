local RubyOrb = {}
local enums = require "milkshake_scripts.enums"

--[[Customisation]]
local fireAngle = 20;
local fireRange = 180;
local blendAmount = 0.2;

local numShots = 35;
local shootTime = 70;

local shotSpeed = 8;
local fireLifespan = 25;

--Other Variables
local clampAngle = (fireRange/2) - (fireAngle/2);
local shotDelay = shootTime/numShots;

function RubyOrb:OnRubyOrbUse(_, player, flags)
	local aimDir = player:GetAimDirection()
	local angle = aimDir:GetAngleDegrees()
	if (aimDir:Length() == 0) then angle = 90.0 end
	
	player:GetData().RubyOrb = {
		["angle"] = angle,
		["count"] = numShots,
		["timer"] = 0,
		["prAng"] = 0;
	}
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, RubyOrb.OnRubyOrbUse, enums.Cards.RUBY_ORB)

function RubyOrb:OnPeffectUpdate(player)
	local info = player:GetData().RubyOrb
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

	angle = (1-blendAmount) * info.prAng + blendAmount * angle
	info.prAng = angle

	angle = angle + rng:RandomInt(fireAngle+1) - (fireAngle/2)
	Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, player.Position, shotSpeed * Vector.FromAngle(angle+info.angle), player):ToEffect().Timeout = fireLifespan
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, RubyOrb.OnPeffectUpdate)