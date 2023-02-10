local RubyOrb = {}
local enums = require "milkshake_scripts.enums"

local NotGetData = {}

--[[Customisation]]
local angleVariance = 20;
local maxAngle = 180;
local blendAmount = 0.2;

local numShots = 35;
local shootTime = 70;

local shotSpeed = 8;
local fireLifespan = 25;
local fireStartScale = 0.1; --Greater than 0.
local fireTearOffset = 5;

--Other Variables
local clampAngle = (maxAngle/2) - (angleVariance/2);
local shotDelay = shootTime/numShots;

function RubyOrb:UseCard(_, player, flags)
	local aimDir = player:GetAimDirection()
	local angle = aimDir:GetAngleDegrees()
	if (aimDir:Length() == 0) then angle = 90.0 end
	
	NotGetData[GetPtrHash(player)] = {
		["angle"] = angle,
		["count"] = NotGetData[GetPtrHash(player)].count + numShots,
		["timer"] = 0,
		["prAng"] = 0;
	}
	SFXManager():Play(SoundEffect.SOUND_GHOST_ROAR)
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, RubyOrb.UseCard, enums.Cards.RUBY_ORB)

function RubyOrb:PostPEffectUpdate(player)
	local info = NotGetData[GetPtrHash(player)]
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

	angle = angle + rng:RandomInt(angleVariance+1) - (angleVariance/2)
	---@diagnostic disable-next-line: param-type-mismatch
	local flame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, player.Position + player:GetAimDirection()*fireTearOffset, shotSpeed * Vector.FromAngle(angle+info.angle), player):ToEffect()
	flame.Scale = fireStartScale
	flame.Timeout = fireLifespan
	flame.CollisionDamage = (10 + 3*player.Damage)/flame.Scale
	NotGetData[GetPtrHash(flame)] = true
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, RubyOrb.PostPEffectUpdate)

function RubyOrb:PostEffectUpdate(flame)
	if not NotGetData[GetPtrHash(flame)] then return end
	flame.Scale = ((fireLifespan-flame.Timeout)/fireLifespan)*(1-fireStartScale) + fireStartScale
	flame.CollisionDamage = (10 + 3*flame.SpawnerEntity:ToPlayer().Damage)/flame.Scale
	if (flame.Timeout == 0) then 
		NotGetData[GetPtrHash(flame)] = nil 
		flame:Remove()
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, RubyOrb.PostEffectUpdate, EffectVariant.HOT_BOMB_FIRE)

function RubyOrb:PostPlayerInit(player)
	NotGetData[GetPtrHash(player)] = {
		["angle"] = 0,
		["count"] = 0,
		["timer"] = 0,
		["prAng"] = 0;
	}
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, RubyOrb.PostPlayerInit)

function RubyOrb:PreGameExit()
	NotGetData = {}
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, RubyOrb.PreGameExit)

function RubyOrb:PostEffectInit(flame)
	if not NotGetData[GetPtrHash(flame)] then return end
end
milkshakeMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, RubyOrb.PostEffectInit, EffectVariant.HOT_BOMB_FIRE)