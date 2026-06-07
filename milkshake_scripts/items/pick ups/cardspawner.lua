local CardSpawner = {}

local CARD_SPAWN_TYPE = 618
local CARD_SPAWN_VARIANT = 124


---@param variant any
---@param subtype any
---@param seed any
function CardSpawner:PreEntitySpawn(type, variant, subtype, _, _, _, seed)
    if type ~= CARD_SPAWN_TYPE then return end
    if variant ~= CARD_SPAWN_VARIANT then return end

    if Game():GetRoom():IsFirstVisit() then
        local card = MilkshakeVol1.enums.CardSpawnerSubtypePerCard[subtype]
        if not card then return end

        return {
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TAROTCARD,
            card,
            seed
        }
    else
        return {
            1000,
            40,
            0,
            seed
        }
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_ENTITY_SPAWN,
    CardSpawner.PreEntitySpawn
)