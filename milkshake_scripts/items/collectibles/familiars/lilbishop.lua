local lilBishop = {}
local enums = MilkshakeVol1.enums
local sfx = SFXManager()

lilBishop.BlockCooldown = 150 -- 5*30
lilBishop.BlockChance = 0.2
--lilBishop.ShieldTimeout = 120
lilBishop.LaserFade = 10
lilBishop.FadeCounter = 15
--lilBishop.costumeBookShadow = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
lilBishop.ShieldEffect = Isaac.GetEntityVariantByName("Lil Bishop Shield")
lilBishop.IgnoreFlag = DamageFlag.DAMAGE_INVINCIBLE
lilBishop.bffsMultiplier = 2
lilBishop.ShieldOffset = Vector(0, -12.5)
lilBishop.DepthOffset = 100
lilBishop.AlternativeSprite = "gfx/familiar/familiar_lilbishop_alt.png"
lilBishop.BaseSprite = "gfx/familiar/familiar_lilbishop.png"

--local game = Game()

function lilBishop:OnFamiliarCache(player, cacheFlag)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.LIL_BISHOP,
        enums.Familiars.LIL_BISHOP
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    lilBishop.OnFamiliarCache,
	CacheFlag.CACHE_FAMILIARS
)

--- PLAYER TAKE DMG --
function lilBishop:onPlayerTakeDamage(entity, _, flags) --entity, amount, flags, source, countdown
	local player = entity:ToPlayer()
	local ignore = false

	if flags & lilBishop.IgnoreFlag ~= lilBishop.IgnoreFlag then
		local lilBishops = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, enums.Familiars.LIL_BISHOP)
		if #lilBishops > 0 then
			for _, lilBishopFam in pairs(lilBishops) do
				if lilBishopFam:GetData().Active then -- and lilBishopFam:GetSprite():GetAnimation() == "Active" then
					ignore = true -- to play animation for all active lil bishops
					local sprite = lilBishopFam:GetSprite()
					if sprite:GetAnimation() == "Active" or sprite:GetAnimation() == "Sleep" then
						sfx:Play(SoundEffect.SOUND_BISHOP_HIT)
						if sprite:GetAnimation() == "Active" then
							sprite:Play("Block")
						end
						local laser = Isaac.Spawn(EntityType.ENTITY_LASER, LaserVariant.ELECTRIC, 0, lilBishopFam.Position, Vector.Zero, nil):ToLaser()
						sfx:Stop(SoundEffect.SOUND_LASERRING)
						laser:GetData().BishopLaser = player
						laser:SetTimeout(lilBishop.LaserFade)
						laser.CollisionDamage = 0
						laser.Mass = 0
						local distance = lilBishopFam.Position:Distance(player.Position)
						laser.Parent = lilBishopFam
						laser:SetMaxDistance(distance)
						local pos = player.Position - lilBishopFam.Position
						laser.Angle = pos:GetAngleDegrees() -- lilBishopFam.Velocity
						laser:SetColor(Color(2,2,2), 15, 1, false, false)
						local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, lilBishop.ShieldEffect, 0, player.Position, Vector.Zero, nil):ToEffect()
						effect.Parent = player
						effect:FollowParent(effect.Parent)
						effect.SpriteOffset = lilBishop.ShieldOffset * player.SpriteScale.X
						effect.SpriteScale = player.SpriteScale
						effect:SetTimeout(lilBishop.FadeCounter)
						effect.DepthOffset = lilBishop.DepthOffset
						effect:GetSprite():Play("Fade")
					end
				end
			end
		end
		if ignore then return false end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, lilBishop.onPlayerTakeDamage, EntityType.ENTITY_PLAYER)

function lilBishop:onLaserUpdate(laser)
	local data = laser:GetData()
	if not data.BishopLaser then return end
	local distance = laser.Parent.Position:Distance(data.BishopLaser.Position)
	laser:SetMaxDistance(distance)
	local pos = data.BishopLaser.Position - laser.Parent.Position
	laser.Angle = pos:GetAngleDegrees()
end
MilkshakeVol1:AddCallback(ModCallbacks. MC_POST_LASER_UPDATE, lilBishop.onLaserUpdate, LaserVariant.ELECTRIC)


function lilBishop:onEffectUpdate(effect)
	local player = effect.Parent
	effect:FollowParent(player)
	effect.SpriteOffset = lilBishop.ShieldOffset * player.SpriteScale.X
	if effect.Timeout <= 0 then
		effect:Remove()
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, lilBishop.onEffectUpdate, lilBishop.ShieldEffect)

