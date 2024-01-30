if not EID then return end

local enums = MilkshakeVol1.enums
local descriptions = include("milkshake_scripts.modcompatibility.descriptions")

EID:setModIndicatorName("Isaac Reshaken! ")
EID:setModIndicatorIcon("Collectible" .. enums.Collectibles.MILKSHAKE)

local ICON_ANM2_PER_CARD = {
    [enums.Orbs.ELECTRIC] = "gfx/spirit_conductivity.anm2",
    [enums.Orbs.FIRE] = "gfx/spirit_inferno.anm2",
    [enums.Orbs.HOLY] = "gfx/spirit_salvation.anm2",
    [enums.Orbs.NATURE] = "gfx/spirit_druidity.anm2",
    [enums.Orbs.POISON] = "gfx/spirit_biohazard.anm2",
    [enums.Orbs.PSYCHIC] = "gfx/spirit_clairvoyance.anm2",
    [enums.Orbs.RANDOM] = "gfx/spirit_chaos.anm2",
    [enums.Orbs.ROCK] = "gfx/spirit_terra.anm2",
    [enums.Orbs.UNDEAD] = "gfx/spirit_undead.anm2",
    [enums.Orbs.UNHOLY] = "gfx/spirit_demonic.anm2",
    [enums.Orbs.WATER] = "gfx/spirit_water.anm2",
    [enums.Cards.TATTERED_PAGE] = "gfx/tattered_page.anm2"
}
for orb, anm2 in pairs(ICON_ANM2_PER_CARD) do
    local spr = Sprite()
    spr:Load(anm2, true)
    EID:addIcon("Card" .. orb, "EIDIcon", 1, 16, 16, 6, 6, spr)
end

local spr = Sprite()
spr:Load("gfx/spirit_chaos.anm2", true)
EID:addIcon("SpiritOrb", "EIDIcon", 1, 6, 6, 3, 6, spr)

local spr = Sprite()
spr:Load("gfx/fruit_heart.anm2", true)
EID:addIcon("FruitHeart", "EIDIcon", 1, 16, 16, 6, 6, spr)

-- Collectibles
for collectible, translations in pairs(descriptions.Collectibles) do
    for language, description in pairs(translations) do
        EID:addCollectible(collectible, description.description, description.name, language)

        if description.abyss then
            if not EID.descriptions[language].abyssSynergies then
                EID.descriptions[language].abyssSynergies = {}
            end
            EID.descriptions[language].abyssSynergies[collectible] = description.abyss
        end

        if description.book_of_virtues then
            if not EID.descriptions[language].bookOfVirtuesWisps then
                EID.descriptions[language].bookOfVirtuesWisps = {}
            end
            EID.descriptions[language].bookOfVirtuesWisps[collectible] = description.book_of_virtues
        end

        if description.book_of_belial then
            if not EID.descriptions[language].bookOfBelialBuffs then
                EID.descriptions[language].bookOfBelialBuffs = {}
            end
            EID.descriptions[language].bookOfBelialBuffs[collectible] = description.book_of_belial
        end
    end
end

-- Trinkets
for trinket, translations in pairs(descriptions.Trinkets) do
    for language, description in pairs(translations) do
        EID:addTrinket(trinket, description.description, description.name, language)

        if description.double then
            EID:addGoldenTrinketTable(trinket, {fullReplace = true})

            if not EID.descriptions[language].goldenTrinketEffects then
                EID.descriptions[language].goldenTrinketEffects = {}
            end

            EID.descriptions[language].goldenTrinketEffects[trinket] = {
                description.description,
                description.double,
                description.triple or description.double
            }
        end
    end
end

-- Pickups
for card, translations in pairs(descriptions.Cards) do
    for language, description in pairs(translations) do
        EID:addCard(card, description.description, description.name, language)

        if description.lyra_extra then
            EID:addDescriptionModifier("Lyra" .. card .. language,
                --Modifier condition
                function(descObj)
                    return EID:getLanguage() == language
                        and TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.LYRA)
                        and descObj.ObjType == EntityType.ENTITY_PICKUP
                        and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD
                        and descObj.ObjSubType == card
                end,
                --Modifier callback
                function(descObj)
                    EID:appendToDescription(descObj, description.lyra_extra)
                    return descObj
                end
            )
        end
    end
end

-- Entities
for entity, translations in pairs(descriptions.Entities) do
    local tokens = TSIL.Utils.String.Split(entity, ".")
    local type = tokens[1]
    local variant = tokens[2] or 0
    local subtype = tokens[3] or 0

    for language, description in pairs(translations) do
        EID:addEntity(
            type,
            variant,
            subtype,
            description.name,
            description.description,
            language
        )
    end
end