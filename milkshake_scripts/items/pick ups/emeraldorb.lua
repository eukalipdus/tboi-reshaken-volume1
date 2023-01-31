local EmeraldOrb = {}
local enums = require("milkshake_scripts.enums")

---@param player EntityPlayer
function EmeraldOrb:OnEmeraldOrbUse(_, player)
    if not player then return end

    local npcs = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, false)

    npcs = TSIL.Utils.Tables.Filter(npcs, function (_, npc)
        return npc:IsVulnerableEnemy() and not npc:IsBoss()
    end)

    TSIL.Utils.Tables.ForEach(npcs, function (_, npc)
        npc:AddFreeze(EntityRef(player), 3)

        local vine = TSIL.EntitySpecific.SpawnEffect(
            enums.Effects.VINES,
            0,
            npc.Position,
            Vector.Zero,
            player
        )

        vine.Target = npc
        vine.Timeout = 20 * 30
        vine.DepthOffset = 10

        vine:GetSprite():Play("Grow", true)
    end)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_USE_CARD,
    EmeraldOrb.OnEmeraldOrbUse,
    enums.Cards.EMERALD_ORB
)


---@param vine EntityEffect
function EmeraldOrb:OnVineUpdate(vine)
    local vineSprite = vine:GetSprite()
    local timeout = vine.Timeout
    local target = vine.Target

    if vineSprite:IsPlaying("Hide") then return end

    if vineSprite:IsFinished("Hide") then
        vine:Remove()
    end

    if not target or not target:Exists() or target:IsDead() or
    not target:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
        vineSprite:Play("Hide", true)
        return
    end

    target.Velocity = Vector.Zero
    target.Position = vine.Position
    target:AddFreeze(EntityRef(vine.SpawnerEntity), 1)

    if vineSprite:IsPlaying("Grow") then return end

    if vineSprite:IsFinished("Grow") then
        vineSprite:Play("Idle", true)
    end

    if timeout == 0 then
        vineSprite:Play("Hide", true)
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    EmeraldOrb.OnVineUpdate,
    enums.Effects.VINES
)


---@param npc EntityNPC
function EmeraldOrb:OnNPCDeath(npc)
    local vines = TSIL.EntitySpecific.GetEffects(enums.Effects.VINES)

    local ptr = GetPtrHash(npc)

    for _, vine in ipairs(vines) do
        if vine.Target then
            local targetPtr = GetPtrHash(vine.Target)

            if ptr == targetPtr then
                TSIL.EntitySpecific.SpawnPickup(
                    PickupVariant.PICKUP_HEART,
                    HeartSubType.HEART_FULL,
                    npc.Position
                )

                return
            end
        end
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    EmeraldOrb.OnNPCDeath
)


return EmeraldOrb