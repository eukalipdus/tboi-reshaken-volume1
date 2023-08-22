local EmeraldOrb = {}
local enums = MilkshakeVol1.enums

local VINE_DURATION = 12
local VINE_DAMAGE = 1
local FRUIT_HEART_DURATION = 45

---@param player EntityPlayer
---@param flags UseOrbFlag
function EmeraldOrb:OnEmeraldOrbUse(_, player, flags)
    local npcs = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, false)

    npcs = TSIL.Utils.Tables.Filter(npcs, function (_, npc)
        return npc:IsVulnerableEnemy()
    end)

    if #npcs == 0 then
        local vine = TSIL.EntitySpecific.SpawnEffect(
            enums.Effects.VINES,
            0,
            player.Position,
            Vector.Zero,
            player
        )

        vine.Target = player
        vine.DepthOffset = 10

        vine:GetSprite():Play("Grow", true)

        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            vine,
            "IsLyraUse",
            TSIL.Utils.Flags.HasFlags(flags, enums.UseOrbFlags.DOUBLE_POWER)
        )
    end

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

        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            vine,
            "IsLyraUse",
            TSIL.Utils.Flags.HasFlags(flags, enums.UseOrbFlags.DOUBLE_POWER)
        )
    end)
end
MilkshakeVol1:AddCallback(
    enums.Callbacks.ON_ORB_USE,
    EmeraldOrb.OnEmeraldOrbUse,
    enums.Orbs.NATURE
)


---@param spawnPos Vector
---@param rng RNG
local function SpawnFruitHeart(spawnPos, rng)
    local spawningVelocity = Vector.FromAngle(rng:RandomInt(360)):Resized(TSIL.Random.GetRandomFloat(2, 4, rng))

    local heart = TSIL.EntitySpecific.SpawnPickup(
        PickupVariant.PICKUP_HEART,
        enums.Hearts.FRUIT_HEART,
        spawnPos,
        spawningVelocity
    )

    heart.Timeout = FRUIT_HEART_DURATION

    local heartSpr = heart:GetSprite()
    for i = 0, heartSpr:GetLayerCount()-1, 1 do
        heartSpr:ReplaceSpritesheet(i, "gfx/items/pick ups/fruit_heart.png")
    end
    heartSpr:LoadGraphics()
end


---@param vine EntityEffect
function EmeraldOrb:OnVineUpdate(vine)
    local isLyra = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        vine,
        "IsLyraUse"
    )
    local vineSprite = vine:GetSprite()
    local timeout = vine.Timeout
    local target = vine.Target

    if vineSprite:IsPlaying("Hide") then return end

    if vineSprite:IsFinished("Hide") then
        if target and target:ToPlayer() then
            SpawnFruitHeart(vine.Position, vine:GetDropRNG())
            if isLyra then
                SpawnFruitHeart(vine.Position, vine:GetDropRNG())
            end
        end
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
        local damage = VINE_DAMAGE
        if isLyra then
            damage = damage * 2
        end

        target:TakeDamage(damage, 0, EntityRef(vine.SpawnerEntity), -1)
        vineSprite:Play("Attack", true)
    end

    if vineSprite:IsFinished("Attack") then
        vineSprite:Play("Idle")
    end
end
MilkshakeVol1:AddCallback(
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
                local isLyra = TSIL.Entities.GetEntityData(
                    MilkshakeVol1,
                    vine,
                    "IsLyraUse"
                )

                SpawnFruitHeart(npc.Position, vine:GetDropRNG())
                if isLyra then
                    SpawnFruitHeart(npc.Position, vine:GetDropRNG())
                end

                return
            end
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    EmeraldOrb.OnNPCDeath
)


return EmeraldOrb