local GlobinInABucket = {}
local enums = MilkshakeVol1.enums


---@class GlobinInfo
---@field anm2 any
---@field anim any
---@field type any
---@field variant any
---@field subtype any

local GLOBIN_LIMIT = 4
local SPECIAL_GLOBIN_CHANCE = 0.33
---@type table<BackdropType, GlobinInfo[]>
local GLOBINS_PER_BACKDROP = {}
---@type GlobinInfo
local DEFAULT_GLOBIN_INFO = {
    anm2 = "gfx/effect_globin_bucket.anm2",
    anim = "globin",
    type = EntityType.ENTITY_GLOBIN,
    variant = TSIL.Enums.GlobinVariant.GLOBIN,
    subtype = 0
}


---Adds a special globin for the Globin In a Bucket to spawn.
---@param anm2 string
---@param anim string
---@param globinType EntityType
---@param globinVariant integer
---@param globinSubtype integer
---@param ... BackdropType The backdrops where it can spawn
function MilkshakeVol1.API:AddSpecialGlobin(anm2, anim, globinType, globinVariant, globinSubtype, ...)
    local globinInfo = {
        anm2 = anm2,
        anim = anim,
        type = globinType,
        variant = globinVariant,
        subtype = globinSubtype
    }

    local backdrops = {...}
    for _, backdrop in ipairs(backdrops) do
        local globins = GLOBINS_PER_BACKDROP[backdrop]
        if not globins then
            globins = {}
            GLOBINS_PER_BACKDROP[backdrop] = globins
        end

        globins[#globins+1] = globinInfo
    end
end

MilkshakeVol1.API:AddSpecialGlobin(
    "gfx/effect_globin_bucket.anm2",
    "gazing_globin",
    EntityType.ENTITY_GLOBIN,
    TSIL.Enums.GlobinVariant.GAZING_GLOBIN,
    0,
    BackdropType.CAVES,
    BackdropType.CATACOMBS,
    BackdropType.FLOODED_CAVES
)

MilkshakeVol1.API:AddSpecialGlobin(
    "gfx/effect_globin_bucket.anm2",
    "dank_globin",
    EntityType.ENTITY_GLOBIN,
    TSIL.Enums.GlobinVariant.DANK_GLOBIN,
    0,
    BackdropType.DANK_DEPTHS
)

MilkshakeVol1.API:AddSpecialGlobin(
    "gfx/effect_globin_bucket.anm2",
    "cursed_globin_mausoleum",
    EntityType.ENTITY_GLOBIN,
    TSIL.Enums.GlobinVariant.CURSED_GLOBIN,
    0,
    BackdropType.MAUSOLEUM_ENTRANCE,
    BackdropType.MAUSOLEUM,
    BackdropType.MAUSOLEUM2,
    BackdropType.MAUSOLEUM3,
    BackdropType.MAUSOLEUM4
)

MilkshakeVol1.API:AddSpecialGlobin(
    "gfx/effect_globin_bucket.anm2",
    "cursed_globin_gehenna",
    EntityType.ENTITY_GLOBIN,
    TSIL.Enums.GlobinVariant.CURSED_GLOBIN,
    0,
    BackdropType.GEHENNA
)


---@param effect EntityEffect
---@return GlobinInfo
local function GetGlobinEffectInfo(effect)
    local rng = TSIL.RNG.NewRNG(effect.InitSeed)
    local backdrop = Game():GetRoom():GetBackdropType()

    local specialGlobins = GLOBINS_PER_BACKDROP[backdrop]

    if rng:RandomFloat() >= SPECIAL_GLOBIN_CHANCE
    or not specialGlobins
    or #specialGlobins == 0 then
        return DEFAULT_GLOBIN_INFO
    end

    return TSIL.Random.GetRandomElementsFromTable(specialGlobins, 1, rng)[1]
end


---@param rng RNG
---@param player EntityPlayer
function GlobinInABucket:OnGlobinBucketUse(_, rng, player)
    if not player then return end
    local globins = Isaac.FindByType(EntityType.ENTITY_EFFECT, enums.Effects.GLOBIN_IN_A_BUCKET)
    local count = 0
    for i = 1, #globins do
        if GetPtrHash(globins[i].SpawnerEntity) == GetPtrHash(player) then
            count = count + 1
        end
    end

    local globinEffects = Isaac.FindByType(EntityType.ENTITY_GLOBIN)
    for i = 1, #globinEffects do
        if GetPtrHash(globinEffects[i].SpawnerEntity) == GetPtrHash(player) then
            count = count + 1
        end
    end
    
    if count >= GLOBIN_LIMIT then return end


    local velX = TSIL.Random.GetRandomFloat(-7, 7, rng)
    local velY = TSIL.Random.GetRandomFloat(-7, 7, rng)
    local spawningVelocity = Vector(velX, velY)

    TSIL.EntitySpecific.SpawnEffect(
        enums.Effects.GLOBIN_IN_A_BUCKET,
        0,
        player.Position,
        spawningVelocity,
        player,
        rng
    )

    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, GlobinInABucket.OnGlobinBucketUse, enums.Collectibles.GLOBIN_IN_A_BUCKET)


---@param entity EntityEffect
function GlobinInABucket:onGlobinEffectInit(entity)
    local sprite = entity:GetSprite()

    local globinInfo = GetGlobinEffectInfo(entity)

    sprite:Load(globinInfo.anm2, true)
    sprite:Play(globinInfo.anim, true)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_INIT,
    GlobinInABucket.onGlobinEffectInit,
    enums.Effects.GLOBIN_IN_A_BUCKET
)


---@param effect EntityEffect
local function IsEffectCollidingWithGrid(effect)
    local room = Game():GetRoom()
    local gridOffset = Vector(40, 0)

    for angle = 0, 359, 90 do
        gridOffset = gridOffset:Rotated(angle)
        local gridPos = effect.Position + gridOffset
        local gridColl = room:GetGridCollisionAtPos(gridPos)

        if gridColl ~= GridCollisionClass.COLLISION_NONE then
            local gridIndex = room:GetGridIndex(gridPos)
            local clampedPos = room:GetGridPosition(gridIndex)

            local intersecting = TSIL.Utils.Math.IsCircleIntersectingWithRectangle(
                clampedPos,
                Vector(40, 40),
                effect.Position,
                30
            )

            if intersecting then
                return true
            end
        end
    end

    return false
end


---@param entity EntityEffect
function GlobinInABucket:onNPCUpdate(entity)
    local player = TSIL.Players.GetPlayerFromEntity(entity)
    if not player then
        entity:Remove()
        return
    end

    if not TSIL.Vector.VectorFuzzyEquals(entity.Velocity, Vector.Zero)
    and IsEffectCollidingWithGrid(entity) then
        entity.Velocity = Vector.Zero
    end

    local sprite = entity:GetSprite()

    local globinInfo = GetGlobinEffectInfo(entity)

    if sprite:IsEventTriggered("DropSound") then
        entity.Velocity = entity.Velocity*0
    elseif sprite:IsFinished(globinInfo.anim) then
        local globin = TSIL.EntitySpecific.SpawnNPC(
            globinInfo.type,
            globinInfo.variant,
            globinInfo.subtype,
            entity.Position,
            Vector.Zero,
            player
        )

        globin:AddCharmed(EntityRef(player), -1)
        globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        globin.State = NpcState.STATE_IDLE
        globin:GetSprite():Play("ReGen", true)

        entity:Remove()
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, GlobinInABucket.onNPCUpdate, enums.Effects.GLOBIN_IN_A_BUCKET)