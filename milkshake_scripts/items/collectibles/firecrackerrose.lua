local FirecrackerRose = {}
local enums = require("milkshake_scripts.enums")

TSIL.SaveManager.AddPersistentVariable(milkshakeMod, "FirecrackerTears", {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM)
TSIL.SaveManager.AddPersistentVariable(milkshakeMod, "CrackeredEnemies", {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM)
TSIL.SaveManager.AddPersistentVariable(milkshakeMod, "PetalTears", {}, TSIL.Enums.VariablePersistenceMode.RESET_ROOM)

local CrackerSeedSprites = {}


---@param npc EntityNPC
---@param source EntityPlayer?
local function FirecrackerExplode(npc, source)
    if source == nil then return end

    Isaac.Explode(npc.Position, source, 35 + 6 * source.Damage)

    local npcPtr = GetPtrHash(npc)
    local petalTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PetalTears")

    local rng = TSIL.RNG.NewRNG(npc.InitSeed)
    local numTears = 5 + rng:RandomInt(3)

    for _ = 1, numTears, 1 do
        local angle = rng:RandomInt(360)
        local velocity = Vector.FromAngle(angle):Resized(7)

        local tear = source:FireTear(npc.Position, velocity, false, true, false, source, (1/source.Damage) * 5)
        tear.Height = -26
        tear.FallingSpeed = TSIL.Random.GetRandomFloat(0, 3, rng)
        tear.FallingAcceleration = 0.5 * (TSIL.Random.GetRandomFloat(0.3, 1.3, rng))

        local tearSpr = tear:GetSprite()
        tearSpr:Load("/gfx/firecracker_petal.anm2", true)

        tearSpr:PlayRandom(tear.InitSeed)

        local tearPtr = GetPtrHash(tear)
        petalTears[tearPtr] = npcPtr
    end
end


---@param npc EntityNPC
---@param player EntityPlayer
local function AddCrackered(npc, player)
    local colliderPtr = GetPtrHash(npc)
    local crackeredEnemies = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "CrackeredEnemies")

    if crackeredEnemies[colliderPtr] ~= nil then return end

    local seedSprite = Sprite()
    seedSprite:Load("/gfx/firecracker_bullet.anm2", true)
    seedSprite:Play("SeedIdle", true)
    CrackerSeedSprites[colliderPtr] = seedSprite

    crackeredEnemies[colliderPtr] = {
        timer = 30 * 5,
        source = TSIL.Players.GetPlayerIndex(player)
    }
end


---@param tear EntityTear
local function MakeTearFirecrackerSeed(tear)
    local tearPtr = GetPtrHash(tear)

    tear:ChangeVariant(TearVariant.BONE)

    local tearSpr = tear:GetSprite()
    tearSpr:Load("/gfx/firecracker_seed.anm2", true)
    tearSpr:Play("spin", true)

    local newColor = Color(1, 1, 1, 1, 0.5)
    tear.Color = newColor

    TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "FirecrackerTears")[tearPtr] = true
end


---@param tear EntityTear
function FirecrackerRose:OnTearInit(tear)
    local tearPtr = GetPtrHash(tear)
    local petalTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PetalTears")

    if petalTears[tearPtr] then return end

    local player = TSIL.Players.GetPlayerFromEntity(tear)

    if player == nil then return end
    if not player:HasCollectible(enums.Collectibles.FIRECRACKER_ROSE) then return end

    local rng = player:GetCollectibleRNG(enums.Collectibles.FIRECRACKER_ROSE)
    local randomChance = TSIL.Random.GetRandomFloat(0, 1, rng)
    local luckThershold = TSIL.Utils.Math.Clamp(0.10 + 0.04 * player.Luck, 0.05, 0.5)
    if randomChance >= luckThershold then return end

    MakeTearFirecrackerSeed(tear)
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_TEAR_INIT_LATE,
    FirecrackerRose.OnTearInit
)


