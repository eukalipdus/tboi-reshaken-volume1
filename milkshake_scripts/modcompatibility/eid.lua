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
    EID:addIcon("SpiritOrb", "EIDIcon", 1, 16, 16, 6, 6, spr)

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
        end
    end
end)