MilkshakeVol1:AddModCompatibility("CrabbyCertins", function()
    local OrbsPerCrabbyEntities = {
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 25,  variant = 20,}, -- ?.fly
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 25,  variant = 22,}, -- coal fly
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,    type = 25,  variant = 21,}, -- i.fly
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 834, variant = 20 },          -- enraged bones
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 833, variant = 20 },          -- zealot
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 300, variant = 999 },         -- flood cap
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 24,  variant = 2,  subtype = 20 }, -- dank gazing globin spawner
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 24,  variant = 1,  subtype = 20 }, -- dank gazing globin
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 825, variant = 20 },          -- aqua worm
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 109, variant = 15 },          -- flooder
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 838, variant = 20 },          -- psy willo
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 838, variant = 21 },          -- red willo
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 838, variant = 22 },          -- full willo
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 109, variant = 5 },           -- danker
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 109, variant = 6 },           -- hanging danker
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 90,  variant = 21 },          -- tainted hanger
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 284, variant = 40 },          -- vessel
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 284, variant = 40, subtype = 1 }, -- vessel(geh)
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 26,  variant = 20 },          -- spec-soul
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 26,  variant = 20, subtype = 1 }, -- spec-soul(geh)
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 109, variant = 0 },           -- chainlink
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 109, variant = 1 },           -- the holy one
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 109, variant = 1,  subtype = 1 }, -- the holy one corpse
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 109, variant = 2 },           -- the blighted
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 109, variant = 16 },          -- sealed
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 109, variant = 4 },           -- bombardier
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 109, variant = 17,}, -- coaly
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 92,  variant = 100 },         -- visheart
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 93,  variant = 100 },         -- vismask
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 214, variant = 20 },          -- rib fly
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 109, variant = 10 },          -- camillo
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 109, variant = 11 },          -- mini camillo
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 284, variant = 50 },          -- waddoo
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,    type = 881, variant = 5 },           -- seam
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 109, variant = 13 },          -- maiden
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 109, variant = 14 },          -- pharaoh's tomb
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,    type = 109, variant = 12 },          -- globlobber
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 109, variant = 7 },           -- shroomy
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 109, variant = 8 },           -- ramble gag
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 109, variant = 9 },           -- tainted mushroom
    }
    MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerCrabbyEntities)
end)
