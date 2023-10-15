local ToxicOrb = {}

local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

ToxicOrb.TearVariant = TearVariant.BLUE
ToxicOrb.Timeout = 30*30
ToxicOrb.GfxPath = ""
ToxicOrb.SizeUp = 0.5
ToxicOrb.Hearts = {
	[HeartSubType.HEART_FULL] =1,
	[HeartSubType.HEART_HALF] = 1,
	[HeartSubType.HEART_DOUBLEPACK] =2,
}

--[[
function ToxicOrb:TearUpdate(tear)
	if not tear:GetData().ToxicBomb then return end
	--if tear:CollidesWithGrid() or
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, ToxicOrb.TearUpdate, ToxicOrb.TearVariant)

function ToxicOrb:TearCollision(tear, collider)
	if not tear:GetData().ToxicBomb then return end


end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, ToxicOrb.TearCollision, ToxicOrb.TearVariant)
--]]



function ToxicOrb:CloudUpdate(poisonCloud)
	if not poisonCloud:GetData().ToxicOrbCloud then return end
	for _, enemy in pairs(Isaac.FindInRadius(poisonCloud.Position, poisonCloud.Size * (poisonCloud.Scale-0.2), EntityPartition.ENEMY)) do
		if enemy:ToNPC() and enemy:HasMortalDamage() then
			poisonCloud.Scale = poisonCloud.Scale + 0.5
		end
	end
	for _, hearts in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART)) do
		if ToxicOrb.Hearts[hearts.SubType] then
			hearts.Remove()
			for _ = 1, ToxicOrb.Hearts[hearts.SubType] do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, hearts.Position, hearts.Velocity, nil)
			end
		end
	end
	for _, beggar in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT, 4)) do
		beggar:Remove()
		Isaac.Spawn(EntityType.ENTITY_SLOT, 18, 0, beggar.Position, Vector.Zero, nil)
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, ToxicOrb.CloudUpdate, EffectVariant.SMOKE_CLOUD)

function ToxicOrb:PEffectUpdate(player)
	if utility:GetData(player, "ToxicOrbShoot") then
		local tear = utility:GetData(player, "ToxicOrbShoot")
		if not tear:Exists() then
			Game():Fart(tear.Position, 80, player)
			Game():BombExplosionEffects(tear.Position, 0)
			local poisonCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, tear.Position, Vector.Zero, player):ToEffect()
			poisonCloud:GetData().ToxicOrbCloud = true
			poisonCloud:SetTimeout(ToxicOrb.Timeout)
		end
	elseif utility:GetData(player, "ToxicOrbLift") then
		if not player:IsHoldingItem() then
			player:AddCard(enums.Orbs.POISON)
		elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then
            utility:SetData(player, "ToxicOrbLift", nil)
	        --ToxicBomb(player.Position, player:GetLastDirection())
	        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, ToxicOrb.TearVariant , 0, player.Position, player:GetAimDirection()*7, nil):ToTear() --BOBS_HEAD
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