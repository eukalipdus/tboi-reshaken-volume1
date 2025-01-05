local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local DOWNGRADE_CHANCE = 20
local SHIFT_RIGHT = 40
local SHIFT_LEFT = -40
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220 / 255, 1, 0, 0, 0)
local SHATTERED_COLOR_FRAMES = 30
local PRIORITY = 2
local DOWNGRADE_COOLDOWN = 90

local nextEnemiesSplit = 0

---Spawns a devolved enemy by using a D10 wisp to force devolving the enemy
---@param player EntityPlayer
---@param baseEnemy Entity
---@param position Vector
local function SpawnDowngrade(player, baseEnemy, position)
    local newEnemy = TSIL.EntitySpecific.SpawnNPC(
        baseEnemy.Type,
        baseEnemy.Variant,
        baseEnemy.SubType,
        position,
        Vector.Zero,
        baseEnemy
    )

    local baseEnemyHPPercent = baseEnemy.HitPoints / baseEnemy.MaxHitPoints
    newEnemy.HitPoints = baseEnemyHPPercent * newEnemy.MaxHitPoints * 0.75

    utility:DevolveEnemy(player, newEnemy)
end

---Remove an enemy and spawn two devolved versions of itself, also changing their colors temporarily
---@param enemy Entity
---@param player EntityPlayer
function MilkshakeVol1.API.SplitEnemy(enemy, player, ignoreCooldown)
    if utility:GetData(enemy, "PrismaticHasSplit")
    or (not ignoreCooldown and utility:GetData(player, "LocustSplit"))
    or not enemy:IsVulnerableEnemy()
    or enemy:IsBoss() then
        return
    end

    if REPENTOGON then
        local entry = XMLData.GetEntryFromEntity(enemy, true, true)
        local entityIdString = tostring(enemy.Type) .. "." .. tostring(enemy.Variant) .. "." .. tostring(enemy.SubType)

        if entry.devolve[1].id == nil
        or entry.devolve[1].id == entityIdString then
            return
        end
    end

    if not ignoreCooldown then
        utility:SetData(player, "LocustSplit", true)
    end

    nextEnemiesSplit = 2

    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
        enemy:Remove()
        SpawnDowngrade(player, enemy, Isaac.GetFreeNearPosition(enemy.Position, SHIFT_LEFT))
        SpawnDowngrade(player, enemy, Isaac.GetFreeNearPosition(enemy.Position, SHIFT_RIGHT))
    end, 1)

    TSIL.Utils.Functions.RunInFrames(function ()
        utility:SetData(player, "LocustSplit", false)
    end, DOWNGRADE_COOLDOWN)
end

---@param npc EntityNPC
function prismaticDice:NpcUpdate(npc)
    if nextEnemiesSplit > 0 then

        if nextEnemiesSplit == 2 then
            npc:SetColor(PINK, SHATTERED_COLOR_FRAMES, PRIORITY, false, false)
        else
            npc:SetColor(CYAN, SHATTERED_COLOR_FRAMES, PRIORITY, false, false)
        end

        nextEnemiesSplit = nextEnemiesSplit - 1
        utility:SetData(npc, "PrismaticHasSplit", true)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, prismaticDice.NpcUpdate)

---@param entity Entity
---@param source Entity
function prismaticDice:EntityTakeDmg(entity, _, _, source)
    if not source.Entity
    or entity:IsBoss()
    or not entity:IsVulnerableEnemy() then
        return
    end

    local sourceEntity = source.Entity
    local isPrismaticLocust = sourceEntity.Type == EntityType.ENTITY_FAMILIAR
                              and sourceEntity.Variant == FamiliarVariant.ABYSS_LOCUST
                              and sourceEntity.SubType == enums.Collectibles.PRISMATIC_DICE

    if utility:GetData(sourceEntity, "ShouldSplitDowngrade") then
        local player = utility:GetPlayerFromTear(sourceEntity)

        if not player then
            return
        end

        if sourceEntity.Type == EntityType.ENTITY_TEAR then
            MilkshakeVol1.API.SplitEnemy(entity, player, true)
        else
            MilkshakeVol1.API.SplitEnemy(entity, player)
        end

    elseif isPrismaticLocust then
        local familiar = sourceEntity:ToFamiliar()

        if not familiar then
            return
        end

        local player = familiar.Player
        local rng = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE)
        local roll = TSIL.Random.GetRandomInt(1, 100, rng)
        if roll <= DOWNGRADE_CHANCE
        and not utility:GetData(player, "LocustSplit") then
            MilkshakeVol1.API.SplitEnemy(entity, player)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, prismaticDice.EntityTakeDmg)