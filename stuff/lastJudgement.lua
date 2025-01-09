MilkshakeVol1:AddModCompatibility("LastJudgement", function()
  local OrbsPerLastJudgementEntities = {
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 743, variant = 0 },    -- Canary
		{ orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 743, variant = 1 },    -- Foreigner
		{ orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 743, variant = 170 },    -- Coil
		
		{ orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 743, variant = 90 },    -- Lobodious
		{ orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 743, variant = 110 },    -- Exorcist
		{ orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 743, variant = 140 },    -- Cyabin
		{ orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 743, variant = 141 },    -- Cyabin Goo
		
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 39, variant = 743 },    -- Cage Vis
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 55, variant = 0 },    -- Vax
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 744, variant = 1 },    -- Vax Pustule
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 20 },    -- Phage
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 21 },    -- Pheege
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 22 },    -- Phooge
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 30 },    -- Stress Ball
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 50 },    -- Strain Baby
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 70 },    -- Terror Cell
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 80 },    -- Popper
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 100 },    -- Heap
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 743, variant = 220 },    -- Patho
		{ orb = MilkshakeVol1.enums.Orbs.POISON, type = 744, variant = 2 },    -- AIDS
		
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 10 },    -- Tainted Mr. Maw
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 11 },    -- Tainted Maw
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 40 },    -- Topsy
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 60 },    -- Donor
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 61},    -- Slinking Guts
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 62 },    -- Hulking Guts
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 63 },    -- Pathetic Guts
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 111 },    -- Remnant
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 130 },    -- Gash
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 150 },    -- D.O.C.
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 305, variant = 743 },    -- Ministro II
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 190 },    -- Skinburster
		{ orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 743, variant = 210 },    -- Carnis
		
		{ orb = MilkshakeVol1.enums.Orbs.UNHOLY, type = 743, variant = 200 },    -- Brimstone Host
		
		{ orb = MilkshakeVol1.enums.Orbs.WATER, type = 743, variant = 180 },    -- Jibble
		
		{ orb = MilkshakeVol1.enums.Orbs.RANDOM, type = 744, variant = 0 },    -- Embolism
		}
		MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerLastJudgementEntities)
		
end)