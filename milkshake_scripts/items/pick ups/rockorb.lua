local rockOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local LONG_ROOM_GRID_SIZE = 252
local NORMAL_MIN = 4
local NORMAL_MAX = 5
local BIG_MIN = 7
local BIG_MAX = 9
local KILL_RADIUS = 40
local SHAKE_TIMEOUT = 25
local PILLAR_TARGETS = 2
local TINTED_TARGETS = 1
local BASE_BOSS_DAMAGE = 50
local WALL_MARGIN = 15
local TIMES_CAN_FAIL = 1000

local floorRockSprites = {
    [BackdropType.BLUE_WOMB] = "gfx/grid/terrastrium_spike_bluewomb.png",
    [BackdropType.BURNT_BASEMENT] = "gfx/grid/terrastrium_spike_burningbasement.png",
    [BackdropType.CATACOMBS] = "gfx/grid/terrastrium_spike_catacombs.png",
    [BackdropType.CATHEDRAL] = "gfx/grid/terrastrium_spike_cathedral.png",
    [BackdropType.CAVES] = "gfx/grid/terrastrium_spike_caves.png",
    [BackdropType.CELLAR] = "gfx/grid/terrastrium_spike_cellar.png",
    [BackdropType.CORPSE_ENTRANCE] = "gfx/grid/terrastrium_spike_corpse.png",
    [BackdropType.CORPSE] = "gfx/grid/terrastrium_spike_corpse.png",
    [BackdropType.DUNGEON_ROTGUT] = "gfx/grid/terrastrium_spike_corpse.png",
    [BackdropType.DEPTHS] = "gfx/grid/terrastrium_spike_depths.png",
    [BackdropType.NECROPOLIS] = "gfx/grid/terrastrium_spike_depths.png",
    [BackdropType.DANK_DEPTHS] = "gfx/grid/terrastrium_spike_depths.png",
    [BackdropType.DOWNPOUR_ENTRANCE] = "gfx/grid/terrastrium_spike_downpour.png",
    [BackdropType.DOWNPOUR] = "gfx/grid/terrastrium_spike_downpour.png",
    [BackdropType.DROSS] = "gfx/grid/terrastrium_spike_dross.png",
    [BackdropType.FLOODED_CAVES] = "gfx/grid/terrastrium_spike_floodedcaves.png",
    [BackdropType.GEHENNA] = "gfx/grid/terrastrium_spike_gehenna.png",
    [BackdropType.MAUSOLEUM_ENTRANCE] = "gfx/grid/terrastrium_spike_mausoleum.png",
    [BackdropType.MAUSOLEUM] = "gfx/grid/terrastrium_spike_mausoleum.png",
    [BackdropType.MAUSOLEUM2] = "gfx/grid/terrastrium_spike_mausoleum.png",
    [BackdropType.MAUSOLEUM3] = "gfx/grid/terrastrium_spike_mausoleum.png",
    [BackdropType.MAUSOLEUM4] = "gfx/grid/terrastrium_spike_mausoleum.png",
    [BackdropType.MINES_ENTRANCE] = "gfx/grid/terrastrium_spike_mines.png",
    [BackdropType.MINES] = "gfx/grid/terrastrium_spike_mines.png",
    [BackdropType.ASHPIT] = "gfx/grid/terrastrium_spike_mines.png",
    [BackdropType.ASHPIT_SHAFT] = "gfx/grid/terrastrium_spike_mines.png",
    [BackdropType.SCARRED_WOMB] = "gfx/grid/terrastrium_spike_scarredwomb.png",
    [BackdropType.SECRET] = "gfx/grid/terrastrium_spike_secretroom.png",
    [BackdropType.SHEOL] = "gfx/grid/terrastrium_spike_sheol.png",
    [BackdropType.UTERO] = "gfx/grid/terrastrium_spike_utero.png",
    [BackdropType.WOMB] = "gfx/grid/terrastrium_spike_womb.png",
}

local safeGridEntities = {
    GridEntityType.GRID_ROCK,
    GridEntityType.GRID_ROCKB,
    GridEntityType.GRID_ROCKT,
    GridEntityType.GRID_ROCK_BOMB,
    GridEntityType.GRID_ROCK_ALT,
    GridEntityType.GRID_LOCK,
    GridEntityType.GRID_TNT,
    GridEntityType.GRID_ROCK_SS,
    GridEntityType.GRID_PILLAR,
    GridEntityType.GRID_ROCK_SPIKED,
    GridEntityType.GRID_ROCK_ALT2,
    GridEntityType.GRID_ROCK_GOLD,
}

local removeRequired = {
    GridEntityType.GRID_ROCKB,
    GridEntityType.GRID_LOCK,
    GridEntityType.GRID_PILLAR,
}

