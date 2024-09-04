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
ToxicOrb.TearSpeedMulti = 14
ToxicOrb.BaseSpriteScale = Vector(1.18758, 1.18758)
ToxicOrb.Hearts = {
	[HeartSubType.HEART_FULL] =1,
	[HeartSubType.HEART_HALF] = 1,
	[HeartSubType.HEART_DOUBLEPACK] =2,
}
ToxicOrb.BeggarVariants = {
	[4] = true,
}
ToxicOrb.Coins = {
	[CoinSubType.COIN_PENNY] = 1,
	[CoinSubType.COIN_DOUBLEPACK] = 2
}

function MilkshakeVol1.API:AddToxicOrbBeggar(beggarType)
	ToxicOrb.BeggarVariants[beggarType] = true
end


local function pooffy(position, color)
	SFXManager():Play(SoundEffect.SOUND_SUMMON_POOF, 1.5)
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, position, Vector.Zero, nil)
	if color then
		poof:SetColor(color,-1,1, false, false)
	end
end

local function Rotten(pos, area)
	for _, pickup in pairs(Isaac.FindInRadius(pos, area, EntityPartition.PICKUP)) do
		if pickup:ToPickup() then
			pickup = pickup:ToPickup()
			if not pickup.GetData().ToxicMorph then
				if pickup.Variant == PickupVariant.PICKUP_HEART and ToxicOrb.Hearts[pickup.SubType] then
					--pickup:Remove()
					pooffy(pickup.Position, Color(1,1,1, 1, 0.5,0.5,0))
					local num = ToxicOrb.Hearts[pickup.SubType]
					pickup:Morph(pickup.Type, pickup.Variant, HeartSubType.HEART_ROTTEN)
					if num > 1 then
						for _ = 2, num do
							Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, pickup.Position, pickup.Velocity+(RandomVector()*4), nil)
						end
					end
				elseif pickup.Variant == PickupVariant.PICKUP_COIN and ToxicOrb.Coins[pickup.SubType] then -- and pickup.SubType ~= enums.Coins.ROTTEN_PENNY then -- eh?
					--print("coin subtype: ", pickup.SubType, enums.Coins.ROTTEN_PENNY) -- for debug
					--pickup:Remove()
					pooffy(pickup.Position, Color(1,1,1, 1, 0.5,0.5,0))
					local num = ToxicOrb.Coins[pickup.SubType]
					local pickupMorphed = pickup:Morph(pickup.Type, pickup.Variant, enums.Coins.ROTTEN_PENNY, false, true)
					pickupMorphed.GetData().ToxicMorph = true
					--Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, enums.Coins.ROTTEN_PENNY, pickup.Position, Vector.Zero, nil)
					if num > 1 then
						for _ = 2, num do
							local pickupMorphed = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, enums.Coins.ROTTEN_PENNY, pickup.Position, pickup.Velocity+(RandomVector()*4), nil)
							pickupMorphed.GetData().ToxicMorph = true
						end
					end
				end
			end
		elseif pickup.Type == EntityType.ENTITY_SLOT and ToxicOrb.BeggarVariants[pickup.Variant] then
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
				enemy:AddSlowing(EntityRef(poisonCloud), ToxicOrb.ExtraDmgTickFrame, 0.5, Color(1,1,1))
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
					if poisonCloud.Scale < ToxicOrb.SizeLimit then
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

local function ThrowOrb(player, vector)
	--vector = vector or player:GetAimDirection() -- :GetShootingInput()
	utility:SetData(player, "ToxicOrbLift", nil)
	local velo = (vector*ToxicOrb.TearSpeedMulti)+player:GetTearMovementInheritance(player:GetMovementInput())
	local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, ToxicOrb.TearVariant , 0, player.Position, velo, nil):ToTear() --BOBS_HEAD
	--local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, ToxicOrb.TearVariant , 0, player.Position, vector*14, nil):ToTear() --BOBS_HEAD
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

function ToxicOrb:PEffectUpdate(player)
	if utility:GetData(player, "ToxicOrbShoot") then
		local tear = utility:GetData(player, "ToxicOrbShoot")
		if not tear:Exists() then
			utility:SetData(player, "ToxicOrbShoot", nil)
			local double = utility:GetData(player, "ToxicDouble") and 2 or 1
			local size = ToxicOrb.InitSize
			local area = 135
			if double > 1 then
				size = size * 1.5
				area = area * 1.5
			end
			utility:SetData(player, "ToxicDouble", nil)
			local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 1, tear.Position, Vector.Zero, player):ToEffect()
			fart:SetColor(Color(1,1,1, 1, 0.3,0.3,0),-1,1,true,true)
			fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, tear.Position, Vector.Zero, player):ToEffect()
			fart.SpriteScale = fart.SpriteScale * size
			fart:SetColor(Color(1,1,1, 1, 0.5,0.3,0),-1,1,true,true)
			local poisonCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, enums.Effects.TOXIC_GAS, 0, tear.Position, Vector.Zero, player):ToEffect()
			poisonCloud.Scale = size * poisonCloud.Scale
			poisonCloud.SpriteScale = ToxicOrb.BaseSpriteScale * poisonCloud.Scale
			poisonCloud:SetColor(Color(1,1,1, 1, 0.5,0.5,0),-1,1,true,true)
			poisonCloud:GetData().ToxicOrbCloud = true
			poisonCloud:SetTimeout(ToxicOrb.Timeout * double)
			poisonCloud.DepthOffset = 500
			SFXManager():Play(SoundEffect.SOUND_PESTILENCE_HEAD_EXPLODE, 1.5 * double)
			Rotten(tear.Position, area)
		end
	elseif utility:GetData(player, "ToxicOrbLift") then
		if not player:IsHoldingItem() then -- set it back to ur pocket
			player:AnimateCard(enums.Orbs.POISON, "LiftItem")
		elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then
			player:AnimateCard(enums.Orbs.POISON, "HideItem")
			ThrowOrb(player, player:GetAimDirection():Normalized()) -- GetAimDirection GetShootingInput
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ToxicOrb.PEffectUpdate)


function ToxicOrb:OnToxicOrbUse(card, player, flags)
	if flags & enums.UseOrbFlags.DOUBLE_POWER > 0 then
		utility:SetData(player, "ToxicDouble", true)
	end
	if flags & enums.UseOrbFlags.NO_SOUND == 0 then
		--player:GetSprite():Play("LiftItem", true)
		player:AnimateCard(card, "LiftItem")
	end

	utility:SetData(player, "ToxicOrbLift", true)
end
MilkshakeVol1:AddCallback(
    enums.Callbacks.ON_ORB_USE,
    ToxicOrb.OnToxicOrbUse,
    enums.Orbs.POISON
)