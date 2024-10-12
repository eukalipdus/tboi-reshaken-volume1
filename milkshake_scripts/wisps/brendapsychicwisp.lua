local BrendaPsychicWisp = {}


---@param entity Entity
function BrendaPsychicWisp:OnBrendaPsychicWispDeath(entity)
    if entity.Variant ~= FamiliarVariant.WISP
    or entity.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_PSYCHIC_WISP then
        return
    end

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        MilkshakeVol1.enums.Orbs.PSYCHIC,
        entity.Position
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_KILL,
    BrendaPsychicWisp.OnBrendaPsychicWispDeath,
    EntityType.ENTITY_FAMILIAR
)