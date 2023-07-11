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
    MilkshakeVol1.API:AddSoulStone(FiendFolio.ITEM.CARD.SOUL_OF_FIEND, function()
        return FiendFolio.ACHIEVEMENT.SOUL_OF_FIEND:IsUnlocked(false)
    end)
    --MilkshakeVol1.API:AddSoulStones(FiendFolio.ITEM.CARD.SOUL_OF_GOLEM, FiendFolio.ACHIEVEMENT.SOUL_OF_GOLEM:IsUnlocked(false))

    --Add entities to shattered orb
    local OrbsPerFiendFolioEntities = {
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=210, }, --Tado Kid
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=29, variant=960, }, --Tot
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=170, variant=90, }, --Pyroclasm
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=234, variant=960, }, --Jawbone
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=258, variant=961, }, --Ribbone
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=666, variant=20, }, --Baro
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1160, }, --Deathany
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1140, }, --Clergy
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=41, variant=114, }, --Psychoknight
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1100, }, --Sixth
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=240, variant=450, }, --Arcane Creep
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=25, variant=920, }, --Psycho Fly
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=7, }, --Psystalk
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=7, subtype=1, }, --Psystalk
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=7,2, }, --Psystalk
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=130, variant=40, }, --Morvid
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=10, variant=40, subtype=1, }, --
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=59, }, --Acolyte
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=1, }, --Skulltist
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=21, }, --Zissuru
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=29, }, --Madhat
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=24, }, --Psyclopia
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=27, }, --Alderman
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=52, }, --Lunksack
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=30, }, --Grimoire
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=25, }, --Nihilist
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=1130, }, --Looksee
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=451, variant=220, }, --Temptress
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=451, variant=220, subtype=1, }, --Temptress
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=877, variant=114, }, --Grievance
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=18, }, --Maze Runner
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=750, variant=201, subtype=11, }, --Bead Fly
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=108, variant=118, }, --Eye of Shaggoth
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=156, variant=0, }, --Craterface
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=971, }, --Neonate
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=510, }, --Peepling
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=451, variant=180, }, --Frayed Nerve
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=114, variant=50, subtype=0, }, --Whale
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=901, }, --Enlightened --Enlightened
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=900, }, --Inner Eye --Inner Eye
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=521, }, --Effigy --Effigy
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=420, }, --Primemind --Primemind
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=870, subtype=1, }, --Armoured Looker
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=960, }, --Seeker
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=108, variant=111, }, --Watcher
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=108, variant=112, }, --Watcher Eye
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=37, }, --Dogrock
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=120, variant=236, }, --Thrall
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=670, }, --Ms. Dominator
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=150, variant=23, }, --Psyeg
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=341, }, --Psleech
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=21, variant=961, }, --Psionic Knight
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=34, }, --Outlier
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=340, }, --Foreseer
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=450, variant=1510, }, --Observer
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=951, }, --Eclipse
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=112, variant=1, }, --Sombra
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=822, subtype=2, }, --Slim Shady
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=160, variant=80, subtype=3, }, --Dweller
        {orb=MilkshakeVol1.enums.Orbs.PSYCHIC, type=120, variant=232, subtype=1, }, --Foetus
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=151, variant=5, }, --S'More
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=310, }, --Woodburner
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=750, variant=110, }, --Wick
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=280, }, --Mr. Flare
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=281, }, --Mr. Crisply
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=240, variant=700, }, --Fried
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=61, variant=960, }, --Spitroast
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=152, }, --Spark
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=151, }, --Litling
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=430, }, --Charlie
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=208, variant=963, }, --Big Smoke
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=114, variant=33, }, --Brisket
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=817, variant=140, }, --Smogger
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=350, }, --Fumegeist
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=351, }, --Mote
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=441, }, --Smokin
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=442, }, --Flamin
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=180, variant=21, }, --Commission
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=1080, }, --Mini-Min
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=114, variant=4, }, --Bellow
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=33, }, --Tricko
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=2, }, --Ring Leader
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=42, }, --Aleya
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=1160, }, --Deathany
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=7, }, --Ashtray
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=43, subtype=1, }, --Chunky
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=35, }, --Grilled Meatwad
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=42, variant=964, }, --Casted
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=661, }, --Pitchfork Hitcher
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=156, variant=666, }, --Blazer
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=1170, }, --Bull
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=170, variant=80, }, --Phoenix
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=153, }, --Glob
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=153, subtype=1, }, --Glob
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=154, }, --Sizzle
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=160, variant=154, subtype=1, }, --Sizzle
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=815, variant=960, }, --Fuego
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=450, variant=14, }, --Roasty
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=40, }, --Coalby
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=41, }, --Coupile
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=451, variant=42, }, --Cairn
        {orb=MilkshakeVol1.enums.Orbs.FIRE, type=170, variant=110, }, --Blastcore
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=640, }, --Zapbladder
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=641, }, --Wire
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=170, variant=30, }, --Lightning Fly
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=114, variant=65, }, --Anode
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=140, }, --Craig
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=10, }, --Grazer
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=1120, }, --Technician
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=21, }, --Shock Collar
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=114, variant=10, }, --Drillbit
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=5, }, --Thumper
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=1150, }, --Stolas
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=120, variant=222, }, --Onlooker
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=20, }, --Weeper
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=420, }, --Primemind
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=450, variant=1510, }, --Observer
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=250, }, --Zephyr
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=451, variant=141, }, --Roy Gerald Dericott II
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=617, variant=402, }, --Beacon
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=80, subtype=68, }, --Dweller
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=160, variant=85, subtype=395, }, --Missing Link
        {orb=MilkshakeVol1.enums.Orbs.ELECTRIC, type=195, variant=30}, --Volt
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=360, }, --Sourpatch
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=29, variant=962, }, --Sourpatch Head
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=361, }, --Sourpatch Body
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=1718, }, --Carrot
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=750, }, --Shiitake
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=840, }, --Ramblin' Evil Mushroom
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=2001, }, --Cordy
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=2000, }, --Splattercap
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=666, variant=110, }, --Wobbles
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=451, variant=30, }, --Infected Mushroom
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=25, variant=962, }, --Warhead
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=683, }, --Bunch
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=683, subtype=1, }, --Bunch
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=90, }, --Warty
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=160, variant=60, }, --Frog
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=170, variant=100, }, --Prick
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=114, variant=57, }, --Spiroll
        {orb=MilkshakeVol1.enums.Orbs.NATURE, type=450, variant=6, }, --Coconut
    }
    MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerFiendFolioEntities)
    local ffPills = {
                        [101] = MilkshakeVol1.enums.Orbs.RANDOM,
                        [102] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [103] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [104] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [105] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [106] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [107] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [108] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [109] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [110] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [111] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [112] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [113] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [114] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [115] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [116] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [117] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [118] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [119] =  MilkshakeVol1.enums.Orbs.RANDOM,
                        [120] =  MilkshakeVol1.enums.Orbs.RANDOM,
                    }
    for i, value in pairs(ffPills) do
        MilkshakeVol1.API:AddOrbsPerPill(i, value)
    end
end)