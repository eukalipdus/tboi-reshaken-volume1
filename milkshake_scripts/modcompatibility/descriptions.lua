local descriptions = {}
local enums = MilkshakeVol1.enums
local LyraIcon = "{{Collectible"..enums.Collectibles.LYRA .."}}"
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
            description = "{{Heart}} +1 Corazón de Alma, Corazón Negro, o Corazón Rojo aleatoriamente" ..
            "#{{ArrowUp}} {{ArrowUp}} de 1.1x a 1.5x para todas las estadísticas!"
        },
        ru = {
            name = "Milkshake",
            description = "{{Heart}} +1 Soul Heart, Black Heart, or Health up randomly" ..
            "#{{ArrowUp}} {{ArrowUp}} 1.1x to 1.5x multiplier to all stats!"
        },
    },
    [enums.Collectibles.SHARP_CURSOR] = {
        en_us = {
            name = "Sharp Cursor",
            description = "#Targets the furthest enemy in the room" ..
            "#{{Damage}} Pressing a shooting key makes it click, dealing 10% of Isaac's damage" ..
            "#{{Warning}} Double press ctrl to toggle mouse control mode",
        },
        spa = {
            name = "Cursor Afilado",
            description = "#Apunta al enemigo más lejano en la habitación" ..
            "#{{Damage}} Presionar una tecla de disparo lo hace hacer clic, causando un 10% del daño de Isaac" ..
            "#{{Warning}} Pulsa dos veces Ctrl para alternar el modo de control de ratón",
        },
        ru = {
            name = "Sharp Cursor",
            description = "#Targets the furthest enemy in the room #{{Damage}} Pressing a shooting key makes it click, dealing 10% of Isaac's damage #{{Warning}} Double press ctrl to toggle mouse control mode.",
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
        ru = {
            name = "Black Eye",
            description = "{{Blank}}{{ArrowUp}} +0.7 tears up and knockback up for the right eye only #Currently unused and uncoded, maybe it will show up later (It probably wont)",
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
        ru = {
            name = "Dice Dice",
            description = "Activates a random dice room effect #Currently unused and uncoded, maybe it will show up later",
        },
    },
    [enums.Collectibles.FIRECRACKER_ROSE] = {
        en_us = {
            name = "Firecracker Flower",
            description = "{{Burning}} Chance to shoot a seed tear that inflicts enemies with Kabloom #Kabloomed enemies will burst into exploding petal tears after 5 seconds",
        },
        spa = {
            name = "Flor Petardo",
            description = "{{Burning}} Posibilidad de disparar una semilla que inflige a los enemigos con Kabloom #Los enemigos con Kabloom explotarán en lágrimas de pétalos explosivos después de 5 segundos",
        },
        ru = {
            name = "Firecracker Flower",
            description = "{{Burning}} Chance to shoot a seed tear that inflicts enemies with Kabloom #Kabloomed enemies will burst into exploding petal tears after 5 seconds",
        },
    },
    [enums.Collectibles.GLOBIN_IN_A_BUCKET] = {
        en_us = {
            name = "Globin In A Bucket",
            description = "Spawns a friendly globin that fights by your side" ..
            "#Chance to spawn different globin variants depending on the floor" .. 
            "#A maximum of 4 globins can be spawned at once",
        },
        spa = {
            name = "Globin en un Cubo",
            description = "Invoca a un globin amigable que lucha a tu lado" ..
            "#Posibilidad de invocar diferentes variantes según el piso",
        },
        ru = {
            name = "Globin In A Bucket",
            description = "Spawns a friendly globin that fights by your side" ..
            "#Chance to spawn different globin variants depending on the floor",
        },
    },
    [enums.Collectibles.GOLDEN_SHOVEL] = {
        en_us = {
            name = "Golden Shovel",
            description = "Digs up 1-2 golden chests and a random golden pickup." ..
            "#{{LadderRoom}} Opens up a member card trapdoor if used on a decorative floor tile.",
        },
        spa = {
            name = "Pala Dorada",
            description = "Desentierra de 1 a 2 cofres dorados y un pickup dorado al azar." ..
            "#{{LadderRoom}} Abre una trampilla de tarjeta de miembro si se usa en una baldosa decorativa del suelo.",
        },
        ru = {
            name = "Golden Shovel",
            description = "Digs up 1-2 golden chests and a random golden pickup. #{{LadderRoom}} Opens up a member card trapdoor if used on a decorative floor tile.",
        },
    },
    [enums.Collectibles.LA_CHANCLA] = {
        en_us = {
            name = "La Chancla",
            description = "\1 0.3 Speed up" ..
            "#Immune to {{MomBossSmall}} stomping attacks",
        },
        spa = {
            name = "La Chancla",
            description = "\1 0.3 de velocidad" ..
            "#Hace a Isaac inmune a los ataques de {{MomBossSmall}} pisotones"
        },
        ru = {
            name = "La Chancla",
            description = "\1 0.3 Speed up #Immune to {{MomBossSmall}} stomping attacks",
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
            description = "{{SpiritOrb}} 15% de probabilidad de que la recompensa por completar la habitación sea un orbe espiritual aleatorio" ..
            "#{{SpiritOrb}} Posibilidad de obtener un orbe espiritual adicional de cofres, rocas marcadas y al destruir máquinas" ..
            "#\1 Usar un orbe espiritual inicia un minijuego de ritmo corto." ..
            "#{{Blank}} Completarlo con éxito activa el orbe espiritual con efecto doble",
        },
        ru = {
            name = "Lyra",
            description = "{{SpiritOrb}} 15% chance for the room clear reward to be a random spirit orb" ..
            "#{{SpiritOrb}} Chance for a bonus spirit orb from chests, tinted rocks, and destoryed machines" .. 
            "#\1 Using a spirit orb starts a short rhythm mini game." ..
            "#{{Blank}} Successful completion activates the spirit orb with double effect",
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
            name = "Tragaperras Vacía",
            description = "{{Coin}} Inserta una moneda" ..
            "#Después de 10 monedas, tiene un 1% de probabilidad de explotar y generar el doble de las monedas insertadas" ..
            "#Garantizado que explotará al insertar 100 monedas",
        },
        ru = {
            name = "Empty Slot",
            description = "{{Coin}} Inserts a coin" ..
            "#After 10 coins, has a 1% chance to explode and spawn double the coins inserted" ..
            "#Guranteed to explode at 100 coins inserted",
        },
    },
    [enums.Collectibles.SHATTERED_ORB] = {
        en_us = {
            name = "Shattered Orb",
            description = "Can be thrown at enemies to capture their soul" ..
            "#{{SpiritOrb}} Captured enemies are turned into spirit orbs corresponding to their soul's element",
        },
        spa = {
            name = "Orbe Fragmentado",
            description = "Puede arrojarse a los enemigos para capturar sus almas" ..
            "#{{SpiritOrb}} Los enemigos capturados se convierten en orbes espirituales que corresponden al elemento de su alma",
        },
        ru = {
            name = "Shattered Orb",
            description = "Can be thrown at enemies to capture their soul" ..
            "#{{SpiritOrb}} Captured enemies are turned into spirit orbs corresponding to their soul's element",
        },
    },
    [enums.Collectibles.PRISMATIC_DICE] = {
        en_us = {
            name = "Prismatic Dice",
            description = "Splits pedestal items in the room into two pedestals of 1 less quality" ..
            "#Quality {{Quality0}} items are split into random pickups",
        },
        spa = {
            name = "Dado Prismático",
            description = "Divide los pedestales en la habitación en dos pedestales de 1 calidad inferior" ..
            "#Los objetos de calidad {{Quality0}} se dividen en objetos aleatorios",
        },
        ru = {
            name = "Prismatic Dice",
            description = "Splits pedestal items in the room into two pedestals of 1 less quality" ..
            "#Quality {{Quality0}} items are split into random pickups",
        },
    },
    [enums.Collectibles.SPIRIT_BUM] = {
        en_us = {
            name = "Spirit Bum",
            description = "{{SoulHeart}} Picks up nearby soul hearts" ..
            "#{{SpiritOrb}} Spawns random spirit orbs in return",
        },
        spa = {
            name = "Mendigo Espiritual",
            description = "{{SoulHeart}} Recoge corazones de alma cercanos" ..
            "#{{SpiritOrb}} Genera orbes espirituales aleatorios a cambio",
        },
        ru = {
            name = "Spirit Bum",
            description = "{{SoulHeart}} Picks up nearby soul hearts" ..
            "#{{SpiritOrb}} Spawns random spirit orbs in return",
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
            name = "Espejo Celestial",
            description = "Refleja el movimiento de Isaac" ..
            "#Inflige 75 puntos de daño por segundo" ..
            "#\1  {{MirrorRoom}} +2.5 de daño en la dimensión espejo",
        },
        ru = {
            name = "Celestial Mirror",
            description = "Mirrors Isaac's movement" ..
            "#Deals 75 damage a second" ..
            "#\1  {{MirrorRoom}} +2.5 Damage in the mirror world",
        },
    },
    [enums.Collectibles.SICKLE_CELL] = {
        en_us = {
            name = "Sickle Cell",
            description = "Piercing tears" ..
            "#{{BleedingOut}} Tears cause bleeding, which makes enemies leave creep and take damage when they move",
        },
        spa = {
            name = "Célula Falciforme",
            description = "Lágrimas perforantes" ..
            "#{{BleedingOut}} Las lágrimas causan sangrado, lo que hace que los enemigos dejen sangre y reciban daño al moverse",
        },
        ru = {
            name = "Sickle Cell",
            description = "Piercing tears" ..
            "#{{BleedingOut}} Tears cause bleeding, which makes enemies leave creep and take damage when they move",
        },
    },
    [enums.Collectibles.SPOILED_BREAKFAST] = {
        en_us = {
            name = "Spoiled Breakfast",
            description = "\1 +1 Health" ..
            "#{{EmptyHeart}} Removes half a heart",
        },
        spa = {
            name = "Desayuno Estropeado",
            description = "\1 +1 Contenedor de corazón" ..
            "#{{EmptyHeart}} Quita medio corazón",
        },
        ru = {
            name = "Spoiled Breakfast",
            description = "\1 +1 Health" ..
            "#{{EmptyHeart}} Removes half a heart",
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
            name = "Desayuno Equilibrado",
            description = "\1 +1 Contenedor de corazón" ..
            "#\1 +1 Suerte" ..
            "#{{SoulHeart}} +1 Corazón de Alma" ..
            "#{{Heart}} Restaura 1 corazón",
        },
        ru = {
            name = "Balanced Breakfast",
            description = "\1 +1 Health" ..
            "#\1 +1 Luck" ..
            "#{{SoulHeart}} +1 Soul Heart" ..
            "#{{Heart}} Heals 1 heart",
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
            name = "Desayuno Copioso",
            description = "\1 +1 Contenedor de corazón" ..
            "#\1 +0.5 Daño" ..
            "#\1 +0.3 Velocidad de disparo" ..
            "#\1 +1 Suerte" ..
            "#{{Heart}} Restaura completamente la salud",
        },
        ru = {
            name = "Hearty Breakfast",
            description = "\1 +1 Health" ..
            "#\1 +0.5 Damage" ..
            "#\1 +0.3 Fire rate" ..
            "#\1 +1 Luck" ..
            "#{{Heart}} Full heal",
        },
    },
    [enums.Collectibles.POT_OF_GOLD] = {
        en_us = {
            name = "Pot of Gold",
            description = "Converts all bomb, key, and most coin pickups into rainbow pennies" ..
            "#{{Trinket52}} Rainbow pennies activate the effect of their corresponding penny trinkets on pickup",
        },
        spa = {
            name = "Olla de Oro",
            description = "Convierte todas las bombas, llaves y la mayoría de monedas en monedas arcoíris" ..
            "#{{Trinket52}} Las monedas arcoíris activan el efecto de sus respectivas baratijas al recogerlos",
        },
        ru = {
            name = "Pot of Gold",
            description = "Converts all bomb, key, and most coin pickups into rainbow pennies" ..
            "#{{Trinket52}} Rainbow pennies activate the effect of their corresponding penny trinkets on pickup",
        },
    },
    [enums.Collectibles.FRAGILE_MIRROR] = {
        en_us = {
            name = "Glass Idol",
            description = "\1 +1 Life while intact" ..
            "#{{SoulHeart}} Isaac respawns with +1 Soul heart and 10 seconds of invinicibility on death" ..
            "#Can revive Isaac once per floor" ..
            "#Blocks 3 projectiles before shattering" ..
            "#\2 -1 Luck while shattered",
        },
        spa = {
            name = "Ídolo de Cristal",
            description = "\1 +1 Vida mientras esté intacto" ..
            "#{{SoulHeart}} Isaac resucita con +1 Corazón de Alma y 10 segundos de invulnerabilidad al morir" ..
            "#Can revive Isaac once per floor" ..
            "#Bloquea 3 proyectiles antes de romperse" ..
            "#\2 -1 Suerte mientras está roto",
        },
        ru = {
            name = "Glass Idol",
            description = "\1 +1 Life while intact" ..
            "#{{SoulHeart}} Isaac respawns with +1 Soul heart and 10 seconds of invinicibility on death" ..
            "#Can revive Isaac once per floor" ..
            "#Blocks 3 projectiles before shattering" ..
            "#\2 -1 Luck while shattered",
        },
    },
    [enums.Collectibles.LEVITICUS] = {
        en_us = {
            name = "Leviticus",
            description = "{{SoulHeart}} Must be charged by picking up soul hearts" ..
            "#{{EternalHeart}} +1 Eternal Heart" ..
            "#{{AngelRoom}} Using the item before a boss fight makes the boss reward an angel item" ..
            "#{{DevilRoom}} The angel item will cost money if a devil deal was taken previously",
            --+1 Immortal Heart instead if Immortal Hearts mod is installed
        },
        spa = {
            name = "Levítico",
            description = "{{SoulHeart}} Debe ser cargado usando corazones de alma" ..
            "#{{EternalHeart}} +1 Corazón Eterno" ..
            "#{{AngelRoom}} Usar el objeto antes de la pelea contra el jefe hace que la recompensa sea un objeto de ángel" ..
            "#{{DevilRoom}} El objeto costará dinerp si se ha tomado un pacto con el diablo",
            --+1 Corazón Inmortal en su lugar si está instalado el mod de Corazones Inmortales
        },
        ru = {
            name = "Leviticus",
            description = "{{SoulHeart}} Must be charged by picking up soul hearts" ..
            "#{{EternalHeart}} +1 Eternal Heart" ..
            "#{{AngelRoom}} Using the item before a boss fight makes the boss reward an angel item" ..
            "#{{DevilRoom}} The angel item will cost money if a devil deal was taken previously",
            --+1 Immortal Heart instead if Immortal Hearts mod is installed
        },
    },
    [enums.Collectibles.BATTERY_ACID] = {
        en_us = {
            name = "Battery Acid",
            description = "{{Battery}} Doubles active item charge from clearing rooms" ..
            "#\2 Drains 1 charge every 15 seconds",
        },
        spa = {
            name = "Ácido de Batería",
            description = "{{Battery}} Duplica la carga del objeto activo al limpiar habitaciones" ..
            "#\2 Agota 1 carga cada 15 segundos",
        },
        ru = {
            name = "Battery Acid",
            description = "{{Battery}} Doubles active item charge from clearing rooms" ..
            "#\2 Drains 1 charge every 15 seconds",
        },
    },
    [enums.Collectibles.DOGGY_BAG] = {
        en_us = {
            name = "Doggy Bag",
            description = "Taking damage spawns a random poop" ..
            "#Isaac can pick up poops by walking into them",
        },
        spa = {
            name = "Bolsa de Perro",
            description = "Recibir daño genera una caca aleatoria" ..
            "#Isaac puede coger cacas al andar hacia ellas",
        },
        ru = {
            name = "Doggy Bag",
            description = "Poop",
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
            name = "Guante de Papá",
            description = "\1 +10% Velocidad de disparo" ..
            "#\2 -0.2 Velocidad de lágrima" ..
            "#Las lágrimas se ven afectadas por el movimiento de Isaac",
        },
        ru = {
            name = "Dad's Mitt",
            description = "\1 +10% Fire rate" ..
            "#\2 -0.2 Shot speed" ..
            "#Tears become influenced by Isaac's movement",
        },
    },
    [enums.Collectibles.LIL_BISHOP] = {
        en_us = {
            name = "Lil Bishop",
            description = "Blocks projectiles" ..
            "#When hit, 20% chance to shield Isaac for 5 seconds",
        },
        spa = {
            name = "Pequeño Obispo",
            description = "Bloquea proyectiles" ..
            "#Cuando recibe un golpe, 20% de probabilidad de proteger a Isaac durante 5 segundos",
        },
        ru = {
            name = "Lil Bishop",
            description = "Blocks projectiles" ..
            "#When hit, 20% chance to shield Isaac for 5 seconds",
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
            name = "Fragmento de Arcoíris",
            description = "\1 +1 Aumento de Suerte" ..
            "#Genera 4 monedas arcoíris" ..
            "#{{Trinket52}} Las monedas arcoíris activan el efecto de sus baratijas correspondientes al recogerlas",
        },
        ru = {
            name = "Rainbow Fragment",
            description = "\1 +1 Luck up" ..
            "#Spawns 4 rainbow pennies" ..
            "#{{Trinket52}} Rainbow pennies activate the effect of their corresponding penny trinkets on pickup",
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
            name = "Máscara de Médico Brujo",
            description = "{{Pill}} Genera 1 píldora" ..
            "#Convierte todas las píldoras en píldoras espirituales" ..
            "#{{SpiritOrb}} Las píldoras espirituales activan un efecto de orbe espiritual además de su efecto de píldora",
        },
        ru = {
            name = "Witch Doctor Mask",
            description = "{{Pill}} Spawns 1 pill" ..
            "#Converts all pills into spirit pills" ..
            "#{{SpiritOrb}} Spirit pills activate a spirit orb effect on top of their pill effect",
        },
    },
    [enums.Collectibles.MIRROR_KEY] = {
        en_us = {
            name = "Mirror Key",
            description = "{{MirrorRoom}} Once a room, can create a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
        },
        spa = {
            name = "Llave de Espejo",
            description = "{{MirrorRoom}} Crea una puerta a la dimensión espejo en la pared, indicada por un contorno de puerta" ..
            "#Las habitaciones reflejadas regeneran todas los objetos, obstáculos y enemigos" ..
            "#{{Warning}} Los pedestales no se regeneran" ..
            "#{{BossRoom}} Permite volver a luchar contra el jefe para obtener una recompensa adicional",
        },
        ru = {
            name = "Mirror Key",
            description = "{{MirrorRoom}} Creates a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
        },
    },
    [enums.Collectibles.UNCHARGED_MIRROR_KEY] = {
        en_us = {
            name = "Mirror Key (Uncharged)",
            description = "{{MirrorRoom}} Once a room, can create a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
        },
        spa = {
            name = "Llave de Espejo (Sin Cargar)",
            description = "{{MirrorRoom}} Crea una puerta a la dimensión espejo en la pared, indicada por un contorno de puerta" ..
            "#Las habitaciones reflejadas regeneran todas los objetos, obstáculos y enemigos" ..
            "#{{Warning}} Los pedestales no se regeneran" ..
            "#{{BossRoom}} Permite volver a luchar contra el jefe para obtener una recompensa adicional",
        },
        ru = {
            name = "Mirror Key (Uncharged)",
            description = "{{MirrorRoom}} Creates a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
        },
    },
    
}

--TRINKET DESCRIPTIONS
descriptions.Trinkets = {
    [enums.Trinkets.TUNGSTEN_CUBE] = {
        en_us = {
            name = "Tungsten Cube",
            description = "{{ArrowDown}} -0.2 Speed. #Dropping it creates a huge damaging shockwave",
        },
        spa = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.ACID_PENNY] = {
        en_us = {
            name = "Acid Penny",
            description = "{{Pill11}} Picking up a coin has an 8% chance to spawn a pill",
        },
        spa = {
            name = "Penique Ácido",
            description = "{{Pill11}} Recoger una moneda tiene un 8% de probabilidad de crear una píldora",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.CRYSTAL_PENNY] = {
        en_us = {
            name = "Crystal Penny",
            description = "{{Card}} Picking up a coin has an 8% chance to spawn a card",
        },
        spa = {
            name = "Penique Cristalino",
            description = "{{Pill11}} Recoger una moneda tiene un 8% de probabilidad de crear una carta",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.ROCK_WHEEL] = {
        en_us = {
            name = "Rock Wheel",
            description = "Stonies and grimaces target hostile enemies",
        },
        spa = {
            name = "Rueda de Roca",
            description = "Los enemigos rocosos atacan a otros enemigos",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.AMETHYST_SHARD] = {
        en_us = {
            name = "Amethyst Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Clairvoyance when destroyed",
        },
        spa = {
            name = "Fragmento de Amatista",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Premonición",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.RUBY_SHARD] = {
        en_us = {
            name = "Ruby Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Inferno when destroyed",
        },
        spa = {
            name = "Fragmento de Rubí",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu Infernal",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.TOURMALINE_SHARD] = {
        en_us = {
            name = "Tourmaline Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Conductivity when destroyed",
        },
        spa = {
            name = "Fragmento de Turmalina",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Conductividad",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.EMERALD_SHARD] = {
        en_us = {
            name = "Emerald Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Druidity when destroyed",
        },
        spa = {
            name = "Fragmento de Esmeralda",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu Druídico",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.PERIDOT_SHARD] = {
        en_us = {
            name = "Peridot Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Virulence when destroyed",
        },
        spa = {
            name = "Fragmento de Peridoto",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Virulencia",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.GARNET_SHARD] = {
        en_us = {
            name = "Garnet Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Sacrilege when destroyed",
        },
        spa = {
            name = "Fragmento de Granate",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Sacrilegio",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.ONYX_SHARD] = {
        en_us = {
            name = "Onyx Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Revenance when destroyed",
        },
        spa = {
            name = "Fragmento de Ónix",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu del Renacido",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.DIAMOND_SHARD] = {
        en_us = {
            name = "Diamond Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Salvation when destroyed",
        },
        spa = {
            name = "Fragmento de Diamante",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Salvación",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.SAPPHIRE_SHARD] = {
        en_us = {
            name = "Sapphire Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Deluge when destroyed",
        },
        spa = {
            name = "Fragmento de Zafiro",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu del Diluvio",
        },
        ru = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
        },
    },
    [enums.Trinkets.AMBER_SHARD] = {
        en_us = {
            name = "Amber Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Terrastrium when destroyed",
        },
        spa = {
            name = "Fragmento de Ámbar",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Terrastrium",
        },
        ru = {
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
            description = "Traps all enemies in the room in vines for 12 seconds. Trapped enemies drop a fruit heart on death" ..
            "#{{BlendedHeart}} Fruit Hearts heal half a red heart, or half a soul heart if full",
            lyra_extra = "#{{ColorGray}}" .. LyraIcon .. " Doubles fruit heart drops"
        },
        spa = {
            name = "Espíritu Druídico",
            description = "#Enreda a todos los enemigos en enredaderas durante 12 segundoss. Matar a un enemigo enredado genera un corazon frutal" ..
            "#{{BlendedHeart}} Los corazones frutales dan un corazón rojo, o medio corazón de alma si está lleno",
            lyra_extra = "#{{ColorGray}}" .. LyraIcon .. " Duplica los corazones frutales generados"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.ELECTRIC] = {
        en_us = {
            name = "Spirit of Conductivity",
            description = "Shoots a wave of electricity in all directions, damaging nearby enemies" ..
            "#{{ArcadeRoom}} Short circuits all machines in radius, causing them to pay out multiple times and explode",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Doubles electricity duration and range"
        },
        spa = {
            name = "Espíritu de Conductividad",
            description = "Dispara ondas eléctricas en todas direcciones, dañando a los enemigos cercanos" ..
            "#{{ArcadeRoom}} Cortocircuita todas las máquinas cercanas, causando que paguen algunas veces y exploten",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Duplica la duración y el rango de las ondas"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.FIRE] = {
        en_us = {
            name = "Spirit of Inferno",
            description = "{{Burning}} Shoots a stream of high damage flames in a chosen direction" ..
            "#{{BossRoom}} Pierces Boss Armor",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Doubles flames shot"
        },
        spa = {
            name = "Espíritu Infernal",
            description = "{{Burning}} Dispara un chorro de poderosas llamas en la dirección elegida" ..
            "#{{BossRoom}} Penetra la Armadura de Jefe",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Duplica las llamas disparadas"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.PSYCHIC] = {
        en_us = {
            name = "Spirit of Clairvoyance",
            description = "{{Timer}} Grants an aura that slows enemies and reflects projectiles for 100 seconds",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Doubles duration and reflects faster"
        },
        spa = {
            name = "Espíritu de Premonición",
            description = "{{Timer}} Otorga un aura que ralentiza enemigos y refleja proyectiles durante 100 segundos",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Duplica la duración y refleja más rapido"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.UNDEAD] = {
        en_us = {
            name = "Spirit of Revenance",
            description = "Summons 4-6 graves around the room that spawn friendly bonies or ghosts when destroyed" ..
            "#Fills all pits in the room with bones",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Doubles spawned graves"
        },
        spa = {
            name = "Espíritu del Renacido",
            description = "Crea 4-6 tumbas en la habitación que generan bonies amistosos o fantasmas cuando se destruyen" ..
            "#Rellena todos los fosos de la habitación con huesos",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Duplica la cantidad de tumbas"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.POISON] = {
        en_us = {
            name = "Spirit of Virulence",
            description = "{{Throwable}} Throws a toxic orb that explodes into a damaging poison cloud" ..
            "#{{Slow}} Enemies inside will be slowed and take damage over time" ..
            "#The cloud grows larger the more damage it deals" ..
            "#{{RottenHeart}} Transforms hearts and beggars into their rotten variants {{RottenBeggar}}",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Doubles cloud size"
        },
        spa = {
            name = "Espíritu de Virulencia",
            description = "{{Throwable}} Lanza un orbe tóxico que explota en una nube venenosa" ..
            "#{{Slow}} Los enemigos dentro de la nube se ralentizan y envenenan" ..
            "#Cuanto más daño haga la nube, más crecerá" ..
            "#{{RottenHeart}} Transforma corazones y mendigos en sus versiones podridas {{RottenBeggar}}",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Duplica el tamaño de la nube"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.HOLY] = {
        en_us = {
            name = "Spirit of Salvation",
            description = "#Shoots 8 damaging beams of light in all directions" ..
            "#Beams can destroy rocks and open secret rooms",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Shoots 16 beams"
        },
        spa = {
            name = "Espíritu de la Salvación",
            description = "#Dispara 8 rayos de luz en todas direcciones" ..
            "#Los rayos pueden destruir rocas y abrir habitaciones secretas",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Dispara 16 rayos"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.UNHOLY] = {
        en_us = {
            name = "Spirit of Sacrilege",
            description = "#{{BleedingOut}} Slashes through all enemies and beggars in the room, inflicting them with bleeding and brimstone curse" ..
            "#Slain beggars drop extra pickups",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Slashes through enemies a second time"
        },
        spa = {
            name = "Espíritu del Sacrilegio",
            description = "#{{BleedingOut}} Atraviesa a todos los enemigos y mendigos en la habitación, inflingiendo sangrado y maldición de azufre" ..
            "#Los mendigos asesinados dan más recompensa",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Atraviesa a todos los enemigos dos veces"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.WATER] = {
        en_us = {
            name = "Spirit of Deluge",
            description = "#{{Timer}} For 8 seconds, Isaac's tears are replaced with a controllable waterfall cyclone that sucks in enemies and pickups",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Doubles duration"
        },
        spa = {
            name = "Espíritu del Diluvio",
            description = "#{{Timer}} Durante 8 segundos reemplaza las lágrimas de Isaac con un ciclón de agua controlable que atrae enemigos y objetos",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Duplica la duración"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.ROCK] = {
        en_us = {
            name = "Spirit of Terrastrium",
            description = "#Summons 4-5 rock stalagmites that impale enemies and break through metal blocks",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Spawns 8-10 stalagmites"
        },
        spa = {
            name = "Espíritu de Terrastrium",
            description = "#Crea 4-5 estalagmitas de piedra, que empalan a los enemigos y pueden romper incluso bloques de metal",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Crea el doble de estalagmitas"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    },
    [enums.Orbs.RANDOM] = {
        en_us = {
            name = "Spirit of Chaos",
            description = "#Uses a random spirit orb effect",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Doubles chosen effect"
        },
        spa = {
            name = "Espíritu de Caos",
            description = "#Usa un efecto de orbe espiritual aleatorio",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Duplica el efecto elegido"
        },
        ru = {
            name = "Orbe Druidico",
            description = "#Enreda a todos los enemigos en enredaderas durante 20 segundos, parandolos #Matar a un enemigo enredado genera un corazon frutal"
        }
    }
}

return descriptions