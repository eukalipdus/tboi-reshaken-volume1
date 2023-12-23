local fireCrackerRose = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local DOWNGRADE_CHANCE = 100
local COLLISION_COOLDOWN = 60

function fireCrackerRose:EntityTakeDmg(entity, _, _, source)
    if not source.Entity then return end
    local sourceEntity = source.Entity
    local familiar = sourceEntity:ToFamiliar()
    if not familiar then return end
    if (familiar.Variant ~= FamiliarVariant.ABYSS_LOCUST or familiar.SubType ~= enums.Collectibles.FIRECRACKER_ROSE) then return end
    local player = familiar.Player
    local rng = player:GetCollectibleRNG(enums.Collectibles.FIRECRACKER_ROSE)
    local roll = TSIL.Random.GetRandomInt(1, 100, rng)
    if roll <= DOWNGRADE_CHANCE
    and not utility:GetData(familiar, "FireCrackerCooldown") then
        MilkshakeVol1.API:AddCrackered(entity:ToNPC(), player)
        utility:SetData(familiar, "FireCrackerCooldown", true)
        TSIL.Utils.Functions.RunInFramesTemporary(function ()
            utility:SetData(familiar, "FireCrackerCooldown", false)
        end, COLLISION_COOLDOWN, {})
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, fireCrackerRose.EntityTakeDmg)

return fireCrackerRose