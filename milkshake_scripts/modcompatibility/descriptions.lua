local descriptions = {}
local enums = require("milkshake_scripts.enums")

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
            description = "{{Blank}}{{ArrowUp}} Grants a random multiplier to each stat",
        },
        spa = {
            name = "Batido",
            description = "{{Blank}}{{ArrowUp}} Otorga un multiplicador aleatorio a cada estadistica",
        },
    },
    [enums.Collectibles.SHARP_CURSOR] = {
        en_us = {
            name = "Sharp Cursor",
            description = "#Spawns a familiar that targets the furthest enemy from the player #Pressing a shooting key makes it deal 10% player's damage #Works with Mouse Control!",
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
    [enums.Collectibles.FIRE_CRACKER_ROSE] = {
        en_us = {
            name = "Firecracker Rose",
            description = "{{Burning}} Chance to shoot a seed tear that inflicts enemies with Kabloom #Kabloomed enemies will explode into exploding petal tears after 5 seconds",
        },
        spa = {
            name = "Rosa De Fuego",
            description = "{{Burning}} Posibilidad de disparar una semilla que inflinge a los enemigos con Kabloom. #Los enemigos con Kabloom explotan en petalos despues de 5 segundos"
        },
    },
    [enums.Collectibles.GLOBIN_IN_A_BUCKET] = {
        en_us = {
            name = "Globin In A Bucket",
            description = "Spawns a friendly globin that fights by your side",
        },
        spa = {
            name = "Globin En Un Cubo",
            description = "Genera un globin amistoso que lucha por ti"
        },
    },
    [enums.Collectibles.GOLDEN_SHOVEL] = {
        en_us = {
            name = "Golden Shovel",
            description = "On use, digs into the ground, spawning 1-2 golden chests and a random golden pickup, as well as digging up a golden crawlspace if used on decoration tiles",
        },
        spa = {
            name = "Pala Dorada",
            description = "Cava en el suelo, generando 1-2 cofres dorados y un pickup dorado aleatorio. Ademas, cavar en una decoracion genera un acceso a la tienda secreta"
        },
    },
    [enums.Collectibles.LA_CHANCLA] = {
        en_us = {
            name = "La Chancla",
            description = "{{Blank}} {{Speed}} 0.3 Speed up #Makes Isaac immune to stomping attacks (Such as {{MomBossSmall}} Mom and {{SatanSmall}} Satan)",
        },
        spa = {
            name = "La Chancla",
            description = "{{Blank}} {{Speed}} 0.3 de velocidad #Hace a Isaac inmune a los ataques de pisotones (Como {{MomBossSmall}} Mama o {{SatanSmall}} Satan)"
        },
    },
}

--TRINKET DESCRIPTIONS
descriptions.Trinkets = {
    [enums.Trinkets.TUNGSTEN_CUBE] = {
        en_us = {
            name = "Tungsten Cube",
            description = "{{Blank}}{{ArrowDown}} Grants a -0.2 speed down #Dropping it creates a huge shockwaves that deals big damage",
        },
        spa = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
}

--CARD DESCRIPTIONS
descriptions.Cards = {
    [enums.Cards.EMERALD_ORB] = {
        en_use = {
            name = "Druidity Orb",
            description = "#Wraps all enemies in the room in vines for 20 seconds, freezing them #Killing a vined enemy spawns a fruit heart"
        },
        spa = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    }
}

return descriptions