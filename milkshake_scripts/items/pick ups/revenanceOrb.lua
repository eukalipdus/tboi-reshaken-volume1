RevenanceOrb = {}
local enums = MilkshakeVol1.enums
local game = Game()

RevenanceOrb.Undeads = {
[EntityType.ENTITY_BONY] = true,
}

RevenanceOrb.Timeout = 45

function RevenanceOrb:OnRevenanceOrbUse(card, player) -- useFlag
	game:ShakeScreen(RevenanceOrb.Timeout)
	local bony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, player.Position, Vector.Zero, nil):ToNPC()
	bony:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
	
	local undeads = Isaac.FindInRadius(player.Position, 5000, EntityPartition.ENEMY)
	for _, undead in pairs(undeads) do
		if RevenanceOrb.Undeads[undead.Type] then
			bony:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM)
		end
	end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, RevenanceOrb.OnRevenanceOrbUse, enums.Orbs.UNDEAD)
