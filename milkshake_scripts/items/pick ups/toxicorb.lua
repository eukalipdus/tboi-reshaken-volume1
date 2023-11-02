local ToxicOrb = {}

local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

ToxicOrb.TearVariant = TearVariant.STONE
ToxicOrb.Timeout = 30*60
ToxicOrb.GfxPath = "gfx/tears/toxic_orb_tear.png"
ToxicOrb.InitSize = 1.5
ToxicOrb.SizeUp = 0.05
ToxicOrb.ExtraDmgTickFrame = 15
ToxicOrb.BaseDMG = 3
ToxicOrb.SizeLimit = 4
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
			pooffy(pickup.Position, Color(1,1,1, 1, 0.5,0.5,0))
			for _ = 1, ToxicOrb.Hearts[pickup.SubType] do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, pickup.Position, pickup.Velocity, nil)
			end
		elseif pickup.Type == EntityType.ENTITY_SLOT and pickup.Variant == 4 then
			pickup:Remove()
			Isaac.Spawn(EntityType.ENTITY_SLOT, 18, 0, pickup.Position, Vector.Zero, nil)
			pooffy(pickup.Position, Color(1,1,1, 1, 0.5,0.5,0))
		end
	end
end

function ToxicOrb:CloudUpdate(poisonCloud)
	if poisonCloud.Timeout <= 0 then
		if poisonCloud:GetData().ToxicOrbCloud then poisonCloud:GetData().ToxicOrbCloud = nil end
		poisonCloud.Scale = poisonCloud.Scale - 0.1
		poisonCloud.SpriteScale = ToxicOrb.BaseSpriteScale * poisonCloud.Scale
		if poisonCloud.Scale < 0.5 then
			poisonCloud:Remove()
			return
		end
	end
	if not poisonCloud:GetData().ToxicOrbCloud then return end
	local area = 40 * (poisonCloud.Scale)
	if poisonCloud.FrameCount%ToxicOrb.ExtraDmgTickFrame == 0 then
		for _, enemy in pairs(Isaac.FindInRadius(poisonCloud.Position, area, EntityPartition.ENEMY)) do
			if enemy:IsVulnerableEnemy() and not enemy:HasMortalDamage() then
				enemy:SetColor(Color(1,1,1, 1, 0.5,0.5,0),ToxicOrb.ExtraDmgTickFrame,1,true,true)
				enemy:TakeDamage(utility:GetCurrentChapter()+ToxicOrb.BaseDMG, DamageFlag.DAMAGE_POISON_BURN, EntityRef(poisonCloud), 1)
				enemy:GetData().ToxicDead = true
				if poisonCloud.Scale < ToxicOrb.SizeLimit then
					poisonCloud.Scale = poisonCloud.Scale + (ToxicOrb.SizeUp/(utility:GetCurrentChapter()+1))
					poisonCloud.SpriteScale = ToxicOrb.BaseSpriteScale * poisonCloud.Scale
				end
				if enemy:HasMortalDamage() then -- I dealt mortal damage
					local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, enemy.Position, Vector.Zero, nil):ToEffect()
					fart:SetColor(Color(1,1,1, 1, 0.3,0.3,0),-1,1,true,true)
					fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, enemy.Position, Vector.Zero, nil):ToEffect()
					fart:SetColor(Color(1,1,1, 1, 0.5,0.3,0),-1,1,true,true)
					if poisonCloud.Scale < utility:GetCurrentChapter()+ToxicOrb.BaseDMG then
						poisonCloud.Scale = poisonCloud.Scale + (ToxicOrb.SizeUp/(utility:GetCurrentChapter()+1))
						poisonCloud.SpriteScale = ToxicOrb.BaseSpriteScale * poisonCloud.Scale
					end
					SFXManager():Play(SoundEffect.SOUND_MOTHER_WRIST_EXPLODE, 1.5)
				end
			end
		end
	end
	Rotten(poisonCloud.Position, area)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, ToxicOrb.CloudUpdate, enums.Effects.TOXIC_GAS)

function ToxicOrb:PEffectUpdate(player)
	if utility:GetData(player, "ToxicOrbShoot") then
		local tear = utility:GetData(player, "ToxicOrbShoot")
		if not tear:Exists() then
			utility:SetData(player, "ToxicOrbShoot", nil)
			local FartArea = 135
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, tear.Position, Vector.Zero, player):ToEffect()
			fart:SetColor(Color(1,1,1, 1, 0.3,0.3,0),-1,1,true,true)
			fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, tear.Position, Vector.Zero, player):ToEffect()
			fart.SpriteScale = fart.SpriteScale * ToxicOrb.InitSize
			fart:SetColor(Color(1,1,1, 1, 0.5,0.3,0),-1,1,true,true)
			Rotten(tear.Position, FartArea)
			local poisonCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.TOXIC_GAS, 0, tear.Position, Vector.Zero, player):ToEffect()
			poisonCloud.Scale = ToxicOrb.InitSize * poisonCloud.Scale
			poisonCloud.SpriteScale = ToxicOrb.BaseSpriteScale * poisonCloud.Scale
			poisonCloud:SetColor(Color(1,1,1, 1, 0.5,0.5,0),-1,1,true,true)
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
	        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, ToxicOrb.TearVariant , 0, player.Position, player:GetAimDirection()*14, nil):ToTear() --BOBS_HEAD
			tear.Height = -72
			tear.FallingSpeed = -5
			tear.FallingAcceleration = 1
			tear.CollisionDamage = 0
			tear:GetData().ToxicBomb = true
			local orbSprite = tear:GetSprite()
			orbSprite:ReplaceSpritesheet(0, ToxicOrb.GfxPath)
			orbSprite:LoadGraphics()
			utility:SetData(player, "ToxicOrbShoot", tear)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ToxicOrb.PEffectUpdate)


function ToxicOrb:OnToxicOrbUse(card, player)
    utility:SetData(player, "ToxicOrbLift", true)
    player:AnimateCard(card, "LiftItem")
end
MilkshakeVol1:AddCallback(
    enums.Callbacks.ON_ORB_USE,
    ToxicOrb.OnToxicOrbUse,
    enums.Orbs.POISON
)