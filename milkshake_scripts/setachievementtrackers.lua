local achievementTrackers = {
    MilkshakeVol1.enums.Trinkets.TRACK_ALT_PATH_UNLOCK,
    MilkshakeVol1.enums.Trinkets.TRACK_GOLDEN_BATTERY_UNLOCK,
    MilkshakeVol1.enums.Trinkets.TRACK_GOLD_BOMB_UNLOCK,
    MilkshakeVol1.enums.Trinkets.TRACK_GOLDEN_HEART_UNLOCK,
    MilkshakeVol1.enums.Trinkets.TRACK_GOLD_PILL_UNLOCK,
    MilkshakeVol1.enums.Trinkets.TRACK_GOLDEN_TRINKET_UNLOCK,
    MilkshakeVol1.enums.Trinkets.TRACK_MEGA_CHEST_UNLOCK
}

MilkshakeVol1.AchievementChecker = include("milkshake_scripts.achievementchecker")

for _, trinket in pairs(achievementTrackers) do
    MilkshakeVol1.AchievementChecker:AddTrackerTrinket(trinket)
end