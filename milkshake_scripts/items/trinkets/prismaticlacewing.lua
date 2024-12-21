local PrismaticLacewing = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local CHANCE_TEAR = 5
local CHANCE_LASER = 100
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220/255, 1, 0, 0, 0)
local LERP_AMOUNT = 0.1
local LERP_PINK = 1
local LERP_CYAN = 2
local EPSILON = 0.01

local function PrismaticColorLerpBegin(entity)
    utility:SetData(entity, "ShouldSplitDowngrade", true)
    entity.Color = CYAN
    utility:SetData(entity, "PrismaticLacewingLerpType", LERP_PINK)
end

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

---@param tear EntityTear
function PrismaticLacewing:PostFireTear(tear)
    local player = utility:GetPlayerFromTear(tear)

    if not player
    or not player:HasTrinket(enums.Trinkets.PRISMATIC_LACEWING) then
        return
    end

    local rng = player:GetTrinketRNG(enums.Trinkets.PRISMATIC_LACEWING)
    local currentChance = CHANCE_TEAR * player:GetTrinketMultiplier(enums.Trinkets.PRISMATIC_LACEWING)

    if TSIL.Random.GetRandomInt(1, 100, rng) <= currentChance then
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

function PrismaticLacewing:PostLaserInit(laser)
    
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_LASER_INIT,
    PrismaticLacewing.PostLaserInit
)

function PrismaticLacewing:OnEntityDamage(entity, _, flags, source)
    if not source.Entity
    or source.Type ~= EntityType.ENTITY_PLAYER then
        return
    end

    local npc = entity:ToNPC()

    if not npc
    or not npc:IsVulnerableEnemy() then
        return
    end

    local player = TSIL.Players.GetPlayerFromEntity(source.Entity)

    if not player then
        return
    end

    if TSIL.Utils.Flags.HasFlags(flags, DamageFlag.DAMAGE_LASER) then
        local rng = player:GetTrinketRNG(enums.Trinkets.PRISMATIC_LACEWING)
        local currentChance = CHANCE_LASER * player:GetTrinketMultiplier(enums.Trinkets.PRISMATIC_LACEWING)

        if TSIL.Random.GetRandomInt(1, 100, rng) <= currentChance then
            MilkshakeVol1.API.SplitEnemy(entity, player)
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    PrismaticLacewing.OnEntityDamage
)