local witchDoctorMask = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local HORSE_PILL_INC = 2048

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

function witchDoctorMask:UsePill(pillEffect, player)
    local colorToEffect = {}
    for i = 1, PillColor.NUM_STANDARD_PILLS do
        colorToEffect[Game():GetItemPool():GetPillEffect(i, player)] = i
    end
    local pillColor = colorToEffect[pillEffect]
    if TSIL.Pills.IsHorsePill(pillColor) then
        utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
    end
    player:UseCard(matchingPills[pillColor], UseFlag.USE_NOANIM)
    --utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", false) seems like it should be done but could mess with lyra?
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_PILL, witchDoctorMask.UsePill)

return witchDoctorMask