--- LIL BISHOP INIT --
function lilBishop:onFamiliarInit(familiar)
	familiar:AddToFollowers()
	local famData = familiar:GetData()
	local sprite = familiar:GetSprite()
	famData.Active = nil
	sprite:Play("FloatDown")
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, lilBishop.onFamiliarInit, enums.Familiars.LIL_BISHOP)

--- LIL BISHOP UPDATE --
function lilBishop:onFamiliarUpdate(familiar)
	local famData = familiar:GetData()
	local sprite = familiar:GetSprite()
	local player = familiar.Player
	familiar:FollowParent()

	if not famData.Alt and player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		famData.Alt = true
		sprite:ReplaceSpritesheet(0, lilBishop.AlternativeSprite)
		sprite:LoadGraphics()
	elseif famData.Alt and not player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
		famData.Alt = nil
		sprite:ReplaceSpritesheet(0, lilBishop.BaseSprite)
		sprite:LoadGraphics()
	end

	if famData.Active then
		famData.Active = famData.Active - 1
		if famData.Active < 0 and sprite:IsFinished("Sleep") then
			famData.Active = nil
			sprite:Play("FloatDown")
		elseif famData.Active <= 32 then
			sprite:Play("Sleep")
		end
	elseif sprite:IsFinished("Sleep") then
		sprite:Play("FloatDown")
	elseif sprite:GetAnimation() == "Active" then
		sprite:Play("Sleep")
	end

    if sprite:IsFinished("Block") then
    	if famData.Active then
    	    sprite:Play("Active")
    	else
    	    sprite:Play("Sleep")
    	end
    end
	--print(famData.Active, sprite:GetAnimation(), sprite:IsFinished("Sleep"))
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, lilBishop.onFamiliarUpdate, enums.Familiars.LIL_BISHOP)

--- LIL BISHOP COLLISION --
function lilBishop:onFamiliarCollision(familiar, collider)
	if collider:ToProjectile() then
		if collider:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then return end
		collider:Die()
		local famData = familiar:GetData()
		local sprite = familiar:GetSprite()
		local player = familiar.Player
		local rng = familiar:GetDropRNG()
		if rng:RandomFloat() <= lilBishop.BlockChance and not famData.Active then
			famData.Active = lilBishop.BlockCooldown
			if player:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				famData.Active = lilBishop.BlockCooldown * lilBishop.bffsMultiplier
			end
			sprite:Play("Block")
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, lilBishop.onFamiliarCollision, enums.Familiars.LIL_BISHOP)


--[[
---TEST
lilBishop.Font = Font()
lilBishop.Font:Load("font/pftempestasevencondensed.fnt")

function lilBishop:onRender(familiar)
	--if familiar:GetData().Active then
	local active = familiar:GetData().Active
	local pos = Isaac.WorldToScreen(familiar.Position)
	if active then
		lilBishop.Font:DrawString(active, pos.X , pos.Y, KColor(1 ,1 ,1 ,1), 0, true)
	end
	--end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, lilBishop.onRender, enums.Familiars.LIL_BISHOP)
--]]

--- PLAYER UPDATE --
--[[
function lilBishop:onPEffectUpdate(player)
	local data = player:GetData()
	if data.lilBishoped then
		if data.lilBishopCurrentRoomIndex ~= game:GetLevel():GetCurrentRoomIndex() then
			data.lilBishopCurrentRoomIndex = nil
			data.lilBishoped = nil
			player:RemoveCostume(lilBishop.costumeBookShadow)
		else
			--if game:GetFrameCount() - data.lilBishoped >= lilBishop.ShieldTimeout then
			data.lilBishoped = data.lilBishoped - 1
			if data.lilBishoped <= 0 then
				data.lilBishoped = nil
				if player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS) == 0 then
					player:RemoveCostume(lilBishop.costumeBookShadow)
				end
			elseif data.lilBishoped <= lilBishop.FadeCounter and data.lilBishoped%3 == 0 and player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS) == 0 then
				if data.lilBishopFadeCounter then
					data.lilBishopFadeCounter = nil
					player:AddCostume(lilBishop.costumeBookShadow, false)
				else
					data.lilBishopFadeCounter = true
					player:RemoveCostume(lilBishop.costumeBookShadow)
				end
			end
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, lilBishop.onPEffectUpdate)
--]]
