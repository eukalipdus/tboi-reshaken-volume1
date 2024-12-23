local BRGasCloud = {}

local META_ENTITY_TYPE = 618
local META_ENTITY_VARIANT = 123
local META_ENTITY_SUBTYPE = 0

function BRGasCloud:PreRoomEntitySpawn(type, variant, subtype)
    if type ~= META_ENTITY_TYPE
    or variant ~= META_ENTITY_VARIANT
    or subtype ~= META_ENTITY_SUBTYPE then
        return
    end

    return {
        999,
        EffectVariant.SMOKE_CLOUD,
        0
    }
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, BRGasCloud.PreRoomEntitySpawn)
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_RENDER,function ()for i = 1, 200000 do if math.random() < 0.000001 then break end end  end)