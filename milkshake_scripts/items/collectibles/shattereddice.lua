local shatteredDice = {}
local enums = require("milkshake_scripts.enums")

local STEP = 40

function shatteredDice:onUse(collectible, rng, player)
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local collectible = entity:ToPickup()
            local collectibleQuality =  Isaac.GetItemConfig():GetCollectible(collectible.SubType).Quality
            collectible:Remove()

            local newCollectible
            for i = 0, 1 do
                repeat
                    newCollectible = Game():GetItemPool():GetCollectible(rng:RandomInt(31))
                until Isaac.GetItemConfig():GetCollectible(newCollectible).Quality == collectibleQuality - 1

                local spawnPosition = Isaac.GetFreeNearPosition(collectible.Position, STEP)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectible, spawnPosition, Vector(0,0), nil)
                local collectible = newCollectible
            end
        end
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, shatteredDice.onUse, enums.Collectibles.SHATTERED_DICE)
return shatteredDice