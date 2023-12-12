local game = Game()
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local RockWheel = {}

local SPEED_BONUS = 0.1
local STONEY_COLLISION_DAMAGE = 4
local BASE_TARGET_SEARCH_RADIUS = 120

local LINECHECK_MODE_HIT_OBSTACLES_ONLY = 3

local GRIMACES = TSIL.Utils.Tables.ConstructDictionaryFromTable({
    EntityType.ENTITY_STONEHEAD,
    EntityType.ENTITY_CONSTANT_STONE_SHOOTER,
    EntityType.ENTITY_BRIMSTONE_HEAD,
    EntityType.ENTITY_GAPING_MAW,
    EntityType.ENTITY_BROKEN_GAPING_MAW,
    EntityType.ENTITY_QUAKE_GRIMACE,
    EntityType.ENTITY_STONEY,
})

---@param npc EntityNPC
---@param searchRadius number
local function FindEnemyTarget(npc, searchRadius)
    local room = game:GetRoom()
    local closestDistance
    local closest
    for _, entity in ipairs(Isaac.FindInRadius(npc.Position, searchRadius, EntityPartition.ENEMY)) do
        if not (
            entity:IsActiveEnemy(false)
            and entity:IsVulnerableEnemy()
            and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)
            and room:CheckLine(npc.Position, entity.Position, LINECHECK_MODE_HIT_OBSTACLES_ONLY)
        ) then
            goto continue
        end
        if not closest or npc.Position:DistanceSquared(entity.Position) < closestDistance then
            closest = entity
            closestDistance = npc.Position:DistanceSquared(entity.Position)
        end
        ::continue::
    end
    npc.Target = closest
end

---@param npc EntityNPC
function RockWheel:NPCInit(npc)
    if not GRIMACES[npc.Type] then
        return
    end
    if not TSIL.Players.DoesAnyPlayerHasTrinket(enums.Trinkets.ROCK_WHEEL) then
        return
    end

    npc:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    utility:SetData(npc, "HasRockWheelCharm", true)
    npc.CollisionDamage = STONEY_COLLISION_DAMAGE
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_INIT, RockWheel.NPCInit)

---@param player EntityPlayer
---@param flag CacheFlag
function RockWheel:EvaluateCache(player, flag)
    if player:HasTrinket(enums.Trinkets.ROCK_WHEEL) then
        player.MoveSpeed = player.MoveSpeed + SPEED_BONUS * player:GetTrinketMultiplier(enums.Trinkets.ROCK_WHEEL)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, RockWheel.EvaluateCache, CacheFlag.CACHE_SPEED)

---@param projectile EntityProjectile
function RockWheel:PostProjectileInit(projectile)
    local spawner = projectile.SpawnerEntity
    if not(spawner and (spawner.Type == EntityType.ENTITY_CONSTANT_STONE_SHOOTER or spawner.Type == EntityType.ENTITY_STONEHEAD)) then
        return
    end
    if not (spawner:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and utility:GetData(spawner, "HasRockWheelCharm")) then
        return
    end
    projectile:AddProjectileFlags(ProjectileFlags.HIT_ENEMIES)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, RockWheel.PostProjectileInit)

---@param npc EntityNPC
function RockWheel:PostNPCUpdate(npc)
    if not (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and utility:GetData(npc, "HasRockWheelCharm")) then
        return
    end
    if npc.Target == nil
    or npc.Target:IsDead()
    or npc.Target.Type == EntityType.ENTITY_PLAYER
    or npc.Position:DistanceSquared(npc.Target.Position) > BASE_TARGET_SEARCH_RADIUS^2
    or not game:GetRoom():CheckLine(npc.Position, npc.Target.Position, LINECHECK_MODE_HIT_OBSTACLES_ONLY)
    then
        FindEnemyTarget(npc, BASE_TARGET_SEARCH_RADIUS)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, RockWheel.PostNPCUpdate, EntityType.ENTITY_STONEHEAD)
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, RockWheel.PostNPCUpdate, EntityType.ENTITY_STONEY)

return RockWheel