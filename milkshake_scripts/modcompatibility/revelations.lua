MilkshakeVol1:AddModCompatibility("REVEL", function()
    local OrbsPerRevelationsEntities = {
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 624, variant = 541 },   -- snow flake
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 624, variant = 542 },   -- big snow flake
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 450, variant = 333 },   -- ice stalactite
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 450, variant = 332 },   -- smallactite
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 460, variant = 541 },   -- snowball
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 461, variant = 541 },   -- blockhead
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 461, variant = 542 },   -- cardinal blockhead
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 461, variant = 543 },   -- yellow blockhead
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 461, variant = 544 },   -- yellow cardinal blockhead
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 10,  variant = 542 },   -- block gaper
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 10,  variant = 543 },   -- cardinal block gaper
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 10,  variant = 544 },   -- yellow block gaper
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 10,  variant = 545 },   -- yellow cardinal block gaper
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 10,  variant = 546 },   -- block block block gaper
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 462, variant = 541 },   -- geicer
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 455, variant = 541 },   -- iced spider
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 455, variant = 542 },   -- yellow iced spider
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 476, variant = 541 },   -- drifty
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 22,  variant = 541 },   -- hice
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 478, variant = 541 },   -- cloudy
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 480, variant = 541 },   -- smolycephalus
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 338 },   -- ice hazard gaper
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 337 },   -- ice hazard horf
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 336 },   -- ice hazard hopper
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 335 },   -- ice hazard drifty
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 334 },   -- ice hazard clotty
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 333 },   -- ice hazard brother bloody
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 481, variant = 332 },   -- ice hazard troll bomb
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 331 },   -- ice hazard i.blob
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 481, variant = 330 },   -- ice hazard empty
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 476, variant = 542 },   -- pucker
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 483, variant = 541 },   -- brainfreeze
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 485, variant = 541 },   -- rolling snowball
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 485, variant = 542 },   -- snot rocket
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 482, variant = 543 },   -- snowbob
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 482, variant = 542 },   -- snowbob head
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 482, variant = 541 },   -- snowbob head (tears)
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 484, variant = 541 },   -- fatsnow
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 487, variant = 334 },   -- chill o' wisp
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 487, variant = 335 },   -- ice wraith
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 487, variant = 335, subtype = 1 }, -- ice wraith body
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 487, variant = 333 },   -- grill o' wisp
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 487, variant = 333, subtype = 1 }, -- small grill o' wisp
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 488, variant = 541 },   -- brother bloody
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 634, variant = 541 },   -- ice pooter
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 489, variant = 541 },   -- iced hive
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 490, variant = 541 },   -- stalactrite
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 491, variant = 541 },   -- ice worm
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 492, variant = 541 },   -- yellow snow
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 590, variant = 541 },   -- sickie
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 591, variant = 541 },   -- yellow snowball
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,  type = 460, variant = 542 },   -- strawberry snowball
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 500, variant = 541 },   -- rag tag
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 501, variant = 541 },   -- arrowhead
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 502, variant = 541 },   -- rag gaper
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 507, variant = 541 },   -- rag gaper (head)
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 11,  variant = 543 },   -- rag gusher
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 503, variant = 541 },   -- sandbob
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 503, variant = 542 },   -- sandbip
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 503, variant = 543 },   -- demobip
        { orb = MilkshakeVol1.enums.Orbs.SAND,    type = 503, variant = 544 },   -- bloatbip
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 504, variant = 541 },   -- antlion
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 504, variant = 541, subtype = 1 }, -- antlion (shuts doors)
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 506, variant = 541 },   -- pyramid head
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 742, variant = 163 },   -- anima
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 743, variant = 541 },   -- locust
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 744, variant = 541 },   -- rag bony
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 745, variant = 541 },   -- mother pucker
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 746, variant = 541 },   -- aerotoma
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 747, variant = 541, subtype = 0 }, -- rag trite
        { orb = MilkshakeVol1.enums.Orbs.POISON,  type = 748, variant = 541 },   -- innard
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 749, variant = 541 },   -- necragmancer
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 749, variant = 542 },   -- necragmancer no shut doors
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,  type = 508, variant = 541 },   -- prank shop
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 751, variant = 541 },   -- wretcher
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 752, variant = 541 },   -- sandshaper
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,  type = 753, variant = 1006 },  -- prank (tomb)
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,  type = 753, variant = 1005 },  -- prank (glacier)
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 754, variant = 541 },   -- urny
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 759, variant = 541 },   -- cannonbip
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 759, variant = 541, subtype = 10 }, -- cannonbip projectile
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 755, variant = 541 },   -- snipebip
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 756, variant = 541 },   -- trenchbip
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 757, variant = 541 },   -- rag fatty
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 760, variant = 541 },   -- firecaller (tomb)
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 760, variant = 542 },   -- firecaller (glacier)
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 762, variant = 541 },   -- sand worm
        { orb = MilkshakeVol1.enums.Orbs.HOLY,    type = 925, variant = 541 },   -- skitterpill good
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,  type = 925, variant = 542 },   -- skitterpill bad
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 763, variant = 541 },   -- peashy
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 763, variant = 542 },   -- peashy nail
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 763, variant = 542, subtype = 1 }, -- peashy nail (in ground)
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 764, variant = 541, subtype = 0 }, -- chicken
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 240, variant = 541 },   -- stone creep
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 218, variant = 541 },   -- button masher
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 766, variant = 541 },   -- slambip
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 767, variant = 541 },   -- tile monger
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 768, variant = 541 },   -- rag drifty
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 768, variant = 542 },   -- pseudo rag drifty
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 524, variant = 541 },   -- antlion baby
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 526, variant = 541 },   -- antlion egg
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 3,   variant = 1778 },  -- antlion familiar
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 925, variant = 543 },   -- skitterpill card
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,   type = 449, variant = 541 },   -- smolycephalus for scale
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 203, variant = 541 },   -- big blowy
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 203, variant = 542 },   -- igloo
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 203, variant = 543 },   -- frost shooter
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 735, variant = 541 },   -- draugr
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 735, variant = 542 },   -- haugr
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 735, variant = 543 },   -- jaugr
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 735, variant = 544 },   -- juniaugr
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 614, variant = 541 },   -- sasquatch
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 614, variant = 542 },   -- ice block
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 792, variant = 541 },   -- avalanche
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 319, variant = 2678 },  -- snowst
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 25,  variant = 541 },   -- shy fly
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 214, variant = 541 },   -- cryo fly
        { orb = MilkshakeVol1.enums.Orbs.WATER,   type = 658, variant = 541 },   -- huffpuff
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 667, variant = 541 },   -- tusky
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 659, variant = 541 },   -- emperor
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 462, variant = 542 },   -- coal heater
        { orb = MilkshakeVol1.enums.Orbs.FIRE,    type = 450, variant = 334 },   -- coal shard
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 703, variant = 541, subtype = 0 }, -- harfang
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,  type = 891, variant = 541 },   -- jackal
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,  type = 891, variant = 1,   subtype = 41 }, -- gilded jackal
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 773, variant = 541 },   -- stabstack
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 773, variant = 542 },   -- stabstack piece
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 773, variant = 543 },   -- stabstack rolling piece
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 776, variant = 541, subtype = 0 }, -- purgatory soul (enemy)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,  type = 704, variant = 541, subtype = 0 }, -- ragma
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 705, variant = 541, subtype = 0 }, -- pine
        { orb = MilkshakeVol1.enums.Orbs.NATURE,  type = 705, variant = 542 },   -- pinecone
        { orb = MilkshakeVol1.enums.Orbs.ROCK,    type = 706, variant = 541, subtype = 0 }, -- dune
    }
    MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerRevelationsEntities)
end)
