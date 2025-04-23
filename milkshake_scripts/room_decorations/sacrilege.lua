local Sacrilege = {}

--[[
    
 ______     __    __     ______     __  __     ______    
/\  ___\   /\ "-./  \   /\  ___\   /\ \/ /    /\  ___\   
\ \  __\   \ \ \-./\ \  \ \  __\   \ \  _"-.  \ \  __\   
 \ \_____\  \ \_\ \ \_\  \ \_____\  \ \_\ \_\  \ \_____\ 
  \/_____/   \/_/  \/_/   \/_____/   \/_/\/_/   \/_____/ 
                                                         

]]


function Sacrilege:PreEntitySpawn(type, variant, subtype)
    if type ~= 618 or variant ~= 126 or subtype ~= 0 then return end

    local room = Game():GetRoom()
    local centerPos = room:GetCenterPos()

    local wall = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.SACRILEGE_WALL,
        0,
        centerPos
    )
    wall:AddEntityFlags(EntityFlag.FLAG_RENDER_WALL)

    local floor = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.SACRILEGE_FLOOR,
        0,
        centerPos
    )
    floor:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)

    local pentagram = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.SACRILEGE_PENTAGRAM,
        0,
        centerPos
    )
    pentagram:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)

    local overlay = TSIL.EntitySpecific.SpawnEffect(
        MilkshakeVol1.enums.Effects.SACRILEGE_OVERLAY,
        0,
        centerPos
    )
    overlay.DepthOffset = math.maxinteger

    return {
        1000,
        40,
        0
    }
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_ENTITY_SPAWN,
    Sacrilege.PreEntitySpawn
)