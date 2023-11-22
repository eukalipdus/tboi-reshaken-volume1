local rockOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local LONG_ROOM_GRID_SIZE = 252
local NORMAL_MIN = 5
local NORMAL_MAX = 6
local BIG_MIN = 7
local BIG_MAX = 9
local KILL_FRAME = 7
local KILL_RADIUS = 40
local SHAKE_TIMEOUT = 25
local STALAGMITE_DMG = 200
local PILLAR_TARGETS = 2
local TINTED_TARGETS = 1
local BASE_BOSS_DAMAGE = 50

local floorRockSprites = {
    ["???"] = "gfx/grid/terrastrium_spike_bluewomb.png",
    ["Burning Basement"] = "gfx/grid/terrastrium_spike_burningbasement.png",
    ["Catacombs"] = "gfx/grid/terrastrium_spike_catacombs.png",
    ["Cathedral"] = "gfx/grid/terrastrium_spike_cathedral.png",
    ["Caves"] = "gfx/grid/terrastrium_spike_caves.png",
    ["Cellar"] = "gfx/grid/terrastrium_spike_cellar.png",
    ["Corpse"] = "gfx/grid/terrastrium_spike_corpse.png",
    ["Depths"] = "gfx/grid/terrastrium_spike_depths.png",
    ["Downpour"] = "gfx/grid/terrastrium_spike_downpour.png",
    ["Dross"] = "gfx/grid/terrastrium_spike_dross.png",
    ["Flooded Caves"] = "gfx/grid/terrastrium_spike_floodedcaves.png",
    ["Gehenna"] = "gfx/grid/terrastrium_spike_gehenna.png",
    ["Mausoleum"] = "gfx/grid/terrastrium_spike_mausoleum.png",
    ["Mines"] = "gfx/grid/terrastrium_spike_mines.png",
    ["Scarred Womb"] = "gfx/grid/terrastrium_spike_scarredwomb.png",
    ["Secret"] = "gfx/grid/terrastrium_spike_secretroom.png",
    ["Sheol"] = "gfx/grid/terrastrium_spike_sheol.png",
    ["Utero"] = "gfx/grid/terrastrium_spike_utero.png",
    ["Womb"] = "gfx/grid/terrastrium_spike_womb.png",

}

local function SetStalagmiteInfo(stalagmite, stageName, forcePosition)
    if forcePosition then
        utility:SetData(stalagmite, "ForcePosition", forcePosition)
    end
    stalagmite.CollisionDamage = 0
    stalagmite.GridCollisionClass = GridCollisionClass.COLLISION_NONE
    local sprite = stalagmite:GetSprite()
    local spritePath = floorRockSprites[stageName]
    if stageName ~= "Basement" then
        local roomType = Game():GetRoom():GetType()

        if roomType == RoomType.ROOM_SECRET
        or roomType == RoomType.ROOM_SUPERSECRET then
            spritePath = floorRockSprites["Secret"]
        end
        sprite:ReplaceSpritesheet(1, spritePath)
        sprite:LoadGraphics()
    end
    sprite:Play("Windup")
end

local function GetVulnerableEnemies()
    local enemies = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, true)
    enemies = TSIL.Utils.Tables.Filter(enemies, function (_, enemy)
        return enemy:IsVulnerableEnemy()
    end)
    return enemies
end

local function DelayedDestroyGridEntity(gridEntity, remove)
    TSIL.Utils.Functions.RunInFrames(function ()
        SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
        if remove then
            TSIL.GridEntities.RemoveGridEntity(gridEntity)
        else
            gridEntity:Destroy()
        end
    end, 10)
end

local function DelayedStalagmiteDamage(stalagmite)
    local enemies = GetVulnerableEnemies()
    TSIL.Utils.Functions.RunInFrames(function ()
        for _, enemy in ipairs(enemies) do
            if enemy.Type ~= enums.Enemies.STALAGMITE
            and (enemy.Position):Distance(stalagmite.Position) <= KILL_RADIUS then
                if enemy:IsBoss() then
                    enemy:TakeDamage(BASE_BOSS_DAMAGE + (BASE_BOSS_DAMAGE * utility:GetCurrentChapter()), 0, EntityRef(stalagmite), 0)
                else
                    enemy:Kill()
                end
            end
        end
    end, 10)
end

