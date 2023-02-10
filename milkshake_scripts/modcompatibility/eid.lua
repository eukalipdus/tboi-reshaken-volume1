local eid = {}
local descriptions = require("milkshake_scripts.modcompatibility.descriptions")

function eid:addEid()
    if EID then
        -- Collectibles
        for collectible, translations in pairs(descriptions.Collectibles) do
            for language, description in pairs(translations) do
                EID:addCollectible(collectible, description, language)
            end
        end

        -- Trinkets
        for trinket, translations in pairs(descriptions.Trinkets) do
            for language, description in pairs(translations) do
                EID:addTrinket(trinket, description, language)
            end
        end

        -- Pickups
        for card, translations in pairs(descriptions.Cards) do
            for language, description in pairs(translations) do
                EID:addCard(card, description, language)
            end
        end
    end
end
return eid