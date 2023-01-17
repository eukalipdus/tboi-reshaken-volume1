local FirecrackerRose = {}
local enums = require("milkshake_scripts.enums")

TSIL.SaveManager.AddPersistentVariable(milkshakeMod, "FirecrackerTears", {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM)
TSIL.SaveManager.AddPersistentVariable(milkshakeMod, "CrackeredEnemies", {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM)
TSIL.SaveManager.AddPersistentVariable(milkshakeMod, "PetalTears", {}, TSIL.Enums.VariablePersistenceMode.RESET_ROOM)


---@param npc EntityNPC
---@param source EntityPlayer?
local function FirecrackerExplode(npc, source)
    if source == nil then return end

    Isaac.Explode(npc.Position, source, 50)

    local npcPtr = GetPtrHash(npc)
    local petalTears = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "PetalTears")

    local rng = TSIL.RNG.NewRNG(npc.InitSeed)
    local numTears = 5 + rng:RandomInt(3)

    for _ = 1, numTears, 1 do
        local velocity = Vector.FromAngle(rng:RandomInt(360)):Resized(7 * source.ShotSpeed)

        local tear = source:FireTear(npc.Position, velocity, false, true, false, source, (1/source.Damage) * 5)
        tear.FallingSpeed = tear.FallingSpeed * (4.5 + TSIL.Random.GetRandomFloat(0, 1.5, rng))

        local tearPtr = GetPtrHash(tear)
        petalTears[tearPtr] = npcPtr
    end
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
    local luckThershold = TSIL.Utils.Math.Clamp(0.15 + 0.05 * player.Luck, 0.02, 0.5)
    if randomChance >= luckThershold then return end

    local newColor = Color(1, 1, 1, 1, 1)
    tear.Color = newColor

    TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "FirecrackerTears")[tearPtr] = true
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_TEAR_INIT_LATE,
    FirecrackerRose.OnTearInit
)


---@param tear EntityTear
---@param collider Entity
local function OnFirecrackerTearCollision(tear, collider)
    if not collider:ToNPC() or not collider:IsVulnerableEnemy() then return end

    local player = TSIL.Players.GetPlayerFromEntity(tear)

    if player == nil then return end

    local colliderPtr = GetPtrHash(collider)
    local crackeredEnemies = TSIL.SaveManager.GetPersistentVariable(milkshakeMod, "CrackeredEnemies")

    if crackeredEnemies[colliderPtr] ~= nil then return end

    crackeredEnemies[colliderPtr] = {
        timer = 30 * 5,
        source = TSIL.Players.GetPlayerIndex(player)
    }
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
        return
    end

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

    local miniExplosion = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.BOMB_EXPLOSION,
        0,
        tear.Position
    ):ToEffect()

    miniExplosion.SpriteScale = Vector(0.5, 0.5)

    SFXManager():Stop(SoundEffect.SOUND_EXPLOSION_STRONG)
    SFXManager():Play(SoundEffect.SOUND_EXPLOSION_WEAK)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    FirecrackerRose.OnEntityRemove
)