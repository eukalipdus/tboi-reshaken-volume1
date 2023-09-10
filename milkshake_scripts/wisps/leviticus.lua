local LeviticusWisp = {}

local ANGEL_CHANCE = 0.2

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "LeviticusWispsAppliedDealChance",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

---@param wisp EntityFamiliar
function LeviticusWisp:OnWispUpdate(wisp)
    if wisp.SubType ~= MilkshakeVol1.enums.Collectibles.LEVITICUS then return end

    if not Game():GetStateFlag(GameStateFlag.STATE_DEVILROOM_SPAWNED) then
        return
    end

    local wispsAppliedDealChance = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "LeviticusWispsAppliedDealChance"
    )
    if wispsAppliedDealChance[wisp.InitSeed] then return end

    local level = Game():GetLevel()
    level:AddAngelRoomChance(ANGEL_CHANCE)
    wispsAppliedDealChance[wisp.InitSeed] = true
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    LeviticusWisp.OnWispUpdate,
    FamiliarVariant.WISP
)


---@param entity Entity
function LeviticusWisp:OnFamiliarRemove(entity)
    if entity.Variant ~= FamiliarVariant.WISP then return end
    if entity.SubType ~= MilkshakeVol1.enums.Collectibles.LEVITICUS then return end

    if not Game():GetStateFlag(GameStateFlag.STATE_DEVILROOM_SPAWNED) then
        return
    end

    local wispsAppliedDealChance = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "LeviticusWispsAppliedDealChance"
    )
    if not wispsAppliedDealChance[entity.InitSeed] then return end

    local level = Game():GetLevel()
    level:AddAngelRoomChance(-ANGEL_CHANCE)
    wispsAppliedDealChance[entity.InitSeed] = nil
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    LeviticusWisp.OnFamiliarRemove,
    EntityType.ENTITY_FAMILIAR
)