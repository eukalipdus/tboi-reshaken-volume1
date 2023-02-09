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
            description = "#Grants a random multiplier to each stat",
        },
        spa = {
            name = "Batido",
            description = "#Otorga un multiplicador aleatorio a cada estadistica",
        },
    },
    [enums.Collectibles.SHARP_CURSOR] = {
        en_us = {
            name = "Sharp Cursors",
            description = "#Spawns a familiar that targets the furthest enemy from the player #Pressing a shooting key makes it deal 10% player's damage.",
        },
    }
}

--TRINKET DESCRIPTIONS
descriptions.Trinkets = {
    [enums.Trinkets.TUNGSTEN_CUBE] = {
        en_us = {
            name = "Tungsten Cube",
            description = "#Grants a -0.2 speed down #Dropping it creates a huge shockwaves that deals big damage",
        },
    },
}

--CARD DESCRIPTIONS
descriptions.Cards = {
    [enums.Cards.EMERALD_ORB] = {
        en_use = {
            name = "Druidity Orb",
            description = "#Wraps all enemies in the room in vines for 20 seconds, freezing them #Killing a vined enemy spawns a half red heart"
        },
    }
}

return descriptions