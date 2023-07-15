local witchDoctorMask = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local HORSE_PILL_INC = 2048
local NO_PILL = 0
local FF_PILL_BEGIN = 101
local FF_PILL_END = 120

local playersCurrentPills = {}

local matchingPills = {
    [PillColor.PILL_BLUE_BLUE] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_BLUE] = enums.Orbs.RANDOM,
    [PillColor.PILL_ORANGE_ORANGE] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_WHITE] = enums.Orbs.RANDOM,
    [PillColor.PILL_REDDOTS_RED] = enums.Orbs.RANDOM,
    [PillColor.PILL_PINK_RED] = enums.Orbs.RANDOM,
    [PillColor.PILL_BLUE_CADETBLUE] = enums.Orbs.RANDOM,
    [PillColor.PILL_YELLOW_ORANGE] = enums.Orbs.RANDOM,
    [PillColor.PILL_ORANGEDOTS_WHITE] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_AZURE] = enums.Orbs.RANDOM,
    [PillColor.PILL_BLACK_YELLOW] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_BLACK] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_YELLOW] = enums.Orbs.RANDOM,
    [PillColor.PILL_GOLD] = enums.Orbs.RANDOM,
    [PillColor.PILL_BLUE_BLUE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_BLUE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_ORANGE_ORANGE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_WHITE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_REDDOTS_RED + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_PINK_RED + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_BLUE_CADETBLUE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_YELLOW_ORANGE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_ORANGEDOTS_WHITE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_AZURE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_BLACK_YELLOW + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_BLACK + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_YELLOW + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_GOLD + HORSE_PILL_INC] = enums.Orbs.RANDOM,

}

--- Adds a pill color and its horse pill variant and gives it a corresponding spirit orb
---@param pillColor integer
---@param spiritOrb number
function MilkshakeVol1.API:AddOrbsPerPill(pillColor, spiritOrb)
    matchingPills[pillColor] = spiritOrb
    matchingPills[pillColor + HORSE_PILL_INC] = spiritOrb
end

function witchDoctorMask:UsePill(_, player)
    if player:HasCollectible(enums.Collectibles.WITCH_DOCTOR_MASK) then
        --local colorToEffect = {}
        --for i = 1, PillColor.NUM_STANDARD_PILLS do
        --    colorToEffect[Game():GetItemPool():GetPillEffect(i, player)] = i
        --end
        local pillColor = playersCurrentPills[GetPtrHash(player)] --colorToEffect[pillEffect]
        if TSIL.Pills.IsHorsePill(pillColor) then
            utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
        end
        local spiritOrb = matchingPills[pillColor]
        if not spiritOrb then
            spiritOrb = enums.Orbs.RANDOM
        end
        player:UseCard(spiritOrb, UseFlag.USE_NOANIM)
        --utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", false) seems like it should be done but could mess with lyra?
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_PILL, witchDoctorMask.UsePill)

function witchDoctorMask:PostPEffectUpdate(player)
    if player:GetPill(0) == NO_PILL then return end
    playersCurrentPills[GetPtrHash(player)] = player:GetPill(0)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, witchDoctorMask.PostPEffectUpdate)

function witchDoctorMask:PostPickupUpdate(pickup)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.WITCH_DOCTOR_MASK) then
            if not utility:GetData(pickup, "SpiritPillSprite") then
                if pickup.SubType < FF_PILL_BEGIN then
                    pickup:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/spirit pills ground.png")
                elseif pickup.SubType >= FF_PILL_BEGIN and pickup.SubType <= FF_PILL_END then
                    pickup:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/spirit pills ground.png")
                end
                pickup:GetSprite():LoadGraphics()
                utility:SetData(pickup, "SpiritPillSprite", true)
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, witchDoctorMask.PostPickupUpdate)

return witchDoctorMask