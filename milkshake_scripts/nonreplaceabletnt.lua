local NonReplaceableTNT = {}
local META_ENTITY_TYPE = 618
local META_ENTITY_VARIANT = 125
local META_ENTITY_SUBTYPE = 0

function NonReplaceableTNT:PreRoomEntitySpawn(type, variant, subtype)
    if type ~= META_ENTITY_TYPE
    or variant ~= META_ENTITY_VARIANT
    or subtype ~= META_ENTITY_SUBTYPE then
        return
    end

    return {
        TSIL.Enums.GridEntityXMLType.TNT,
        0,
        0
    }
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, NonReplaceableTNT.PreRoomEntitySpawn)