local sickleCell = {}
local enums = MilkshakeVol1.enums

function sickleCell:EntityTakeDmg(entity, _, _, source)
    if not source.Entity then return end
    local sourceEntity = source.Entity
    if sourceEntity.Type == EntityType.ENTITY_FAMILIAR
    and sourceEntity.Variant == FamiliarVariant.ABYSS_LOCUST
    and sourceEntity.SubType == enums.Collectibles.SICKLE_CELL then
        entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
        SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, sickleCell.EntityTakeDmg)
return sickleCell