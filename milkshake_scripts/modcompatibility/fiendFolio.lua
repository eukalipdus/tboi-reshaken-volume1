local mod = FiendFolio

local PENNY_MIN = 1
local PENNY_MAX = 4
local DIME_MIN = 4
local DIME_MAX = 12

local isCursedPenny = {
    [FiendFolio.PICKUP.COIN.CURSED] = true,
    [FiendFolio.PICKUP.COIN.GOLDENCURSED] = true,
    [FiendFolio.PICKUP.COIN.MEDLEY] = true,
}

---Almost does the same effect Penny Stack would have,
---taken from Fiend Folio
---@param player EntityPlayer
---@param pickup EntityPickup
local function PennyStackPickup(player, pickup)
    local value = math.max(0, math.min(1, 10))
    local minSpawn, maxSpawn
    
    if value < 1 then
        minSpawn = 0
        maxSpawn = math.ceil(value * PENNY_MAX)
    else
        local n = (value-1) / 9
        minSpawn = math.ceil(FiendFolio:Lerp(PENNY_MIN, DIME_MIN, n))
        maxSpawn = math.ceil(FiendFolio:Lerp(PENNY_MAX, DIME_MAX, n))
    end

    local numToSpawn = minSpawn + (pickup.InitSeed % (maxSpawn - minSpawn + 1))
    
    for i=1, numToSpawn do
        local speed = 1.5 + 2.5 * pickup:GetDropRNG():RandomFloat()
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, FiendFolio.PICKUP.COIN.LIL_PENNY, pickup.Position, RandomVector() * speed, nil)
    end
end

---Pick up effect for Flaming Penny, taken from Fiend Folio
---@param player EntityPlayer
---@param pickup EntityPickup
local function FlamingPennyPickup(player, pickup)
    local data = FiendFolio:GetEntityData(player)
    local sdata = data.ffsavedata
    if sdata.orbitingfireballs and sdata.orbitingfireballs < FiendFolio:GetFireballCap(player) + 3 then
        local fiendflasheffect = Isaac.Spawn(1000, 668, 0, player.Position, Vector(0,0), player):ToEffect()
        FiendFolio:GetEntityData(fiendflasheffect).parent = player
        if FiendFolio:isSuperpositionedPlayer(player) then
            local flashcolor = Color.Lerp(fiendflasheffect.Color, Color(1,1,1,1,0,0,0), 0)
            flashcolor.A = flashcolor.A / 4
            fiendflasheffect.Color = flashcolor
        end
        SFXManager():Play(SoundEffect.SOUND_FLAME_BURST, 0.3, 0, false, math.random(150,160)/100)

        sdata.orbitingfireballs = sdata.orbitingfireballs + 1
        if isCursedPenny[pickup.SubType] then
            data.nextFireballShouldBeFiendish = true
        end
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
        player:EvaluateItems()
    end
end

