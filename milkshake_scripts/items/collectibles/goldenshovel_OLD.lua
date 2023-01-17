local goldenShovel = {}
local enums = require("milkshake_scripts.enums")

local goldenShovelData = {
    FREEZE_DURATION = 180,
    GOLD_PICKUP_CHANCE = 10,
    DOUBLE_CHEST_CHANCE = 50,
    PICKUP_VELOCITY = Vector(2,2),
    PIT_STEP = 20,
    PICKUP_STEP = 30,
    DOUBLE_CHEST_STEP = 10
}

function goldenShovel:spawnGoldenPickup(roll, position)
    if roll == 0 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, position, goldenShovelData.PICKUP_VELOCITY, nil)
    elseif roll == 1 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, position, goldenShovelData.PICKUP_VELOCITY, nil)
    elseif roll == 2 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN, position, goldenShovelData.PICKUP_VELOCITY, nil)
    end
end

function goldenShovel:onUse(collectible, rng, player)
    if not player then return end
    print("poopis")
    Game():GetRoom():TurnGold()
    local pitPos = Isaac.GetFreeNearPosition(player.Position, goldenShovelData.PIT_STEP)
    Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, pitPos, true) -- Maybe get rid of this when re-entering the room?
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, goldenShovel.onUse, enums.Collectibles.GOLDEN_SHOVEL)

return goldenShovel