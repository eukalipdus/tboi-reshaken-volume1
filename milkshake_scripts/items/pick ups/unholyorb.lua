local UnholyOrb = {}
local game = Game()

local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

-- some thoughts
-- killing beggars is difficult stuff, cause beggar is "slot machine", so it must also destroy slot machines, cause there is mod beggars

--TODO it to get slot machines position
--save all enemy and beggars position?
--blood tears fontaine when enemy dies

UnholyOrb.DamageMultiplier = 5




function UnholyOrb.GetNearestEnemy(basePos)
	--- get near enemy's position, else return basePos position
	local positionsTable = {}
	local enemies = Isaac.FindInRadius(basePos, 5000, EntityPartition.ENEMY)
	for _, enemy in pairs(enemies) do
		if enemy:ToNPC() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and enemy.Type ~= EntityType.ENTITY_FIREPLACE then
			--positionsTable.insert(enemy.Position, basePos:Distance(enemy.Position))
			table.insert(positionsTable, enemy)
        end
	end
	local slots = Isaac.FindByType(EntityType.ENTITY_SLOT)
	for _, slot in pairs(slots) do
		--positionsTable.insert(slot.Position, basePos:Distance(slot.Position))
		table.insert(positionsTable, slot)
	end
	return positionsTable
end


function UnholyOrb:onPEffectUpdate(player)
	if utility:GetData(player, "UsedUnholyOrb") then
		if game:GetRoom():GetFrameCount() == 1 then
			utility:SetData(player, "UsedUnholyOrb", nil)
		else -- if positionsTable has elements
			-- move player to targets by X speed
			--player.Velocity =
			-- remove element from positionsTable
			-- if #positionsTable == 0 then set utility:SetData(player, "UsedUnholyOrb", nil)
		end
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, UnholyOrb.onPEffectUpdate)


function UnholyOrb:enemyUpd(enemy)
	if not enemy:GetData().UnholyOrbFlag then return end
	if enemy.Type == EntityType.ENTITY_FIREPLACE then return end
	if enemy:HasMortalDamage() then
		--blood tears
		--local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, enemy.Position, Vector.Zero, player):ToEffect()
	end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, UnholyOrb.enemyUpd)

function UnholyOrb:onPlayerCollision(player, collider)
	if not utility:GetData(player, "UsedUnholyOrb") then return end
	if not collider:ToNPC() then return end
	if collider:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then return end
    local enemy = collider:ToNPC()
	game:ShakeScreen(5)
	local damage = UnholyOrb.DamageMultiplier + utility:GetCurrentChapter()
    enemy:TakeDamage(damage, DamageFlag.DAMAGE_CRUSH, EntityRef(player), 1)
	enemy:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT | EntityFlag.FLAG_BRIMSTONE_MARKED | EntityFlag.FLAG_EXTRA_GORE)
	enemy:GetData().UnholyOrbFlag = true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, UnholyOrb.onPlayerCollision)

---@param player EntityPlayer
function UnholyOrb:OnUnholyOrbUse(_, player)

	player:UseActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS)

    local room = game:GetRoom()
    UnholyOrb.StartingPos = player.Position -- return to this position
    local positionsTable = UnholyOrb.GetNearestEnemy(player.Position)

	if #positionsTable == 0 then
		utility:SetData(player, "UsedUnholyOrb", true)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_MIMIC)
		local pentagram = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PENTAGRAM_BLACKPOWDER, 0, room:GetCenterPos(), Vector.Zero, player):ToEffect()
	    pentagram:GetData().UnholyOrbFlag = true -- remove after dash
		pentagram:SetTimeout(-1)
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, UnholyOrb.OnUnholyOrbUse, enums.Orbs.UNHOLY)