MilkshakeVol1:AddModCompatibility("FiendFolio", function()
    --Add coins
    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.SHARP_PENNY,
        function(_, player)
            player:UseActiveItem(CollectibleType.COLLECTIBLE_DULL_RAZOR, UseFlag.USE_NOANIM)
            SFXManager():Play(SoundEffect.SOUND_KNIFE_PULL)
            player:BloodExplode()
        end, 0.10)

    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.EGG_PENNY,
        function(_, player)
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FiendFolio.ITEM.FAMILIAR.FRAGILE_BOBBY, 0, player.Position,
                Vector.Zero, player)
            SFXManager():Play(SoundEffect.SOUND_DERP)
        end, 0.15)

    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.FUZZY_PENNY,
        function(_, player)
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ATTACK_SKUZZ, 0, player.Position, Vector.Zero, player)
            SFXManager():Play(SoundEffect.SOUND_SKIN_PULL, 0.6, 0, false, 1.5)
            --SOUND_PESTILENCE_MAGGOT_ENTER (probably wont use this for anything)
        end, 0.25)

    MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.MOLTEN_PENNY,
        function(_, player)
            player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)
            SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS)
        end, 0.05)


    if FiendFolio.RELOADED == true then

        MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.SCARAB_PENNY,
            function(_, player)
                FiendFolio:ThrowBlueBeetle(player)
            end, 0.25)

        MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.FLAMING_PENNY,
            function(pickup, player)
                FlamingPennyPickup(player, pickup)
            end, 0.05)

        MilkshakeVol1.API:AddRainbowPenny(PickupVariant.PICKUP_COIN, MilkshakeVol1.enums.Coins.STACKED_PENNY,
            function(pickup, player)
                PennyStackPickup(player, pickup)
            end, 0.05)
    end

    --Add brenda payouts
    MilkshakeVol1.API:AddSoulStone(FiendFolio.ITEM.CARD.SOUL_OF_FIEND, function()
        return FiendFolio.ACHIEVEMENT.SOUL_OF_FIEND:IsUnlocked(false)
    end)
    --MilkshakeVol1.API:AddSoulStones(FiendFolio.ITEM.CARD.SOUL_OF_GOLEM, FiendFolio.ACHIEVEMENT.SOUL_OF_GOLEM:IsUnlocked(false))

    --Add entities to shattered orb
    local OrbsPerFiendFolioEntities = {
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 210, },                 --Tado Kid
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 29,  variant = 960, },                 --Tot
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 170, variant = 90, },                  --Pyroclasm
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 234, variant = 960, },                 --Jawbone
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 258, variant = 961, },                 --Ribbone
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 666, variant = 20, },                  --Baro
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 1160, },                --Deathany
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 1140, },                --Clergy
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 41,  variant = 114, },                 --Psychoknight
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 1100, },                --Sixth
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 240, variant = 450, },                 --Arcane Creep
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 25,  variant = 920, },                 --Psycho Fly
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 7, },                   --Psystalk
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 7,    subtype = 1, },   --Psystalk
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 7,    2, },             --Psystalk
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 130, variant = 40, },                  --Morvid
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 10,  variant = 40,   subtype = 1, },   --
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 59, },                  --Acolyte
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 450, variant = 1, },                   --Skulltist
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 21, },                  --Zissuru
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 450, variant = 29, },                  --Madhat
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 24, },                  --Psyclopia
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 27, },                  --Alderman
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 52, },                  --Lunksack
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 450, variant = 30, },                  --Grimoire
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 450, variant = 25, },                  --Nihilist
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 1130, },                --Looksee
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 451, variant = 220, },                 --Temptress
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 451, variant = 220,  subtype = 1, },   --Temptress
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 877, variant = 114, },                 --Grievance
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 450, variant = 18, },                  --Maze Runner
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 750, variant = 201,  subtype = 11, },  --Bead Fly
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 108, variant = 118, },                 --Eye of Shaggoth
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 156, variant = 0, },                   --Craterface
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 971, },                 --Neonate
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 510, },                 --Peepling
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 451, variant = 180, },                 --Frayed Nerve
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 114, variant = 50,   subtype = 0, },   --Whale
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 901, },                 --Enlightened --Enlightened
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 900, },                 --Inner Eye --Inner Eye
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 521, },                 --Effigy --Effigy
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 420, },                 --Primemind
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 870,  subtype = 1, },   --Armoured Looker
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 960, },                 --Seeker
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 108, variant = 111, },                 --Watcher
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 108, variant = 112, },                 --Watcher Eye
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 450, variant = 37, },                  --Dogrock
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 120, variant = 236, },                 --Thrall
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 670, },                 --Ms. Dominator
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 150, variant = 23, },                  --Psyeg
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 341, },                 --Psleech
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 21,  variant = 961, },                 --Psionic Knight
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 34, },                  --Outlier
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 340, },                 --Foreseer
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 450, variant = 1510, },                --Observer
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 951, },                 --Eclipse
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 112, variant = 1, },                   --Sombra
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 822,  subtype = 2, },   --Slim Shady
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 160, variant = 80,   subtype = 3, },   --Dweller
        { orb = MilkshakeVol1.enums.Orbs.PSYCHIC,  type = 120, variant = 232,  subtype = 1, },   --Foetus
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 151, variant = 5, },                   --S'More
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 310, },                 --Woodburner
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 750, variant = 110, },                 --Wick
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 280, },                 --Mr. Flare
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 281, },                 --Mr. Crisply
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 240, variant = 700, },                 --Fried
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 61,  variant = 960, },                 --Spitroast
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 152, },                 --Spark
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 451, variant = 151, },                 --Litling
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 430, },                 --Charlie
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 208, variant = 963, },                 --Big Smoke
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 114, variant = 33, },                  --Brisket
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 817, variant = 140, },                 --Smogger
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 350, },                 --Fumegeist
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 351, },                 --Mote
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 441, },                 --Smokin
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 442, },                 --Flamin
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 451, variant = 100, },                 --Trailblazer
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 451, variant = 100,  subtype = 1, },   --Trailblazer Flame Segment
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 451, variant = 150, },                 --Chili
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 180, variant = 21, },                  --Commission
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 1080, },                --Mini-Min
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 114, variant = 4, },                   --Bellow
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 450, variant = 33, },                  --Tricko
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 450, variant = 2, },                   --Ring Leader
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 450, variant = 42, },                  --Aleya
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 1160, },                --Deathany
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 450, variant = 7, },                   --Ashtray
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 450, variant = 43,   subtype = 1, },   --Chunky
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 35, },                  --Grilled Meatwad
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 42,  variant = 964, },                 --Casted
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 661, },                 --Pitchfork Hitcher
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 156, variant = 666, },                 --Blazer
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 1170, },                --Bull
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 170, variant = 80, },                  --Phoenix
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 153, },                 --Glob
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 153,  subtype = 1, },   --Glob
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 154, },                 --Sizzle
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 154,  subtype = 1, },   --Sizzle
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 815, variant = 960, },                 --Fuego
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 450, variant = 14, },                  --Roasty
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 451, variant = 40, },                  --Coalby
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 451, variant = 41, },                  --Coupile
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 451, variant = 42, },                  --Cairn
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 114, variant = 8,    subtype = 1, },   --Crucible (ignited)
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 170, variant = 110, },                 --Blastcore
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 450, variant = 40, },                  --Rufus
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 29,  variant = 1,    subtype = 5 },    --Bombmuncher
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 151, variant = 10 },                   --Flinty
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 227, variant = 961,},                  --Powderkeg
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 160, variant = 550,},                  --Mullikaboom
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 819, variant = 450,},                  --Golden Fly Bomb
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 819, variant = 450,  subtype = 1},     --Rose Golden Fly Bomb
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 25,  variant = 961,},                  --Golden Boom Fly
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 829, variant = 450,},                  --Blasted
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 23,  variant = 961,},                  --Splodum
        { orb = MilkshakeVol1.enums.Orbs.FIRE,     type = 214, variant = 715, },                 --Ticking Fly
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 160, variant = 640, },                 --Zapbladder
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 160, variant = 641, },                 --Wire
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 170, variant = 30, },                  --Lightning Fly
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 114, variant = 65, },                  --Anode
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 451, variant = 140, },                 --Craig
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 451, variant = 10, },                  --Grazer
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 160, variant = 1120, },                --Technician
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 450, variant = 21, },                  --Shock Collar
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 114, variant = 10, },                  --Drillbit
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 450, variant = 5, },                   --Thumper
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 160, variant = 1150, },                --Stolas
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 120, variant = 222, },                 --Onlooker
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 450, variant = 20, },                  --Weeper
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 450, variant = 1510, },                --Observer
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 451, variant = 250, },                 --Zephyr
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 451, variant = 141, },                 --Roy Gerald Dericott II
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 617, variant = 402, },                 --Beacon
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 160, variant = 80,   subtype = 68, },  --Dweller
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 160, variant = 85,   subtype = 395, }, --Missing Link
        { orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 195, variant = 30 },                   --Volt
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 360, },                 --Sourpatch
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 29,  variant = 962, },                 --Sourpatch Head
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 361, },                 --Sourpatch Body
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 1718, },                --Carrot
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 750, },                 --Shiitake
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 840, },                 --Ramblin' Evil Mushroom
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 2001, },                --Cordy
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 2000, },                --Splattercap
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 666, variant = 110, },                 --Wobbles
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 451, variant = 30, },                  --Infected Mushroom
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 25,  variant = 962, },                 --Warhead
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 683, },                 --Bunch
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 683,  subtype = 1, },   --Bunch
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 60, },                  --Frog
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 170, variant = 100, },                 --Prick
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 114, variant = 57, },                  --Spiroll
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 450, variant = 6, },                   --Coconut
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 52,  variant = 0 },                    --Square Fly (Blue)
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 152, variant = 0,    subtype = 1 },    --Square Fly (Yellow)
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 700 },                  --Bumbler
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 451, variant = 60 },                   --Potluck
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 560 },                  --Poobottle
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 450, variant = 44 },                   --Butt Fly
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 155, variant = 0 },                    --Weaver
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 666, variant = 100 },                  --Drink Worm
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 1240 },                 --Bunker Worm
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 85,  variant = 960 },                  --Spooter
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 85,  variant = 961 },                  --Super Spooter
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 1040 },                 --Nanny Long Legs
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 114, variant = 26 },                   --Brood (with sack)
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 114, variant = 26,   subtype = 1 },    --Brood (without sack)
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 401 },                  --Zingling
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 180 },                  --Beeter
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 610 },                  --Hover
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 140, variant = 0 },                    --Honey Eye
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 681 },                  --Stingler
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 590 },                  --Homer
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 810 },                  --Honeydrip
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 114, variant = 28 },                   --Unshornz
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 320 },                  --Milk Tooth
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 666, variant = 40 },                   --Foamy
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 155, variant = 1 },                    --Weaver Sr.
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 21,  variant = 960 },                  --Roly Poly
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 540 },                  --Centipede (head)
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 540,  subtype = 1 },    --Centipede (segment)
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 540,  subtype = 103 },  --Centipede (pit)
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 750, variant = 80 },                   --Sackboy
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 29,  variant = 961 },                  --Spinneretch
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 666, variant = 101 },                  --Drunk Worm
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 1230 },                 --Matte
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 400 },                  --Colonel
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 402 },                  --Zingy
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 60 },                   --Frog
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 21,  variant = 960,  subtype = 2 },    --Isopoly
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 561 },                  --Drainfly
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 114, variant = 56 },                   --Spanky
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 450, variant = 31 },                   --Ztewie
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 451, variant = 0 },                    --Briar
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 1280 },                 --Beebee
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 990 },                  --Carrier
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 150, variant = 14 },                   --Gary
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 155, variant = 3 },                    --Thread
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 120, variant = 227 },                  --Warble
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 21,  variant = 450 },                  --Retch
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 155, variant = 5 },                    --Diagetic
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 114, variant = 37 },                   --Nematode
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 160, variant = 701 },                  --Buckshot
        { orb = MilkshakeVol1.enums.Orbs.NATURE,   type = 215, variant = 710 },                  --Full Spider
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 160, variant = 450 },                  --Flickerspirit
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 160, variant = 451 },                  --Eternal Flickerspirit
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 21,  variant = 115 },                  --Alfil
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 450, variant = 0 },                    --Zealot
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 666, variant = 30 },                   --Chorister
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 160, variant = 460 },                  --Deadfly
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 160, variant = 1380 },                 --Holy Clotty
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 114, variant = 48 },                   --Holy Wobbles
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 450, variant = 3 },                    --Cherub
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 160, variant = 720 },                  --Warden
        { orb = MilkshakeVol1.enums.Orbs.HOLY,     type = 212, variant = 450 },                  --Cherubskull
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 10 },                   --Dung
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 500 },                  --Tall Boi
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 501 },                  --Shitling
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 812, variant = 114 },                  --Floaty
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 631 },                  --Shitty Horf
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 450, variant = 34 },                   --Dollop
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 2 },                    --Connipshit
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 1110 },                 --Residuum
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 369, variant = 11 },                   --Pipeneck
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 369, variant = 13 },                   --Shottie
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 53 },                   --Coloscope
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 369, variant = 10,   subtype = 2 },    --Stomy
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 451, variant = 210 },                  --Wasty
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 1290 },                 --Delinquent
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 25 },                   --Peepisser
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 450, variant = 22 },                   --Cathy
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 28 },                   --Unshornz
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 50 },                   --Fathead
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 115, variant = 130 },                  --Edema
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 260 },                  --Spitum
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 774 },                  --Mr. Gurgle
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 750, variant = 50 },                   --Mama Pooter
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 220 },                  --Toxic Knight
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 2 },                    --Scoop
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 1 },                    --Sundae
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 0 },                    --Soft Serve
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 11 },                   --Corn Load
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 10 },                   --Load
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 170, variant = 40 },                   --Blot
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 170, variant = 60 },                   --Pitcher
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 150, variant = 0 },                    --Tar Bubble
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 208, variant = 960 },                  --Squidge
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 970, variant = 50 },                   --Melty
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 108, variant = 115 },                  --Guflush
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 910 },                  --Mr. Gob
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 911 },                  --Gob
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 100 },                  --Gunk
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 31 },                   --Slag
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 530 },                  --Gis
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 42 },                   --Slimer
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 960, variant = 140 },                  --Gorger
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 120 },                  --Sludge Host
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 29,  variant = 1,    subtype = 170 },  --Gobhopper
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 80 },                   --Skuzzball
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 81 },                   --Small Skuzzball
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 570 },                  --Grater
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 450, variant = 8 },                    --Clogmo
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 650 },                  --Piper (cardinal)
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 650,  subtype = 1 },    --Piper (ordinal)
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 666, variant = 90 },                   --Boiler
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 85,  variant = 964 },                  --Litter Bug
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 85,  variant = 965 },                  --Toxic Litter Bug
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 85,  variant = 966 },                  --Charmed Litter Bug
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 369, variant = 10 },                   --Trashbagger (Dross)
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 369, variant = 10,   subtype = 1 },    --Trashbagger (Dank Depths)
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 451, variant = 230 },                  --Dumptruck
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 450, variant = 19 },                   --Bunkter
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 21,  variant = 450 },                  --Retch
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 12 },                   --Bladder
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 1020 },                 --Lipoma
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 151, variant = 9 },                    --Marzlammer
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 450, variant = 16,   subtype = 0 },    --Rotdrink
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 750, variant = 170 },                  --Rotspin
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 750, variant = 172 },                  --Spoilie
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 621 },                  --Sagging Spit
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 25,  variant = 450 },                  --Droolie
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 20 },                   --Torment
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 54 },                   --Putrefatty
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 450, variant = 6 },                    --Coconut
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 22 },                   --Wheezer
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 50,   subtype = 0 },    --Whale
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 50,   subtype = 1 },    --Whale Guts
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 108, variant = 117 },                  --Cancer Boy
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 114, variant = 55 },                   --Musk
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 120, variant = 232 },                  --Foetus
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 120, variant = 232,  subtype = 1 },    --Foetu
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 505 },                  --Really Tall Boi
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 33 },                   --Haunch
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 162 },                  --Mold
        { orb = MilkshakeVol1.enums.Orbs.POISON,   type = 160, variant = 1717 },                 --Crudemate
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 231 },                  --Yawner
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 210 },                  --Spoop
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 13 },                   --Shirk
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1080 },                 --Mini-Min
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 4 },                    --Bellow
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 14 },                   --Ignis
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1160 },                 --Deathany
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 3 },                    --Tango
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1320 },                 --Onlyfan
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 224 },                  --Cuffs
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 130, variant = 60 },                   --Glass Eye
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 52 },                   --Slick
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 53 },                   --Stump
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 821 },                  --Pale Slim
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 821,  subtype = 1 },    --Jim
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 821,  subtype = 2 },    --Pale Limb
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 2102 },                 --Pale Bleeder
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 170 },                  --Balor
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 451, variant = 80 },                   --Shrunken Head
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 710 },                  --Menace
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 890 },                  --Dr.Shambles
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 880, variant = 450 },                  --Flesh Sistren
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 36 },                   --Shellmet
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 57 },                   --Spiroll
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 170, variant = 100 },                  --Prick
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 153, variant = 10 },                   --Dry Wheeze
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 32 },                   --Marlin
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 229 },                  --Fishfreak
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 229,  subtype = 1 },    --Fishfreak (bonepile)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 889, variant = 750 },                  --Clickety Clash
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 160 },                  --Ossularry
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 207, variant = 961 },                  --Krass Blaster
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 207, variant = 961,  subtype = 1 },    --Krass Blaster
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 207, variant = 961,  subtype = 2 },    --Krass Blaster
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 23 },                   --Gritty
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 41 },                   --Hangman
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 980 },                  --Flanks
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 451, variant = 260 },                  --Flagpole Head
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 451, variant = 261 },                  --Flagpole Body
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 451, variant = 50 },                   --Blare
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 761 },                  --Striker
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 761,  subtype = 1 },    --Pale Loafer
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 151, variant = 4 },                    --Smasher
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 270 },                  --Ghostse
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 90 },                   --Gnawful
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 880 },                  --Peek-A-Boo
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 170, variant = 0 },                    --Temper
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 218, variant = 750 },                  --Banshee
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 790 },                  --Spook
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 108, variant = 113 },                  --Mistmonger
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 130, variant = 808 },                  --Sleeper
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 451, variant = 120 },                  --Wailer
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 1500 },                 --Dungeon Master
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 38 },                   --G.Host
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 244, variant = 960 },                  --Bone Worm
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 23,  variant = 960 },                  --Sternum
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 25,  variant = 960 },                  --Doom Fly
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 227, variant = 666 },                  --Crepitus
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 227, variant = 667 },                  --Mr.Bones
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 227, variant = 750 },                  --Possesed
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 227, variant = 751 },                  --Possesed
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 140 },                  --Cracker
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 234, variant = 960 },                  --Jawbone
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 150, variant = 4 },                    --Jawbone (Dead)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 120 },                  --Ribeye
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 30 },                   --Unpawtunate
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 43 },                   --Fracture
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 26 },                   --Molar System
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 960, variant = 190 },                  --Lil' Jon
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 170, variant = 10 },                   --Spinny
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 666, variant = 130 },                  --Creepterum
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 610, variant = 0 },                    --Dangler
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 580 },                  --Tombit
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 581 },                  --Gravin
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1215 },                 --Pale Gaper
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 180, variant = 235 },                  --Pale Gusher
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1360 },                 --Pale Horf
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1370 },                 --Pale Clotty
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 130, variant = 40 },                   --Morvid
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 130, variant = 40,   subtype = 1 },    --Morvid (Perched)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 369, variant = 14 },                   --Shi
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 225 },                  --Empath
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1130 },                 --Looksee
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 451, variant = 220 },                  --Temptress
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1270, subtype = 0 },    --Discy
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1270, subtype = 1 },    --Nobody
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 240, variant = 114 },                  --Scowl Creep
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 18 },                   --Maze Runner
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1220 },                 --Aper (diagonal mirror),
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1220, subtype = 1 },    --Aper (horizontal mirror),
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1220, subtype = 2 },    --Aper (vertical mirror)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 1090 },                 --Gutter
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 200 },                  --Ripcord
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 212, variant = 451 },                  --Astroskull
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 16,   subtype = 1 },    --Rotskull
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 12,   subtype = 0 },    --Bub
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 12,   subtype = 1 },    --Bub
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 12,   subtype = 2 },    --Bub
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 12,   subtype = 3 },    --Bub
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 12,   subtype = 4 },    --Bub
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 310, variant = 450 },                  --Molly
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 310, variant = 1 },                    --Toma Chunk
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 180 },                  --Small Conglobberate
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 181 },                  --Medium Conglobberate
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 182 },                  --Large Conglobberate
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 235 },                  --Oralid (regular)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 235,  subtype = 1 },    --Oralid (buried)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 234 },                  --Oralopede (Regular)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 120, variant = 234 },                  --Oralopede (Buried)
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 450, variant = 36 },                   --Steralis
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 750, variant = 260 },                  --Lurker
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 212, variant = 450 },                  --Cherubskull
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 114, variant = 35 },                   --Murmur
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 160, variant = 160 },                  --Fossil
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 170, variant = 11 },                   --Dizzy
        { orb = MilkshakeVol1.enums.Orbs.UNDEAD,   type = 960, variant = 190,  subtype = 1 },    --Elite Jon
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 660 },                  --Scythe Rider
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 750, variant = 20 },                   --Moaner
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 240, variant = 114 },                  --Scowl Creep
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 450, variant = 18 },                   --Maze Runner
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 1220 },                 --Aper (diagonal mirror)
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 1220, subtype = 1 },    --Aper (horizontal mirror)
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 1220, subtype = 2 },    --Aper (vertical mirror)
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 114, variant = 17 },                   ---Gabber
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 451, variant = 110 },                  --Gamper
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 1090 },                 --Gutter
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 750, variant = 200 },                  --Ripcord
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 120, variant = 226 },                  --Manic Fly
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 661 },                  --Pitchfork Hitcher
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 150, variant = 35 },                   --Hitcher's Pitchfork
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 450, variant = 17 },                   --Kukodemon
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 750, variant = 230 },                  --Haemo
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 450, variant = 15 },                   --Lurch
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 151, variant = 8 },                    --Doomer
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 114, variant = 29 },                   --Dread Maw
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 155, variant = 2 },                    --Dread Weaver
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 120, variant = 236 },                  --Thrall
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 671 },                  --Dominated
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 670 },                  --Ms. Dominator
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 940 },                  --Psi Hunter
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 150, variant = 23 },                   --Psyeg
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 941 },                  --Psiling
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 341 },                  --Psleech
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 21,  variant = 961 },                  --Psionic Knight
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 34 },                   --Outlier
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 960, variant = 200 },                  --Crosseyes
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 340 },                  --Foreseer
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 450, variant = 1510 },                 --Observer
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 950 },                  --Umbra
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 950,  subtype = 1 },    --Blistered Umbra
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 950,  subtype = 2 },    --Blistered Umbra
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 951 },                  --Eclipse
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 112, variant = 1 },                    --Sombra
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 822 },                  --Slim Shady
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 822,  subtype = 2 },    --Red Hand
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 666 },                  --Reaper
        { orb = MilkshakeVol1.enums.Orbs.UNHOLY,   type = 160, variant = 711 },                  --Thousand Eyes
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 1350, subtype = 1 },    --Buoy
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 1250 },                 --Buckethead
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 776 },                  --Mr. Sub Horf
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 120, variant = 228 },                  --Rift Walker (visible)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 120, variant = 228,  subtype = 1 },    --Rift Walker (reflected)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 817, variant = 170 },                  --Cushion
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 170, variant = 120 },                  --Skipper
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 155, variant = 4 },                    --Archer
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 61,  variant = 450 },                  --Mayfly
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 25,  variant = 451 },                  --Mightfly
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 114, variant = 1 },                    --Dewdrop
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 1260 },                 --Bubby
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 450, variant = 9 },                    --Fishy
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 450, variant = 9,    subtype = 2 },    --Fish
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 450, variant = 10 },                   --Catfish
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 750, variant = 220 },                  --Croca
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 150 },                  --Drop
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 151 },                  --Dribble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 21,  variant = 666 },                  --Nimbus
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 114, variant = 5 },                    --Floodface (Random)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 114, variant = 5,    subtype = 1 },    --Floodface (Chasing)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 208, variant = 961 },                  --Tubby
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 830 },                  --Geyser
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 90 },                   --Warty
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 258, variant = 960 },                  --Bubble Bat
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 22,  variant = 666 },                  --Cistern
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 250 },                  --Bubble Blowing Double Baby
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 410 },                  --Globulon
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 207, variant = 960 },                  --Gutbuster (Offal)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 40 },                   --Offal
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 730 },                  --Eroded Host (regular)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 730,  subtype = 1 },    --Eroded Host (cracked)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 730,  subtype = 1 },    --Eroded Host (eroded)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 862 },                  --Eroded Smidgen (regular),
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 862,  subtype = 1 },    --Eroded Smidgen (eroded)
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 240 },                  --Fishface
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 160, variant = 380 },                  --Madclaw
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 120, variant = 233 },                  --Anemone
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 114, variant = 51 },                   --Clam
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 450, variant = 27 },                   --Puffer
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 450, variant = 11 },                   --Squid
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 21,  variant = 114 },                  --Sea Cucumber
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 450, variant = 28 },                   --Dolphin
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 450, variant = 45 },                   --Sponge
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 666, variant = 150,  subtype = 1 },    --Panini
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 180, variant = 161 },                  --Aquabab
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1 },                    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 1 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 2 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 3 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 4 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 5 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 6 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 7 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 8 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 9 },    --Bubble
        { orb = MilkshakeVol1.enums.Orbs.WATER,    type = 150, variant = 1,    subtype = 10 },   --Bubble (Isopoly)
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 490 },                  --Tap
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 829, variant = 450 },                  --Blasted
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 151, variant = 2 },                    --Stoney Slammer
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 227, variant = 960 },                  --Hollow Knight
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 330 },                  --Squire
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 666, variant = 200 },                  --Patzer
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 120, variant = 230 },                  --King
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 580 },                  --Tombit
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 581 },                  --Gravin
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 877, variant = 114 },                  --Grievance
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 150, variant = 31 },                   --Dangerous Disc
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 450, variant = 35 },                   --Apega
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 42,  variant = 963 },                  --Sensory Grimace
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 58 },                   --Thwammy
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 41,  variant = 750 },                  --Strobila
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 155, variant = 5 },                    --Diagetic
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 870 },                  --Armoured Looker
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 870,  subtype = 1 },    --Looker
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 960 },                  --Seeker
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 108, variant = 111 },                  --Watcher
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 450, variant = 37 },                   --Dogrock
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 750, variant = 190 },                  --Lonely Knight
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 151, variant = 10 },                   --Flinty
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 451, variant = 240 },                  --Pillar John
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 1200 },                 --Super Grimace
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 160, variant = 680 },                  --Fossilized Boom Fly
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 6 },                    --Frowny
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 31 },                   --Quaker
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 18 },                   --Stalagnaught (hanging)
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 18,   subtype = 1 },    --Stalagnaught (buried)
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 451, variant = 130 },                  --Speleo
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 19 },                   --Anti Golem
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 19,   subtype = 1 },    --Anti Golem (with bomb)
        { orb = MilkshakeVol1.enums.Orbs.ROCK,     type = 114, variant = 8 },                    --Crucible

    }
    MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerFiendFolioEntities)
    local ffPills = {
        [101] = MilkshakeVol1.enums.Orbs.PSYCHIC,
        [102] = MilkshakeVol1.enums.Orbs.FIRE,
        [103] = MilkshakeVol1.enums.Orbs.POISON,
        [104] = MilkshakeVol1.enums.Orbs.WATER,
        [105] = MilkshakeVol1.enums.Orbs.HOLY,
        [106] = MilkshakeVol1.enums.Orbs.UNHOLY,
        [107] = MilkshakeVol1.enums.Orbs.NATURE,
        [108] = MilkshakeVol1.enums.Orbs.ELECTRIC,
        [109] = MilkshakeVol1.enums.Orbs.UNDEAD,
        [110] = MilkshakeVol1.enums.Orbs.ROCK,
        [111] = MilkshakeVol1.enums.Orbs.WATER,
        [112] = MilkshakeVol1.enums.Orbs.UNHOLY,
        [113] = MilkshakeVol1.enums.Orbs.PSYCHIC,
        [114] = MilkshakeVol1.enums.Orbs.FIRE,
        [115] = MilkshakeVol1.enums.Orbs.UNDEAD,
        [116] = MilkshakeVol1.enums.Orbs.HOLY,
        [117] = MilkshakeVol1.enums.Orbs.ELECTRIC,
        [118] = MilkshakeVol1.enums.Orbs.POISON,
        [119] = MilkshakeVol1.enums.Orbs.ROCK,
        [120] = MilkshakeVol1.enums.Orbs.NATURE,
    }
    for i, value in pairs(ffPills) do
        MilkshakeVol1.API:AddOrbsPerPill(i, value)
    end

    --Special globins
    MilkshakeVol1.API:AddSpecialGlobin(
        "gfx/effect_globin_bucket.anm2",
        "conglobberate_small",
        FiendFolio.FF.ConglobberateSmall.ID,
        FiendFolio.FF.ConglobberateSmall.Var,
        0,
        BackdropType.CORPSE_ENTRANCE,
        BackdropType.CORPSE,
        BackdropType.CORPSE2,
        BackdropType.CORPSE3
    )

    MilkshakeVol1.API:AddSpecialGlobin(
        "gfx/effect_globin_bucket.anm2",
        "spoilie",
        FiendFolio.FF.Spoilie.ID,
        FiendFolio.FF.Spoilie.Var,
        0,
        BackdropType.CORPSE_ENTRANCE,
        BackdropType.CORPSE,
        BackdropType.CORPSE2,
        BackdropType.CORPSE3
    )

    --Glass Item Pool
    MilkshakeVol1.API:AddItemsToGlassPool({
        { Collectible = FiendFolio.ITEM.COLLECTIBLE.CLEAR_CASE,       Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
        { Collectible = FiendFolio.ITEM.COLLECTIBLE.AZURITE_SPINDOWN, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
        {
            Collectible = FiendFolio.ITEM.COLLECTIBLE.SNOW_GLOBE,
            Weight = 1,
            DecreaseBy = 1,
            RemoveOn = 0.1,
            IsUnlocked = function()
                return
                    FiendFolio.ACHIEVEMENT.SNOW_GLOBE:IsUnlocked(false)
            end
        },
        {
            Collectible = FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ORB,
            Weight = 1,
            DecreaseBy = 1,
            RemoveOn = 0.1,
            IsUnlocked = function()
                return
                    FiendFolio.ACHIEVEMENT.GOLEMS_ORB:IsUnlocked(false)
            end
        },
        {
            Collectible = FiendFolio.ITEM.COLLECTIBLE.HEART_OF_CHINA,
            Weight = 1,
            DecreaseBy = 1,
            RemoveOn = 0.1,
            IsUnlocked = function()
                return
                    FiendFolio.ACHIEVEMENT.HEART_OF_CHINA:IsUnlocked(false)
            end
        },
    })

    -- Fuzzy Pickle
    local referenceItems = {
        Actives = {
            {ID = MilkshakeVol1.enums.Collectibles.INNER_REFLECTION, Reference = "Celeste"},
        },

        Passives = {
            {ID = MilkshakeVol1.enums.Collectibles.MILKSHAKE, Reference = "Team Milkshake"},
            {ID = MilkshakeVol1.enums.Collectibles.SHARP_CURSOR, Reference = "Cookie Clicker"},
        },

        Trinkets = {
            {ID = MilkshakeVol1.enums.Trinkets.RAINBOW_COOKIE, Reference = "Cookie Clicker"},
        }
    }

    for i = 1, #referenceItems.Actives do
        table.insert(FiendFolio.ReferenceItems.Actives, referenceItems.Actives[i])
    end

    for i = 1, #referenceItems.Passives do
        table.insert(FiendFolio.ReferenceItems.Passives, referenceItems.Passives[i])
    end

    for i = 1, #referenceItems.Trinkets do
        table.insert(FiendFolio.ReferenceItems.Trinkets, referenceItems.Trinkets[i])
    end


    --Glass trinkets
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.TRINKET.SHARD_OF_CHINA,
        function()
            return FiendFolio.ACHIEVEMENT.SHARD_OF_CHINA:IsUnlocked(false)
        end
    )
    MilkshakeVol1.API:AddGlassTrinkets(FiendFolio.ITEM.TRINKET.EXTRA_VESSEL)
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.TRINKET.MASSIVE_AMETHYST,
        function()
            return FiendFolio.ACHIEVEMENT.MASSIVE_AMETHYST:IsUnlocked(false)
        end
    )
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.TRINKET.CURSED_URN,
        function()
            return FiendFolio.ACHIEVEMENT.CHINAS_BELONGINGS:IsUnlocked(false)
        end
    )
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.ROCK.TIME_LOST_DIAMOND,
        function()
            return FiendFolio.GolemExists()
        end
    )
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.ROCK.TWENTY_SIDED_EMERALD,
        function()
            return FiendFolio.GolemExists()
        end
    )
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.ROCK.TECHNOLOGICAL_RUBY_2,
        function()
            return FiendFolio.GolemExists()
        end
    )
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.ROCK.FIENDISH_AMETHYST,
        function()
            return FiendFolio.GolemExists()
        end
    )
    MilkshakeVol1.API:AddGlassTrinkets(
        FiendFolio.ITEM.ROCK.FRIENDLY_RAPID_FIRE_OPAL,
        function()
            return FiendFolio.GolemExists()
        end
    )

    --Unholy orb beggars
    local FiendBeggars = {
        [FiendFolio.FF.HugBeggar.Var] = {
            Config = { Count = 1, MinCount = 0 },
            { Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = 0 },
        },
        [FiendFolio.FF.EvilBeggar.Var] = {
            Config = { Count = 2, MinCount = 1 },
            --idk where is half black and immoral harts
            { Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_BLACK },
            { Type = EntityType.ENTITY_PICKUP, Variant = FiendFolio.PICKUP.HALF_BLACK_HEART, SubType = 0 },
            { Type = EntityType.ENTITY_PICKUP, Variant = FiendFolio.PICKUP.IMMORAL_HEART, SubType = 0 },
        },
        [FiendFolio.FF.ZodiacBeggar.Var] = {
            Config = { Count = 2, MinCount = 0, OnlyRune = true },
            { Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_TAROTCARD, SubType = 0 },
        },
        [FiendFolio.FF.CellGame.Var] = {
            Config = { Count = 2, MinCount = 2 },
            { Type = EntityType.ENTITY_PICKUP, Variant = PickupVariant.PICKUP_KEY, SubType = 0 },
        },
        [FiendFolio.FF.FakeBeggar.Var] = {
            Config = { Count = 1, MinCount = 0 },
            { Type = EntityType.ENTITY_BOMB, Variant = BombVariant.BOMB_TROLL, SubType = 0 },
        },
    }
    for key, datatable in pairs(FiendBeggars) do
        MilkshakeVol1.API:AddUnholyOrbBeggar(key, datatable)
    end

    MilkshakeVol1.API:AddConductivityOrbSlotPayout(FiendFolio.FF.RobotTeller.Var, {
        {
            chance = 100,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = 0,
                weight = 1
            }
        },
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_TAROTCARD,
                subtype = 0,
                weight = 3
            }
        }
    })

    MilkshakeVol1.API:AddConductivityOrbSlotPayout(FiendFolio.FF.GoldenSlotMachine.Var, {
        {
            chance = 100,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = CoinSubType.COIN_GOLDEN,
                weight = 0.1
            }
        },
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_KEY,
                subtype = KeySubType.KEY_GOLDEN,
                weight = 3
            }
        },
        {
            chance = 50,
            value = {
                variant = PickupVariant.PICKUP_BOMB,
                subtype = BombSubType.BOMB_GOLDEN,
                weight = 3
            }
        }
    })

    MilkshakeVol1.API:AddConductivityOrbSlotPayout(FiendFolio.FF.VendingMachine.Var, {
        {
            chance = 100,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = 0,
                weight = 3
            }
        },
    })

    MilkshakeVol1.API:AddConductivityOrbSlotPayout(FiendFolio.FF.VendingMachineFF.Var, {
        {
            chance = 100,
            value = {
                variant = PickupVariant.PICKUP_COIN,
                subtype = 0,
                weight = 3
            }
        },
    })


    local PrismaticLocustBlacklist = {
        {type = 750, variant = 260, subtype = 0}, --Lurker corpse pit guy and his parts
        {type = 750, variant = 261, subtype = 0},
        {type = 750, variant = 262, subtype = 0},
        {type = 750, variant = 263, subtype = 0},
        {type = 750, variant = 264, subtype = 0},
        {type = 750, variant = 270, subtype = 0},
        {type = 750, variant = 271, subtype = 0},
        {type = 750, variant = 272, subtype = 0},
        {type = 750, variant = 273, subtype = 0},
        {type = 750, variant = 274, subtype = 0},
    }

    for _, enemyData in pairs(PrismaticLocustBlacklist) do
        MilkshakeVol1.API.ForbidEnemySplit(enemyData)
    end

    FiendFolio:AddStackableItems({
        MilkshakeVol1.enums.Collectibles.BATTERY_ACID,
        MilkshakeVol1.enums.Collectibles.BALANCED_BREAKFAST,
        MilkshakeVol1.enums.Collectibles.DADS_MITT,
        MilkshakeVol1.enums.Collectibles.DOGGY_BAG,
        MilkshakeVol1.enums.Collectibles.FINGORE,
        MilkshakeVol1.enums.Collectibles.FRAGILE_MIRROR,
        MilkshakeVol1.enums.Collectibles.HEARTY_BREAKFAST,
        MilkshakeVol1.enums.Collectibles.INNER_REFLECTION,
        MilkshakeVol1.enums.Collectibles.LA_CHANCLA,
        MilkshakeVol1.enums.Collectibles.LIL_BISHOP,
        MilkshakeVol1.enums.Collectibles.MILKSHAKE,
        MilkshakeVol1.enums.Collectibles.RAINBOW_FRAGMENT,
        MilkshakeVol1.enums.Collectibles.SHARP_CURSOR,
        MilkshakeVol1.enums.Collectibles.SPOILED_BREAKFAST,
        MilkshakeVol1.enums.Collectibles.WATER_WITH_FOOD_COLORING

    })
end)
