local BrendaUnholyWisp = {}

---@param entity Entity
function BrendaUnholyWisp:PostEntityKill(entity)
    if entity.Variant ~= FamiliarVariant.WISP
    or entity.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_UNHOLY_WISP then
        return
    end

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        MilkshakeVol1.enums.Orbs.UNHOLY,
        entity.Position
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_KILL,
    BrendaUnholyWisp.PostEntityKill,
    EntityType.ENTITY_FAMILIAR
)

function BrendaUnholyWisp:PreTearCollision(tear, collider)
    local spawner = tear.SpawnerEntity

    if not spawner then
        return
    end

    if not collider:IsVulnerableEnemy()
    or spawner.Type ~= EntityType.ENTITY_FAMILIAR
    or spawner.Variant ~= FamiliarVariant.WISP
    or spawner.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_UNHOLY_WISP then
        return
    end

    collider:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_TEAR_COLLISION,
    BrendaUnholyWisp.PreTearCollision
)