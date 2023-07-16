local BrendaNatureWisp = {}


---@param entity Entity
function BrendaNatureWisp:OnBrendaNatureWispRemove(entity)
    if entity.Variant ~= FamiliarVariant.WISP
    or entity.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_NATURE_WISP then
        return
    end

    TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_HEART,
        MilkshakeVol1.enums.Hearts.FRUIT_HEART,
        entity.Position
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    BrendaNatureWisp.OnBrendaNatureWispRemove,
    EntityType.ENTITY_FAMILIAR
)