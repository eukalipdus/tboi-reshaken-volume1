local unlockableManager = {}
local enums = MilkshakeVol1.enums
local collectibles = enums.Collectibles

local requiredItems = {
    collectibles.GLOBIN_IN_A_BUCKET,
    collectibles.GOLDEN_SHOVEL,
    collectibles.MILKSHAKE,
    collectibles.FIRECRACKER_ROSE,
    collectibles.SHARP_CURSOR,
    collectibles.LA_CHANCLA,
    collectibles.LYRA,
    collectibles.EMPTY_SLOT,
    collectibles.SHATTERED_ORB,
    collectibles.PRISMATIC_DICE,
    collectibles.SPIRIT_BUM,
    collectibles.MILKSHAKE,
    collectibles.INNER_REFLECTION,
    collectibles.SICKLE_CELL,
    collectibles.POT_OF_GOLD,
    collectibles.FRAGILE_MIRROR,
    collectibles.LEVITICUS,
    collectibles.BATTERY_ACID,
    collectibles.DOGGY_BAG,
    collectibles.DADS_MITT,
    collectibles.LIL_BISHOP,
    collectibles.RAINBOW_FRAGMENT,
    collectibles.WITCH_DOCTOR_MASK,
    collectibles.MIRROR_KEY,
    collectibles.PRISMATIC_GOGGLES,
}

---Creates saved table to track unlock data
local function InitializeUnlockData()
    TSIL.SaveManager.AddPersistentVariable(
        MilkshakeVol1,
        "UnlockData",
        {
            [enums.Achievements.PRISMATIC_GOGGLES] = false,
            [enums.Achievements.RAINBOW_PENNIES] = false,
            [enums.Achievements.SPIRIT_OF_ORDER] = false,
            [enums.Achievements.GLASS_GOD] = false,
        },
        TSIL.Enums.VariablePersistenceMode.NONE,
        true
    )
end

---Returns if an achievement is unlocked
---@param achievementId integer
---@return boolean | nil
function MilkshakeVol1.UnlockManager:IsAchievementUnlocked(achievementId)
    local unlockData = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "UnlockData")
    if not unlockData then
        InitializeUnlockData()
        return false
    end
    return unlockData[achievementId]
end

---Set the unlock status of an achievement
---@param achievementId integer
---@param value boolean
function MilkshakeVol1.UnlockManager:UpdateAchievement(achievementId, value)
    local unlockData = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "UnlockData")
    if not unlockData then
        InitializeUnlockData()
        unlockData = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "UnlockData")
    end
    unlockData[achievementId] = value
    TSIL.SaveManager.SetPersistentVariable(MilkshakeVol1, "UnlockData", unlockData)
end

---@param npc EntityNPC
function unlockableManager:PostNpcDeath(npc)
    local stage = Game():GetLevel():GetStage()
    local challenge = Isaac.GetChallenge()

    if stage == LevelStage.STAGE6
    and npc.Type == EntityType.ENTITY_MEGA_SATAN_2  then
        if challenge == enums.Challenges.WORLD_OF_LIGHT
        and not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.PRISMATIC_GOGGLES) then
            local filePath = MilkshakeVol1.UnlockManager.GetAchievementFilePath(enums.Achievements.PRISMATIC_GOGGLES)
            MilkshakeVol1.UnlockManager:AddToAchievementQueue(filePath)
            MilkshakeVol1.UnlockManager:UpdateAchievement(
                enums.Achievements.PRISMATIC_GOGGLES,
                true
            )
        end
    end

    if stage == LevelStage.STAGE4_2
    and npc.Type == EntityType.ENTITY_MOTHER then
        if challenge == enums.Challenges.SPIRIT_SAGE
        and not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.SPIRIT_OF_ORDER) then
            local filePath = MilkshakeVol1.UnlockManager.GetAchievementFilePath(enums.Achievements.SPIRIT_OF_ORDER)
            MilkshakeVol1.UnlockManager:AddToAchievementQueue(filePath)
            MilkshakeVol1.UnlockManager:UpdateAchievement(
                enums.Achievements.SPIRIT_OF_ORDER,
                true
            )
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    unlockableManager.PostNpcDeath
)