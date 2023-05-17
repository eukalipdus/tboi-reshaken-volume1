local lilBishop = {}
local enums = MilkshakeVol1.enums

lilBishop.BlockCooldown = 150 -- 5*30
lilBishop.ShieldTimeout = 30
lilBishop.CosF = 15
lilBishop.costumeBookShadow = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)

local game = Game()

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
	local data = player:GetData()

	--- soul of nadab and abihu
	if data.lilBishoped and flags & DamageFlag.DAMAGE_INVINCIBLE ~= DamageFlag.DAMAGE_INVINCIBLE then
		return false
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, lilBishop.onPlayerTakeDamage, EntityType.ENTITY_PLAYER)

--- PLAYER UPDATE --
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
			elseif data.lilBishoped <= lilBishop.CosF and data.lilBishoped%3 == 0 and player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS) == 0 then
				if data.lilBishopCosF then
					data.lilBishopCosF = nil
					player:AddCostume(lilBishop.costumeBookShadow, false)
				else
					data.lilBishopCosF = true
					player:RemoveCostume(lilBishop.costumeBookShadow)
				end
			end
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, lilBishop.onPEffectUpdate)

--- LIL BISHOP INIT --
function lilBishop:onFamiliarInit(familiar)
	familiar.OrbitSpeed = 0.01
	familiar:AddToOrbit(8)
	--local sprite = familiar:GetSprite()
	--sprite:Play("FloatDown")
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, lilBishop.onFamiliarInit, enums.Familiars.LIL_BISHOP)

--- LIL BISHOP UPDATE --
function lilBishop:onFamiliarUpdate(familiar)
	local data = familiar:GetData()
	local player = familiar.Player
	--local sprite = player:GetSprite()

	if data.BlockCooldown then
		data.BlockCooldown = data.BlockCooldown - 1
		if data.BlockCooldown <= 0 then
			data.BlockCooldown = nil
			--sprite:Play("WakeUp")
		end
	end

	familiar.Velocity = familiar:GetOrbitPosition(player.Position) - familiar.Position

    --if sprite:IsFinished("WakeUp") then
    --	sprite:Play("FloatDown")
    --end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, lilBishop.onFamiliarUpdate, enums.Familiars.LIL_BISHOP)

--- LIL BISHOP COLLISION --
function lilBishop:onFamiliarCollision(familiar, collider)
	if collider:ToProjectile() then
		collider:Die()
		--local sprite = player:GetSprite()

		local data = familiar:GetData()
		if not data.BlockCooldown then
			--sprite:Play("Sleep")
			local player = familiar.Player
			data.BlockCooldown = lilBishop.BlockCooldown
			player:AddCostume(lilBishop.costumeBookShadow, false)
			local pdata = player:GetData()
			pdata.lilBishoped = pdata.lilBishoped or 0
			pdata.lilBishoped = pdata.lilBishoped + lilBishop.ShieldTimeout
			pdata.lilBishopCurrentRoomIndex = game:GetLevel():GetCurrentRoomIndex()
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, lilBishop.onFamiliarCollision, enums.Familiars.LIL_BISHOP)