local function SpawnStalagmite(player, rng, isGrid, targetTable)
    local stalagmite
    if targetTable then
        local idxToRemove = TSIL.Random.GetRandomInt(1, #targetTable, rng)
        local target = targetTable[idxToRemove]
        stalagmite = TSIL.EntitySpecific.SpawnNPC(
            enums.Enemies.STALAGMITE,
            1,
            0,
            target.Position,
            Vector.Zero,
            player
        )
        stalagmite.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        utility:SetData(stalagmite, "TargetPosition", target.Position)
        if isGrid then
            DelayedDestroyGridEntity(target, true)
        end
        table.remove(targetTable, idxToRemove)
    else
        stalagmite = TSIL.EntitySpecific.SpawnNPC(
            enums.Enemies.STALAGMITE,
            1,
            0,
            Isaac.GetRandomPosition(),
            Vector.Zero,
            player
        )
    end
    return stalagmite
end

--- Spawns a random amount of stalagmite effects
---@param player EntityPlayer
---@param stageName string
local function SpawnRandomStalagmites(player, stageName, rng)
    local enemies = GetVulnerableEnemies()

    local blockAndPillarTargets = utility:TableConcat(TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKB),
                                                      TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_PILLAR)
                                                     )

    local tintedRockTargets = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT)

    local max
    local min
    if Game():GetRoom():GetGridSize() > LONG_ROOM_GRID_SIZE then
        min = BIG_MIN
        max = BIG_MAX
    else
        min = NORMAL_MIN
        max = NORMAL_MAX
    end

    local stalagmiteCount = TSIL.Random.GetRandomInt(min, max, rng)

    local numPillarBlockTargets = PILLAR_TARGETS
    if #blockAndPillarTargets < PILLAR_TARGETS then
        numPillarBlockTargets = #blockAndPillarTargets
    end

    local numEnemiesToTarget = stalagmiteCount - numPillarBlockTargets
    local numTintedRocksToTarget = 0

    if #tintedRockTargets > 0 then
        numEnemiesToTarget = numEnemiesToTarget - TINTED_TARGETS
        numTintedRocksToTarget = TINTED_TARGETS
    end

    for _ = 1, numPillarBlockTargets do
        local stalagmite = SpawnStalagmite(player, rng, true, blockAndPillarTargets)
        SetStalagmiteInfo(stalagmite, stageName, utility:GetData(stalagmite, "TargetPosition"))
    end

    for _ = 1, numTintedRocksToTarget do
        local stalagmite = SpawnStalagmite(player, rng, true, tintedRockTargets)
        SetStalagmiteInfo(stalagmite, stageName, utility:GetData(stalagmite, "TargetPosition"))
    end

    if numEnemiesToTarget > #enemies then
        numEnemiesToTarget = #enemies
    end
    for _ = 1, numEnemiesToTarget do
        local stalagmite = SpawnStalagmite(player, rng, false, enemies)
        SetStalagmiteInfo(stalagmite, stageName, utility:GetData(stalagmite, "TargetPosition"))
        DelayedStalagmiteDamage(stalagmite)
    end
    stalagmiteCount = ((stalagmiteCount - numEnemiesToTarget) - numPillarBlockTargets) - numTintedRocksToTarget
    
    for _ = 1, stalagmiteCount do
        local stalagmite = SpawnStalagmite(player, rng, false, nil)
        SetStalagmiteInfo(stalagmite, stageName, nil)
    end
end

function rockOrb:OnOrbUse(orb, player, _, isLyra)
    if orb ~= enums.Orbs.ROCK then return end

    Game():ShakeScreen(SHAKE_TIMEOUT)
    local stageName = Game():GetLevel():GetName()
    stageName = string.gsub(stageName, "I", "")
    stageName = string.gsub(stageName, " ", "")

    TSIL.Utils.Functions.RunInFrames(SpawnRandomStalagmites, 15, player, stageName, player:GetCardRNG(orb))
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, rockOrb.OnOrbUse)

function rockOrb:NpcUpdate(stalagmite)
    if stalagmite.Type ~= enums.Enemies.STALAGMITE then return end

    local forcePosition = utility:GetData(stalagmite, "ForcePosition")
    if forcePosition then
        stalagmite.Position = forcePosition
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, rockOrb.NpcUpdate)

function rockOrb:PostNpcDeath(stalagmite)
    if stalagmite.Variant ~= 1 then return end
    TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.ROCK_PARTICLE,
        0,
        stalagmite.Position,
        Vector.Zero,
        stalagmite
    )
    SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rockOrb.PostNpcDeath, enums.Enemies.STALAGMITE)

return rockOrb