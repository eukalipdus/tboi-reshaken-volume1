local rockOrb = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local LONG_ROOM_GRID_SIZE = 252
local NORMAL_MIN = 5
local NORMAL_MAX = 6
local BIG_MIN = 7
local BIG_MAX = 9
local KILL_FRAME = 7
local KILL_RADIUS = 20

function rockOrb:OnOrbUse(orb, player, _, isLyra)
    if orb ~= enums.Orbs.ROCK then return end

    local enemies = TSIL.EntitySpecific.GetNPCs(nil, nil, nil, true)

    enemies = TSIL.Utils.Tables.Filter(enemies, function (_, enemy)
        return enemy:IsVulnerableEnemy()
    end)

    --local rng = player:GetCardRNG(orb)
    local max
    local min
    if Game():GetRoom():GetGridSize() > LONG_ROOM_GRID_SIZE then
        min = BIG_MIN
        max = BIG_MAX
    else
        min = NORMAL_MIN
        max = NORMAL_MAX
    end

    local stalagmiteCount = TSIL.Random.GetRandomInt(min, max)

    for _ = 1, stalagmiteCount do
        local target = TSIL.Random.GetRandomElementsFromTable(enemies)
        local stalagmite = TSIL.EntitySpecific.SpawnEffect(
            enums.Effects.STALAGMITE,
            0,
            target[1].Position,
            Vector.Zero,
            player
        )

        local sprite = stalagmite:GetSprite()
        sprite:Play("Windup")
        utility:SetData(stalagmite, "Target", target[1])
    end
end
MilkshakeVol1:AddCallback(enums.Callbacks.ON_ORB_USE, rockOrb.OnOrbUse)

function rockOrb:PostEffectUpdate(stalagmite)
    local sprite = stalagmite:GetSprite()
    local target = utility:GetData(stalagmite, "Target")

    if sprite:IsFinished("Windup") then
        sprite:Play("Appear")
        TSIL.Utils.Functions.RunInFrames(function ()
            SFXManager():Play(SoundEffect.SOUND_ROCK_CRUMBLE)
        end, 5, {})
    end

    if sprite:IsFinished("Appear") then
        sprite:Play("Idle")
    end

    if sprite:IsPlaying("Appear") and sprite:GetFrame() == KILL_FRAME then
        local toKill = Isaac.FindInRadius(stalagmite.Position, KILL_RADIUS, EntityPartition.ENEMY)
        for _, enemy in ipairs(toKill) do
            enemy:Kill()
        end
        TSIL.Utils.Functions.RunInFrames(function ()
            sprite:Play("Disappear")
        end, 15, {})
    end

    if sprite:IsFinished("Disappear") then
        stalagmite:Remove()
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, rockOrb.PostEffectUpdate, enums.Effects.STALAGMITE)

return rockOrb