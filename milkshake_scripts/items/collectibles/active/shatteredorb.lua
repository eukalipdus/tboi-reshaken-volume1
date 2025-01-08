local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local ShatteredOrb = {}

local SHATTERED_ORB_THROW_SPEED = 8
local SHATTERED_ORB_FALL_ACCEL = 0.025
local SHATTERED_ORB_TIME_UNTIL_FALL = 5
local SHATTERED_ORB_RADIUS = 20
local JUDAS_CONVERT_CHANCE = 50
local BELIAL_PARTICLE_COUNT = 15
local BELIAL_PARTICLE_SPEED = 8
local BELIAL_PARTICLE_COLOR = Color(1,0,0,1)
local MULTISHOT_SPREAD = 20

--TODO: Find a better place to put this in so it's not repeated
local PossibleWisps = {
    enums.Collectibles.SPECIAL_BRENDA_FIRE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_PSYCHIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_NATURE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_ELECTRIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_WATER_WISP,
    enums.Collectibles.SPECIAL_BRENDA_POISON_WISP,
    enums.Collectibles.SPECIAL_BRENDA_HOLY_WISP,
    enums.Collectibles.SPECIAL_BRENDA_TERRA_WISP,
    enums.Collectibles.SPECIAL_BRENDA_UNDEAD_WISP,
    enums.Collectibles.SPECIAL_BRENDA_UNHOLY_WISP
}


local ORBS_PER_ENEMY = {}

function MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(orbsPerEnemy)
    TSIL.Utils.Tables.ForEach(orbsPerEnemy, function(_, orbPerEnemy)
        if ORBS_PER_ENEMY[orbPerEnemy.type] == nil then
            ORBS_PER_ENEMY[orbPerEnemy.type] = {}
        end

        local perType = ORBS_PER_ENEMY[orbPerEnemy.type]

        if orbPerEnemy.variant == nil then
            --There is no variant, so just set the orb here
            perType.orb = orbPerEnemy.orb
            return
        end

        if not perType.entities then
            perType.entities = {}
        end

        if perType.entities[orbPerEnemy.variant] == nil then
            perType.entities[orbPerEnemy.variant] = {}
        end

        local perVariant = perType.entities[orbPerEnemy.variant]

        if orbPerEnemy.subtype == nil then
            --There is no subtype, so just set the orb here
            perVariant.orb = orbPerEnemy.orb
            return
        end

        if not perVariant.entities then
            perVariant.entities = {}
        end

        perVariant.entities[orbPerEnemy.subtype] = { orb = orbPerEnemy.orb }
    end)
end

