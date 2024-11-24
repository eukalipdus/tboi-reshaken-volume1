local LeviticusWisp = {}

local ANGEL_CHANCE = 0.25

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "LeviticusWispsAppliedDealChance",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)
TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "CanLeviticusWispChanceDealChance",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

local function CanChangeChance()
    return TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "CanLeviticusWispChanceDealChance"
    )
end

local function SetCanChangeChance()
    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "CanLeviticusWispChanceDealChance",
        true
    )
end

function LeviticusWisp:OnUpdate()
    if CanChangeChance() then return end

    local level = Game():GetLevel()
    local roomIndex = level:GetCurrentRoomIndex()

    if roomIndex == GridRooms.ROOM_DEVIL_IDX then
        SetCanChangeChance()
        return
    end

    local dealDoors = TSIL.Doors.GetDoorsToRoomIndex(GridRooms.ROOM_DEVIL_IDX)
    if #dealDoors > 0 then
        SetCanChangeChance()
        return
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_UPDATE,
    LeviticusWisp.OnUpdate
)

local levitici = {
    [MilkshakeVol1.enums.Collectibles.LEVITICUS] = true,
    [MilkshakeVol1.enums.Collectibles.LEVITICUS_ALADAR] = true,
    [MilkshakeVol1.enums.Collectibles.LEVITICUS_FANCY] = true,
}

---@param wisp EntityFamiliar
function LeviticusWisp:OnWispUpdate(wisp)
    if not levitici[wisp.SubType] then return end

    if not CanChangeChance() then return end

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
    if not levitici[entity.SubType] then return end

    if not CanChangeChance() then return end

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