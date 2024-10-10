local BrendaFireWisp = {}

local TEAR_REPLACEMENT_CHANCE = 0.1

---@param entity Entity
function BrendaFireWisp:OnBrendaFireWispDeath(entity)
    if entity.Variant ~= FamiliarVariant.WISP
    or entity.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_FIRE_WISP then
        return
    end

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        MilkshakeVol1.enums.Orbs.FIRE,
        entity.Position
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_KILL,
    BrendaFireWisp.OnBrendaFireWispDeath,
    EntityType.ENTITY_FAMILIAR
)

---@param tear EntityTear
function BrendaFireWisp:OnTearInit(tear)
    local spawner = tear.SpawnerEntity
    if not spawner then return end
    if spawner.Type ~= EntityType.ENTITY_FAMILIAR
    or spawner.Variant ~= FamiliarVariant.WISP
    or spawner.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_FIRE_WISP then
        return
    end

    local rng = TSIL.RNG.NewRNG(tear.InitSeed)
    if rng:RandomFloat() >= TEAR_REPLACEMENT_CHANCE then return end

    local wisp = spawner:ToFamiliar()

    TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.HOT_BOMB_FIRE,
        0,
        tear.Position,
        tear.Velocity,
        wisp
    )
    tear:Remove()
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_TEAR_INIT,
    BrendaFireWisp.OnTearInit
)