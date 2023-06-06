 MilkshakeVol1:AddModCompatibility("FiendFolio", function ()
    --Add coins
    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.SHARP_PENNY, function (_, player)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM)
        SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL)
    end)

    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.EGG_PENNY, function (_, player)
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FiendFolio.ITEM.FAMILIAR.FRAGILE_BOBBY, 0, player.Position, Vector.Zero, player)
        SFXManager():Play(SoundEffect.SOUND_DERP)
    end)

    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.FUZZY_PENNY, function (_, player)
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ATTACK_SKUZZ, 0, player.Position, Vector.Zero, player)
        SFXManager():Play(SoundEffect.SOUND_SKIN_PULL, 0.6, 0, false, 1.5)
        --SOUND_PESTILENCE_MAGGOT_ENTER (probably wont use this for anything)
    end)

    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.MOLTEN_PENNY, function (_, player)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)
        SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS)
    end)

    --Add brenda payouts
    MilkshakeVol1.API:AddSoulStones(FiendFolio.ITEM.CARD.SOUL_OF_FIEND, FiendFolio.ACHIEVEMENT.SOUL_OF_FIEND:IsUnlocked(false))
    --MilkshakeVol1.API:AddSoulStones(FiendFolio.ITEM.CARD.SOUL_OF_GOLEM, FiendFolio.ACHIEVEMENT.SOUL_OF_GOLEM:IsUnlocked(false))

    --Add entities to shattered orb
    local OrbsPerFiendFolioEntities = {
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=210, }, --Tado Kid
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=29, variant=960, }, --Tot
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=170, variant=90, }, --Pyroclasm
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=234, variant=960, }, --Jawbone
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=258, variant=961, }, --Ribbone
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=666, variant=20, }, --Baro
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1160, }, --Deathany
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1140, }, --Clergy
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=41, variant=114, }, --Psychoknight
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1100, }, --Sixth
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=240, variant=450, }, --Arcane Creep
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=25, variant=920, }, --Psycho Fly
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=7, }, --Psystalk
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=7, subtype=1, }, --Psystalk
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=7,2, }, --Psystalk
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=130, variant=40, }, --Morvid
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=10, variant=40, subtype=1, }, --
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=59, }, --Acolyte
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=1, }, --Skulltist
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=21, }, --Zissuru
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=29, }, --Madhat
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=24, }, --Psyclopia
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=27, }, --Alderman
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=52, }, --Lunksack
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=30, }, --Grimoire
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=25, }, --Nihilist
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1130, }, --Looksee
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=451, variant=220, }, --Temptress
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=451, variant=220, subtype=1, }, --Temptress
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=877, variant=114, }, --Grievance
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=18, }, --Maze Runner
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=750, variant=201, subtype=11, }, --Bead Fly
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=108, variant=118, }, --Eye of Shaggoth
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=156, variant=0, }, --Craterface
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=971, }, --Neonate
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=510, }, --Peepling
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=451, variant=180, }, --Frayed Nerve
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=50, subtype=0, }, --Whale
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=901, }, --Enlightened --Enlightened
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=900, }, --Inner Eye --Inner Eye
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=521, }, --Effigy --Effigy
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=420, }, --Primemind --Primemind
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=870, subtype=1, }, --Armoured Looker
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=960, }, --Seeker
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=108, variant=111, }, --Watcher
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=108, variant=112, }, --Watcher Eye
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=37, }, --Dogrock
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=120, variant=236, }, --Thrall
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=670, }, --Ms. Dominator
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=150, variant=23, }, --Psyeg
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=341, }, --Psleech
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=21, variant=961, }, --Psionic Knight
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=34, }, --Outlier
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=340, }, --Foreseer
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=1510, }, --Observer
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=951, }, --Eclipse
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=112, variant=1, }, --Sombra
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=822, subtype=2, }, --Slim Shady
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC_ORB, type=160, variant=80, subtype=3, }, --Dweller
        {trinket=MilkshakeVol1.enums.Orbs.PSYCHIC, type=120, variant=232, subtype=1, }, --Foetus
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=151, variant=5, }, --S'More
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=310, }, --Woodburner
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=750, variant=110, }, --Wick
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=280, }, --Mr. Flare
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=281, }, --Mr. Crisply
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=240, variant=700, }, --Fried
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=61, variant=960, }, --Spitroast
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=152, }, --Spark
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=151, }, --Litling
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=430, }, --Charlie
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=208, variant=963, }, --Big Smoke
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=114, variant=33, }, --Brisket
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=817, variant=140, }, --Smogger
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=350, }, --Fumegeist
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=351, }, --Mote
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=441, }, --Smokin
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=442, }, --Flamin
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=180, variant=21, }, --Commission
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=1080, }, --Mini-Min
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=114, variant=4, }, --Bellow
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=33, }, --Tricko
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=2, }, --Ring Leader
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=42, }, --Aleya
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=1160, }, --Deathany
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=7, }, --Ashtray
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=43, subtype=1, }, --Chunky
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=35, }, --Grilled Meatwad
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=42, variant=964, }, --Casted
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=661, }, --Pitchfork Hitcher
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=156, variant=666, }, --Blazer
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=1170, }, --Bull
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=170, variant=80, }, --Phoenix
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=153, }, --Glob
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=153, subtype=1, }, --Glob
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=154, }, --Sizzle
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=154, subtype=1, }, --Sizzle
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=815, variant=960, }, --Fuego
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=14, }, --Roasty
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=40, }, --Coalby
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=41, }, --Coupile
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=42, }, --Cairn
        {trinket=MilkshakeVol1.enums.Orbs.FIRE, type=170, variant=110, }, --Blastcore
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=640, }, --Zapbladder
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=641, }, --Wire
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=170, variant=30, }, --Lightning Fly
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=114, variant=65, }, --Anode
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=140, }, --Craig
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=10, }, --Grazer
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=1120, }, --Technician
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=21, }, --Shock Collar
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=114, variant=10, }, --Drillbit
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=5, }, --Thumper
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=1150, }, --Stolas
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=120, variant=222, }, --Onlooker
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=20, }, --Weeper
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=420, }, --Primemind
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=1510, }, --Observer
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=250, }, --Zephyr
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=141, }, --Roy Gerald Dericott II
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=617, variant=402, }, --Beacon
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=80, subtype=68, }, --Dweller
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=85, subtype=395, }, --Missing Link
        {trinket=MilkshakeVol1.enums.Orbs.ELECTRIC, type=195, variant=30}, --Volt
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=360, }, --Sourpatch
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=29, variant=962, }, --Sourpatch Head
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=361, }, --Sourpatch Body
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=1718, }, --Carrot
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=750, }, --Shiitake
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=840, }, --Ramblin' Evil Mushroom
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=2001, }, --Cordy
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=2000, }, --Splattercap
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=666, variant=110, }, --Wobbles
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=451, variant=30, }, --Infected Mushroom
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=25, variant=962, }, --Warhead
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=683, }, --Bunch
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=683, subtype=1, }, --Bunch
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=90, }, --Warty
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=60, }, --Frog
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=170, variant=100, }, --Prick
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=114, variant=57, }, --Spiroll
        {trinket=MilkshakeVol1.enums.Orbs.NATURE, type=450, variant=6, }, --Coconut
    }
    MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerFiendFolioEntities)
end)