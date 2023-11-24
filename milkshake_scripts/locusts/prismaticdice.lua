local prismaticDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local DOWNGRADE_CHANCE = 10
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
    local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, newEnemy.Position, Vector.Zero, player):ToTear()
    tear.TearFlags = tear.TearFlags | TearFlags.TEAR_REROLL_ENEMY
    newEnemy:SetColor(solidColor, SHATTERED_SOLID_FRAMES, PRIORITY, false, false)
    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        newEnemy:SetColor(color, SHATTERED_COLOR_FRAMES, PRIORITY, false, false)
    end, SHATTERED_SOLID_FRAMES)
end

local function SplitEnemy(player, enemy)
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
    if not source.Entity then return end
    local sourceEntity = source.Entity
    local familiar = sourceEntity:ToFamiliar()
    if not familiar then return end
    local player = familiar.Player
    local rng = player:GetCollectibleRNG(enums.Collectibles.PRISMATIC_DICE)
    local roll = TSIL.Random.GetRandomInt(1, 100, rng)
    if roll <= DOWNGRADE_CHANCE
    and familiar.SubType == enums.Collectibles.PRISMATIC_DICE
    and not utility:GetData(player, "LocustSplit") then
        SplitEnemy(player, entity)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, prismaticDice.EntityTakeDmg)