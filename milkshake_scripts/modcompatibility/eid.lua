local eid = {}
local enums = require("milkshake_scripts.enums")
local descriptions = require("milkshake_scripts.modcompatibility.descriptions")

function eid:addEid()
    if EID then
        -- Collectibles
        EID:addCollectible(enums.Collectibles.BLACK_EYE, descriptions.Collectibles.BLACK_EYE)
        EID:addCollectible(enums.Collectibles.DICE_DICE, descriptions.Collectibles.DICE_DICE)
        EID:addCollectible(enums.Collectibles.FIRECRACKER_ROSE, descriptions.Collectibles.FIRE_CRACKER_ROSE)
        EID:addCollectible(enums.Collectibles.GLOBIN_IN_A_BUCKET, descriptions.Collectibles.GLOBIN_IN_A_BUCKET)
        EID:addCollectible(enums.Collectibles.GOLDEN_SHOVEL, descriptions.Collectibles.GOLDEN_SHOVEL)
        EID:addCollectible(enums.Collectibles.MILKSHAKE, descriptions.Collectibles.MILKSHAKE)
        EID:addCollectible(enums.Collectibles.SHARP_CURSOR, descriptions.Collectibles.SHARP_CURSOR)
        EID:addCollectible(enums.Collectibles.SHARP_CURSOR, descriptions.Collectibles.LA_CHANCLA)

        -- Trinkets
        EID:addTrinket(enums.Trinkets.AMETHYST_SHARD, descriptions.Trinkets.AMETHYST_SHARD)
        EID:addTrinket(enums.Trinkets.RUBY_SHARD, descriptions.Trinkets.RUBY_SHARD)
        EID:addTrinket(enums.Trinkets.SAPPHIRE_SHARD, descriptions.Trinkets.SAPPHIRE_SHARD)

        -- Pickups
        EID:addCard(enums.Cards.AMETHYST_ORB, descriptions.Cards.AMETHYST_ORB)
        EID:addCard(enums.Cards.EMERALD_ORB, descriptions.Cards.EMERALD_ORB)
        EID:addCard(enums.Cards.RUBY_ORB, descriptions.Cards.RUBY_ORB)
        EID:addCard(enums.Cards.SAPPHIRE_ORB, descriptions.Cards.SAPPHIRE_ORB)
    end
end
return eid