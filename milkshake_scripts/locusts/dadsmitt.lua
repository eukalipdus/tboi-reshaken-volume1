local dadsMitt = {}
local enums = MilkshakeVol1.enums

local MOVEMENT_RATIO = 0.2
local DEADZONE_ANGLE = 60
local DEADZONE_RANGE = math.cos(math.rad(DEADZONE_ANGLE/2))

function dadsMitt:FamiliarUpdate(familiar)
    if familiar.SubType ~= enums.Collectibles.DADS_MITT then return end
    familiar.Velocity = familiar.Velocity + Isaac.GetPlayer().Velocity * MOVEMENT_RATIO
    local player = familiar.Player
    local playerDirection = player.Velocity:Normalized()
    if familiar.Position:Dot(playerDirection) > DEADZONE_RANGE then return end
    familiar.Velocity = familiar.Velocity + player.Velocity * MOVEMENT_RATIO
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, dadsMitt.FamiliarUpdate, FamiliarVariant.ABYSS_LOCUST)

return dadsMitt