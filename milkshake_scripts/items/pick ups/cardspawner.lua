local CardSpawner = {}

local CARD_SPAWN_TYPE = 618
local CARD_SPAWN_VARIANT = 124


---@param variant any
---@param subtype any
---@param seed any
function CardSpawner:PreEntitySpawn(_, variant, subtype, _, _, _, seed)
    if variant ~= CARD_SPAWN_VARIANT then return end
    local card = MilkshakeVol1.enums.CardSpawnerSubtypePerCard[subtype]
    if not card then return end

    return {
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_TAROTCARD,
        card,
        seed
    }
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_ENTITY_SPAWN,
    CardSpawner.PreEntitySpawn,
    CARD_SPAWN_TYPE
)