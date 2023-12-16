local shardRockOverlay = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local shardTrinkets = {
    enums.Trinkets.AMETHYST_SHARD,
    enums.Trinkets.RUBY_SHARD,
    enums.Trinkets.TOURMALINE_SHARD,
    enums.Trinkets.EMERALD_SHARD,
    enums.Trinkets.PERIDOT_SHARD,
    enums.Trinkets.GARNET_SHARD,
    enums.Trinkets.ONYX_SHARD,
    enums.Trinkets.DIAMOND_SHARD,
    enums.Trinkets.SAPPHIRE_SHARD,
    enums.Trinkets.AMBER_SHARD,
}

local shardTrinketNames = {
    "amethyst",
    "ruby",
    "tourmaline",
    "emerald",
    "peridot",
    "garnet",
    "onyx",
    "diamond",
    "sapphire",
    "amber",
}

function shardRockOverlay:PostGridEntityInit()
    local emptyEffects = TSIL.EntitySpecific.GetEffects(enums.Effects.EFFECT_REPLACER)
    if #emptyEffects > 1 then return end
    for _, trinketId in ipairs(shardTrinkets) do
        if TSIL.Players.DoesAnyPlayerHasTrinket(trinketId) then
            TSIL.EntitySpecific.SpawnEffect(enums.Effects.EFFECT_REPLACER, 0, Vector.Zero, Vector.Zero, nil, Random() + 1)
            break
        end
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GRID_ENTITY_INIT, shardRockOverlay.PostGridEntityInit)

function shardRockOverlay:PostEffectRender(effect)
    for idx, trinketId in ipairs(shardTrinkets) do
        if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT
        or effect.Variant ~= enums.Effects.EFFECT_REPLACER
        or not TSIL.Players.DoesAnyPlayerHasTrinket(trinketId) then return end
        local tintedRocks = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)
        for _, gridEntity in ipairs(tintedRocks) do
            if gridEntity.State ~= 2 then
                utility:RenderCrystalRockSprite(gridEntity, shardTrinketNames[idx])
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, shardRockOverlay.PostEffectRender)

return shardRockOverlay