local SapphireOrb = {}
local enums = require("milkshake_scripts.enums")


local CLAIRVOYANCE_ORB_DURATION = 10 * 30
local PROJECTILE_REFLECTION_RADIUS = 100
local PROJECTILE_REFLECTION_INTERVAL = 21
local FAKE_CENSER_RADIUS = 60


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "ClairvoyanceOrbPlayerFrames",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)


---@param player EntityPlayer
function SapphireOrb:OnAmethystOrbUse(_, player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    player:AddNullCostume(enums.Costumes.CLAIRVOYANCE_ORB)

    local clairvoyanceOrbPlayerFrames = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "ClairvoyanceOrbPlayerFrames"
    )
    local frameCount = Game():GetFrameCount()
    clairvoyanceOrbPlayerFrames[tostring(playerIndex)] = frameCount

    local aura = TSIL.EntitySpecific.SpawnEffect(
        enums.Effects.CLAIRVOYANCE_AURA,
        0,
        player.Position
    )
    aura.Parent = player
    aura:FollowParent(player)
    aura.DepthOffset = -100
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_USE_CARD,
    SapphireOrb.OnAmethystOrbUse,
    enums.Cards.AMETHYST_ORB
)


---@param player EntityPlayer
local function TryReflectProjectile(player)
    local rng = player:GetCardRNG(enums.Cards.AMETHYST_ORB)

    local nearProjectiles = Isaac.FindInRadius(
        player.Position,
        PROJECTILE_REFLECTION_RADIUS,
        EntityPartition.BULLET
    )

    if #nearProjectiles == 0 then
        return
    end

    nearProjectiles = TSIL.Utils.Tables.Map(nearProjectiles, function (_, projectile)
        return projectile:ToProjectile()
    end)

    nearProjectiles = TSIL.Utils.Tables.Filter(nearProjectiles, function (_, projectile)
        return not projectile:HasProjectileFlags(ProjectileFlags.HIT_ENEMIES | ProjectileFlags.CANT_HIT_PLAYER)
    end)

    if #nearProjectiles == 0 then
        return
    end

    local projectileToReflect = TSIL.Random.GetRandomElementsFromTable(
        nearProjectiles,
        1,
        rng
    )[1]

    projectileToReflect.Velocity = -projectileToReflect.Velocity
    projectileToReflect.SpawnerEntity = nil
    projectileToReflect.FallingSpeed = 0
    projectileToReflect.FallingAccel = -0.05
    projectileToReflect:AddProjectileFlags(
        ProjectileFlags.HIT_ENEMIES |
        ProjectileFlags.CANT_HIT_PLAYER |
        ProjectileFlags.SMART
    )
end


local function FakeCenserEffect(player)
    local nearProjectiles = Isaac.FindInRadius(
        player.Position,
        FAKE_CENSER_RADIUS,
        EntityPartition.BULLET
    )

    for _, entity in ipairs(nearProjectiles) do
        local projectile = entity:ToProjectile()

        if not projectile:HasProjectileFlags(
        ProjectileFlags.HIT_ENEMIES |
        ProjectileFlags.CANT_HIT_PLAYER) then
            projectile:AddProjectileFlags(ProjectileFlags.SLOWED)
        end
    end
end


---@param player EntityPlayer
function SapphireOrb:OnPeffectUpdate(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local clairvoyanceOrbPlayerFrames = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "ClairvoyanceOrbPlayerFrames"
    )
    local playerUsedClairvoyanceFrame = clairvoyanceOrbPlayerFrames[tostring(playerIndex)]

    if not playerUsedClairvoyanceFrame then return end

    local currentFrame = Game():GetFrameCount()
    local orbDuration = currentFrame - playerUsedClairvoyanceFrame

    if orbDuration >= CLAIRVOYANCE_ORB_DURATION then
        player:TryRemoveNullCostume(enums.Costumes.CLAIRVOYANCE_ORB)
        clairvoyanceOrbPlayerFrames[tostring(playerIndex)] = nil
        return
    end

    if orbDuration % PROJECTILE_REFLECTION_INTERVAL == 0 then
        TryReflectProjectile(player)
    end

    FakeCenserEffect(player)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PEFFECT_UPDATE,
    SapphireOrb.OnPeffectUpdate
)


function SapphireOrb:OnNewRoom()
    local players = TSIL.Players.GetPlayers()

    TSIL.Utils.Tables.ForEach(players, function (_, player)
        player:TryRemoveNullCostume(enums.Costumes.CLAIRVOYANCE_ORB)
    end)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    SapphireOrb.OnNewRoom
)


---@param effect EntityEffect
function SapphireOrb:OnClairvoyanceAuraUpdate(effect)
    if not effect.Parent then return end

    local player = effect.Parent:ToPlayer()

    if not player then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local clairvoyanceOrbPlayerFrames = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "ClairvoyanceOrbPlayerFrames"
    )
    local playerUsedClairvoyanceFrame = clairvoyanceOrbPlayerFrames[tostring(playerIndex)]

    if not playerUsedClairvoyanceFrame then
        effect:Remove()
        return
    end

    effect:FollowParent(effect.Parent)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    SapphireOrb.OnClairvoyanceAuraUpdate,
    enums.Effects.CLAIRVOYANCE_AURA
)