---@param tear EntityTear
function FirecrackerRose:OnTearUpdate(tear)
    local tearPtr = GetPtrHash(tear)
    local petalTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PetalTears")

    if not petalTears[tearPtr] then return end

    local angle = tear.Velocity:GetAngleDegrees()
    tear.SpriteRotation = angle + 180
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_TEAR_UPDATE,
    FirecrackerRose.OnTearUpdate
)


---@param tear EntityTear
---@param collider Entity
local function OnFirecrackerTearCollision(tear, collider)
    local npc = collider:ToNPC()
    if not npc or not collider:IsVulnerableEnemy() then return end

    local player = TSIL.Players.GetPlayerFromEntity(tear)

    if player == nil then return end

    AddCrackered(npc, player)
end


---@param collider Entity
---@param targetPtr integer
local function OnPetalTearCollision(collider, targetPtr)
    local colliderPtr = GetPtrHash(collider)

    if colliderPtr == targetPtr then
        return true
    end
end


---@param tear EntityTear
---@param collider Entity
function FirecrackerRose:OnTearCollision(tear, collider)
    local tearPtr = GetPtrHash(tear)
    local firecrackerTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "FirecrackerTears")
    local petalTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PetalTears")

    if petalTears[tearPtr] then
        return OnPetalTearCollision(collider, petalTears[tearPtr])
    elseif firecrackerTears[tearPtr] then
        OnFirecrackerTearCollision(tear, collider)
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_PRE_TEAR_COLLISION,
    FirecrackerRose.OnTearCollision
)


---@param npc EntityNPC
function FirecrackerRose:OnNPCUpdate(npc)
    local npcPtr = GetPtrHash(npc)
    local crackeredEnemies = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "CrackeredEnemies")
    local crackerInfo = crackeredEnemies[npcPtr]

    if crackerInfo == nil then return end

    if crackerInfo.timer > 0 then
        crackerInfo.timer = crackerInfo.timer - 1

        ---@type Sprite
        local seedSpr = CrackerSeedSprites[npcPtr]

        seedSpr:Update()

        if crackerInfo.timer <= 30 * 3 and seedSpr:IsPlaying("SeedIdle") then
            seedSpr:Play("Bloom", true)
        end

        if seedSpr:IsFinished("Bloom") then
            seedSpr:Play("Idle")
        end

        return
    end

    CrackerSeedSprites[npcPtr] = nil

    npc.Color = Color(1, 1, 1)

    crackeredEnemies[npcPtr] = nil

    FirecrackerExplode(npc, TSIL.Players.GetPlayerByIndex(crackerInfo.source))
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_NPC_UPDATE,
    FirecrackerRose.OnNPCUpdate
)


---@param npc EntityNPC
function FirecrackerRose:OnNPCRender(npc)
    local npcPtr = GetPtrHash(npc)
    local crackeredEnemies = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "CrackeredEnemies")
    local crackerInfo = crackeredEnemies[npcPtr]

    if crackerInfo == nil then return end

    local rng = TSIL.RNG.NewRNG(npc.InitSeed)

    ---@type Sprite
    local seedSpr = CrackerSeedSprites[npcPtr]
    local renderPos = Isaac.WorldToScreen(npc.Position) - Vector(0, 10)
    seedSpr:Render(renderPos + Vector(TSIL.Random.GetRandomInt(-6, 6, rng), TSIL.Random.GetRandomInt(-2, 5, rng)))

    local colorAmount = math.abs(math.sin(npc.FrameCount * 0.1) * 0.6)
    local newColor = Color(1, 1, 1, 1, colorAmount)

    npc.Color = newColor
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_NPC_RENDER,
    FirecrackerRose.OnNPCRender
)


