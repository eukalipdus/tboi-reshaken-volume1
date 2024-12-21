local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local DOWNGRADE_CHANCE = 20
local SHIFT_RIGHT = 40
local SHIFT_LEFT = -40
local CYAN = Color(0, 1, 1, 1, 0, 0, 0) -- Should move these colors to enums
local PINK = Color(1, 0, 220 / 255, 1, 0, 0, 0)
local SOLID_CYAN = Color(0, 1, 1, 1, 0, 255, 255)
local SOLID_PINK = Color(1, 192 / 255, 203 / 255, 1, 255, 192 / 255, 203 / 255)
local SHATTERED_SOLID_FRAMES = 7
local SHATTERED_COLOR_FRAMES = 30
local PRIORITY = 2
local DOWNGRADE_COOLDOWN = 90

local function SpawnDowngrade(player, baseEnemy, position, solidColor, color)
    local newEnemy = TSIL.EntitySpecific.SpawnNPC(
        baseEnemy.Type,
        baseEnemy.Variant,
        baseEnemy.SubType,
        position,
        Vector.Zero,
        baseEnemy
    )

    utility:SetData(newEnemy, "ForbidEnemySplit", true)

    local baseEnemyHPPercent = baseEnemy.HitPoints / baseEnemy.MaxHitPoints

    newEnemy.HitPoints = baseEnemyHPPercent * newEnemy.MaxHitPoints

    local wisp = Isaac.Spawn(
        EntityType.ENTITY_FAMILIAR,
        FamiliarVariant.WISP,
        CollectibleType.COLLECTIBLE_D10,
        newEnemy.Position,
        Vector.Zero,
        player)
    wisp:Remove()

    newEnemy:SetColor(solidColor, SHATTERED_SOLID_FRAMES, PRIORITY, false, false)
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        newEnemy:SetColor(color, SHATTERED_COLOR_FRAMES, PRIORITY, false, false)
    end, SHATTERED_SOLID_FRAMES)
end

function MilkshakeVol1.API.SplitEnemy(enemy, player)
    if utility:GetData(enemy, "ForbidEnemySplit") then
        return
    end
    utility:SetData(player, "LocustSplit", true)
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
        enemy:Remove()
        SpawnDowngrade(player, enemy, Isaac.GetFreeNearPosition(enemy.Position, SHIFT_LEFT), SOLID_CYAN, CYAN)
        SpawnDowngrade(player, enemy, Isaac.GetFreeNearPosition(enemy.Position, SHIFT_RIGHT), SOLID_PINK, PINK)
    end, 1)

    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        utility:SetData(player, "LocustSplit", false)
    end, DOWNGRADE_COOLDOWN)
end

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

        MilkshakeVol1.API.SplitEnemy(entity, player)

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