local OrbsPerEnemy = {
    { orb = enums.Orbs.ELECTRIC, type = 60,                       variant = 0, }, --Eye
    { orb = enums.Orbs.ELECTRIC, type = 230,                      variant = 0, }, --Camillo Jr.
    { orb = enums.Orbs.ELECTRIC, type = 201,                      variant = 0, }, --Stone Eye
    { orb = enums.Orbs.ELECTRIC, type = 61,                       variant = 5, }, --Bulb
    { orb = enums.Orbs.PSYCHIC,  type = 832,                      variant = 0, }, --Exorcist
    { orb = enums.Orbs.PSYCHIC,  type = 832,                      variant = 1, }, --Fanatic
    { orb = enums.Orbs.PSYCHIC,  type = 836,                      variant = 0, }, --Vis Versa
    { orb = enums.Orbs.PSYCHIC,  type = 248,                      variant = 0, }, --Psychic Horf
    { orb = enums.Orbs.PSYCHIC,  type = 828,                      variant = 0, }, --Necro
    { orb = enums.Orbs.PSYCHIC,  type = 24,                       variant = 3, }, --Cursed Globin
    { orb = enums.Orbs.PSYCHIC,  type = 26,                       variant = 2, }, --Psychic Maw
    { orb = enums.Orbs.PSYCHIC,  type = 246,                      variant = 0, }, --Ragling
    { orb = enums.Orbs.PSYCHIC,  type = 246,                      variant = 1, }, --Rag Man's Ragling
    { orb = enums.Orbs.PSYCHIC,  type = 57,                       variant = 0, }, --MemBrain
    { orb = enums.Orbs.PSYCHIC,  type = 886,                      variant = 0, }, --Vis Fatty
    { orb = enums.Orbs.PSYCHIC,  type = 212,                      variant = 2, }, --Cursed Death's Head
    { orb = enums.Orbs.PSYCHIC,  type = 253,                      variant = 0, }, --Psy Tumor
    { orb = enums.Orbs.PSYCHIC,  type = 885,                      variant = 0, }, --Cultist
    { orb = enums.Orbs.PSYCHIC,  type = 885,                      variant = 1, }, --Blood Cultist
    { orb = enums.Orbs.PSYCHIC,  type = 816,                      variant = 1, }, --Kineti
    { orb = enums.Orbs.PSYCHIC,  type = 306,                      variant = 0, }, --Portal
    { orb = enums.Orbs.PSYCHIC,  type = 306,                      variant = 1, }, --Lil Portal
    { orb = enums.Orbs.PSYCHIC,  type = 877,                      variant = 0, }, --Grudge
    { orb = enums.Orbs.PSYCHIC,  type = 409,                      variant = 1, }, --Purple Ball
    { orb = enums.Orbs.FIRE,     type = 10,                       variant = 2, }, --Flaming Gaper
    { orb = enums.Orbs.FIRE,     type = 87,                       variant = 1, }, --Crackle
    { orb = enums.Orbs.FIRE,     type = 808,                      variant = 0, }, --Willo
    { orb = enums.Orbs.FIRE,     type = 15,                       variant = 3, }, --Grilled Clotty
    { orb = enums.Orbs.FIRE,     type = 820,                      variant = 1, }, --Coal Boy
    { orb = enums.Orbs.FIRE,     type = 25,                       variant = 3,                               subtype = 0, }, --Dragon Fly
    { orb = enums.Orbs.FIRE,     type = 25,                       variant = 3,                               subtype = 1, }, --Dragon Fly X
    { orb = enums.Orbs.FIRE,     type = 54,                       variant = 0, }, --Flaming Hopper
    { orb = enums.Orbs.FIRE,     type = 824,                      variant = 1, }, --Grilled Gyro
    { orb = enums.Orbs.FIRE,     type = 41,                       variant = 4, }, --Black Knight
    { orb = enums.Orbs.FIRE,     type = 818,                      variant = 2, }, --Coal Spider
    { orb = enums.Orbs.FIRE,     type = 208,                      variant = 2, }, --Flaming Fatty
    { orb = enums.Orbs.FIRE,     type = 212,                      variant = 4, }, --Redskull
    { orb = enums.Orbs.FIRE,     type = 838,                      variant = 0, }, --Level 2 Willo
    { orb = enums.Orbs.FIRE,     type = 226,                      variant = 2, }, --Crispy
    { orb = enums.Orbs.FIRE,     type = 833,                      variant = 0, }, --Candler
    { orb = enums.Orbs.FIRE,     type = 841,                      variant = 0, }, --Revenant
    { orb = enums.Orbs.FIRE,     type = 841,                      variant = 1, }, --Quad Revenant
    { orb = enums.Orbs.FIRE,     type = 825,                      variant = 0, }, --Fire Worm
    { orb = enums.Orbs.FIRE,     type = 819,                      variant = 0, }, --Fly Bomb
    { orb = enums.Orbs.FIRE,     type = 16,                       variant = 2, }, --Mulliboom
    { orb = enums.Orbs.FIRE,     type = 25,                       variant = 0, }, --Boom Fly
    { orb = enums.Orbs.FIRE,     type = 25,                       variant = 6, }, --Tainted Boom Fly
    { orb = enums.Orbs.FIRE,     type = 250,                      variant = 0, }, --Ticking Spider
    { orb = enums.Orbs.FIRE,     type = 869,                      variant = 0, }, --Migraine
    { orb = enums.Orbs.FIRE,     type = 277,                      variant = 0 }, --Black Bony
    { orb = enums.Orbs.FIRE,     type = 844,                      variant = 0, }, --Bombgagger
    { orb = enums.Orbs.NATURE,   type = 300,                      variant = 0, }, --Mushroom
    { orb = enums.Orbs.NATURE,   type = 14,                       variant = 0 }, --Pooter
    { orb = enums.Orbs.NATURE,   type = 14,                       variant = 1 }, --Super Pooter
    { orb = enums.Orbs.NATURE,   type = 14,                       variant = 2 }, --Tainted Pooter
    { orb = enums.Orbs.NATURE,   type = 55,                       variant = 0 }, --Leech
    { orb = enums.Orbs.NATURE,   type = 854,                      variant = 0 }, --Adult Leech
    { orb = enums.Orbs.NATURE,   type = 206,                      variant = 0 }, --Baby Long Legs
    { orb = enums.Orbs.NATURE,   type = 206,                      variant = 1 }, --Small Baby Long Legs
    { orb = enums.Orbs.NATURE,   type = 207,                      variant = 0 }, --Crazy Long Legs
    { orb = enums.Orbs.NATURE,   type = 207,                      variant = 1 }, --Small Crazy Long Legs
    { orb = enums.Orbs.NATURE,   type = 214,                      variant = 0 }, --Level 2 Fly
    { orb = enums.Orbs.NATURE,   type = 249,                      variant = 0 }, --Full Fly
    { orb = enums.Orbs.NATURE,   type = 215,                      variant = 0 }, --Level 2 Spider
    { orb = enums.Orbs.NATURE,   type = 244,                      variant = 0 }, --Round Worm
    { orb = enums.Orbs.NATURE,   type = 244,                      variant = 2 }, ---Tainted Round Worm
    { orb = enums.Orbs.NATURE,   type = 255,                      variant = 0 }, --Night Crawler
    { orb = enums.Orbs.NATURE,   type = 234,                      variant = 0 }, --One Tooth
    { orb = enums.Orbs.NATURE,   type = 258,                      variant = 0 }, --Fat Bat
    { orb = enums.Orbs.NATURE,   type = 21,                       variant = 0 }, --Maggot
    { orb = enums.Orbs.NATURE,   type = 23,                       variant = 0 }, --Charger
    { orb = enums.Orbs.NATURE,   type = 855,                      variant = 0 }, --Level 2 Charger
    { orb = enums.Orbs.NATURE,   type = 31,                       variant = 0 }, --Spitty
    { orb = enums.Orbs.NATURE,   type = 31,                       variant = 1 }, --Tainted Spitty
    { orb = enums.Orbs.NATURE,   type = 243,                      variant = 0 }, --Conjoined Spitty
    { orb = enums.Orbs.NATURE,   type = 239,                      variant = 0 }, --Grub
    { orb = enums.Orbs.HOLY,     type = 96,                       variant = 0 }, --Eternal Fly
    { orb = enums.Orbs.HOLY,     type = 819,                      variant = 1 }, --Eternal Bomb Fly
    { orb = enums.Orbs.HOLY,     type = 38,                       variant = 1, }, --Angelic Baby
    { orb = enums.Orbs.HOLY,     type = 38,                       variant = 1,                               subtype = 1 }, --Angelic Baby (small)
    { orb = enums.Orbs.HOLY,     type = 55,                       variant = 2 }, --Holy Leech
    { orb = enums.Orbs.HOLY,     type = 60,                       variant = 2 }, --Holy Eye
    { orb = enums.Orbs.HOLY,     type = 22,                       variant = 2 }, --Holy Mulligan
    { orb = enums.Orbs.HOLY,     type = 227,                      variant = 1 }, --Holy Bony
    { orb = enums.Orbs.HOLY,     type = 805,                      variant = 0 }, --Bishop
    { orb = enums.Orbs.POISON,   type = 10,                       variant = 3 }, --Rotten Gaper
    { orb = enums.Orbs.POISON,   type = 87,                       variant = 0 }, --Gurgle
    { orb = enums.Orbs.POISON,   type = 850,                      variant = 0 }, --Level 2 Gaper
    { orb = enums.Orbs.POISON,   type = 850,                      variant = 1 }, --Level 2 Horf
    { orb = enums.Orbs.POISON,   type = 850,                      variant = 2 }, --Level 2 Gusher
    { orb = enums.Orbs.POISON,   type = 851,                      variant = 0 }, --Twitchy
    { orb = enums.Orbs.POISON,   type = 912,                      variant = 20 }, --Dead Isaac
    { orb = enums.Orbs.POISON,   type = 876,                      variant = 0 }, --Dump
    { orb = enums.Orbs.POISON,   type = 876,                      variant = 1 }, --Dump Head
    { orb = enums.Orbs.POISON,   type = 238,                      variant = 0 }, --Splasher
    { orb = enums.Orbs.POISON,   type = 951,                      variant = 21 }, --Ultra Pestilence Fly
    { orb = enums.Orbs.POISON,   type = 61,                       variant = 1 }, --Spit
    { orb = enums.Orbs.POISON,   type = 61,                       variant = 3 }, --Ink
    { orb = enums.Orbs.POISON,   type = 61,                       variant = 4 }, --Mama Fly
    { orb = enums.Orbs.POISON,   type = 61,                       variant = 6 }, --Bloodfly
    { orb = enums.Orbs.POISON,   type = 15,                       variant = 1 }, --Clot
    { orb = enums.Orbs.POISON,   type = 872,                      variant = 0 }, --Cloggy
    { orb = enums.Orbs.POISON,   type = 874,                      variant = 0 }, --Gas Dwarf
    { orb = enums.Orbs.POISON,   type = 23,                       variant = 2 }, --Dank Charger
    { orb = enums.Orbs.POISON,   type = 24,                       variant = 2 }, --Dank Globin
    { orb = enums.Orbs.POISON,   type = 856,                      variant = 0 }, --Gasbag
    { orb = enums.Orbs.POISON,   type = 34,                       variant = 1 }, --Sticky Leaper
    { orb = enums.Orbs.POISON,   type = 309,                      variant = 0 }, --Gush
    { orb = enums.Orbs.POISON,   type = 25,                       variant = 5 }, --Sick Boom Fly
    { orb = enums.Orbs.POISON,   type = 30,                       variant = 1 }, --Gut
    { orb = enums.Orbs.POISON,   type = 861,                      variant = 0 }, --Pustule
    { orb = enums.Orbs.POISON,   type = 88,                       variant = 1 }, --Walking Gut
    { orb = enums.Orbs.POISON,   type = 831,                      variant = 20 }, --Festering Guts
    { orb = enums.Orbs.POISON,   type = 301,                      variant = 0 }, --Poison Mind
    { orb = enums.Orbs.POISON,   type = 865,                      variant = 0 }, --Evis
    { orb = enums.Orbs.POISON,   type = 40,                       variant = 2 }, --Slog
    { orb = enums.Orbs.POISON,   type = 862,                      variant = 0 }, --Cyst
    { orb = enums.Orbs.POISON,   type = 307,                      variant = 0 }, --Tar Boy
    { orb = enums.Orbs.POISON,   type = 57,                       variant = 2 }, --Dead Meat
    { orb = enums.Orbs.POISON,   type = 223,                      variant = 0 }, --Dinga
    { orb = enums.Orbs.POISON,   type = 878,                      variant = 0 }, --Butt Slicker
    { orb = enums.Orbs.POISON,   type = 831,                      variant = 0 }, --Gutted Fatty
    { orb = enums.Orbs.POISON,   type = 831,                      variant = 10 }, --Gutted Fatty Eye
    { orb = enums.Orbs.POISON,   type = 217,                      variant = 0 }, --Dip
    { orb = enums.Orbs.POISON,   type = 217,                      variant = 1 }, --Corn
    { orb = enums.Orbs.POISON,   type = 217,                      variant = 2 }, --Brownie Corn
    { orb = enums.Orbs.POISON,   type = 217,                      variant = 3 }, --Big Corn
    { orb = enums.Orbs.POISON,   type = 870,                      variant = 0 }, --Drip
    { orb = enums.Orbs.POISON,   type = 220,                      variant = 0 }, --Squirt
    { orb = enums.Orbs.POISON,   type = 220,                      variant = 1 }, --Dank Squirt
    { orb = enums.Orbs.POISON,   type = 826,                      variant = 0 }, --Hardy
    { orb = enums.Orbs.POISON,   type = 871,                      variant = 0 }, --Splurt
    { orb = enums.Orbs.POISON,   type = 244,                      variant = 3 }, --Tainted Tube Worm
    { orb = enums.Orbs.POISON,   type = 276,                      variant = 0 }, --Roundy
    { orb = enums.Orbs.POISON,   type = 873,                      variant = 0 }, --Fly Trap
    { orb = enums.Orbs.POISON,   type = 875,                      variant = 0 }, --Poot Mine
    { orb = enums.Orbs.POISON,   type = 837,                      variant = 0 }, --Henry
    { orb = enums.Orbs.POISON,   type = 951,                      variant = 23 }, --Ultra Pestilence Fly Ball
    { orb = enums.Orbs.UNDEAD,   type = 297,                      variant = 0 }, --Blue Gaper
    { orb = enums.Orbs.UNDEAD,   type = 912,                      variant = 20 }, --–-Dead Isaac
    { orb = enums.Orbs.UNDEAD,   type = 296,                      variant = 0 }, --Hush Fly
    { orb = enums.Orbs.UNDEAD,   type = 951,                      variant = 11 }, --Ultra Famine Fly
    { orb = enums.Orbs.UNDEAD,   type = 817,                      variant = 1 }, --–-Mullighoul
    { orb = enums.Orbs.UNDEAD,   type = 23,                       variant = 3 }, --–-Carrion Princess
    { orb = enums.Orbs.UNDEAD,   type = 889,                      variant = 0 }, --–-Clickety Clack
    { orb = enums.Orbs.UNDEAD,   type = 25,                       variant = 4 }, --–-Bone Fly
    { orb = enums.Orbs.UNDEAD,   type = 26,                       variant = 0 }, --Maw
    { orb = enums.Orbs.UNDEAD,   type = 38,                       variant = 3 }, --–-Wrinkly baby
    { orb = enums.Orbs.UNDEAD,   type = 298,                      variant = 0 }, --Blue Boil
    { orb = enums.Orbs.UNDEAD,   type = 35,                       variant = 0 }, --Mr. Maw
    { orb = enums.Orbs.UNDEAD,   type = 41,                       variant = 1 }, --–-Selfless Knight
    { orb = enums.Orbs.UNDEAD,   type = 834,                      variant = 2 }, --Flagellant
    { orb = enums.Orbs.UNDEAD,   type = 86,                       variant = 0 }, --Keeper
    { orb = enums.Orbs.UNDEAD,   type = 90,                       variant = 0 }, --Hanger
    { orb = enums.Orbs.UNDEAD,   type = 208,                      variant = 1 }, --Pale Fatty
    { orb = enums.Orbs.UNDEAD,   type = 209,                      variant = 0 }, --Fat Sack
    { orb = enums.Orbs.UNDEAD,   type = 210,                      variant = 0 }, --Blubber
    { orb = enums.Orbs.UNDEAD,   type = 211,                      variant = 0 }, --Half Sack
    { orb = enums.Orbs.UNDEAD,   type = 257,                      variant = 1 }, --Blue Conjoined Fatty
    { orb = enums.Orbs.UNDEAD,   type = 830,                      variant = 0 }, --–-Big Bony
    { orb = enums.Orbs.UNDEAD,   type = 835,                      variant = 0 }, --Peeping Fatty
    { orb = enums.Orbs.UNDEAD,   type = 212,                      variant = 0 }, --–-Death's Head
    { orb = enums.Orbs.UNDEAD,   type = 887,                      variant = 0 }, --–-Dusty Death's Head
    { orb = enums.Orbs.UNDEAD,   type = 951,                      variant = 42 }, --–-Ultra Death Head
    { orb = enums.Orbs.UNDEAD,   type = 287,                      variant = 0 }, --–-Mom's Dead Hand
    { orb = enums.Orbs.UNDEAD,   type = 219,                      variant = 0 }, --–-Wizoob
    { orb = enums.Orbs.UNDEAD,   type = 226,                      variant = 1 }, --Rotty
    { orb = enums.Orbs.UNDEAD,   type = 227,                      variant = 0 }, --–-Bony
    { orb = enums.Orbs.UNDEAD,   type = 227,                      variant = 1 }, --–-Holy Bony
    { orb = enums.Orbs.UNDEAD,   type = 890,                      variant = 0 }, --Maze Roamer
    { orb = enums.Orbs.UNDEAD,   type = 260,                      variant = 10 }, --–-Lil' Haunt
    { orb = enums.Orbs.UNDEAD,   type = 816,                      variant = 0 }, --Polty
    { orb = enums.Orbs.UNDEAD,   type = 882,                      variant = 0 }, --Dust
    { orb = enums.Orbs.UNDEAD,   type = 880,                      variant = 0 }, --Flesh Maiden
    { orb = enums.Orbs.UNDEAD,   type = 881,                      variant = 1 }, --–-Pasty
    { orb = enums.Orbs.UNDEAD,   type = 66,                       variant = 10 }, --–-Death Scythe
    { orb = enums.Orbs.UNDEAD,   type = 951,                      variant = 41 }, --–-Ultra Death Scythe
    { orb = enums.Orbs.UNHOLY,   type = 252,                      variant = 0 }, --Nulls
    { orb = enums.Orbs.UNHOLY,   type = 280,                      variant = 0 }, --Black Globin's Body
    { orb = enums.Orbs.UNHOLY,   type = 61,                       variant = 2 }, --Soul Sucker
    { orb = enums.Orbs.UNHOLY,   type = 23,                       variant = 0,                               subtype = 1 }, --My Shadow
    { orb = enums.Orbs.UNHOLY,   type = 278,                      variant = 0 }, --Black Globin
    { orb = enums.Orbs.UNHOLY,   type = 279,                      variant = 0 }, --Globin's Head
    { orb = enums.Orbs.UNHOLY,   type = 259,                      variant = 0 }, --Imp
    { orb = enums.Orbs.UNHOLY,   type = 883,                      variant = 0 }, --Baby Begotten
    { orb = enums.Orbs.UNHOLY,   type = 834,                      variant = 0 }, --Whipper
    { orb = enums.Orbs.UNHOLY,   type = 834,                      variant = 1 }, --Snapper
    { orb = enums.Orbs.UNHOLY,   type = 834,                      variant = 2 }, --Flagellant
    { orb = enums.Orbs.UNHOLY,   type = 53,                       variant = 1 }, --Evil Twin
    { orb = enums.Orbs.UNHOLY,   type = 55,                       variant = 1 }, --Kamikaze Leech
    { orb = enums.Orbs.UNHOLY,   type = 60,                       variant = 1 }, --Bloodshot Eye
    { orb = enums.Orbs.UNHOLY,   type = 888,                      variant = 0 }, --Shady
    { orb = enums.Orbs.UNHOLY,   type = 886,                      variant = 1 }, --Fetal Demon
    { orb = enums.Orbs.UNHOLY,   type = 212,                      variant = 3 }, --Brimstone Death's Head
    { orb = enums.Orbs.UNHOLY,   type = 225,                      variant = 0 }, --Black Maw
    { orb = enums.Orbs.UNHOLY,   type = 251,                      variant = 0 }, --Begotten
    { orb = enums.Orbs.UNHOLY,   type = 891,                      variant = 0 }, --Goat
    { orb = enums.Orbs.UNHOLY,   type = 891,                      variant = 1 }, --Black Goat
    { orb = enums.Orbs.UNHOLY,   type = 885,                      variant = 1 }, --Blood Cultist
    { orb = enums.Orbs.UNHOLY,   type = 203,                      variant = 0 }, --Brimstone Head
    { orb = enums.Orbs.UNHOLY,   type = 404,                      variant = 1 }, --Dark Ball
    { orb = enums.Orbs.WATER,    type = 807,                      variant = 0 }, --Wraith
    { orb = enums.Orbs.WATER,    type = 811,                      variant = 0 }, --Deep Gaper
    { orb = enums.Orbs.WATER,    type = 813,                      variant = 0 }, --Blurb
    { orb = enums.Orbs.WATER,    type = 812,                      variant = 0 }, --Sub Horf
    { orb = enums.Orbs.WATER,    type = 812,                      variant = 1 }, --Tainted Sub Horf
    { orb = enums.Orbs.WATER,    type = 22,                       variant = 1 }, --Drowned Hive
    { orb = enums.Orbs.WATER,    type = 817,                      variant = 0 }, --Prey
    { orb = enums.Orbs.WATER,    type = 23,                       variant = 1 }, --Drowned Charger
    { orb = enums.Orbs.WATER,    type = 810,                      variant = 0 }, --Small Leech
    { orb = enums.Orbs.WATER,    type = 855,                      variant = 1 }, --Elleech
    { orb = enums.Orbs.WATER,    type = 25,                       variant = 2 }, --Drowned Boom Fly
    { orb = enums.Orbs.WATER,    type = 311,                      variant = 0 }, --Mr. Mine
    { orb = enums.Orbs.WATER,    type = 806,                      variant = 0 }, --Bubbles
    { orb = enums.Orbs.WATER,    type = 879,                      variant = 0 }, --Bloaty
    { orb = enums.Orbs.WATER,    type = 244,                      variant = 1 }, --Tube Worm
    { orb = enums.Orbs.WATER,    type = 244,                      variant = 3 }, --Tainted Tube Worm
    { orb = enums.Orbs.WATER,    type = 815,                      variant = 0 }, --Fissure
    { orb = enums.Orbs.ROCK,     type = 820,                      variant = 0 }, --Danny
    { orb = enums.Orbs.ROCK,     type = 821,                      variant = 0 }, --Blaster
    { orb = enums.Orbs.ROCK,     type = 27,                       variant = 3 }, --Hard Host
    { orb = enums.Orbs.ROCK,     type = 41,                       variant = 0 }, --Knight
    { orb = enums.Orbs.ROCK,     type = 41,                       variant = 1 }, --Selfless Knight
    { orb = enums.Orbs.ROCK,     type = 41,                       variant = 2 }, --Loose Knight
    { orb = enums.Orbs.ROCK,     type = 41,                       variant = 3 }, --Brainless Knight
    { orb = enums.Orbs.ROCK,     type = 254,                      variant = 0 }, --Floating Knight
    { orb = enums.Orbs.ROCK,     type = 283,                      variant = 0 }, --Bone Knight
    { orb = enums.Orbs.ROCK,     type = 818,                      variant = 0 }, --Rock Spider
    { orb = enums.Orbs.ROCK,     type = 818,                      variant = 1 }, --Tinted Rock Spider
    { orb = enums.Orbs.ROCK,     type = 302,                      variant = 0 }, --Stoney
    { orb = enums.Orbs.ROCK,     type = 302,                      variant = 10 }, --Cross Stoney
    { orb = enums.Orbs.ROCK,     type = 823,                      variant = 0 }, --Quakey
    { orb = enums.Orbs.ROCK,     type = 826,                      variant = 0 }, --Hardy
    { orb = enums.Orbs.ROCK,     type = 829,                      variant = 0 }, --Mole
    { orb = enums.Orbs.ROCK,     type = 829,                      variant = 1 }, --Tainted Mole
    { orb = enums.Orbs.ROCK,     type = 42,                       variant = 0 }, --Stone Grimace
    { orb = enums.Orbs.ROCK,     type = 42,                       variant = 2 }, --Triple Grimace
    { orb = enums.Orbs.ROCK,     type = 202,                      variant = 0 }, --Constant Stone Shooter
    { orb = enums.Orbs.ROCK,     type = 202,                      variant = 10 }, --Cross Stone Shooter
    { orb = enums.Orbs.ROCK,     type = 235,                      variant = 0 }, --Gaping Maw
    { orb = enums.Orbs.ROCK,     type = 236,                      variant = 0 }, --Broken Gaping Maw
    { orb = enums.Orbs.ROCK,     type = 804,                      variant = 0 }, --Quake Grimace
    { orb = enums.Orbs.ROCK,     type = 44,                       variant = 0 }, --Poky
    { orb = enums.Orbs.ROCK,     type = 44,                       variant = 1 }, --Slide
    { orb = enums.Orbs.ROCK,     type = 218,                      variant = 0 }, --Wall Hugger
    { orb = enums.Orbs.ROCK,     type = 877,                      variant = 0 }, --Grudge
    { orb = enums.Orbs.ROCK,     type = 893,                      variant = 0 }, --Ball and Chain
    { orb = enums.Orbs.ROCK,     type = 852,                      variant = 0 }, --Spikeball
    { orb = enums.Orbs.ROCK,     type = 915,                      variant = 1 }, --Singe's Ball,
    { orb = enums.Orbs.PSYCHIC,  type = enums.Enemies.GLASS_HEAD, variant = enums.GlassHeadVariant.WINE_HEAD },
    { orb = enums.Orbs.POISON,  type = enums.Enemies.GLASS_HEAD, variant = enums.GlassHeadVariant.FLASK_HEAD }
}
MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerEnemy)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "DataPerShatteredOrb",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