local function GetRandomNonWallPosition()
    local attempts = 0
    local position
    while not position or not Game():GetRoom():IsPositionInRoom(position, WALL_MARGIN) do
        position = Isaac.GetRandomPosition()
        attempts = attempts + 1
        if attempts >= TIMES_CAN_FAIL then break end
    end
    return position
end

--- Changes the sprite of the stalagmite depending on the floor or room and sets various other members, and begins the Windup animation
---@param stalagmite Entity
---@param backdropType integer
---@param forcePosition Vector - A position that the stalagmite will be forced into every frame
local function SetStalagmiteInfo(stalagmite, backdropType, forcePosition)
    if forcePosition then
        utility:SetData(stalagmite, "ForcePosition", forcePosition)
    end
    stalagmite.CollisionDamage = 0
    stalagmite.GridCollisionClass = GridCollisionClass.COLLISION_NONE
    local sprite = stalagmite:GetSprite()
    local spritePath = floorRockSprites[backdropType]
    if spritePath then
        local roomType = Game():GetRoom():GetType()

        if roomType == RoomType.ROOM_SECRET
        or roomType == RoomType.ROOM_SUPERSECRET then
            spritePath = floorRockSprites[BackdropType.SECRET]
        end
        sprite:ReplaceSpritesheet(1, spritePath)
        sprite:LoadGraphics()
    end
    sprite:Play("Windup")
end

--- Returns a table of all the vulnerable enemies in the room
---@return table
local function GetEnemyTargets()
    local enemies = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, true)
    enemies = TSIL.Utils.Tables.Filter(enemies, function (_, enemy)
        return enemy:IsEnemy() and enemy.Type ~= enums.Enemies.STALAGMITE and Game():GetRoom():IsPositionInRoom(enemy.Position, WALL_MARGIN)
    end)
    return enemies
end

--- Destroys a given grid entity 10 frames after being called
---@param gridEntity GridEntity
---@param remove boolean - If true, calls Remove instead of Destroy on gridEntity
local function DelayedDestroyGridEntity(gridEntity, remove)
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        if remove then
            TSIL.GridEntities.RemoveGridEntity(gridEntity)
        else
            gridEntity:Destroy()
        end
    end, 10)
end

--- Locates nearby GridEntities 
---@param stalagmite EntityNPC - The stalagmite to look from
local function DestroyNearbyGridEntities(stalagmite)
    local nearbyGridEntities = TSIL.GridEntities.GetGridEntities()
    for _, grid in ipairs(nearbyGridEntities) do
        local canDestroy = stalagmite.Position:Distance(grid.Position) <= (KILL_RADIUS * 1.4) and TSIL.Utils.Tables.IsIn(safeGridEntities, grid:GetType())
        if canDestroy
        and TSIL.Utils.Tables.IsIn(nearbyGridEntities, grid) then
            if TSIL.Utils.Tables.IsIn(removeRequired, grid) then
                TSIL.GridEntities.RemoveGridEntity(grid)
            elseif canDestroy then
                grid:Destroy()
            end
        end
    end
end

--- Kills enemies in range of the stalagmite and damages bosses in range, 10 frames after being called
---@param stalagmite Entity
local function DelayedStalagmiteDamage(stalagmite)
    local enemies = GetEnemyTargets()
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        for _, enemy in ipairs(enemies) do
            if enemy.Type ~= enums.Enemies.STALAGMITE
            and (enemy.Position):Distance(stalagmite.Position) <= KILL_RADIUS then
                if enemy:IsBoss() then
                    enemy:TakeDamage(BASE_BOSS_DAMAGE + (BASE_BOSS_DAMAGE * utility:GetCurrentChapter()), DamageFlag.DAMAGE_CRUSH, EntityRef(stalagmite), 0)
                else
                    enemy:Kill()
                    TSIL.Utils.Functions.RunInFramesTemporary(function () -- For globins, gapers, etc
                        enemy:Kill()
                    end, 5, {})
                end
            end
        end
        utility:SetData(stalagmite, "Target", nil)
    end, 10)
end

--- Spawns a stalagmite
---@param player EntityPlayer
---@param rng RNG
---@param isGrid boolean - Is it a GridEntity?
---@param targetTable table - Table of entities to randomly select a target from for the stalagmite
local function SpawnStalagmite(player, rng, isGrid, targetTable)
    local stalagmite
    if targetTable and #targetTable > 0 then
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
        if target.Type and target:IsEnemy() then
            utility:SetData(stalagmite, "Target", target)
        end
        if isGrid
        and target:GetType() == GridEntityType.GRID_ROCKT then
            DelayedDestroyGridEntity(target, false)
        elseif isGrid then
            DelayedDestroyGridEntity(target, true)
        end
        table.remove(targetTable, idxToRemove)
    else
        stalagmite = TSIL.EntitySpecific.SpawnNPC(
            enums.Enemies.STALAGMITE,
            1,
            0,
            GetRandomNonWallPosition(),
            Vector.Zero,
            player
        )
    end
    return stalagmite
