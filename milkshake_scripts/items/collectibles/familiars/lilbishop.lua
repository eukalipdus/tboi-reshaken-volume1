local lilBishop = {}
local enums = MilkshakeVol1.enums

lilBishop.BlockCooldown = 120 -- 5*30
lilBishop.BlockChance = 0.1
--lilBishop.ShieldTimeout = 120
lilBishop.FadeCounter = 15
--lilBishop.costumeBookShadow = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
lilBishop.ShieldEffect = Isaac.GetEntityVariantByName("Lil Bishop Shield")
lilBishop.IgnoreFlag = DamageFlag.DAMAGE_INVINCIBLE
lilBishop.bffsMultiplier = 2

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
				if lilBishopFam:GetData().Active then
					--lilBishopFam:GetSprite():Play("Block")
					--TODO lil bishop laser -- from fam to player
					local shield = Isaac.Spawn(EntityType.ENTITY_EFFECT, lilBishop.ShieldEffect, 0, player.Position, Vector.Zero, nil)
					shield.Parent = player
					--shield.Scale = shield.Scale * player.SpriteScale
					shield:SetTimeout(lilBishop.FadeCounter)
					shield:GetSprite():Play("Fade")
					ignore = true -- to play animation for all active lil bishops
				end
			end
		end
		if ignore then return false end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, lilBishop.onPlayerTakeDamage, EntityType.ENTITY_PLAYER)

--- PLAYER UPDATE --
--[[
function lilBishop:onPEffectUpdate(player)
	local data = player:GetData()
	--[[
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
	--]
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, lilBishop.onPEffectUpdate)
--]]

--- LIL BISHOP INIT --
function lilBishop:onFamiliarInit(familiar)
	familiar:AddToFollowers()
	local famData = familiar:GetData()
	famData.Active = nil
	--local sprite = familiar:GetSprite()
	--sprite:Play("FloatDown")
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, lilBishop.onFamiliarInit, enums.Familiars.LIL_BISHOP)

--- LIL BISHOP UPDATE --
function lilBishop:onFamiliarUpdate(familiar)
	local famData = familiar:GetData()
	--local player = familiar.Player
	--local sprite = familiar:GetSprite()
	familiar:FollowParent()
	if famData.Active then
		famData.Active = famData.Active - 1
		if famData.Active <= 0 then
			famData.Active = nil
			--sprite:Play("FloatDown")
		end
	end
	familiar.Velocity = familiar:GetOrbitPosition(player.Position) - familiar.Position
    --[[
    if sprite:IsFinished("Block") then
    	if famData.Active then
    	    sprite:Play("Active")
    	else
    	    sprite:Play("FloatDown")
    	end
    end
	--]]
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, lilBishop.onFamiliarUpdate, enums.Familiars.LIL_BISHOP)

--- LIL BISHOP COLLISION --
function lilBishop:onFamiliarCollision(familiar, collider)
	if collider:ToProjectile() then
		collider:Die()
		local famData = familiar:GetData()
		--local sprite = familiar:GetSprite()
		local player = familiar.Player
		local rng = familiar:GetDropRNG()
		if rng:RandomFloat() <= lilBishop.BlockChance and not famData.Active then
			famData.Active = lilBishop.BlockCooldown
			if player:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				famData.Active = lilBishop.BlockCooldown * lilBishop.bffsMultiplier
			end
			--sprite:Play("Active")
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, lilBishop.onFamiliarCollision, enums.Familiars.LIL_BISHOP)

function lilBishop:onEffectUpdate(effect)
	effect:FollowParent(effect.Parent)
	--[[
	if effect.Timeout < lilBishop.FadeCounter and not effect:GetData().fading then
		effect:GetData().fading = true
		effect:GetSprite():Play("Fade")
	end
	--]]
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, lilBishop.onEffectUpdate, lilBishop.ShieldEffect)

---TEST
lilBishop.Font = Font()
lilBishop.Font:Load("font/pftempestasevencondensed.fnt")

function lilBishop:onRender(familiar)
	--if familiar:GetData().Active then
	local active = familiar:GetData().Active
	local pos = Isaac.WorldToScreen(familiar.Position)
	lilBishop.Font:DrawString(active, pos.X , pos.Y, KColor(1 ,1 ,1 ,1), 0, true)
	--end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, lilBishop.onRender, enums.Familiars.LIL_BISHOP)
