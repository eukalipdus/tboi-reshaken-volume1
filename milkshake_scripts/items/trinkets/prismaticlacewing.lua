local PrismaticLacewing = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local CHANCE = 5
local CYAN = Color(0, 1, 1, 1, 0, 0, 0)
local PINK = Color(1, 0, 220/255, 1, 0, 0, 0)
local LERP_AMOUNT = 0.1
local LERP_PINK = 1
local LERP_CYAN = 2
local EPSILON = 0.01

---@param tear EntityTear
function PrismaticLacewing:PostFireTear(tear)
    local player = utility:GetPlayerFromTear(tear)

    if not player
    or not player:HasTrinket(enums.Trinkets.PRISMATIC_LACEWING) then
        return
    end

    local rng = player:GetTrinketRNG(enums.Trinkets.PRISMATIC_LACEWING)
    local currentChance = CHANCE * player:GetTrinketMultiplier(enums.Trinkets.PRISMATIC_LACEWING)

    if TSIL.Random.GetRandomInt(1, 100, rng) <= currentChance then
        utility:SetData(tear, "ShouldSplitDowngrade", true)
        tear.Color = CYAN
        utility:SetData(tear, "PrismaticLacewingLerpType", LERP_PINK)
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_FIRE_TEAR,
    PrismaticLacewing.PostFireTear
)

---@param tear EntityTear
function PrismaticLacewing:PostTearUpdate(tear)
    local originalColor = tear.Color
    local newR, newG, newB

    if utility:GetData(tear, "PrismaticLacewingLerpType") == LERP_PINK then
        newR = TSIL.Utils.Math.Lerp(originalColor.R, PINK.R, LERP_AMOUNT)
        newG = TSIL.Utils.Math.Lerp(originalColor.G, PINK.G, LERP_AMOUNT)
        newB = TSIL.Utils.Math.Lerp(originalColor.B, PINK.B, LERP_AMOUNT)

        if utility:MaybeEqual(originalColor.R, newR, EPSILON)
        and utility:MaybeEqual(originalColor.G, newG, EPSILON)
        and utility:MaybeEqual(originalColor.B, newB, EPSILON) then
            utility:SetData(tear, "PrismaticLacewingLerpType", LERP_CYAN)
        end

    elseif utility:GetData(tear, "PrismaticLacewingLerpType") == LERP_CYAN then
        newR = TSIL.Utils.Math.Lerp(originalColor.R, CYAN.R, LERP_AMOUNT)
        newG = TSIL.Utils.Math.Lerp(originalColor.G, CYAN.G, LERP_AMOUNT)
        newB = TSIL.Utils.Math.Lerp(originalColor.B, CYAN.B, LERP_AMOUNT)

        if utility:MaybeEqual(originalColor.R, newR, EPSILON)
        and utility:MaybeEqual(originalColor.G, newG, EPSILON)
        and utility:MaybeEqual(originalColor.B, newB, EPSILON) then
            utility:SetData(tear, "PrismaticLacewingLerpType", LERP_PINK)
        end
    else
        return
    end
    tear.Color = Color(newR, newG, newB, tear.Color.A)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_TEAR_UPDATE,
    PrismaticLacewing.PostTearUpdate
)