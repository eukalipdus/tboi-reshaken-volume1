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
        -Korean: "ko_kr"

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
        ko_kr = {
            name = "밀크쉐이크",
            description = "{{UnknownHeart}} 최대 체력, 소울하트, 블랙하트 중 하나 +1" ..
            "#{{ArrowUp}} {{SpeedSmall}}이동속도 배율 x1.1~1.5" ..
            "#{{ArrowUp}} {{TearsSmall}}공격 딜레이 ÷1.1~1.5" ..
            "#{{ArrowUp}} {{DamageSmall}}공격력 배율 x1.1~1.5" ..
            "#{{ArrowUp}} {{RangeSmall}}사거리 배율 x1.1~1.5" ..
            "#{{ArrowUp}} {{ShotspeedSmall}}탄속 배율 x1.1~1.5" ..
            "#{{ArrowUp}} {{LuckSmall}}행운 배율 x1.1~1.5",
            abyss = "공격력 x2의 피해를 주며 빠르게 돌진합니다."
        },
    },
    [enums.Collectibles.SHARP_CURSOR] = {
        en_us = {
            name = "Sharp Cursor",
            description = "#Targets the furthest enemy in the room" ..
            "#{{Damage}} Pressing a shooting key makes it click, dealing 10% of Isaac's damage" ..
            "#{{Warning}} {{ButtonRT}}Double press ctrl to toggle mouse control mode",
        },
        spa = {
            name = "Cursor Afilado",
            description = "#Apunta al enemigo más lejano en la habitación" ..
            "#{{Damage}} Presionar una tecla de disparo lo hace hacer clic, causando un 10% del daño de Isaac" ..
            "#{{Warning}} {{ButtonRT}} dos veces Ctrl para alternar el modo de control de ratón",
        },
        ru = {
            name = "Острый Курсор",
            description = "#Нацеливается на самого дальнего врага в комнате" ..
            "#{{Damage}} При нажатии клавиш стрельбы, она щелкает, нанося 10% урона Исаака" ..
            "#{{Warning}} {{ButtonRT}}Дважды нажмите Ctrl, чтобы переключить режим управления на мышку",
        },
        pl = {
            name = "Ostry Kursor",
            description = "#Atakuje najbardziej oddalonego przeciwnika w pokoju" ..
            "#{{Damage}} Klika po wciśnięciu dowolnego przycisku ataku, zadając 10% twoich obrażeń" ..
            "#{{Warning}} {{ButtonRT}}Wciśnij dwukrotnie przycisk upuszczania, aby przełączyć tryb kontroli myszką",
        },
        ko_kr = {
            name = "뾰족한 커서",
            description = "#캐릭터에서 가장 먼 적을 타겟팅하며;" ..
            "#{{Damage}} 공격키(자동) 혹은 클릭(수동) 시 그 적에게 공격력 x0.1의 피해를 줍니다." ..
            "#{{Warning}} {{ButtonRT}}교체 버튼을 2번 눌러 자동/수동(마우스) 모드 전환",
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
            name = "Черный Глаз",
            description = "{{Blank}}{{ArrowUp}} +0,7 скорострельности и отбрасывания только для правого глаза #В настоящее время не используется и не закодировано, возможно, появится позже (вероятно, не появится)",
        },
        ko_kr = {
            name = "검은 눈",
            description = "!!! 오른쪽 눈에만 적용:#{{ArrowUp}} {{TearsSmall}}연사 +0.7#공격이 적을 더 강하게 밀쳐냅니다.",
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
        ko_kr = {
            name = "주사위 주사위",
            description = "사용 시 랜덤한 주사위방 효과를 발동합니다.",
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
            description = "{{Burning}} Posibilidad de disparar semillas que se pegan a los enemigos" ..
            "#Después de 4 segundos, las semillas florecen y explotan, disparando lágrimas pétalo, haciendo 35 + 6 x el daño de Isaac",
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
        ko_kr = {
            name = "폭탄 플라워",
            description = "{{Burning}} 30%의 확률로 적에게 달라붙는 씨앗 공격이 나갑니다." ..
            "#{{LuckSmall}} 행운 20+ 이상일 때 50% 확률" ..
            "#적에게 달라붙은 씨앗은 4초 후 공격력 x6 +35의 폭발 피해를 줍니다. (자해 없음)",
            abyss = "공격한 적에게 10%의 확률로 {{Burning}}폭발성 씨앗을 심습니다."
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
            name = "Глобин в Ведре",
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
        ko_kr = {
            name = "글로빈 양동이",
            description = "사용 시 아군 Globin을 소환합니다." ..
            "#스테이지에 따라서 확률적으로 소환되는 Globin의 종류가 달라집니다." ..
            "#{{Blank}} (최대 4마리)",
            book_of_virtues = "{{ColorYellow}}중앙 x1{{CR}}/{{Heart}}:3#일반 눈물을 발사합니다. ({{DamageSmall}}:3)#불꽃이 꺼지면 50%의 확률로 다시 켜집니다."
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
            name = "Золотая Зопата",
            description = "Выкапывает 1-2 золотых сундука и случайный золотой предмет" ..
            "#{{LadderRoom}} Создаёт люк к магазину членской карты, если использовано на клетке пола с декорацией (трава, маленькие камешки, бумажки, и т.д.)",
            book_of_virtues = "Огонёк среднего кольца#Огонёк с высоким здоровьем#10% шанс выстрелить слезы с эффектом {{Collectible202}} Прикосновения Мидаса"
        },
        pl = {
            name = "Złota Łopata",
            description = "Wykopuje 1-2 złote skrzynie oraz losowy złoty pickup" ..
            "#{{LadderRoom}} Po użyciu nad dekoracją podłogi otwiera sklep Karty Członkowskiej",
        },
        ko_kr = {
            name = "황금 삽",
            description = "사용 시 {{GoldenChest}}황금상자 1~2개와 랜덤 황금 픽업을 파냅니다." ..
            "#{{Collectible602}} 치장성 타일(풀, 돌 조각 등) 위에 사용 시 비밀 상점으로 가는 다락문을 생성합니다.",
            book_of_virtues = "{{ColorYellow}}중앙 x1{{CR}}/{{Heart}}:4#{{Collectible202}}10%의 확률로 황금화 눈물을 발사합니다. ({{DamageSmall}}:3)"
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
        ko_kr = {
            name = "라 찬클라",
            description = "↑ {{SpeedSmall}}이동속도 +0.3" ..
            "#{{MomBossSmall}} 발 공격에 피해를 받지 않습니다.",
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
        ko_kr = {
            name = "거문고자리",
            description = "{{SpiritOrb}} 방 클리어 시 15%의 확률로 스피릿을 드랍합니다." ..
            "#{{SpiritOrb}} 상자, 색돌, 슬롯머신 파괴 시 확률적으로 스피릿을 추가로 드랍합니다." ..
            "#{{SpiritOrb}} 스피릿 사용 시 미니 리듬게임을 진행하며 성공 시 스피릿 효과를 2배로 발동합니다.",
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
            name = "Пустая Ячейка",
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
        ko_kr = {
            name = "빈 슬롯머신",
            description = "{{Coin}} 사용 시 동전 1개를 소모합니다." ..
            "#10{{Coin}} 소모 후, 사용할 때마다 1%의 확률로 아이템이 사라지며 소모한 {{Coin}}의 2배만큼의 동전을 드랍합니다." ..
            "#{{Blank}} (100{{Coin}}에서 확정)",
            book_of_virtues = "{{ColorLime}}내부 x1{{CR}}/{{Heart}}:1#(눈물 발사 불가)",
            book_of_belial = "↑ 소지 중일 때 소모한 {{Coin}}만큼 {{Damage}}공격력 +0.066"
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
            name = "Расколотая Сфера",
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
        ko_kr = {
            name = "연약한 오브",
            description = "사용 시 공격하는 방향으로 오브를 던집니다." ..
            "#{{SpiritOrb}} 오브에 맞은 적은 포획되며 스피릿 오브로 변합니다.",
            book_of_virtues = "포획 실패 시 랜덤 전용 불꽃을 3개 소환합니다.",
            book_of_belial = "{{SpiritOrb}} Spirit of Chaos를 50%의 확률로 Spirit of Sacrilege로 교체합니다."
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
            name = "Призматический Кубик",
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
        ko_kr = {
            name = "프리즘 주사위",
            description = "사용 시 그 방의 아이템을 등급이 낮은 아이템 2개로 바꿉니다." ..
            "#{{Quality0}}등급 아이템의 경우 픽업으로 분해됩니다.",
            book_of_virtues = "{{ColorYellow}}중앙 x1{{CR}}/{{Heart}}:2#(눈물 발사 불가)#{{Collectible528}}공격이 통과하면 4갈래로 갈라져 나갑니다.",
            book_of_belial = "분해된 아이템이 30%의 확률로 {{DevilRoom}}악마방 아이템으로 바뀝니다."
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
        ko_kr = {
            name = "영혼 거지",
            description = "{{SoulHeart}} 주변의 소울하트를 먹으며" ..
            "#{{SpiritOrb}} 2개의 소울하트를 먹으면 스피릿을 드랍합니다.",
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
            description = "Отражает движения Исаака" ..
            "#Наносит 75 урона в секунду" ..
            "#\1  {{MirrorRoom}} +2,5 Урона в зеркальном мире",
        },
        pl = {
            name = "Gwieździste Lustro",
            description = "Odzwierciedla twoje ruchy" ..
            "#Zadaje 75 obrażeń na sekunde" ..
            "#\1 {{MirrorRoom}} Daje +2.5 Obrażeń w lustrzanym wymiarze",
        },
        ko_kr = {
            name = "천계의 거울",
            description = "캐릭터의 반대편에 있으며 접촉한 적에게 초당 75의 피해를 줍니다." ..
            "#↑ {{MirrorRoom}}거울세계에서 {{DamageSmall}}공격력 +2.5",
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
            name = "Серповидная Клетка",
            description = "Слезы пронзают врагов насквозь" ..
            "#{{BleedingOut}} Слезы вызывают кровотечение, которое заставляет врагов оставлять кровавый след и получать урон при движении",
            abyss = "Красная саранча, вызывающая {{BleedingOut}} кровотечение"
        },
        pl = {
            name = "Sierpowata Krwinka",
            description = "Przebijające łzy" ..
            "#{{BleedingOut}} Łzy wywołują krwawienie. Krwawiący przeciwnicy zostawiaja za sobą plamy krwi i otrzymują obrażenia przy poruszaniu się",
            abyss = "Czerwona szarańcza, która wywołuje {{BleedingOut}} krwotok"
        },
        ko_kr = {
            name = "낫 적혈구",
            description = "{{BleedingOut}} 공격이 적을 관통하며 출혈 상태로 만듭니다." ..
            "#{{BleedingOut}} 출혈 상태의 적 밑에 장판이 깔리며 다른 적도 장판에 피해를 받습니다.",
            abyss = "공격한 적을 {{BleedingOut}}출혈 상태로 만듭니다."
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
            name = "Испорченный Завтрак",
            description = "\1 +1 Здоровье" ..
            "#{{EmptyHeart}} Удаляет половину сердца",
        },
        pl = {
            name = "Przegniłe Śniadanie",
            description = "\1 +1 do Maksymalnego Zdrowia" ..
            "#{{EmptyHeart}} Usuwa pół serduszka",
        },
        ko_kr = {
            name = "엎질러진 아침밥",
            --description = "↑ {{HalfHeart}}빈 최대 체력 {{ColorOrange}}+0.5{{CR}}",
            description = "↑ {{HalfHeart}}반칸 채워진 최대 체력 +1",
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
            name = "Сбалансированный Завтрак",
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
        ko_kr = {
            name = "평범한 아침밥",
            description = "↑ {{HalfHeart}}최대 체력 +1"..
            --"#↑ {{HalfHeart}}빨간하트 +1" .. --Commented this as I'm not sure about for extra red heart heal like vanilla items
            "#↑ {{SoulHeart}}소울하트 +1" ..
            "#↑ {{LuckSmall}}행운 +1",
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
            name = "Сытный Завтрак",
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
        ko_kr = {
            name = "풍부한 아침밥",
            description = "↑ {{HalfHeart}}최대 체력 +1"..
            "#{{Heart}} 체력을 모두 회복합니다." ..
            "#↑ {{TearsSmall}}연사 +0.3" ..
            "#↑ {{DamageSmall}}공격력 +0.5" ..
            "#↑ {{LuckSmall}}행운 +1",
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
            name = "Горшок Золота",
            description = "Преобразует все бомбы, ключи и большинство монет в радужные монеты" ..
            "#{{Trinket52}} Радужные монеты активируют эффект соответствующих им безделушек",
        },
        pl = {
            name = "Kociołek Złota",
            description = "Zamienia bomby, klucze i większość monet w tęczowe monety" ..
            "#{{Trinket52}} Tęczowe monety aktywują efekt wybranego trynkieta Pieniążka po podniesieniu",
        },
        ko_kr = {
            name = "황금의 항아리",
            description = "!!! 모든 {{Bomb}}/{{Key}}/{{Coin}} 픽업을 레인보우 코인으로 바꿉니다." ..
            "#{{Trinket52}} 레인보우 코인을 주으면 각 색상별 페니류 장신구 효과를 발동합니다.",
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
            name = "Стеклянный Идол",
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
        ko_kr = {
            name = "유리 트로피",
            description = "↑ 트로피가 있을 때 목숨 +1" ..
            "#사망 시 트로피를 소모하여 그 방에서 보호막과 함께 부활합니다. (1{{SoulHeart}}, {{Collectible58}})" ..
            "#탄환을 3회 막으면 트로피가 깨지며;" ..
            "#↓ 깨진 경우 {{LuckSmall}}행운 -1, 스테이지 진입 시 복원됩니다.",
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
        ko_kr = {
            name = "레위기",
            description = "!!! 방 클리어로 충전 불가, {{SoulHeart}}로만 충전 가능" ..
            "#{{EternalHeart}} 사용 시 이터널하트 +1" ..
            "#{{AngelRoom}} {{BossRoom}}보스방 클리어 이전에 사용 시 보스방의 아이템이 천사방 아이템으로 바뀝니다." ..
            "#!!! 악마방 거래 시 동전 구매 필요",
            book_of_virtues = "{{ColorLime}}내부 x1{{CR}}/{{Heart}}:8#일반 눈물을 발사합니다. ({{DamageSmall}}:3/{{TearsSmall}}:↓)#불꽃 당 {{AngelChanceSmall}}천사방 확률 +10%",
            abyss = "적과 접촉 시 공격력 3배의 빛줄기를 떨어뜨립니다.",
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
            description = "{{Battery}} Duplica la velocidad de carga de los activos" ..
            "#\2 Agota una carga cada 15 segundos" ..
            "#Isaac deja un rastro de creep ácido"
        },
        ru = {
            name = "Батарейная Кислота",
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
        ko_kr = {
            name = "배터리 누수액",
            description = "{{Battery}} 액티브 아이템의 충전량 2배" ..
            "#↓ 15초마다 액티브 아이템의 충전량이 1칸씩 깎입니다." ..
            "#캐릭터가 지나간 자리에 주기적으로 노란 장판이 생기며 닿은 적은 초당 15의 피해를 입습니다."
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
            name = "Собачья Сумка",
            description = "При получении урона появляется случайная какашка" ..
            "#Исаак может подбирать какашки, проходя по ним",
        },
        pl = {
            name = "Psi Worek",
            description = "Otrzymywanie obrażeń tworzy losową kupę" ..
            "#Izaak możę podnosić kup podchodząc do nich",
        },
        ko_kr = {
            name = "강아지 똥",
            description = "{{PoopPickup}} 피격 시 봉투에 든 똥을 싸며 캐릭터가 싼 똥을 집어 던질 수 있습니다. " ..
            "#봉투의 똥은 방 입장 시 리필됩니다.",
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
            name = "Папина Бейсбольная Перчатка",
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
        ko_kr = {
            name = "아빠의 야구글러브",
            description = "↑ {{TearsSmall}}연사 배율 x1.1" ..
            "#↓ {{ShotspeedSmall}}탄속 -0.2" ..
            "#눈물의 방향이 캐릭터의 이동방향의 영향을 받습니다.",
            abyss = "파리가 날아갈 때 캐릭터의 이동방향의 영향을 받습니다.",
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
        ko_kr = {
            name = "리틀 비숍",
            description = "적의 탄환을 막아주며;" ..
            "#20%의 확률로 5초동안 캐릭터의 피격을 막아줍니다.",
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
            name = "Радужный Фрагмент",
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
        ko_kr = {
            name = "무지개 조각",
            description = "↑ {{LuckSmall}}행운 +1" ..
            "#레인보우 코인 4개를 드랍합니다." ..
            "#{{Trinket52}} 레인보우 코인을 주으면 각 색상별 페니류 장신구 효과를 발동합니다.",
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
            name = "Маска Знахаря",
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
        ko_kr = {
            name = "사제 마스크",
            description = "{{Pill}} 알약을 1개 드랍합니다." ..
            "#모든 알약이 스피릿 알약으로 바뀝니다." ..
            "#{{SpiritOrb}} 스피릿 알약 사용 시 기존 알약 효과에 색상에 따른 스피릿을 추가로 발동합니다.",
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
            name = "Зеркальный Ключ",
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
        ko_kr = {
            name = "거울 열쇠",
            description = "{{MirrorRoom}} 문 테두리 근처에서 사용 시 사용한 방과 같은 구조를 가진 거울방이 생성됩니다.(방 당 1회)" ..
            "#{{Warning}} 아이템은 생성되지 않습니다." ..
            "#{{BossRoom}} 보스방의 경우 다시 클리어할 수 있으며 보상을 추가로 드랍합니다.",
            book_of_belial = "↑ 거울방 안에서 {{DamageSmall}}공격력 +2.5",
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
            name = "Зеркальный Ключ (Незаряженный)",
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
        ko_kr = {
            name = "거울 열쇠",
            description = "{{MirrorRoom}} 문 테두리 근처에서 사용 시 사용한 방과 같은 구조를 가진 거울방이 생성됩니다.(이 방에서 이미 사용됨)" ..
            "#{{Warning}} 아이템은 생성되지 않습니다." ..
            "#{{BossRoom}} 보스방의 경우 다시 클리어할 수 있으며 보상을 추가로 드랍합니다.",
            book_of_belial = "↑ 거울방 안에서 {{DamageSmall}}공격력 +2.5",
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
            description = "{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño",
            double = "{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño #{{ColorGold}}Hace el doble de daño",
            triple = "{{ArrowDown}} Otorga -0.2 de velocidad #Soltarlo crea una gran onda de choque que hace un gran daño #{{ColorGold}}Hace el triple de daño",
        },
        ru = {
            name = "Вольфрамовый Куб",
            description = "{{ArrowDown}} -0.2 Скорости #При падение создаст огромную разрушительную ударную волну",
            double = "{{ArrowDown}} -0.2 Скорости #При падение создаст огромную разрушительную ударную волну #{{ColorGold}}Наносит двойной урон",
            triple = "{{ArrowDown}} -0.2 Скорости #При падение создаст огромную разрушительную ударную волну #{{ColorGold}}Наносит тройной урон",
        },
        pl = {
            name = "Wolframowy Kloc",
            description = "{{ArrowDown}} -0.2 Prędkości. #Tworzy falę uderzeniową po upuszczeniu",
        },
        ko_kr = {
            name = "텅스텐 큐브",
            description = "{{ArrowDown}} {{SpeedSmall}}이동속도 -0.2 #버리기 및 교체 시 주변의 적에게 피해를 주는 원형 지진파를 발산합니다.",
            double = "{{ArrowDown}} {{SpeedSmall}}이동속도 -0.2 #버리기 및 교체 시 주변의 적에게 피해를 주는 원형 지진파를 발산합니다.#{{ColorGold}}피해량 2배",
            triple = "{{ArrowDown}} {{SpeedSmall}}이동속도 -0.2 #버리기 및 교체 시 주변의 적에게 피해를 주는 원형 지진파를 발산합니다.#{{ColorGold}}피해량 3배",
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
            name = "Кислотная Монета",
            description = "{{Blank}}{{ArrowDown}} При подборе монет с вероятностью 8% появится пилюля",
        },
        pl = {
            name = "Kwaśny Pieniążek",
            description = "{{Pill11}} Podnoszenie monety ma 8% szans na stworzenie pigułki",
        },
        ko_kr = {
            name = "산성 동전",
            description = "{{Pill11}} 동전 획득 시 8%의 확률로 알약을 드랍합니다.",
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
            name = "Хрустальная Монета",
            description = "{{Card}} При подборе монет с вероятностью 8% появится карта",
        },
        pl = {
            name = "Kryształowy Pieniążek",
            description = "{{Pill11}} Podnoszenie monety ma 8% szans na stworzenie karty",
        },
        ko_kr = {
            name = "크리스탈 동전",
            description = "{{Card}} 동전 획득 시 8%의 확률로 카드를 드랍합니다.",
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
        ko_kr = {
            name = "굴레바퀴",
            description = "Stoney 및 grimace류 적이 다른 적을 공격합니다.",
        },
    },
    [enums.Trinkets.AMETHYST_SHARD] = {
        en_us = {
            name = "Clairvoyant Amethyst",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Clairvoyance when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Clairvoyance when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Clairvoyance when destroyed",
        },
        spa = {
            name = "Amatista Premonitoria",
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
        ko_kr = {
            name = "예지의 자수정",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Clairvoyance를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Clairvoyance를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Clairvoyance를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.RUBY_SHARD] = {
        en_us = {
            name = "Infernal Ruby",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Inferno when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Inferno when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Inferno when destroyed",
        },
        spa = {
            name = "Rubí Infernal",
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
        ko_kr = {
            name = "지옥의 루비",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Inferno를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Inferno를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Inferno를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.TOURMALINE_SHARD] = {
        en_us = {
            name = "Conductive Tourmaline",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Conductivity when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Conductivity when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Conductivity when destroyed",
        },
        spa = {
            name = "Turmalina Conductora",
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
        ko_kr = {
            name = "전도의 전기석",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Conductivity를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Conductivity를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Conductivity를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.EMERALD_SHARD] = {
        en_us = {
            name = "Druidic Emerald",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Druidity when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Druidity when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Druidity when destroyed",
        },
        spa = {
            name = "Esmeralda Druídica",
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
        ko_kr = {
            name = "드루이드 에메랄드",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Druidity를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Druidity를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Druidity를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.PERIDOT_SHARD] = {
        en_us = {
            name = "Virulent Peridot",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Virulence when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Virulence when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Virulence when destroyed",
        },
        spa = {
            name = "Peridoto Virulento",
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
        ko_kr = {
            name = "맹독의 페리도트",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Virulence를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Virulence를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Virulence를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.GARNET_SHARD] = {
        en_us = {
            name = "Sacrilegious Garnet",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Sacrilege when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Sacrilege when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Sacrilege when destroyed",
        },
        spa = {
            name = "Granate Sacrílego",
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
        ko_kr = {
            name = "천벌의 가넷",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Sacrilege를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Sacrilege를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Sacrilege를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.ONYX_SHARD] = {
        en_us = {
            name = "Revenant Onyx",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Revenance when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Revenance when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Revenance when destroyed",
        },
        spa = {
            name = "Ónix Renacido",
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
        ko_kr = {
            name = "망령의 오닉스",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Revenance를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Revenance를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Revenance를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.DIAMOND_SHARD] = {
        en_us = {
            name = "Sacred Jacinth",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Salvation when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Salvation when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Salvation when destroyed",
        },
        spa = {
            name = "Jacinto Sagrado",
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
        ko_kr = {
            name = "신성의 금강석",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Salvation을 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Salvation을 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Salvation을 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.SAPPHIRE_SHARD] = {
        en_us = {
            name = "Torrential Sapphire",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Deluge when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Deluge when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Deluge when destroyed",
        },
        spa = {
            name = "Zafiro Torrencial",
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
        ko_kr = {
            name = "흐름의 사파이어",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Deluge를 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Deluge를 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Deluge를 추가로 드랍합니다.",
        },
    },
    [enums.Trinkets.AMBER_SHARD] = {
        en_us = {
            name = "Terrestrial Amber",
            description = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop a Spirit of Terrastrium when destroyed",
            double = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}1-2 {{CR}}Spirits of Terrastrium when destroyed",
            triple = "{{SpiritOrb}} Tinted rocks have a 75% chance to drop {{ColorGold}}2-3 {{CR}}Spirits of Terrastrium when destroyed",
        },
        spa = {
            name = "Ámbar Terrestre",
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
        ko_kr = {
            name = "땅의 호박",
            description = "{{SpiritOrb}} 색돌이 75%의 확률로 Spirit of Terrastrium을 추가로 드랍합니다.",
            double = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}1-2{{CR}}개의 Spirit of Terrastrium을 추가로 드랍합니다.",
            triple = "{{SpiritOrb}} 색돌이 75%의 확률로 {{ColorGold}}2-3{{CR}}개의 Spirit of Terrastrium을 추가로 드랍합니다.",
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
        ko_kr = {
            name = "드루이드의 스피릿",
            description = "그 방의 적을 12초동안 속박하며 속박한 적 처치 시 0.5초 뒤 사라지는 과일을 드랍합니다." ..
            "#{{BlendedHeart}} 과일 획득 시 빨간하트 및 소울하트 반칸을 회복합니다.",
            lyra_extra = "#{{ColorGray}}" .. LyraIcon .. " 과일 드랍량 2배"
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
        ru = {
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
        ko_kr = {
            name = "전도의 스피릿",
            description = "캐릭터 주변의 적에게 3의 지속 피해를 주는 전류 발산합니다." ..
            "#{{ArcadeRoom}} 주변의 슬롯머신 보상을 여러번 드랍하며 폭파시킵니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 전류 발산 지속시간 및 거리 2배"
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
        ko_kr = {
            name = "지옥의 스피릿",
            description = "{{Burning}} 공격방향으로 적에게 5의 방어 무시 피해를 주는 불꽃을 여러 발 발사합니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 불꽃 발사 수 2배"
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
        ko_kr = {
            name = "예지의 스피릿",
            description = "{{Timer}} 그 방에서 100초동안 주변의 적을 느리게 하거나 동시에 1개의 탄환을 반사하는 오라를 발동합니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 오라 지속시간 2배 + 탄환 반사 속도 증가"
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
        ko_kr = {
            name = "망령의 스피릿",
            description = "파괴 시 아군 Bony 및 유령을 소환하는 묘비를 4~6개 생성합니다." ..
            "#그 방의 구덩이를 전부 메웁니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 묘비 생성 수 2배"
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
        ko_kr = {
            name = "맹독의 스피릿",
            description = "{{Throwable}} 공격방향으로 독가스를 남기는 독성 구체를 던집니다." ..
            "#{{Slow}} 독가스 주변의 적은 지속 둔화 피해를 받으며;" ..
            "#독가스가 피해를 준만큼 범위가 더 커집니다." ..
            "#{{RottenHeart}} 독가스에 있는 빨간하트 및 거지를 썩게 만듭니다. {{RottenBeggar}}",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 독가스 범위 2배"
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
        ko_kr = {
            name = "신성의 스피릿",
            description = "#8방향으로 적에게 최대 87의 피해를 주는 빔을 발사합니다." ..
            "#빔이 장애물 파괴 및 비밀방 문을 열수 있습니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 빔을 16방향으로 발사"
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
        ko_kr = {
            name = "천벌의 스피릿",
            description = "#{{BleedingOut}} 그 방의 적에게 5의 출혈+유황 피해를 주며;" ..
            "#그 방의 거지를 즉사, 더 많은 픽업을 드랍합니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 적에게 주는 피해량 2배"
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
        ko_kr = {
            name = "흐름의 스피릿",
            description = "#{{Timer}} 8초동안 적 및 픽업을 끌어들이는 물의 레이저를 발동 및 조종합니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 레이저 발동 시간 2배"
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
        ko_kr = {
            name = "땅의 스피릿",
            description = "#그 방에서 적을 즉사 및 강철 블록을 파괴하는 종유석을 4~5개 소환합니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 소환 종유석이 8~10개로 증가"
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
        ko_kr = {
            name = "혼돈의 스피릿",
            description = "#사용 시 랜덤 스피릿 효과를 발동합니다.",
            lyra_extra = "#{{ColorGray}}" ..LyraIcon.. " 발동 효과 2배"
        },
    },
    [enums.Cards.TATTERED_PAGE] = {
        en_us = {
            name = "Tattered Page",
            description = "#Summons a random {{Collectible712}} Lemegeton wisp"
        },
        spa = {
            name = "Página Rota",
            description = "#Genera un fuego fatuo de {{Collectible712}} Lemegeton aleatorio",
        },
        ru = {
            name = "Рваная Страница",
            description = "#{{Collectible712}}Призывает случайный предметный огонёк"
        },
        pl = {
            name = "Porwana Strona",
            description = "#Przywołuje losowego ognika z {{Collectible712}} Lemegetonu"
        },
        ko_kr = {
            name = "낡은 페이지",
            description = "{{Collectible712}} 사용 시 랜덤 Lemegeton 아이템 불꽃을 소환합니다."
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
            description = "{{HalfSoulHeart}}Paga medio corazón de alma para conseguir recompensas:" ..
            "#{{SpiritOrb}} Un orbe espiritual aleatorio" ..
            "#{{Burning}} Un fuego fatuo elemental aleatorio" ..
            "#{{Trinket}} Una baratija de cristal o de gema aleatoria" ..
            "#{{Rune}} Una piedra de alma aleatoria"
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
            name = "Духовка", -- joke, real translation is Духовая печька Бренда
            description = "{{HalfSoulHeart}}Отнимает половинку сердца души взамен различным наградам:" ..
            "#{{SpiritOrb}} Случайная сфера духов" ..
            "#{{Burning}} Случайный элементальный огонёк" ..
            "#{{Trinket}} Случайная стеклянная или драгоценная безделушка" ..
            "#{{Rune}} Случайный камень души"
        },
        ko_kr = {
            name = "영혼 가마", -- Kiln
            description = "{{HalfSoulHeart}} 소울하트 반칸을 소모하여 아래 중 하나를 드랍:" ..
            "#{{SpiritOrb}} 스피릿" ..
            "#{{Burning}} 원소 불꽃" ..
            "#{{Trinket}} 보석류 장신구" ..
            "#{{Rune}} 영혼석"
        },
    }
}

return descriptions
