local BrendaDeadWisp = {}

---@param entity Entity
function BrendaDeadWisp:PostEntityKill(entity)
    if entity.Variant ~= FamiliarVariant.WISP
    or entity.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_DEAD_WISP then
        return
    end

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        MilkshakeVol1.enums.Orbs.UNDEAD,
        entity.Position
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_KILL,
    BrendaDeadWisp.PostEntityKill,
    EntityType.ENTITY_FAMILIAR
)
