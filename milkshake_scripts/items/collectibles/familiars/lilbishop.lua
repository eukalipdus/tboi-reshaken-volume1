local lilBishop = {}
local enums = MilkshakeVol1.enums

lilBishop.BlockCooldown = 150 -- 5*30

function lilBishop:EvaluateCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.LIL_BISHOP,
        enums.Familiars.LIL_BISHOP
    )
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, lilBishop.EvaluateCache, CacheFlag.CACHE_FAMILIARS)


function lilBishop:onFamiliarInit(familiar)
	familiar:AddToOrbit(2)
	--local sprite = familiar:GetSprite()
	--sprite:Play("FloatDown")
    
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, lilBishop.onFamiliarInit, enums.Familiars.LIL_BISHOP)


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
	
	familiar.OrbitDistance = Vector(40, 40)
	local targetPosition = familiar:GetOrbitPosition(player.Position + player.Velocity)
	familiar.Velocity = targetPosition - familiar.Position
    
    --if sprite:IsFinished("WakeUp") then
    --	sprite:Play("FloatDown")
    --end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, lilBishop.onFamiliarUpdate, enums.Familiars.LIL_BISHOP)

function lilBishop:onFamiliarCollision(familiar, collider)
	if collider:ToProjectile() then
		collider:Die()
		--local sprite = player:GetSprite()

		local data = familiar:GetData()
		if not data.BlockCooldown then
			--sprite:Play("Sleep")
			local player = familiar.Player
			data.BlockCooldown = lilBishop.BlockCooldown
			local tempEffects = player:GetEffects()
			tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, true, 1) -- idk how it must work
			--local tempEffect = tempEffects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
			--tempEffect.Cooldown = tempEffect.Cooldown - 270
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, lilBishop.onFamiliarCollision, enums.Familiars.LIL_BISHOP)
