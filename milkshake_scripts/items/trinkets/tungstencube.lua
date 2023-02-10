local TungstenCube = {}
local enums = require("milkshake_scripts.enums")


---@param trinket EntityPickup
function TungstenCube:OnTrinketUpdate(trinket)
    if trinket.SubType ~= enums.Trinkets.TUNGSTEN_CUBE then return end

    local spr = trinket:GetSprite()

    if not spr:IsPlaying("Appear") then return end

    if spr:IsEventTriggered("DropSound") then
        Game():ShakeScreen(10)
        local params = TSIL.ShockWaves.CustomShockwaveParams()
        
        local level = Game():GetLevel()
        params.Damage = 5 + 2*(level:GetStage()-1)
        params.DamagePlayers = false

        TSIL.ShockWaves.CreateShockwaveRing(
            trinket,
            trinket.Position,
            40,
            params,
            nil,
            nil,
            nil,
            3
        )
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    TungstenCube.OnTrinketUpdate,
    PickupVariant.PICKUP_TRINKET
)


---@param player EntityPlayer
function TungstenCube:OnSpeedCache(player)
    if not player:HasTrinket(enums.Trinkets.TUNGSTEN_CUBE) then return end

    player.MoveSpeed = player.MoveSpeed - 0.2
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    TungstenCube.OnSpeedCache,
    CacheFlag.CACHE_SPEED
)

return TungstenCube