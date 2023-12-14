local enums = MilkshakeVol1.enums
local descriptions = include("milkshake_scripts.modcompatibility.descriptions")

MilkshakeVol1:AddModCompatibility("EID", function ()
    EID:setModIndicatorName("Isaac Reshaken! ")
    EID:setModIndicatorIcon("Collectible"..enums.Collectibles.MILKSHAKE .."")

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
        end
    end

    -- Trinkets
    for trinket, translations in pairs(descriptions.Trinkets) do
        for language, description in pairs(translations) do
            EID:addTrinket(trinket, description.description, description.name, language)
        end
    end

    -- Pickups
    for card, translations in pairs(descriptions.Cards) do
        for language, description in pairs(translations) do
            EID:addCard(card, description.description, description.name, language)

            if description.lyra_extra then
                EID:addDescriptionModifier("Lyra" .. card .. language,
                    --Modifier condition
                    function (descObj)
                        return EID:getLanguage() == language
                        and TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.LYRA)
                        and descObj.ObjType == EntityType.ENTITY_PICKUP
                        and descObj.ObjVariant == PickupVariant.PICKUP_TAROTCARD
                        and descObj.ObjSubType == card
                    end,
                    --Modifier callback
                    function (descObj)
                        EID:appendToDescription(descObj, description.lyra_extra)
                        return descObj
                    end
                )
        end
        end
    end

    -- Book of Virtues
    EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.GLOBIN_IN_A_BUCKET] = "Middle ring wisp#50% chance to reform on death"
    EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.PRISMATIC_DICE] = "Middle ring wisp#Cannot shoot tears#Splits Isaac's tears into 4 {{Collectible528}} angelic prism tears"
    EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.GOLDEN_SHOVEL] = "Middle ring wisp#High HP wisp#10% chance for {{Collectible202}} Midas' Touch tears"
    EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.EMPTY_SLOT] = "Inner ring wisp#Low HP wisp"
    EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.LEVITICUS] = "Inner ring wisp#High HP wisp#+10% {{AngelRoom}} Angel Room chance per Leviticus wisp"
    EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.SHATTERED_ORB] = "Upon shattering, spawns 3 random elemental wisps of varying effects"

    -- Book of Belial Judas Birthright
    EID.descriptions["en_us"].bookOfBelialBuffs[enums.Collectibles.SHATTERED_ORB] = "50% chance to replace spawned {{SpiritOrb}} Spirit of Chaos with Spirit of Sacrilege"
    EID.descriptions["en_us"].bookOfBelialBuffs[enums.Collectibles.MIRROR_KEY] = "↑ {{Damage}} +2.5 Damage while in the mirror world"
    EID.descriptions["en_us"].bookOfBelialBuffs[enums.Collectibles.UNCHARGED_MIRROR_KEY] = "↑ Damage applies in the mirror world"
    EID.descriptions["en_us"].bookOfBelialBuffs[enums.Collectibles.EMPTY_SLOT] = "↑ {{Damage}} +0.066 Damage per coin inserted while held"
    EID.descriptions["en_us"].bookOfBelialBuffs[enums.Collectibles.PRISMATIC_DICE] = "30% chance for split items to be {{DevilRoom}} Devil items"

    -- Abyss
    EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.MILKSHAKE] = "Large, fast, pink locust that deals 2x Isaac's damage"
    EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.FIRECRACKER_ROSE] = "Green, burning locust that has a 10% chance to inflict {{Burning}} Kabloom"
    EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.PRISMATIC_DICE] = "Pink, glowing locust that has a 10% chance to split enemies into two weaker enemies on contact"
    EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.DADS_MITT] = "Baseball locust that follows Isaac's movement momentum"
    EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.SICKLE_CELL] = "Red locust that inflicts {{BleedingOut}} Bleeding"
    EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.LEVITICUS] = "Blue, glowing locust that can spawn beams of light that deal deal 3x Isaac's damage"
end)