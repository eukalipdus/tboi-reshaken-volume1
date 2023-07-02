RevenanceOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

RevenanceOrb.Undeads = {
[EntityType.ENTITY_BONY] = true,
}

RevenanceOrb.TombMobs = {
{EntityType.ENTITY_BONY, 0, 0},
{EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1},
{EntityType.ENTITY_EFFECT, EffectVariant.HUNGRY_SOUL, 1},
}
RevenanceOrb.Timeout = 45

--TODO
--TombEffect stones

function RevenanceOrb:OnRevenanceOrbUse(card, player) -- useFlag
	local room = game:GetRoom()
	local rng = player:GetCardRNG(card)
	game:ShakeScreen(RevenanceOrb.Timeout)
	local bony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, player.Position, Vector.Zero, nil):ToNPC()
	bony:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
	
	local tombNum = rng:RandomInt(2)+4
	if room:GetRoomShape() > 7 then tombNum = tombNum+2 end
	
	for _ = 1, tombNum do
		local randMob = RevenanceOrb.TombMobs[rng:RandomInt(#RevenanceOrb.TombMobs)+1]
		local mob = Isaac.Spawn(randMob[1], randMob[2], randMob[3], room:GetRandomPosition(1), Vector.Zero, player)
		if mob.Type ~= EntityType.ENTITY_EFFECT then
			mob:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		else
			mob:ToEffect():SetTimeout(180)
		end
	end
	
	for gridIndex = 1, room:GetGridSize() do
		local grid = room:GetGridEntity(gridIndex)
		if grid and grid:ToPit() and grid.State ~= 1 then
			grid:ToPit():MakeBridge(nil)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, grid.Position, Vector.Zero, nil)
		end
	end
	
	local undeads = Isaac.FindInRadius(player.Position, 5000, EntityPartition.ENEMY)
	for _, undead in pairs(undeads) do
		if RevenanceOrb.Undeads[undead.Type] then
			undead:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		end
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, RevenanceOrb.OnRevenanceOrbUse, enums.Orbs.UNDEAD)

