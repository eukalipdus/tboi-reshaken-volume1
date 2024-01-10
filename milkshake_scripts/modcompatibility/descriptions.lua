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
            "#{{ArrowUp}} {{ArrowUp}} 1.1x to 1.5x multiplier to all stats!",
            abyss = "Large, fast, pink locust that deals 2x Isaac's damage"
        },
        spa = {
            name = "Batido",
            description = "{{Heart}} +1 Corazón de Alma, Corazón Negro, o Corazón Rojo aleatoriamente" ..
            "#{{ArrowUp}} {{ArrowUp}} de 1.1x a 1.5x para todas las estadísticas!",
            abyss = "Langosta grande, rápida y rosa que hace 2 veces el daño de Isaac"
        },
        ru = {
            name = "Милкшейк", --Молочный коктейль
            description = "{{Heart}} +1 Сердце Души, Черное Сердце или Здоровье случайным образом" ..
            "#{{ArrowUp}} {{ArrowUp}} Множитель всех характеристик от 1,1x до 1,5x!",
            abyss = "Большая, быстрая розовая саранча, наносящая двойной урон Исаака"
        },
        pl = {
            name = "Milkshake",
            description = "{{Heart}} +1 serce dusz, czarne serce, lub czerwone serce, losowo" ..
            "#{{ArrowUp}} {{ArrowUp}} Daje losowe mnożniki od 1.1x do 1.5x dla wszystkich statystyk!"
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
            name = "Острый курсор",
            description = "#Нацеливается на самого дальнего врага в комнате" ..
            "#{{Damage}} При нажатии клавиш стрельбы, она щелкает, нанося 10% урона Исаака" ..
            "#{{Warning}} Дважды нажмите Ctrl, чтобы переключить режим управления на мышку",
        },
        pl = {
            name = "Ostry Kursor",
            description = "#Atakuje najbardziej oddalonego przeciwnika w pokoju" ..
            "#{{Damage}} Klika po wciśnięciu dowolnego przycisku ataku, zadając 10% twoich obrażeń" ..
            "#{{Warning}} Wciśnij dwukrotnie przycisk upuszczania, aby przełączyć tryb kontroli myszką",
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
            name = "Черный глаз",
            description = "{{Blank}}{{ArrowUp}} +0,7 скорострельности и отбрасывания только для правого глаза #В настоящее время не используется и не закодировано, возможно, появится позже (вероятно, не появится)",
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
            name = "Кубик-кость",
            description = "Активирует случайный эффект комнаты костей #В настоящее время не используется и не закодирован, возможно, он появится позже",
        },
    },
    [enums.Collectibles.FIRECRACKER_ROSE] = {
        en_us = {
            name = "Firecracker Flower",
            description = "{{Burning}} Chance to shoot seed tears that stick to enemies" ..
            "#Seed tears blossom and burst into exploding petal tears after 4 seconds, dealing 35 + 6xIsaac's Damage",
            abyss = "Green, burning locust that has a 10% chance to inflict {{Burning}} Kabloom"
        },
        spa = {
            name = "Flor Petardo",
            description = "{{Burning}} Posibilidad de disparar una semilla que inflige a los enemigos con Kabloom #Los enemigos con Kabloom explotarán en lágrimas de pétalos explosivos después de 5 segundos",
            abyss = "Langosta verde que tiene un 10% de posibilidad de inflingir {{Burning}} Kabloom"
        },
        ru = {
            name = "Цветок-петарда",
            description = "{{Burning}} Шанс выстрелить семенными слезами, которые прилипают к врагам" ..
            "#Семенные слезы распускаются и через 4 секунды превращаются в взрывающиеся лепестковые слезы, нанося 35 + 6x урона Исаака",
            abyss = "Зеленая, пылающая саранча, с вероятностью 10% может наложить {{Горящий}} Каблум."
        },
        pl = {
            name = "Petunia Petarda",
            description = "{{Burning}} Szansa na wystrzelenie nasion, które przyczepiają się do przeciwników" ..
            "#Nasiona rozkwitają w wybuchowe płatki po 4 sekundach, zadając 35 + 6 x obrażenia Izaaka",
            abyss = "Zielona, płonąca szarańcza, która ma 10% szans na wywołanie {{Burning}} Rozsadzenia"
        },
    },
    [enums.Collectibles.GLOBIN_IN_A_BUCKET] = {
        en_us = {
            name = "Globin In A Bucket",
            description = "Spawns a friendly globin that fights by your side" ..
            "#Chance to spawn different globin variants depending on the floor" .. 
            "#A maximum of 4 globins can be spawned at once",
            book_of_virtues = "Middle ring wisp#50% chance to reform on death"
        },
        spa = {
            name = "Globin en un Cubo",
            description = "Invoca a un globin amigable que lucha a tu lado" ..
            "#Posibilidad de invocar diferentes variantes según el piso",
            book_of_virtues = "Anillo medio#50% de posibilida de regenerarse al morir"
        },
        ru = {
            name = "Глобин в ведре",
            description = "Создает дружелюбного глобина, который сражается на вашей стороне" ..
            "#Шанс создать разные варианты глобина в зависимости от этажа" ..
            "#Одновременно может быть создано максимум 4 глобина",
            book_of_virtues = "Огонёк среднего кольца#50% шанс восстановиться после смерти"
        },
        pl = {
            name = "Wiadro Pełne Globiny",
            description = "Wypuszcza przyjaznego Globina, który walczy po twojej stronie" ..
            "#Może stworzyć inne wariantly Globinów zależnie od piętra",
        },
    },
    [enums.Collectibles.GOLDEN_SHOVEL] = {
        en_us = {
            name = "Golden Shovel",
            description = "Digs up 1-2 golden chests and a random golden pickup." ..
            "#{{LadderRoom}} Opens up a member card trapdoor if used on a decorative floor tile.",
            book_of_virtues = "Middle ring wisp#High HP wisp#10% chance for {{Collectible202}} Midas' Touch tears"
        },
        spa = {
            name = "Pala Dorada",
            description = "Desentierra de 1 a 2 cofres dorados y un pickup dorado al azar." ..
            "#{{LadderRoom}} Abre una trampilla de tarjeta de miembro si se usa en una baldosa decorativa del suelo.",
            book_of_virtues = "Anillo medio con mucha vida#10% de probabilidad de disparar lágrimas de {{Collectible202}} Toque de Midas"
        },
        ru = {
            name = "Золотая лопата",
            description = "Выкапывает 1-2 золотых сундука и случайный золотой предмет" ..
            "#{{LadderRoom}} Создаёт люк к магазину членской карты, если использовано на клетке пола с декорацией (трава, маленькие камешки, бумажки, и т.д.)",
            book_of_virtues = "Огонёк среднего кольца#Огонёк с высоким здоровьем#10% шанс выстрелить слезы с эффектом {{Collectible202}} Прикосновения Мидаса"
        },
        pl = {
            name = "Złota Łopata",
            description = "Wykopuje 1-2 złote skrzynie oraz losowy złoty pickup" ..
            "#{{LadderRoom}} Po użyciu nad dekoracją podłogi otwiera sklep Karty Członkowskiej",
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
            description = "\1 +0.3 Скорости" ..
            "#{{MomBossSmall}} Иммунитет к топающим атакам",
        },
        pl = {
            name = "Laczek",
            description = "\1 +0.3 do Prędkości" ..
            "#Odpornośc na {{MomBossSmall}} ataki przygniatające",
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
            name = "Лира",
            description = "{{SpiritOrb}} 15% шанс, что наградой за зачистку комнаты будет случайная сфера духа" ..
            "#{{SpiritOrb}} Шанс получить бонусную сферу духа из сундуков, отмеченных камней и разрушенных автоматов" ..
            "#\1 Использование сферы духа запускает короткую ритм мини-игру" ..
            "#{{Blank}} Успешное завершение активирует сферу духа с двойным эффектом",
        },
        pl = {
            name = "Lutnia",
            description = "{{SpiritOrb}} 15% na zastąpienie nagrody za ukończenie pokoju widmową kulą" ..
            "#{{SpiritOrb}} Daje szansę na dostanie widmowej kuli z skrzyń, skał z X'em i zniszczonych maszyn" .. 
            "#\1 Użycie widmowej kuli zaczyna krótką minigrę rytmiczną" ..
            "#{{Blank}} Wygranie minigry podwaja efekt użytej kuli",
        },
    },
    [enums.Collectibles.EMPTY_SLOT] = {
        en_us = {
            name = "Empty Slot",
            description = "{{Coin}} Inserts a coin" ..
            "#After 10 coins, has a 1% chance to explode and spawn double the coins inserted" ..
            "#Guranteed to explode at 100 coins inserted",
            book_of_virtues = "Inner ring wisp#Low HP wisp",
            book_of_belial = "↑ {{Damage}} +0.066 Damage per coin inserted while held"
        },
        spa = {
            name = "Tragaperras Vacía",
            description = "{{Coin}} Inserta una moneda" ..
            "#Después de 10 monedas, tiene un 1% de probabilidad de explotar y generar el doble de las monedas insertadas" ..
            "#Garantizado que explotará al insertar 100 monedas",
            book_of_virtues = "Anillo interior con poca vida",
            book_of_belial = "↑ {{Damage}} +0.066 Daño por moneda insertada"
        },
        ru = {
            name = "Пустой слот",
            description = "{{Coin}} Вставляете монету" ..
            "#После 10 монет с вероятностью 1% взорвется и появится вдвое больше вложенных монет" ..
            "#Гарантированно взорвется при 100-ой монете",
            book_of_virtues = "Огонёк внутреннего кольца#Огонёк с низким здоровьем",
            book_of_belial = "↑ {{Damage}} +0,066 Урона за каждую вложенную монету"
        },
        pl = {
            name = "Puste Pudło",
            description = "{{Coin}} Wrzuca monetę" ..
            "#Po 10 monetach, z każdą kolejną monetą ma 1% szansy na wybuchnięcie i wyrzucenie 2 razy więcej monet niż włożono" ..
            "#Zawsze wybucha po włożeniu 100 monet",
        },
    },
    [enums.Collectibles.SHATTERED_ORB] = {
        en_us = {
            name = "Shattered Orb",
            description = "Can be thrown at enemies to capture their soul" ..
            "#{{SpiritOrb}} Captured enemies are turned into spirit orbs corresponding to their soul's element",
            book_of_virtues = "Upon shattering, spawns 3 random elemental wisps of varying effects",
            book_of_belial = "50% chance to replace spawned {{SpiritOrb}} Spirit of Chaos with Spirit of Sacrilege"
        },
        spa = {
            name = "Orbe Fragmentado",
            description = "Puede arrojarse a los enemigos para capturar sus almas" ..
            "#{{SpiritOrb}} Los enemigos capturados se convierten en orbes espirituales que corresponden al elemento de su alma",
            book_of_virtues = "Al romperse, genera 3 orbitales de fuego elementales, con efectos diversos",
            book_of_belial = "50% de probabilidad de reemplazar {{SpiritOrb}} Espíritu del Caos con Espíritu de Sacrilegio",
        },
        ru = {
            name = "Расколотая сфера",
            description = "Можно бросить во врагов, чтобы захватить их душу" ..
            "#{{SpiritOrb}} Захваченные враги превращаются в сферы духов с соответствующим им элементом души",
            book_of_virtues = "При разрушении создает 3 случайных элементальных огонька с различными эффектами",
            book_of_belial = "50% шанс заменить сферы {{SpiritOrb}} Духа Хаоса на Духа Святотатства"
        },
        pl = {
            name = "Strzaskana Kula",
            description = "Rzuć nią w przeciwników, żeby skraść im dusze" ..
            "#{{SpiritOrb}} Złapani przeciwnicy są zamieniani w widmowe kule zależnie od żywiołu ich duszy",
        },
    },
    [enums.Collectibles.PRISMATIC_DICE] = {
        en_us = {
            name = "Prismatic Dice",
            description = "Splits pedestal items in the room into two pedestals of 1 less quality" ..
            "#Quality {{Quality0}} items are split into random pickups",
            book_of_virtues = "Middle ring wisp#Cannot shoot tears#Splits Isaac's tears into 4 {{Collectible528}} angelic prism tears",
            book_of_belial = "30% chance for split items to be {{DevilRoom}} Devil items"
        },
        spa = {
            name = "Dado Prismático",
            description = "Divide los pedestales en la habitación en dos pedestales de 1 calidad inferior" ..
            "#Los objetos de calidad {{Quality0}} se dividen en objetos aleatorios",
            book_of_virtues = "Anillo medio#No dispara#Divide las lágrimas de Isaac en 4 lágrimas de {{Collectible528}} Prisma Angelical",
            book_of_belial = "30% de posibilidad de reemplazar los pedestales divididos por {{DevilRoom}} objetos del demonio"
        },
        ru = {
            name = "Призматический кубик",
            description = "Разделяет предметы в комнате на два пьедестала с качеством меньше на 1" ..
            "#Предметы с качеством {{Quality0}} разделяются на случайные расходники",
            book_of_virtues = "Огоньки среднего кольца#Не может стрелять#Разделяет слезы Исаака на 4 слезы {{Collectible528}} ангельской призмы",
            book_of_belial = "С вероятностью 30% разделенные предметы будут предметами {{DevilRoom}} дьявола"
        },
        pl = {
            name = "Pryzmatyczna Kostka",
            description = "Rozdziela każdy przedmiot w pokoju na 2 przedmioty o jakości o 1 mniejszej" ..
            "#Przedmioty o jakości {{Quality0}} zamiast tego są rozdzielane na pickupy",
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
            name = "Дух-бездельник",
            description = "{{SoulHeart}} Подбирает ближайшие сердца душ" ..
            "#{{SpiritOrb}} Взамен создает случайные сферы духа",
        },
        pl = {
            name = "Widmowy Przybłęda",
            description = "{{SoulHeart}} Zabieria pobliskie serca dusz" ..
            "#{{SpiritOrb}} Odpłaca się widmowymi kulami",
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
            name = "Небесное Зеркало",
            description = "Зеркально повторяет движение Исаака" ..
            "#Наносит 75 урона в секунду" ..
            "#\1  {{MirrorRoom}} +2,5 Урона в зеркальном мире",
        },
        pl = {
            name = "Gwieździste Lustro",
            description = "Odzwierciedla twoje ruchy" ..
            "#Zadaje 75 obrażeń na sekunde" ..
            "#\1 {{MirrorRoom}} Daje +2.5 Obrażeń w lustrzanym wymiarze",
        },
    },
    [enums.Collectibles.SICKLE_CELL] = {
        en_us = {
            name = "Sickle Cell",
            description = "Piercing tears" ..
            "#{{BleedingOut}} Tears cause bleeding, which makes enemies leave creep and take damage when they move",
            abyss = "Red locust that inflicts {{BleedingOut}} Bleeding"
        },
        spa = {
            name = "Célula Falciforme",
            description = "Lágrimas perforantes" ..
            "#{{BleedingOut}} Las lágrimas causan sangrado, lo que hace que los enemigos dejen sangre y reciban daño al moverse",
            abyss = "Langosta roja que inflige {{BleedingOut}} Sangrado"
        },
        ru = {
            name = "Серповидная клетка",
            description = "Слезы пронзают врагов насквозь" ..
            "#{{BleedingOut}} Слезы вызывают кровотечение, которое заставляет врагов оставлять кровавй след и получать урон при движении",
            abyss = "Красная саранча, вызывающая {{BleedingOut}} кровотечение"
        },
        pl = {
            name = "Sierpowata Krwinka",
            description = "Przebijające łzy" ..
            "#{{BleedingOut}} Łzy wywołują krwawienie. Krwawiący przeciwnicy zostawiaja za sobą plamy krwi i otrzymują obrażenia przy poruszaniu się",
            abyss = "Czerwona szarańcza, która wywołuje {{BleedingOut}} krwotok"
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
            name = "Испорченный завтрак",
            description = "\1 +1 Здоровье" ..
            "#{{EmptyHeart}} Удаляет половину сердца",
        },
        pl = {
            name = "Przegniłe Śniadanie",
            description = "\1 +1 do Maksymalnego Zdrowia" ..
            "#{{EmptyHeart}} Usuwa pół serduszka",
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
            name = "Сбалансированный завтрак",
            description = "\1 +1 Здоровье" ..
            "#\1 +1 Удача" ..
            "#{{SoulHeart}} +1 Сердце души" ..
            "#{{Heart}} Лечит 1 сердце",
        },
        pl = {
            name = "Porządne Śniadanie",
            description = "\1 +1 do Maksymalnego Zdrowia" ..
            "#\1 +1 Szczęścia" ..
            "#{{SoulHeart}} +1 serce dusz" ..
            "#{{Heart}} Leczy jedno czerwone serduszko",
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
            name = "Сытный завтрак",
            description = "\1 +1 Здоровье" ..
            "#\1 +0.5 Урон" ..
            "#\1 +0.3 Скорострельность" ..
            "#\1 +1 Удача" ..
            "#{{Heart}} Полное исцеление",
        },
        pl = {
            name = "Obfite Śniadanie",
            description = "\1 +1 do Maksymalnego Zdrowia" ..
            "#\1 +0.5 Obrażeń" ..
            "#\1 +0.3 Szybkostrzelności" ..
            "#\1 +1 Szczęścia" ..
            "#{{Heart}} Pełne leczenie",
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
            name = "Горшок золота",
            description = "Преобразует все бомбы, ключи и большинство монет в радужные монеты" ..
            "#{{Trinket52}} Радужные монеты активируют эффект соответствующих им безделушек",
        },
        pl = {
            name = "Kociołek Złota",
            description = "Zamienia bomby, klucze i większość monet w tęczowe monety" ..
            "#{{Trinket52}} Tęczowe monety aktywują efekt wybranego trynkieta Pieniążka po podniesieniu",
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
            name = "Стеклянный идол",
            description = "\1 +1 доп.жизни, пока не повреждена" ..
            "#{{SoulHeart}} Исаак возрождается с +1 сердцем души и 10 секундами неуязвимости после смерти" ..
            "#Может оживить Исаака один раз за этаж" ..
            "#Блокирует 3 снаряда, прежде чем разбиться" ..
            "#\2 -1 Удача, пока разбита",
        },
        pl = {
            name = "Szklana Statua",
            description = "\1 +1 Życie gdy w całości" ..
            "#{{SoulHeart}} Izaak odradza się z 1 sercem dusz i 10 sekundami nietykalności po śmierci" ..
            "#Może wskrzesić Izaaka raz na piętro" ..
            "#Blokuje 3 pociski po czym rozpada się" ..
            "#\2 -1 Szczęścia gdy roztrzaskana",
        },
    },
    [enums.Collectibles.LEVITICUS] = {
        en_us = {
            name = "Leviticus",
            description = "{{SoulHeart}} Must be charged by picking up soul hearts" ..
            "#{{EternalHeart}} +1 Eternal Heart" ..
            "#{{AngelRoom}} Using the item before a boss fight makes the boss reward an angel item" ..
            "#{{DevilRoom}} The angel item will cost money if a devil deal was taken previously",
            book_of_virtues = "Inner ring wisp#High HP wisp#+10% {{AngelRoom}} Angel Room chance per Leviticus wisp",
            abyss = "Blue, glowing locust that can spawn beams of light that deal 3x Isaac's damage",
        },
        spa = {
            name = "Levítico",
            description = "{{SoulHeart}} Debe ser cargado usando corazones de alma" ..
            "#{{EternalHeart}} +1 Corazón Eterno" ..
            "#{{AngelRoom}} Usar el objeto antes de la pelea contra el jefe hace que la recompensa sea un objeto de ángel" ..
            "#{{DevilRoom}} El objeto costará dinerp si se ha tomado un pacto con el diablo",
            book_of_virtues = "Anillo interior con mucha vida#+10% {{AngelRoom}} de pacto de Ángel",
            abyss = "Langosta azul y brillante que puede generar rayos de luz que hace 3x el daño de Isaac"
        },
        ru = {
            name = "Книга Левит",
            description = "{{SoulHeart}} Заряжается при подборе сердец души" ..
            "#{{EternalHeart}} +1 Вечное сердце" ..
            "#{{AngelRoom}} Использование перед битвой с боссом заставляет его наградить предметом ангела" ..
            "#{{DevilRoom}} Предмет ангела будет стоить денег, если ранее была заключена сделка с дьяволом",
            book_of_virtues = "Огонёк внутренного кольца#Огонёк с высоким здоровьем#+10% {{AngelRoom}} шанс на ангела за каждый огонёк",
            abyss = "Синяя светящаяся саранча, которая может бить лучами света, наносящие тройной урон Исаака",
        },
        pl = {
            name = "Księga Kapłańska",
            description = "{{SoulHeart}} Musi być naładowana poprzez zbieranie serc dusz" ..
            "#{{EternalHeart}} +1 Wieczne serce" ..
            "#{{AngelRoom}} Użycie tego przedmiotu przed bossem zamieni nagrodę za bossa w przedmiot od anioła" ..
            "#{{DevilRoom}} Przedmiot od anioła będzie kosztował pieniądze jeżeli zawarto wcześniej pakt z diabłem",
            book_of_virtues = "Ogniki w wewnętrznym kręgu#Duże zdrowie ognika#+10% szansy na {{AngelRoom}} Anielski Pokój za każdego ognika Księgi Kapłańskiej",
            abyss = "Niebieska, świecąca szarańcza, która czasami przywołuje promień światła, zadający obrażenia Izaaka x 3",
        },
    },
    [enums.Collectibles.BATTERY_ACID] = {
        en_us = {
            name = "Battery Acid",
            description = "{{Battery}} Doubles active item charge rate" ..
            "#\2 Drains 1 charge every 15 seconds" ..
            "#Isaac leaves a sparse trail of acid creep"
        },
        spa = {
            name = "Ácido de Batería",
            description = "{{Battery}} Duplica la carga del objeto activo al limpiar habitaciones" ..
            "#\2 Agota 1 carga cada 15 segundos",
        },
        ru = {
            name = "Батарейная кислота",
            description = "{{Battery}} Удваивает скорость зарядки активного предмета" ..
            "#\2 Снимает 1 заряд каждые 15 секунд" ..
            "#Исаак оставляет разреженный кислотный след"
        },
        pl = {
            name = "Kwas z Baterii",
            description = "{{Battery}} Podwaja zdobyte ładunki aktywowanych przedmiotów" ..
            "#\2 Odbiera jeden ładunek co 15 sekund" ..
            "#Izaac zostawia za sobą smugę z kwasu"
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
            name = "Собачья сумка",
            description = "При получении урона появляется случайная какашка" ..
            "#Исаак может подбирать какашки, проходя по ним",
        },
        pl = {
            name = "Psi Worek",
            description = "Otrzymywanie obrażeń tworzy losową kupę" ..
            "#Izaak możę podnosić kup podchodząc do nich",
        },
    },
    [enums.Collectibles.DADS_MITT] = {
        en_us = {
            name = "Dad's Mitt",
            description = "\1 +10% Fire rate" ..
            "#\2 -0.2 Shot speed" ..
            "#Tears become influenced by Isaac's movement",
            abyss = "Baseball locust that follows Isaac's movement momentum",
        },
        spa = {
            name = "Guante de Papá",
            description = "\1 +10% Velocidad de disparo" ..
            "#\2 -0.2 Velocidad de lágrima" ..
            "#Las lágrimas se ven afectadas por el movimiento de Isaac",
            abyss = "Langosta bola de béisbol afectada por el movimiento de Isaac"
        },
        ru = {
            name = "Папина бейсбольная перчатка",
            description = "\1 +10% Скорострельность" ..
            "#\2 -0.2 Скорость выстрела" ..
            "#Движение Исаака влияет на слезы",
            abyss = "Бейсбольная саранча, которая следует за импульсом движения Исаака.",
        },
        pl = {
            name = "Rękawica Ojca",
            description = "\1 +10% Szybkostrzelności" ..
            "#\2 -0.2 Prędkości pocisków" ..
            "#Tor lotu łez zmienia się wraz z ruchem Isaaka",
            abyss = "Bejsbolowa szarańcza, które naśladuje ruchy Izaaka",
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
            name = "Малютка Епископ",
            description = "Блокирует вражеские снаряды" ..
            "#При попадании вражеского снаряда, есть 20% шанс защитить Исаака щитом на 5 секунд",
        },
        pl = {
            name = "Tyci Biskup",
            description = "Blokuje pociski" ..
            "#Po trafieniu ma 20% szansy na osłonienie Isaaka na 5 sekund",
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
            name = "Радужный фрагмент",
            description = "\1 +1 Удача" ..
            "#Создает 4 радужных монеты" ..
            "#{{Trinket52}} Радужные монеты активируют эффект соответствующих им безделушек",
        },
        pl = {
            name = "Kawałek Tęczy",
            description = "\1 +1 Szczęścia" ..
            "#Tworzy 4 tęczowe monety" ..
            "#{{Trinket52}} Tęczowe monety aktywują efekt wybranego trynkieta Pieniążka po podniesieniu",
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
            name = "Маска знахаря",
            description = "{{Pill}} Создает 1 пилюлю" ..
            "#Превращает все пилюли в пилюли духов" ..
            "#{{SpiritOrb}} Пилюли духов активируют эффекты сферы духов вместо эффекта пилюли",
        },
        pl = {
            name = "Maska Znachora",
            description = "{{Pill}} Tworzy 1 pigułkę" ..
            "#Zamienia wszystkie pigułki w widmowe pigułki" ..
            "#{{SpiritOrb}} Widmowe pigułki poza swoimi normalnymi efektami aktywują efekt wybranej kuli dusz",
        },
    },
    [enums.Collectibles.MIRROR_KEY] = {
        en_us = {
            name = "Mirror Key",
            description = "{{MirrorRoom}} Once a room, can create a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
            book_of_belial = "↑ {{Damage}} +2.5 Damage while in the mirror world",
        },
        spa = {
            name = "Llave de Espejo",
            description = "{{MirrorRoom}} Crea una puerta a la dimensión espejo en la pared, indicada por un contorno de puerta" ..
            "#Las habitaciones reflejadas regeneran todas los objetos, obstáculos y enemigos" ..
            "#{{Warning}} Los pedestales no se regeneran" ..
            "#{{BossRoom}} Permite volver a luchar contra el jefe para obtener una recompensa adicional",
            book_of_belial = "↑ {{Damage}} +2.5 Daño mientras Isaac está en la dimensión espejo",
        },
        ru = {
            name = "Зеркальный ключ",
            description = "{{MirrorRoom}} Один раз за комнату, можно создать зеркальную дверь на стене, обозначенную контуром двери" ..
            "#Зеркальные комнаты воссоздают все предметы, препятствия и врагов" ..
            "#{{Warning}} Пьедесталы предметов не воссоздаются" ..
            "#{{BossRoom}} Позволяет сразиться с боссом этажа и получить дополнительную награду",
            book_of_belial = "↑ {{Damage}} +2.5 урона в зеркальном мире",
        },
        pl = {
            name = "Lustrzany Klucz",
            description = "{{MirrorRoom}} Raz na pokój może stworzyć wejście do lustrzanego pokoju poprzez stworzenie drzwi na pustej ścianie" ..
            "#Lustrzane pokoje zawierają kopie wszystkich pickupów, przeszkód i przeciwników z oryginalnego pokoju" ..
            "#{{Warning}} Przedmioty nie są kopiowane" ..
            "#{{BossRoom}} Pozwala na ponowną walkę z bossem piętra, do daje dodatkowy przedmiot.",
            book_of_belial = "↑ {{Damage}} +2.5 Obrażen w lustrzanym wymiarze",
        },
    },
    [enums.Collectibles.UNCHARGED_MIRROR_KEY] = {
        en_us = {
            name = "Mirror Key (Uncharged)",
            description = "{{MirrorRoom}} Once a room, can create a mirror dimension door on the wall, indicated by a door outline" ..
            "#Mirrored rooms regenerate all pickups, obstacles, and enemies" ..
            "#{{Warning}} Item pedestals are not regenerated" ..
            "#{{BossRoom}} Allows refighting the floor boss for an extra reward",
            book_of_belial = "↑ {{Damage}} +2.5 Damage while in the mirror world",
        },
        spa = {
            name = "Llave de Espejo (Sin Cargar)",
            description = "{{MirrorRoom}} Crea una puerta a la dimensión espejo en la pared, indicada por un contorno de puerta" ..
            "#Las habitaciones reflejadas regeneran todas los objetos, obstáculos y enemigos" ..
            "#{{Warning}} Los pedestales no se regeneran" ..
            "#{{BossRoom}} Permite volver a luchar contra el jefe para obtener una recompensa adicional",
            book_of_belial = "↑ {{Damage}} +2.5 Daño mientras Isaac está en la dimensión espejo",
        },
        ru = {
            name = "Зеркальный ключ (Незаряженный)",
            description = "{{MirrorRoom}} Один раз за комнату, можно создать зеркальную дверь на стене, обозначенную контуром двери" ..
            "#Зеркальные комнаты воссоздают все предметы, препятствия и врагов" ..
            "#{{Warning}} Пьедесталы предметов не воссоздаются" ..
            "#{{BossRoom}} Позволяет сразиться с боссом этажа и получить дополнительную награду",
            book_of_belial = "↑ {{Damage}} +2.5 урона в зеркальном мире",
        },
        pl = {
            name = "Lusztrzany Klucz (Rozładowany)",
            description = "{{MirrorRoom}} Raz na pokój może stworzyć wejście do lustrzanego pokoju poprzez stworzenie drzwi na pustej ścianie" ..
            "#Lustrzane pokoje zawierają kopie wszystkich pickupów, przeszkód i przeciwników z oryginalnego pokoju" ..
            "#{{Warning}} Przedmioty nie są kopiowane" ..
            "#{{BossRoom}} Pozwala na ponowną walkę z bossem piętra, do daje dodatkowy przedmiot.",
            book_of_belial = "↑ {{Damage}} +2.5 Obrażen w lustrzanym wymiarze",
        },
    },
    
}

