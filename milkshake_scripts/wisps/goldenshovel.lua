local GoldenShovelWisp = {}


local GOLDEN_TEAR_CHANCE = 0.1
local GOLDEN_COLOR = Color(0.9, 0.8, 0, 1, 0.8, 0.7, 0)
local FREEZE_DURATION = 30 * 3


---@param tear EntityTear
function GoldenShovelWisp:OnTearInit(tear)
    local spawner = tear.SpawnerEntity

    if not spawner then return end

    if spawner.Type ~= EntityType.ENTITY_FAMILIAR
    or spawner.Variant ~= FamiliarVariant.WISP
    or spawner.SubType ~= MilkshakeVol1.enums.Collectibles.GOLDEN_SHOVEL then
        return
    end

    local rng = TSIL.RNG.NewRNG(tear.InitSeed)
    if rng:RandomFloat() >= GOLDEN_TEAR_CHANCE then return end

    tear.Color = GOLDEN_COLOR
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        tear,
        "IsMidasFreezeTear",
        true
    )
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_TEAR_INIT_LATE,
    GoldenShovelWisp.OnTearInit
)


---@param entity Entity
---@param source EntityRef
function GoldenShovelWisp:OnEntityDamage(entity, _, _, source)
    local npc = entity:ToNPC()
    if not npc then return end
    if npc:IsBoss() or not npc:IsActiveEnemy(false) then return end

    local sourceEntity = source.Entity
    if not sourceEntity then return end

    local isMidasFreezeTear = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        sourceEntity,
        "IsMidasFreezeTear"
    )
    if not isMidasFreezeTear then return end

    entity:AddMidasFreeze(source, FREEZE_DURATION)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    GoldenShovelWisp.OnEntityDamage
)