end

--- Spawns a random amount of stalagmite NPCs
---@param player EntityPlayer
---@param backdropType integer - Must be within the floorRockSprites table declared at the top, if nil will default to Basement sprite
---@param rng RNG
---@param isLyra boolean - If true, Lyra's double effect is activated, if false it's not
local function SpawnSetStalagmites(player, backdropType, rng, isLyra)
    local enemies = GetEnemyTargets()

    local blockAndPillarTargets = utility:TableConcat(TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKB),
                                                      TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_PILLAR)
                                                     )

    local tintedRockTargets = utility:TableConcat(TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCKT),
                                                  TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_ROCK_SS)
                                                 )

    local max
    local min
    if Game():GetRoom():GetGridSize() > LONG_ROOM_GRID_SIZE then
        min = BIG_MIN
        max = BIG_MAX
    else
        min = NORMAL_MIN
        max = NORMAL_MAX
    end

    if isLyra then
        min = min * 2
        max = max * 2
    end

    local stalagmiteCount = TSIL.Random.GetRandomInt(min, max, rng)

    local numTintedRocksToTarget = 0
    local numPillarBlockTargets = PILLAR_TARGETS

    if #tintedRockTargets > 0 then
        stalagmiteCount = stalagmiteCount - TINTED_TARGETS
        numTintedRocksToTarget = TINTED_TARGETS
    end
   
    if #blockAndPillarTargets < PILLAR_TARGETS then
        numPillarBlockTargets = #blockAndPillarTargets
    elseif #blockAndPillarTargets == 0 then
        numPillarBlockTargets = 0
    end

    stalagmiteCount = stalagmiteCount - numPillarBlockTargets
    local remainingPillarBlocks = #blockAndPillarTargets - numPillarBlockTargets

    local enemiesToTarget
    if stalagmiteCount > #enemies then
        enemiesToTarget = #enemies
        stalagmiteCount = stalagmiteCount - enemiesToTarget
    else
        enemiesToTarget = stalagmiteCount
        stalagmiteCount = 0
    end

    while stalagmiteCount > 0 do
        remainingPillarBlocks = remainingPillarBlocks - 1
        numPillarBlockTargets = numPillarBlockTargets + 1
        stalagmiteCount = stalagmiteCount - 1
    end

    for _ = 1, numPillarBlockTargets do
        local stalagmite = SpawnStalagmite(player, rng, true, blockAndPillarTargets)
        SetStalagmiteInfo(stalagmite, backdropType, utility:GetData(stalagmite, "TargetPosition"))
    end

    for _ = 1, numTintedRocksToTarget do
        local stalagmite = SpawnStalagmite(player, rng, true, tintedRockTargets)
        SetStalagmiteInfo(stalagmite, backdropType, utility:GetData(stalagmite, "TargetPosition"))
    end

    for _ = 1, enemiesToTarget do
        local stalagmite = SpawnStalagmite(player, rng, false, enemies)
        SetStalagmiteInfo(stalagmite, backdropType, utility:GetData(stalagmite, "TargetPosition"))
        DelayedStalagmiteDamage(stalagmite)
    end

    for _ = 1, stalagmiteCount do
        local stalagmite = SpawnStalagmite(player, rng, false, nil)
        SetStalagmiteInfo(stalagmite, backdropType, nil)
    end
end

function rockOrb:OnOrbUse(orb, player, _, isLyra)
    if orb ~= enums.Orbs.ROCK then return end

    Game():ShakeScreen(SHAKE_TIMEOUT)
    local backdropType = Game():GetRoom():GetBackdropType()

    TSIL.Utils.Functions.RunInFramesTemporary(SpawnSetStalagmites, 15, player, backdropType, player:GetCardRNG(orb), isLyra)
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
    end, 30)
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, rockOrb.OnOrbUse)

function rockOrb:NpcUpdate(stalagmite)
    if stalagmite.Type ~= enums.Enemies.STALAGMITE then return end

    if not stalagmite:GetSprite():IsPlaying("Windup") then
        DestroyNearbyGridEntities(stalagmite)
    end

    local forcePosition = utility:GetData(stalagmite, "ForcePosition")
    local target = utility:GetData(stalagmite, "Target")

    if target and not target:IsDead() then
        stalagmite.Position = target.Position
    elseif forcePosition then
        stalagmite.Position = forcePosition
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, rockOrb.NpcUpdate)

function rockOrb:PostNpcDeath(stalagmite)
    if stalagmite.Variant ~= enums.GravestoneType.TERRA then return end
    TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.ROCK_PARTICLE,
        0,
        stalagmite.Position,
        Vector.Zero,
        stalagmite
    ):Update()
    SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, rockOrb.PostNpcDeath, enums.Enemies.STALAGMITE)

return rockOrb