---@param entity Entity
function FirecrackerRose:OnEntityRemove(entity)
    if TSIL.Rooms.IsLeavingRoom() then return end

    local tear = entity:ToTear()
    if tear == nil then return end
    local tearPtr = GetPtrHash(tear)

    local petalTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PetalTears")

    if not petalTears[tearPtr] then return end

    petalTears[tearPtr] = nil

    local spawner = tear.SpawnerEntity
    if not spawner then return end
    local player = spawner:ToPlayer()
    if not player then return end

    local miniExplosion = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.BOMB_EXPLOSION,
        0,
        tear.Position
    )

    miniExplosion.SpriteScale = Vector(0.5, 0.5)

    local nearEnemies = Isaac.FindInRadius(entity.Position, 40, EntityPartition.ENEMY)

    for _, enemy in ipairs(nearEnemies) do
        enemy:TakeDamage(
            10 + 2 * player.Damage,
            DamageFlag.DAMAGE_EXPLOSION,
            EntityRef(player),
            -1
        )
    end

    SFXManager():Stop(SoundEffect.SOUND_EXPLOSION_STRONG)
    SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    FirecrackerRose.OnEntityRemove
)


---@param npc EntityNPC
---@param source EntityRef
function CheckForFirecrackerLaser(npc, source)
    if source.Type ~= EntityType.ENTITY_PLAYER then return end

    local player = source.Entity:ToPlayer()
    if not player:HasCollectible(enums.Collectibles.FIRECRACKER_ROSE) then return end

    local rng = player:GetCollectibleRNG(enums.Collectibles.FIRECRACKER_ROSE)

    local randomChance = TSIL.Random.GetRandomFloat(0, 1, rng)
    local luckThershold = TSIL.Utils.Math.Clamp(0.010 + 0.05 * player.Luck, 0.01, 0.5)

    if randomChance >= luckThershold then return end

    AddCrackered(npc, player)
end


---@param npc EntityNPC
---@param source EntityRef
function CheckForFirecrackerKnife(npc, source)
    if source.SpawnerType ~= EntityType.ENTITY_PLAYER then return end

    local player = source.Entity.SpawnerEntity:ToPlayer()

    if not player:HasCollectible(enums.Collectibles.FIRECRACKER_ROSE) then return end

    local rng = player:GetCollectibleRNG(enums.Collectibles.FIRECRACKER_ROSE)

    local randomChance = TSIL.Random.GetRandomFloat(0, 1, rng)
    local luckThershold = TSIL.Utils.Math.Clamp(0.05 + 0.02 * player.Luck, 0.01, 0.5)

    if randomChance >= luckThershold then return end

    AddCrackered(npc, player)
end


---@param entity Entity
---@param flags integer
---@param source EntityRef
function FirecrackerRose:OnEntityDamage(entity, _, flags, source)
    local npc = entity:ToNPC()
    if not npc or not npc:IsVulnerableEnemy() then return end

    if TSIL.Utils.Flags.HasFlags(flags, DamageFlag.DAMAGE_LASER) then
        CheckForFirecrackerLaser(npc, source)
    elseif source.Type == EntityType.ENTITY_KNIFE then
        CheckForFirecrackerKnife(npc, source)
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    FirecrackerRose.OnEntityDamage
)


---@param bone EntityKnife
function FirecrackerRose:OnBoneSwing(bone)
    local spawner = bone.SpawnerEntity
    if spawner == nil then return end

    local player = spawner:ToPlayer()
    if not player then return end
    if not player:HasCollectible(enums.Collectibles.FIRECRACKER_ROSE) then return end

    local rng = player:GetCollectibleRNG(enums.Collectibles.FIRECRACKER_ROSE)
    local randomChance = TSIL.Random.GetRandomFloat(0, 1, rng)
    local luckThershold = TSIL.Utils.Math.Clamp(0.15 + 0.05 * player.Luck, 0.02, 0.5)
    if randomChance >= luckThershold then return end

    local tearVelocity = TSIL.Direction.DirectionToVector(player:GetFireDirection())
    tearVelocity = tearVelocity * 7 * player.ShotSpeed
    tearVelocity = tearVelocity + player.Velocity

    local tear = player:FireTear(
        bone.Position,
        tearVelocity,
        true,
        false,
        false,
        player
    )

    tear.FallingAcceleration = player.TearFallingAcceleration
    tear.FallingSpeed = player.TearFallingSpeed
    MakeTearFirecrackerSeed(tear)
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_BONE_SWING,
    FirecrackerRose.OnBoneSwing
)