---@class ShatteredOrbData
---@field direction Vector
---@field fallingSpeed number

---@param effect EntityEffect
---@param direction Vector
local function AddShatteredOrbData(effect, direction)
    local ptrHash = GetPtrHash(effect)

    local directionsPerShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "DataPerShatteredOrb"
    )

    directionsPerShatteredOrb[tostring(ptrHash)] = {
        direction = direction,
        fallingSpeed = 0
    }
end

---@param effect EntityEffect
---@return ShatteredOrbData
local function GetShatteredOrbData(effect)
    local ptrHash = GetPtrHash(effect)

    local directionsPerShatteredOrb = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "DataPerShatteredOrb"
    )

    return directionsPerShatteredOrb[tostring(ptrHash)]
end

local emptySprite = Sprite()

ThrowableItemLib:RegisterThrowableItem({
    Type = ThrowableItemLib.Type.ACTIVE,
    ID = MilkshakeVol1.enums.Collectibles.SHATTERED_ORB,
    ---@param player EntityPlayer
    ---@param vect Vector
    ThrowFn = function (player, vect)
        local num = player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) and 2 or 1

        for i = 1, num do
            local shatteredOrb = TSIL.EntitySpecific.SpawnEffect(
                enums.Effects.SHATTERED_ORB,
                0,
                player.Position,
                Vector.Zero,
                player
            )

            shatteredOrb.SpriteOffset = Vector(0, -36) * player.SpriteScale
            shatteredOrb:GetSprite():Play("Thrown", true)

            AddShatteredOrbData(shatteredOrb, (vect * SHATTERED_ORB_THROW_SPEED + (player.Velocity * 0.9)):Rotated(num == 1 and 0 or -MULTISHOT_SPREAD - MULTISHOT_SPREAD / num + MULTISHOT_SPREAD * i))
        end

        SFXManager():Play(SoundEffect.SOUND_SHELLGAME)
    end,
    Identifier = "RE_SHATTERED_ORB",
    AnimateFn = function (player, state)
        if state == ThrowableItemLib.State.THROW then
            player:AnimatePickup(emptySprite, true, "HideItem")
            return true
        end
    end
})

