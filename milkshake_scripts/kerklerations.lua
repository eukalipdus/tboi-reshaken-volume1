MilkshakeVol1.Game = Game()
MilkshakeVol1.SFX = SFXManager()

---@param entity Entity
---@param identifier string | nil
---@return any
function MilkshakeVol1:GetData(entity, identifier)
    local data = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        entity,
        identifier or ""
    )

    if not data then
        data = {}
        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            entity,
            identifier or "",
            data
        )
    end

    return data
end