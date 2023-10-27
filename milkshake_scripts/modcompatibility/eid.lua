local eid = {}
local enums = MilkshakeVol1.enums
local descriptions = include("milkshake_scripts.modcompatibility.descriptions")

function eid:addEid()
    if not EID then return end

    EID:setModIndicatorName("Isaac Reshaken! ")
    EID:setModIndicatorIcon("Collectible"..enums.Collectibles.MILKSHAKE .."")

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
end
return eid