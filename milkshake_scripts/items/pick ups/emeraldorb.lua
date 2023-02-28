local EmeraldOrb = {}
local enums = milkshakeMod.enums
local utility = milkshakeMod.utility

local VINE_DURATION = 12

---@param player EntityPlayer
function EmeraldOrb:OnEmeraldOrbUse(_, player)
    local playerUsingLyraData = utility:GetTemporaryPlayerData(player, "UsingLyraData")

    if playerUsingLyraData then return end

    local isDoublePower = utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
    utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", nil)

    local npcs = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, false)

    npcs = TSIL.Utils.Tables.Filter(npcs, function (_, npc)
        return npc:IsVulnerableEnemy()
    end)

    TSIL.Utils.Tables.ForEach(npcs, function (_, npc)
        npc:AddFreeze(EntityRef(player), npc:IsBoss() and 150 or 3)

        local vine = TSIL.EntitySpecific.SpawnEffect(
            enums.Effects.VINES,
            0,
            npc.Position,
            Vector.Zero,
            player
        )

        local rng = TSIL.RNG.NewRNG(npc.InitSeed)

        vine.Target = npc
        local timeout = npc:IsBoss() and 8 or VINE_DURATION
        vine.Timeout = timeout * 30 + TSIL.Random.GetRandomInt(0, 12, rng)
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
    if not target:IsBoss() then
        target:AddFreeze(EntityRef(vine.SpawnerEntity), 1)
    end

    if vineSprite:IsPlaying("Grow") then return end

    if vineSprite:IsFinished("Grow") then
        vineSprite:Play("Idle", true)
    end

    if timeout == 0 then
        vineSprite:Play("Hide", true)
        return
    end

    if timeout % 40 == 0 then
        target:TakeDamage(1, 0, EntityRef(vine.SpawnerEntity), -1)
        vineSprite:Play("Attack", true)
    end

    if vineSprite:IsFinished("Attack") then
        vineSprite:Play("Idle")
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
                local heart = TSIL.EntitySpecific.SpawnPickup(
                    PickupVariant.PICKUP_HEART,
                    enums.Hearts.FRUIT_HEART,
                    npc.Position
                )

                heart.Timeout = 45

                local heartSpr = heart:GetSprite()
                for i = 0, heartSpr:GetLayerCount()-1, 1 do
                    heartSpr:ReplaceSpritesheet(i, "gfx/items/pick ups/fruit_heart.png")
                end
                heartSpr:LoadGraphics()

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