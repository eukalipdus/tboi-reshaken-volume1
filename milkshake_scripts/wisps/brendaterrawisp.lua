local BrendaTerraWisp = {}


---@param entity Entity
function BrendaTerraWisp:OnBrendaTerraWispDeath(entity)
    if entity.Variant ~= FamiliarVariant.WISP
    or entity.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_TERRA_WISP then
        return
    end

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        MilkshakeVol1.enums.Orbs.ROCK,
        entity.Position
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_KILL,
    BrendaTerraWisp.OnBrendaTerraWispDeath,
    EntityType.ENTITY_FAMILIAR
)