MilkshakeVol1:AddModCompatibility("Retribution", function()
    local OrbsPerRetributionEntities = {
        { orb = MilkshakeVol1.enums.Orbs.NATURE, type = 793, variant = 1888 },    -- circe swine
        { orb = MilkshakeVol1.enums.Orbs.NATURE, type = 793, variant = 1889 },    -- spirit
        { orb = MilkshakeVol1.enums.Orbs.NATURE, type = 793, variant = 1890 },    -- lifeseed spirit
        { orb = MilkshakeVol1.enums.Orbs.NATURE, type = 793, variant = 1891,}, -- viscerine
        { orb = MilkshakeVol1.enums.Orbs.FIRE,   type = 793, variant = 1892 },    -- pig bang
        { orb = MilkshakeVol1.enums.Orbs.HOLY,   type = 950, variant = 1873 },    -- hogma
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY, type = 38,  variant = 1,    subtype = 118 }, -- samael angel
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,  type = 15,  variant = 1873 },    -- curdle
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 282, variant = 1873 },    -- mega clot
        { orb = MilkshakeVol1.enums.Orbs.FIRE,   type = 25,  variant = 1873 },    -- kaboom fly
        { orb = MilkshakeVol1.enums.Orbs.WATER,  type = 25,  variant = 1874 },    -- bloated fly
        { orb = MilkshakeVol1.enums.Orbs.NATURE, type = 25,  variant = 1875 },    -- spew fly
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 89,  variant = 0,    subtype = 183 }, -- buttmuncher
        { orb = MilkshakeVol1.enums.Orbs.WATER,  type = 239, variant = 0,    subtype = 183 }, -- drowned grub
        { orb = MilkshakeVol1.enums.Orbs.WATER,  type = 21,  variant = 1873 },    -- drowned maggot
        { orb = MilkshakeVol1.enums.Orbs.WATER,  type = 31,  variant = 1873 },    -- drowned spitty
        { orb = MilkshakeVol1.enums.Orbs.WATER,  type = 243, variant = 1873 },    -- drowned conjoined spitty
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 217, variant = 1873 },    -- dripling
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 220, variant = 1873 },    -- dropling
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 220, variant = 1873, subtype = 1 }, -- dank dropling
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 223, variant = 1873 },    -- drossling
        { orb = MilkshakeVol1.enums.Orbs.NATURE, type = 61,  variant = 1873 },    -- full sucker
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 61,  variant = 1874 },    -- full spit
        { orb = MilkshakeVol1.enums.Orbs.WATER,  type = 61,  variant = 1875 },    -- sip
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,  type = 88,  variant = 0,    subtype = 183 }, -- stumbling boil
        { orb = MilkshakeVol1.enums.Orbs.POISON, type = 88,  variant = 1,    subtype = 183 }, -- stumbling gut
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,  type = 88,  variant = 2,    subtype = 183 }, -- stumbling sack
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,  type = 240, variant = 1873 },    -- wall writhe
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,  type = 242, variant = 1873 },    -- blind writhe
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY, type = 241, variant = 1873 },    -- rage writhe
        { orb = MilkshakeVol1.enums.Orbs.CHAOS,  type = 288, variant = 1873 },    -- huskie
        { orb = MilkshakeVol1.enums.Orbs.NATURE, type = 244, variant = 1873 },    -- pinhead
        { orb = MilkshakeVol1.enums.Orbs.FIRE,   type = 255, variant = 1873 },    -- pinprick
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 88,  variant = 0,    subtype = 184 }, -- walking blue boil
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 88,  variant = 0,    subtype = 185 }, -- stumbling blue boil
    }
    MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerRetributionEntities)

    ---Toxic orb
    MilkshakeVol1.API:AddToxicOrbBeggar(Isaac.GetEntityVariantByName("Swine Beggar"))
    MilkshakeVol1.API:AddToxicOrbBeggar(Isaac.GetEntityVariantByName("Angelic Swine Beggar"))
    MilkshakeVol1.API:AddToxicOrbBeggar(Isaac.GetEntityVariantByName("Demonic Swine Beggar"))
    ---Unholy orb
    local capsules = {
        Config = { Count = 1, MinCount = 0 },
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("Damage Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("Health Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("Luck Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("Range Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("Shotspeed Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("Speed Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("Tears Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("HD Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("LD Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("RD Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("SD Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("MD Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("TD Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("HL Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("HR Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("HS Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("HM Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("HT Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("LR Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("LS Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("LM Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("LT Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("RS Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("RM Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("RT Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("SM Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("ST Capsule"), SubType = 0},
        {Type = EntityType.ENTITY_PICKUP, Variant = Isaac.GetEntityVariantByName("MT Capsule"), SubType = 0},
    }
    MilkshakeVol1.API:AddUnholyOrbBeggar(Isaac.GetEntityVariantByName("Swine Beggar"), capsules)
    MilkshakeVol1.API:AddUnholyOrbBeggar(Isaac.GetEntityVariantByName("Angelic Swine Beggar"), capsules)
    MilkshakeVol1.API:AddUnholyOrbBeggar(Isaac.GetEntityVariantByName("Demonic Swine Beggar"), capsules)

end)