---@param entity Entity
---@return Card
local function GetEntityOrb(entity)
    local orb
    local orbsPerType = ORBS_PER_ENEMY[entity.Type]

    if orbsPerType then
        orb = orbsPerType.orb

        if orbsPerType.entities then
            local orbsPerVariant = orbsPerType.entities[entity.Variant]

            if orbsPerVariant then
                if orbsPerVariant.orb then
                    orb = orbsPerVariant.orb
                end

                if orbsPerVariant.entities then
                    local orbsPerSubtype = orbsPerVariant.entities[entity.SubType]

                    if orbsPerSubtype and orbsPerSubtype.orb then
                        orb = orbsPerSubtype.orb
                    end
                end
            end
        end
    end

    if not orb then
        orb = enums.Orbs.RANDOM
    end

    return orb
end

---@param shatteredOrb EntityEffect
local function SpawnWisps(shatteredOrb)
    local spawner = shatteredOrb.SpawnerEntity
    if not spawner then return end
    local player = spawner:ToPlayer()
    if not player then return end
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then return end

    local wisps = TSIL.Random.GetRandomElementsFromTable(
        PossibleWisps,
        1,
        player:GetCollectibleRNG(enums.Collectibles.SHATTERED_ORB)
    )
    for _, wisp in ipairs(wisps) do
        player:AddWisp(wisp, shatteredOrb.Position)
    end
