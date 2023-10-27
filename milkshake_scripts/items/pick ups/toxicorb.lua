local ToxicOrb = {}

local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

ToxicOrb.TearVariant = TearVariant.BLUE
ToxicOrb.Timeout = 30*15
ToxicOrb.GfxPath = "gfx/tears/toxic_orb_tear.png"
ToxicOrb.InitSize = 1.5
ToxicOrb.SizeUp = 0.1
ToxicOrb.TearHigh = -42
ToxicOrb.ExtraDmgTickFrame = 15
ToxicOrb.BaseSpriteScale = Vector(1.18758, 1.18758)
ToxicOrb.Hearts = {
	[HeartSubType.HEART_FULL] =1,
	[HeartSubType.HEART_HALF] = 1,
	[HeartSubType.HEART_DOUBLEPACK] =2,
}


local function pooffy(position, color)
	SFXManager():Play(SoundEffect.SOUND_SUMMON_POOF, 1.5)
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, position, Vector.Zero, nil)
	if color then
		poof:SetColor(color,-1,1, false, false)
	end
end

local function Rotten(pos, area)
	for _, pickup in pairs(Isaac.FindInRadius(pos, area, EntityPartition.PICKUP)) do
		if pickup:ToPickup() and pickup.Variant == PickupVariant.PICKUP_HEART and ToxicOrb.Hearts[pickup.SubType] then
			pickup:Remove()
			pooffy(pickup.Position, Color(0.1,1,0.1))
			for _ = 1, ToxicOrb.Hearts[pickup.SubType] do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, pickup.Position, pickup.Velocity, nil)
			end
		elseif pickup.Type == EntityType.ENTITY_SLOT and pickup.Variant == 4 then
			pickup:Remove()
			Isaac.Spawn(EntityType.ENTITY_SLOT, 18, 0, pickup.Position, Vector.Zero, nil)
			pooffy(pickup.Position, Color(0.1,1,0.1))
		end
	end
end

function ToxicOrb:CloudUpdate(poisonCloud)
	if not poisonCloud:GetData().ToxicOrbCloud then return end
	local area = 40 * (poisonCloud.Scale)
	for _, enemy in pairs(Isaac.FindInRadius(poisonCloud.Position, area, EntityPartition.ENEMY)) do
		if enemy:ToNPC() then
			if not enemy:HasEntityFlags(EntityFlag.FLAG_POISON) and poisonCloud.FrameCount%ToxicOrb.ExtraDmgTickFrame == 0 then
				enemy:TakeDamage(utility:GetCurrentChapter(), DamageFlag.DAMAGE_POISON_BURN, EntityRef(poisonCloud), 15)
			end
			if enemy:HasMortalDamage() and not enemy:GetData().ToxicDead then
				enemy:GetData().ToxicDead = true
				poisonCloud.Scale = poisonCloud.Scale + ToxicOrb.SizeUp
				poisonCloud.SpriteScale = ToxicOrb.BaseSpriteScale * poisonCloud.Scale
			end
		end
	end
	Rotten(poisonCloud.Position, area)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, ToxicOrb.CloudUpdate, EffectVariant.SMOKE_CLOUD)

function ToxicOrb:PEffectUpdate(player)
	if utility:GetData(player, "ToxicOrbShoot") then
		local tear = utility:GetData(player, "ToxicOrbShoot")
		if not tear:Exists() then
			utility:SetData(player, "ToxicOrbShoot", nil)
			local FartArea = 135
			Game():Fart(tear.Position, FartArea, player, 1.6)
			SFXManager():Stop(SoundEffect.SOUND_FART) -- idk
			Rotten(tear.Position, FartArea)
			--Game():BombExplosionEffects(tear.Position, 0)
			local poisonCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, tear.Position, Vector.Zero, player):ToEffect()
			poisonCloud.Scale = ToxicOrb.InitSize * poisonCloud.Scale
			poisonCloud.CollisionDamage = 0
			--poisonCloud.CollisionDamage = utility:GetCurrentChapter()
			poisonCloud:GetData().ToxicOrbCloud = true
			poisonCloud:SetTimeout(ToxicOrb.Timeout)
			SFXManager():Play(SoundEffect.SOUND_PESTILENCE_HEAD_EXPLODE, 1.5)
		end
	elseif utility:GetData(player, "ToxicOrbLift") then
		if not player:IsHoldingItem() then
			player:AddCard(enums.Orbs.POISON)
			utility:SetData(player, "ToxicOrbLift", nil)
		elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then
			player:AnimateCard(enums.Orbs.POISON, "HideItem")
            utility:SetData(player, "ToxicOrbLift", nil)
	        --ToxicBomb(player.Position, player:GetLastDirection())
	        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, ToxicOrb.TearVariant , 0, player.Position, player:GetAimDirection()*14, nil):ToTear() --BOBS_HEAD
			tear.Height = ToxicOrb.TearHigh
			tear.FallingSpeed = 1.35
			tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
			tear.CollisionDamage = 0
			tear:GetData().ToxicBomb = true
			local orbSprite = tear:GetSprite()
			orbSprite:ReplaceSpritesheet(0, ToxicOrb.GfxPath)
			orbSprite:LoadGraphics()
			--SFXManager():Play(SoundEffect.SOUND_FETUS_JUMP, 2)
			 utility:SetData(player, "ToxicOrbShoot", tear)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ToxicOrb.PEffectUpdate)


function ToxicOrb:OnToxicOrbUse(card, player)
    utility:SetData(player, "ToxicOrbLift", true)
    --EffectVariant.SMOKE_CLOUD
    player:AnimateCard(card, "LiftItem")
    --player:UseActiveItem(CollectibleType.COLLECTIBLE_MEGA_BEAN)
end
MilkshakeVol1:AddCallback(
    MilkshakeVol1.enums.Callbacks.ON_ORB_USE,
    ToxicOrb.OnToxicOrbUse,
    enums.Orbs.POISON
)