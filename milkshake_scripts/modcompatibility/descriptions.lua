local descriptions = {}
local enums = MilkshakeVol1.enums

--[[
    Available Languages:
        -English: "en_us"
        -Russian: "ru"
        -French: "fr"
        -Portuguese: "pt"
        -Spanish: "spa"
        -Polish: "pl"
        -Bulgarian: "bul"
        -Turkish: "turkish"

    How to add more descriptions:
        1- Add a new entry in the corresponding list, like this:
            [enums.X.X] = {

            },
        2- Inside those curly braces { } add an entry for each language description, like this:
            [enums.X.X] = {
                language_code = 
                    {
                        name = "name",
                        description = "description",
                    },
            },
        3- To add more languages to an item, just add more language entries, like this:
            [enums.X.X] = {
                language_code = {
                        name = "name",
                        description = "description",
                },
                language_code_2 = {
                        name = "name 2",
                        description = "description 2",
                },
            },
    
    The language_code is the thing between quotes in the language list.
    To check what enum value correspond to the item, check the enums.lua file.
    Don't forget to add all the commas!
]]

--COLLECTIBLE DESCRIPTIONS
descriptions.Collectibles = {
    [enums.Collectibles.MILKSHAKE] = {
        en_us = {
            name = "Milkshake",
            description = "{{Heart}} +1 Soul Heart, Black Heart, or Health up randomly" ..
            "#{{ArrowUp}} {{ArrowUp}} 1.1x to 1.5x multiplier to all stats!"
        },
        spa = {
            name = "Batido",
            description = "{{Blank}}{{ArrowUp}} Otorga un multiplicador aleatorio a cada estadistica",
        },
    },
    [enums.Collectibles.SHARP_CURSOR] = {
        en_us = {
            name = "Sharp Cursor",
            description = "#Targets the furthest enemy in the room #{{Damage}} Pressing a shooting key makes it click, dealing 10% of Isaac's damage #{{Warning}} Double press ctrl to toggle mouse control mode.",
        },
        spa = {
            name = "Cursor Afilado",
            description = "#Genera un familiar que va hacia el enemigo mas alejado #Pulsar cualquier tecla de disparo hace que haga un 10% del daño del jugador #Funciona con los Controles de Raton!"
        },
    },
    [enums.Collectibles.BLACK_EYE] = {
        en_us = {
            name = "Black Eye",
            description = "{{Blank}}{{ArrowUp}} +0.7 tears up and knockback up for the right eye only #Currently unused and uncoded, maybe it will show up later (It probably wont)",
        },
        spa = {
            name = "Ojo Morado",
            description = "{{Blank}}{{ArrowUp}} +0.7 lagrimas y empuje solo para el ojo derecho #De momento sin usar y sin programar, puede que aparezca despues (Probablemente no)"
        },
    },
    [enums.Collectibles.DICE_DICE] = {
        en_us = {
            name = "Dice Dice",
            description = "Activates a random dice room effect #Currently unused and uncoded, maybe it will show up later",
        },
        spa = {
            name = "Dado Dado",
            description = "Activa un efecto de la habitacion de dado aleatorio #De momento sin usar y sin programar, puede que aparezca despues"
        },
    },
    [enums.Collectibles.FIRECRACKER_ROSE] = {
        en_us = {
            name = "Firecracker Flower",
            description = "{{Burning}} Chance to shoot a seed tear that inflicts enemies with Kabloom #Kabloomed enemies will burst into exploding petal tears after 5 seconds",
        },
        spa = {
            name = "Flor De Fuego",
            description = "{{Burning}} Posibilidad de disparar una semilla que inflinge a los enemigos con Kabloom. #Los enemigos con Kabloom explotan en petalos despues de 5 segundos"
        },
    },
    [enums.Collectibles.GLOBIN_IN_A_BUCKET] = {
        en_us = {
            name = "Globin In A Bucket",
            description = "Spawns a friendly globin that fights by your side" ..
            "#Chance to spawn different globin variants depending on the floor",
        },
        spa = {
            name = "Globin En Un Cubo",
            description = "Genera un globin amistoso que lucha por ti"
        },
    },
    [enums.Collectibles.GOLDEN_SHOVEL] = {
        en_us = {
            name = "Golden Shovel",
            description = "Digs up 1-2 golden chests and a random golden pickup. #{{LadderRoom}} Opens up a member card trapdoor if used on a decorative floor tile.",
        },
        spa = {
            name = "Pala Dorada",
            description = "Cava en el suelo, generando 1-2 cofres dorados y un pickup dorado aleatorio. Ademas, cavar en una decoracion genera un acceso a la tienda secreta"
        },
    },
    [enums.Collectibles.LA_CHANCLA] = {
        en_us = {
            name = "La Chancla",
            description = "\1 0.3 Speed up #Immune to {{MomBossSmall}} stomping attacks",
        },
        spa = {
            name = "La Chancla",
            description = "{{Blank}} {{Speed}} 0.3 de velocidad #Hace a Isaac inmune a los ataques de pisotones (Como {{MomBossSmall}} Mama o {{SatanSmall}} Satan)"
        },
    },
    [enums.Collectibles.LYRA] = {
        en_us = {
            name = "Lyra",
            description = "{{SpiritOrb}} 15% chance for the room clear reward to be a random spirit orb" ..
            "#{{SpiritOrb}} Chance for a bonus spirit orb from chests, tinted rocks, and destoryed machines" .. 
            "#\1 Using a spirit orb starts a short rhythm mini game." ..
            "#{{Blank}} Successful completion activates the spirit orb with double effect",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.EMPTY_SLOT] = {
        en_us = {
            name = "Empty Slot",
            description = "{{Coin}} Inserts a coin" ..
            "#After 10 coins, has a 1% chance to explode and spawn double the coins inserted" ..
            "#Guranteed to explode at 100 coins inserted",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.SHATTERED_ORB] = {
        en_us = {
            name = "Shattered Orb",
            description = "Can be thrown at enemies to capture their soul" ..
            "#{{SpiritOrb}} Captured enemies are turned into spirit orbs corresponding to their soul's element",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.PRISMATIC_DICE] = {
        en_us = {
            name = "Prismatic Dice",
            description = "Splits pedestal items in the room into two pedestals of 1 less quality" ..
            "#Quality {{Quality0}} items are split into random pickups",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.SPIRIT_BUM] = {
        en_us = {
            name = "Spirit Bum",
            description = "{{SoulHeart}} Picks up nearby soul hearts" ..
            "#{{SpiritOrb}} Spawns random spirit orbs in return",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.INNER_REFLECTION] = {
        en_us = {
            name = "Celestial Mirror",
            description = "Mirrors Isaac's movement" ..
            "#Deals 75 damage a second" ..
            "#\1  {{MirrorRoom}} +2.5 Damage in the mirror world",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.SICKLE_CELL] = {
        en_us = {
            name = "Sickle Cell",
            description = "Piercing tears" ..
            "#{{BleedingOut}} Tears cause bleeding, which makes enemies leave creep and take damage when they move",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.SPOILED_BREAKFAST] = {
        en_us = {
            name = "Spoiled Breakfast",
            description = "\1 +1 Health" ..
            "#{{EmptyHeart}} Removes half a heart",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.BALANCED_BREAKFAST] = {
        en_us = {
            name = "Balanced Breakfast",
            description = "\1 +1 Health" ..
            "#\1 +1 Luck" ..
            "#{{SoulHeart}} +1 Soul Heart" ..
            "#{{Heart}} Heals 1 heart",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.HEARTY_BREAKFAST] = {
        en_us = {
            name = "Hearty Breakfast",
            description = "\1 +1 Health" ..
            "#\1 +0.5 Damage" ..
            "#\1 +0.3 Fire rate" ..
            "#\1 +1 Luck" ..
            "#{{Heart}} Full heal",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.POT_OF_GOLD] = {
        en_us = {
            name = "Pot of Gold",
            description = "Converts all bomb, key, and most coin pickups into rainbow pennies" ..
            "#{{Trinket52}} Rainbow pennies activate the effect of their corresponding penny trinkets on pickup",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.FRAGILE_MIRROR] = {
        en_us = {
            name = "Glass Idol",
            description = "\1 +1 Life while intact" ..
            "#{{SoulHeart}} Isaac respawns with +1 Soul heart and 10 seconds of invinicibility on death" ..
            "#Respawns the next floor" ..
            "#Blocks 3 projectiles before shattering" ..
            "#\2 -1 Luck while shattered",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.LEVITICUS] = {
        en_us = {
            name = "Leviticus",
            description = "{{EternalHeart}} +1 Eternal Heart" ..
            "#{{AngelRoom}} Using the item before a boss fight makes the boss reward an angel item",
            --+1 Immortal Heart instead if Immortal Hearts mod is installed
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.BATTERY_ACID] = {
        en_us = {
            name = "Battery Acid",
            description = "{{Battery}} Doubles active item charge from clearing rooms" ..
            "#\2 Drains 1 charge every 15 seconds",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.DOGGY_BAG] = {
        en_us = {
            name = "Doggy Bag",
            description = "Poop",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.DADS_MITT] = {
        en_us = {
            name = "Dad's Mitt",
            description = "\1 +10% Fire rate" ..
            "#\2 -0.2 Shot speed" ..
            "#Tears become influenced by Isaac's movement",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.LIL_BISHOP] = {
        en_us = {
            name = "Lil Bishop",
            description = "Blocks projectiles" ..
            "#When hit, 20% chance to shield Isaac for 5 seconds",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.RAINBOW_FRAGMENT] = {
        en_us = {
            name = "Rainbow Fragment",
            description = "\1 +1 Luck up" ..
            "#Spawns 4 rainbow pennies" ..
            "#{{Trinket52}} Rainbow pennies activate the effect of their corresponding penny trinkets on pickup",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.WITCH_DOCTOR_MASK] = {
        en_us = {
            name = "Witch Doctor Mask",
            description = "{{Pill}} Spawns 1 pill" ..
            "#Converts all pills into spirit pills" ..
            "#{{SpiritOrb}} Spirit pills activate a spirit orb effect on top of their pill effect",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.MIRROR_KEY] = {
        en_us = {
            name = "Mirror Key",
            description = "{{MirrorRoom}} Creates a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    [enums.Collectibles.UNCHARGED_MIRROR_KEY] = {
        en_us = {
            name = "Mirror Key (Uncharged)",
            description = "{{MirrorRoom}} Creates a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
        },
        spa = {
            name = "Lyra",
            description = ""
        },
    },
    
}

--TRINKET DESCRIPTIONS
descriptions.Trinkets = {
    [enums.Trinkets.TUNGSTEN_CUBE] = {
        en_us = {
            name = "Tungsten Cube",
            description = "{{Blank}}{{ArrowDown}} -0.2 speed down. #Dropping it creates a huge shockwave that deals big damage",
        },
        spa = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
}

--CARD DESCRIPTIONS
descriptions.Cards = {
    [enums.Orbs.NATURE] = {
        en_us = {
            name = "Spirit of Druidity",
            description = "#Traps all enemies in the room in vines for 20 seconds. Trapped enemies drop a fruit heart on death."
        },
        spa = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    }
}

return descriptions