end


---@param shatteredOrb EntityEffect
function ShatteredOrb:OnShatteredOrbUpdate(shatteredOrb)
    local sprite = shatteredOrb:GetSprite()

    if sprite:IsPlaying("Shatter") or sprite:IsPlaying("Capture") or sprite:IsPlaying("Broken") then
        shatteredOrb.Velocity = Vector.Zero
        return
    end

    if sprite:IsFinished("Shatter") then
        sprite:Play("Broken", true)
        return
    end

    if sprite:IsFinished("Capture") then
        shatteredOrb:Remove()
        return
    end

    local shatteredOrbData = GetShatteredOrbData(shatteredOrb)

    shatteredOrb.Velocity = shatteredOrbData.direction

    shatteredOrb.SpriteOffset = shatteredOrb.SpriteOffset + Vector(0, shatteredOrbData.fallingSpeed)

    if shatteredOrb.FrameCount >= SHATTERED_ORB_TIME_UNTIL_FALL then
        shatteredOrbData.fallingSpeed = shatteredOrbData.fallingSpeed +
        SHATTERED_ORB_FALL_ACCEL * (shatteredOrb.FrameCount - SHATTERED_ORB_TIME_UNTIL_FALL)
    end


    if shatteredOrb.SpriteOffset.Y >= -10 then
        SpawnWisps(shatteredOrb)
        SFXManager():Play(SoundEffect.SOUND_MIRROR_BREAK, 1, 2, false, 1.3)

        MusicManager():Pause()
        TSIL.Utils.Functions.RunInFrames(function()
            MusicManager():Resume()
        end, 30 * 2)

        sprite:Load("/gfx/shattered_orb_effects.anm2", true)
        sprite:Play("Shatter", true)

        shatteredOrb:Die()

        return
    end

    local npcs = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, true)
    npcs = TSIL.Utils.Tables.Filter(npcs, function(_, npc)
        return npc:IsVulnerableEnemy() and not npc:IsBoss() and
            not (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or
                npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL))
    end)

    for _, npc in ipairs(npcs) do
        local distanceSqr = npc.Position:DistanceSquared(shatteredOrb.Position)
        local distanceToCollide = npc.Size + SHATTERED_ORB_RADIUS
        distanceToCollide = distanceToCollide ^ 2

        if distanceSqr < distanceToCollide then
            npc:Remove()

            local orbToSpawn = GetEntityOrb(npc)
            local belialConversion = false

            local player = shatteredOrb.SpawnerEntity and shatteredOrb.SpawnerEntity:ToPlayer() if not player then return end
            if orbToSpawn == enums.Orbs.RANDOM
            and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
                local roll = TSIL.Random.GetRandomInt(1, 100, player:GetCollectibleRNG(enums.Collectibles.SHATTERED_ORB))
                if roll <= JUDAS_CONVERT_CHANCE then
                    orbToSpawn = enums.Orbs.UNHOLY
                    belialConversion = true
                end
            end

            local orb = TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_TAROTCARD,
                orbToSpawn,
                npc.Position
            )

            if belialConversion then
                SFXManager():Play(SoundEffect.SOUND_UNHOLY)
                Game():SpawnParticles(orb.Position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, BELIAL_PARTICLE_COUNT, BELIAL_PARTICLE_SPEED, BELIAL_PARTICLE_COLOR)
            end

            sprite:Load("/gfx/shattered_orb_effects.anm2", true)
            sprite:Play("Capture", true)
            break
        end
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    ShatteredOrb.OnShatteredOrbUpdate,
    enums.Effects.SHATTERED_ORB
)

return ShatteredOrb