descriptions.Collectibles[enums.Collectibles.LEVITICUS_ALADAR] = descriptions.Collectibles[enums.Collectibles.LEVITICUS]
descriptions.Collectibles[enums.Collectibles.LEVITICUS_FANCY] = descriptions.Collectibles[enums.Collectibles.LEVITICUS]

--TRINKET DESCRIPTIONS
descriptions.Trinkets = {
    [enums.Trinkets.TUNGSTEN_CUBE] = {
        en_us = {
            name = "Tungsten Cube",
            description = "{{ArrowDown}} -0.2 Speed #Dropping it creates a huge damaging shockwave",
            double = "{{ArrowDown}} -0.2 Speed #Dropping it creates a huge damaging shockwave #{{ColorGold}}Deals double damage",
            triple = "{{ArrowDown}} -0.2 Speed #Dropping it creates a huge damaging shockwave #{{ColorGold}}Deals triple damage",
        },
        spa = {
            name = "Cubo De Tungsteno",
            description = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
            double = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño #{{ColorGold}}Hace el doble de daño",
            triple = "{{Blank}}{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño #{{ColorGold}}Hace el triple de daño",
        },
        ru = {
            name = "Вольфрамовый куб",
            description = "{{ArrowDown}} -0.2 Скорости #При падение создаст огромную разрушительную ударную волну",
            double = "{{ArrowDown}} -0.2 Скорости #При падение создаст огромную разрушительную ударную волну #{{ColorGold}}Наносит двойной урон",
            triple = "{{ArrowDown}} -0.2 Скорости #При падение создаст огромную разрушительную ударную волну #{{ColorGold}}Наносит тройной урон",
        },
        pl = {
            name = "Wolframowy Kloc",
            description = "{{ArrowDown}} -0.2 Prędkości. #Tworzy falę uderzeniową po upuszczeniu",
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
            name = "Кислотная монетка",
            description = "{{Blank}}{{ArrowDown}} При подборе монет с вероятностью 8% появится пилюля",
        },
        pl = {
            name = "Kwaśny Pieniążek",
            description = "{{Pill11}} Podnoszenie monety ma 8% szans na stworzenie pigułki",
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
            name = "Хрустальный монетка",
            description = "{{Card}} При подборе монет с вероятностью 8% появится карта",
        },
        pl = {
            name = "Kryształowy Pieniążek",
            description = "{{Pill11}} Podnoszenie monety ma 8% szans na stworzenie karty",
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
            name = "Каменное колесо",
            description = "Каменюки и гримассы атакуют врагов",
        },
        pl = {
            name = "Skalne Koło",
            description = "Grymasy stają się przyjazne i atakują innych przeciwników",
        },
    },
    [enums.Trinkets.AMETHYST_SHARD] = {
        en_us = {
            name = "Amethyst Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Clairvoyance when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Clairvoyance when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Clairvoyance when destroyed",
        },
        spa = {
            name = "Fragmento de Amatista",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Premonición",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus de Premonición",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus de Premonición",
        },
        ru = {
            name = "Осколок Аметиста",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Ясновидения",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Ясновидения",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Ясновидения",
        },
        pl = {
            name = "Odłamek Ametystu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Jasnowidzenia po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Jasnowidzenia po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Jasnowidzenia po zniszczeniu",
        },
    },
    [enums.Trinkets.RUBY_SHARD] = {
        en_us = {
            name = "Ruby Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Inferno when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Inferno when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Inferno when destroyed",
        },
        spa = {
            name = "Fragmento de Rubí",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu Infernal",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus Infernales",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus Infernales",
        },
        ru = {
            name = "Осколок Рубина",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Инферно",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Инферно",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Инферно",
        },
        pl = {
            name = "Odłamek Rubinu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Pożogi po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Pożogi po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Pożogi po zniszczeniu",
        },
    },
    [enums.Trinkets.TOURMALINE_SHARD] = {
        en_us = {
            name = "Tourmaline Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Conductivity when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Conductivity when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Conductivity when destroyed",
        },
        spa = {
            name = "Fragmento de Turmalina",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Conductividad",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus de Conductividad",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus de Conductividad",
        },
        ru = {
            name = "Осколок Турмалина",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Электропотока",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Электропотока",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Электропотока",
        },
        pl = {
            name = "Odłamek Turmalinu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Elektryczności po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Elektryczności po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Elektryczności po zniszczeniu",
        },
    },
    [enums.Trinkets.EMERALD_SHARD] = {
        en_us = {
            name = "Emerald Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Druidity when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Druidity when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Druidity when destroyed",
        },
        spa = {
            name = "Fragmento de Esmeralda",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu Druídico",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus Druídicos",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus Druídicos",
        },
        ru = {
            name = "Осколок Изумруда",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Друидизма",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Друидизма",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Друидизма",
        },
        pl = {
            name = "Odłamek Szmaragdu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Przyrody po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Przyrody po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Przyrody po zniszczeniu",
        },
    },
    [enums.Trinkets.PERIDOT_SHARD] = {
        en_us = {
            name = "Peridot Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Virulence when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Virulence when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Virulence when destroyed",
        },
        spa = {
            name = "Fragmento de Peridoto",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Virulencia",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus de Virulencia",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus de Virulencia",
        },
        ru = {
            name = "Осколок Перидота",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Ядовитости",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Ядовитости",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Ядовитости",
        },
        pl = {
            name = "Odłamek Perydotu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Skażenia po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Skażenia po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Skażenia po zniszczeniu",
        },
    },
    [enums.Trinkets.GARNET_SHARD] = {
        en_us = {
            name = "Garnet Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Sacrilege when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Sacrilege when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Sacrilege when destroyed",
        },
        spa = {
            name = "Fragmento de Granate",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Sacrilegio",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus de Sacrilegio",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus de Sacrilegio",
        },
        ru = {
            name = "Осколок Граната",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Святотатства",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Святотатства",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Святотатства",
        },
        pl = {
            name = "Odłamek Granatu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Świętokradztwa po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Świętokradztwa po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Świętokradztwa po zniszczeniu",
        },
    },
    [enums.Trinkets.ONYX_SHARD] = {
        en_us = {
            name = "Onyx Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Revenance when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Revenance when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Revenance when destroyed",
        },
        spa = {
            name = "Fragmento de Ónix",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu del Renacido",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus del Renacido",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus del Renacido",
        },
        ru = {
            name = "Осколок Оникса",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Возврата",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Возврата",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Возврата",
        },
        pl = {
            name = "Odłamek Onyksu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Zaświatów po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Zaświatów po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Zaświatów po zniszczeniu",
        },
    },
    [enums.Trinkets.DIAMOND_SHARD] = {
        en_us = {
            name = "Diamond Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Salvation when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Salvation when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Salvation when destroyed",
        },
        spa = {
            name = "Fragmento de Diamante",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Salvación",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus de Salvación",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus de Salvación",
        },
        ru = {
            name = "Осколок Алмаза",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Спасения",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Спасения",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Спасения",
        },
        pl = {
            name = "Odłamek Diamentu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Zbawienia po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Zbawienia po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Zbawienia po zniszczeniu",
        },
    },
    [enums.Trinkets.SAPPHIRE_SHARD] = {
        en_us = {
            name = "Sapphire Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Deluge when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Deluge when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Deluge when destroyed",
        },
        spa = {
            name = "Fragmento de Zafiro",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu del Diluvio",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus del Diluvio",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus del Diluvio",
        },
        ru = {
            name = "Осколок Сапфира",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Потопа",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духи Потопа",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духи Потопа",
        },
        pl = {
            name = "Odłamek Szafiru",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Potopu po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Potopu po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Potopu po zniszczeniu",
        },
    },
    [enums.Trinkets.AMBER_SHARD] = {
        en_us = {
            name = "Amber Shard",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Terrastrium when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Terrastrium when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Terrastrium when destroyed",
        },
        spa = {
            name = "Fragmento de Ámbar",
            description = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear un Espíritu de Terrastrium",
            double = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}1-2 {{CR}}Espíritus de Terrastrium",
            triple = "{{SpiritOrb}} Destruir rocas marcadas tiene un 75% de probabilidad de crear {{ColorGold}}2-3 {{CR}}Espíritus de Terrastrium",
        },
        ru = {
            name = "Осколок Янтаря",
            description = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадет Дух Террастриума",
            double = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}1-2 {{CR}}Духа Террастриума",
            triple = "{{SpiritOrb}} При уничтожении отмеченных камней с вероятностью 75% выпадут {{ColorGold}}2-3 {{CR}}Духа Террастриума",
        },
        pl = {
            name = "Odłamek Bursztynu",
            description = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie Widma Podziemi po zniszczeniu",
            double = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}1-2 {{CR}}Widma Podziemi po zniszczeniu",
            triple = "{{SpiritOrb}} Oznaczone skały mają 75% szans na upuszczenie {{ColorGold}}2-3 {{CR}}Widma Podziemi po zniszczeniu",
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
            name = "Дух Друидизма",
            description = "Захватывает всех врагов в комнате лозами на 12 секунд. Попавшие в ловушку враги после смерти оставляют фруктовое сердце" ..
            "#{{BlendedHeart}} Фруктовые сердца исцеляют половину красного сердца или половину сердца души, если сердца заполнены",
            lyra_extra = "#{{ColorGray}}" .. LyraIcon .. " Удваивает количество фруктовых сердец"
        },
        pl = {
            name = "Widmo Przyrody",
            description = "Liany unieruchamiają wszystkich przeciwników w pokoju na 12 sekund. Splątani przeciwnicy upuszcają owocowe serduszka po śmierci" ..
            "#{{BlendedHeart}} Owocowe serduszka leczą pół czerwonego serca albo pół serca dusz jeżeli czerwone zdrowie jest już pełne",
            lyra_extra = "#{{ColorGray}}" .. LyraIcon .. " Podwaja ilość upuszczanych owocowych serduszek"
        },
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
         en_us = {
            name = "Дух Электропотока", -- я не буду переводить это как Дух Электропроводки XD
            description = "Выпускает волну электричества во всех направлениях, нанося урон ближайшим врагам" ..
            "#{{ArcadeRoom}} Замыкает все автоматы в радиусе, в результате чего они выбрасывают награды несколько раз и взрываются",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Удваивает продолжительность и дальность действия электричества"
        },
        pl = {
            name = "Widmo Elektryczności",
            description = "Wypuszcza fale elektryczności we wszystkie strony, raniąc pobliskich przeciwników" ..
            "#{{ArcadeRoom}} Wywołuje zwarcie w trafionych maszynach, co uruchamia je kilkakrotnie a następnie niszczy je",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Podwaja zasięg i czas trwania elektryczności"
        },
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
            name = "Дух Инферно",
            description = "{{Burning}} Выпускает поток пламени с высоким уроном в выбранном направлении" ..
            "#{{BossRoom}} Пронзает броню босса",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Удваивает выстрел пламенем"
        },
        pl = {
            name = "Widmo Pożogi",
            description = "{{Burning}} Strzela strumieniem potężnych płomieni w wybranym kierunku" ..
            "#{{BossRoom}} Ignoruję redukcję obrażeń bossów",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Sztrzela dwa razy więcej płomieni"
        },
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
            name = "Дух Ясновидения",
            description = "{{Timer}} Дает ауру на 100 секунд, которая замедляет врагов и отражает снаряды",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Удваивает продолжительность и ускоряет отражание снарядов"
        },
        pl = {
            name = "Widmo Jasnowidzenia",
            description = "{{Timer}} Tworzy aurę, która spowalnia przeciwników i odbija pociski przez 100 sekund",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Podwaja czas trwania i przyspiesza odbijanie"
        },
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
            name = "Дух Возврата",
            description = "Призывает 4-6 надгробии по комнате, при уничтожении которых появляются дружелюбные скелеты или призраки" ..
            "#Заполняет все ямы в комнате костями",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Удваивает число надгробий"
        },
        pl = {
            name = "Widmo Zaświatów",
            description = "Przywołuje 4-6 nagrobków w pokoju, które tworzą przyjazne szkielety i duchy po zniszczeniu" ..
            "#Zapełnia dziury w pokoju kościami",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Podwaja ilość przywołanych nagrobków"
        },
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
            name = "Дух Ядовитости",
            description = "{{Throwable}} Бросает токсичный шар, который взрывается, образуя разрушительное ядовитое облако" ..
            "#{{Slow}} Враги внутри будут замедляться и получать урон" ..
            "#Облако увеличивается в размерах пропорционально нанесенному урону" ..
            "#{{RottenHeart}} Превращает сердца и попрашаек в их гнилые варианты {{RottenBeggar}}",
            lyra_extra = "#{{ColorGray}}" .. LyraIcon .. " Удваивает размер облака"
        },
        pl = {
            name = "Widmo Skażenia",
            description = "{{Throwable}} Rzucza toksyczną kulą, która wybucha w raniącą chmurę toksyn" ..
            "#{{Slow}} Wrogowie wewnątrz chmury są spowolnieni i otrzymują stałe obrażenia" ..
            "#Chmura rośnie wraz z zadawanymi obrażeniami" ..
            "#{{RottenHeart}} Zamienia upuszczone serca i żebraków w ich zgniłe wersje {{RottenBeggar}}",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Podwaja rozmiar chmury"
        },
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
            name = "Дух Спасения",
            description = "#Выпускает 8 разрушительных лучей света во всех направлениях" ..
            "#Лучи могут разрушать камни и открывать секретные комнаты",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Выпускает 16 лучей"
        },
        pl = {
            name = "Widmo Zbawienia",
            description = "#Wystrzeliwuje 8 promieni światła we wszystkie kierunki" ..
            "#Promienie niszczą kamienie i otwierają przejścia do sekretnych pokoji",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Wystrzeliwuje 16 promieni"
        },
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
            name = "Дух Святотатства",
            description = "#{{BleedingOut}} Прорезает всех врагов и попрашаек в комнате, накладывая на них кровотечение и проклятие серы"..
            "#Убитые попрашайки бросают дополнительные расходники",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Slashes through enemies a second time"
        },
        pl = {
            name = "Widmo Świętokradztwa",
            description = "#{{BleedingOut}} Ścina wszystkich przeciwników i żebraków w pokoju, co nakłada krwawienie i zwiększa obrażenia zadawane piekelnymi laserami" ..
            "#Zabici żebracy upuszczają więcej pickupów",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. "Ścina przeciwników drugi raz"
        },
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
            name = "Дух Потопа",
            description = "#{{Timer}} На 8 секунд заменяет слезы Исаака управляемым водопадом-циклоном, засасывающим врагов и предметы",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Удваивает продолжительность"
        },
        pl = {
            name = "Widmo Potopu",
            description = "#{{Timer}} Przez 8 sekund, łzy Izaaka są zastąpione kontrolowanym strumieniem wody, który przyciąga przeciwników i pickupy",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Podwaja czas trwania"
        },
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
            name = "Дух Террастриума",
            description = "#Призывает 4-5 каменных сталагмитов которые пронзают врагов и пробивают металлические блоки",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Призывает 8-10 сталагмитов"
        },
        pl = {
            name = "Widmo Podziemi",
            description = "#Przywołuje 4-5 kammiennych stalagmitów, które przebijają przeciwników i niszczą metalowe blocki",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Przywołuje 8-10 stalagmitów"
        },
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
            name = "Дух Хаоса",
            description = "#Исползует случайную сферу духов",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Удваивает выбранный эффект"
        },
        pl = {
            name = "Widmo Chaosu",
            description = "#Wywołuje efekt losowej kuli dusz",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " Podwaja wywołany efekt"
        },
    },
    [enums.Cards.TATTERED_PAGE] = {
        en_us = {
            name = "Tattered Page",
            description = "#Summons a random {{Collectible712}} Lemegeton wisp"
        },
        spa = {
            name = "Tattered Page",
            description = "#Summons a random {{Collectible712}} Lemegeton wisp"
        },
        ru = {
            name = "Рваная Страница",
            description = "#{{Collectible712}}Призывает случайный предметный огонёк"
        },
        pl = {
            name = "Porwana Strona",
            description = "#Przywołuje losowego ognika z {{Collectible712}} Lemegetonu"
        },
    }
}

