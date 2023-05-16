--Lil Bishop: Bishop orbital familiar that orbits close to Isaac. 
--If an enemy tear hits the bishop, it will briefly create a bubble shield around Isaac for a second, 
--making him immune to damage. Has 5 second cooldown.

local lilBishop = {}
local enums = MilkshakeVol1.enums

lilBishop.BlockCooldown = 150 -- 5*30

function lilBishop:OnFamiliarUpdate(familiar)
	local data = familiar:GetData()
	if data.BlockCooldown then
		data.BlockCooldown = data.BlockCooldown - 1
		if data.BlockCooldown <= 0 then
			data.BlockCooldown = nil
		end
	end
	
    familiar:FollowParent()
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, lilBishop.OnFamiliarUpdate, enums.Familiars.LIL_BISHOP)

function lilBishop:onFamiliarCollision(fam, collider)
	local data = fam:GetData()
	if fam.SpawnerEntity and fam.SpawnerEntity:ToPlayer() and collider:ToProjectile() and not data.BlockCooldown then
		local projectile = collider:ToProjectile()
		local player = fam.SpawnerEntity:ToPlayer()
		data.BlockCooldown = lilBishop.BlockCooldown
		local tempEffects = player:GetEffects()
		tempEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
		--local tempEffect = tempEffects:GetCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS)
		--tempEffect.Cooldown = tempEffect.Cooldown - 270
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, lilBishop.onFamiliarCollision, enums.Familiars.LIL_BISHOP)
