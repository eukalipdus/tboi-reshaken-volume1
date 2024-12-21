local PrismaticLacewing = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local CHANCE_TEAR = 100--5
local CHANCE_FETUS = 10
local EXPLOSION_RADIUS = 40
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220/255, 1, 0, 0, 0)
local LERP_AMOUNT = 0.1
local LERP_PINK = 1
local LERP_CYAN = 2
local EPSILON = 0.01

---Sets an entity to lerp between cyan and pink
---@param entity any
local function PrismaticColorLerpBegin(entity)
    utility:SetData(entity, "ShouldSplitDowngrade", true)
    entity.Color = CYAN
    utility:SetData(entity, "PrismaticLacewingLerpType", LERP_PINK)
end

---Updates the color lerping for a given entity
---@param entity any
local function PrismaticColorLerpUpdate(entity)
    local originalColor = entity.Color
    local newR, newG, newB

    if utility:GetData(entity, "PrismaticLacewingLerpType") == LERP_PINK then
        newR = TSIL.Utils.Math.Lerp(originalColor.R, PINK.R, LERP_AMOUNT)
        newG = TSIL.Utils.Math.Lerp(originalColor.G, PINK.G, LERP_AMOUNT)
        newB = TSIL.Utils.Math.Lerp(originalColor.B, PINK.B, LERP_AMOUNT)

        if utility:MaybeEqual(originalColor.R, newR, EPSILON)
        and utility:MaybeEqual(originalColor.G, newG, EPSILON)
        and utility:MaybeEqual(originalColor.B, newB, EPSILON) then
            utility:SetData(entity, "PrismaticLacewingLerpType", LERP_CYAN)
        end

    elseif utility:GetData(entity, "PrismaticLacewingLerpType") == LERP_CYAN then
        newR = TSIL.Utils.Math.Lerp(originalColor.R, CYAN.R, LERP_AMOUNT)
        newG = TSIL.Utils.Math.Lerp(originalColor.G, CYAN.G, LERP_AMOUNT)
        newB = TSIL.Utils.Math.Lerp(originalColor.B, CYAN.B, LERP_AMOUNT)

        if utility:MaybeEqual(originalColor.R, newR, EPSILON)
        and utility:MaybeEqual(originalColor.G, newG, EPSILON)
        and utility:MaybeEqual(originalColor.B, newB, EPSILON) then
            utility:SetData(entity, "PrismaticLacewingLerpType", LERP_PINK)
        end
    else
        return
    end
    entity.Color = Color(newR, newG, newB, entity.Color.A)
end

---Calculates and returns the chance for Prismatic Lacewing to activate
---@param player EntityPlayer
---@param baseOdds number
---@return boolean
local function ShouldActivate(player, baseOdds)
    local rng = player:GetTrinketRNG(enums.Trinkets.PRISMATIC_LACEWING)
    local chance = baseOdds * player:GetTrinketMultiplier(enums.Trinkets.PRISMATIC_LACEWING)
    return TSIL.Random.GetRandomInt(1, 100, rng) <= chance
end

---Used for the Dr. Fetus and Epic Fetus synergy
---@param player EntityPlayer
---@param entity Entity
local function ExplosionDevolve(player, entity)
    if not ShouldActivate(player, CHANCE_FETUS) then
        return
    end

    local explosionEffect = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.BOMB_EXPLOSION,
        0,
        entity.Position,
        Vector.Zero,
        entity
    )

    local rng = player:GetTrinketRNG(enums.Trinkets.PRISMATIC_LACEWING)
    local roll = TSIL.Random.GetRandomInt(0, 1, rng)

    if roll == 0 then
        explosionEffect.Color = CYAN
    else
        explosionEffect.Color = PINK
    end

    local radius = EXPLOSION_RADIUS

    if entity.Type == EntityType.ENTITY_BOMB then
        local bomb = entity:ToBomb()

        if not bomb then
            return
        end

        radius = radius * bomb.RadiusMultiplier
    end

    local nearEnemies = Isaac.FindInRadius(
        entity.Position,
        radius,
        EntityPartition.ENEMY
    )

    nearEnemies = TSIL.Utils.Tables.Filter(nearEnemies, function (_, enemy)
        return enemy:IsVulnerableEnemy() and not enemy:IsBoss()
    end)

    for _, curEnemy in pairs(nearEnemies) do
        MilkshakeVol1.API.SplitEnemy(curEnemy, player)
    end
end

---@param tear EntityTear
function PrismaticLacewing:PostFireTear(tear)
    local player = utility:GetPlayerFromTear(tear)

    if not player
    or not player:HasTrinket(enums.Trinkets.PRISMATIC_LACEWING) then
        return
    end

    if ShouldActivate(player, CHANCE_TEAR) then
        PrismaticColorLerpBegin(tear)
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    PrismaticLacewing.PostFireTear
)

---@param tear EntityTear
function PrismaticLacewing:PostTearUpdate(tear)
    PrismaticColorLerpUpdate(tear)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_TEAR_UPDATE,
    PrismaticLacewing.PostTearUpdate
)

---@param entity Entity
---@param flags DamageFlag
---@param source Entity
function PrismaticLacewing:OnEntityDamage(entity, _, flags, source)
    local npc = entity:ToNPC()

    if not npc
    or not npc:IsVulnerableEnemy() then
        return
    end

    if TSIL.Utils.Flags.HasFlags(flags, DamageFlag.DAMAGE_LASER) then
        if not source.Entity
        or source.Type ~= EntityType.ENTITY_PLAYER then
            return
        end

        local player = TSIL.Players.GetPlayerFromEntity(source.Entity)

        if not player
        or not player:HasTrinket(enums.Trinkets.PRISMATIC_LACEWING) then
            return
        end

        if ShouldActivate(player, CHANCE_TEAR) then
            MilkshakeVol1.API.SplitEnemy(entity, player)
        end

    elseif source.Type == EntityType.ENTITY_KNIFE then
        if source.SpawnerType ~= EntityType.ENTITY_PLAYER
        or not source.Entity then
            return
        end

        local player = source.Entity.SpawnerEntity:ToPlayer()

        if not player
        or not player:HasTrinket(enums.Trinkets.PRISMATIC_LACEWING) then
            return
        end

        if ShouldActivate(player, CHANCE_TEAR) then
            MilkshakeVol1.API.SplitEnemy(entity, player)
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    PrismaticLacewing.OnEntityDamage
)

---@param bomb EntityBomb
function PrismaticLacewing:PostBombExploded(bomb)
    if not bomb.IsFetus
    or not bomb.SpawnerEntity then
        return
    end

    local player = bomb.SpawnerEntity:ToPlayer()

    if not player
    or not player:HasTrinket(enums.Trinkets.PRISMATIC_LACEWING) then
        return
    end

    ExplosionDevolve(player, bomb)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_BOMB_EXPLODED,
    PrismaticLacewing.PostBombExploded
)

---@param effect EntityEffect
function PrismaticLacewing:PostEntityRemove(effect)
    if effect.Variant ~= EffectVariant.ROCKET
    or not effect.SpawnerEntity then
        return
    end

    local player = effect.SpawnerEntity:ToPlayer()

    if not player
    or not player:HasTrinket(enums.Trinkets.PRISMATIC_LACEWING) then
        return
    end

    ExplosionDevolve(player, effect)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    PrismaticLacewing.PostEntityRemove,
    EntityType.ENTITY_EFFECT
)