--ENTITY DESCRIPTIONS
local BRENDA = EntityType.ENTITY_SLOT .. "." .. MilkshakeVol1.enums.Slots.SPIRIT_KLIN_BRENDA

descriptions.Entities = {
    [BRENDA] = {
        en_us = {
            name = "Spirit Kiln", -- Kiln
            description = "{{HalfSoulHeart}}Takes half a soul heart in exchange for various rewards:" ..
            "#{{SpiritOrb}} A random Spirit Orb" ..
            "#{{Burning}} A random elemental wisp" ..
            "#{{Trinket}} A random glass or gem trinket" ..
            "#{{Rune}} A random soul stone"
        },
        spa = {
            name = "Brenda la Forja Espiritual",
            description = "zorra"
        },
        pl = {
            name = "Kuźnia Dusz",
            description = "{{HalfSoulHeart}}Zabiera pół serca dusz w zamian za rozmaite nagrody:" ..
            "#{{SpiritOrb}} Losowa widmowa kula" ..
            "#{{Burning}} Ognik o losowym żywiole" ..
            "#{{Trinket}} Losowy szklany lub kryształowy trynkiet" ..
            "#{{Rune}} Dusza losowej postaci"
        },
        ru = {
            name = "Духовка", -- joke real translation is Духовая печька Бренда
            description = "{{HalfSoulHeart}}Отнимает половинку сердца души взамен различным наградам:" ..
            "#{{SpiritOrb}} Случайная сфера духов" ..
            "#{{Burning}} Случайный элементальный огонёк" ..
            "#{{Trinket}} Случайная стеклянная или драгоценная безделушка" ..
            "#{{Rune}} Случайный камень души"
        },
    }
}

return descriptions