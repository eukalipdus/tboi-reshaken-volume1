local BrendaNatureWisp = {}


---@param entity Entity
function BrendaNatureWisp:OnBrendaNatureWispDeath(entity)
    if entity.Variant ~= FamiliarVariant.WISP
    or entity.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_NATURE_WISP then
        return
    end

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_TAROTCARD,
        MilkshakeVol1.enums.Orbs.NATURE,
        entity.Position
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_KILL,
    BrendaNatureWisp.OnBrendaNatureWispDeath,
    EntityType.ENTITY_FAMILIAR
)