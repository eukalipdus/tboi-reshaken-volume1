local unlockableManager = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local collectibles = enums.Collectibles

local idToName = {
    [collectibles.GLOBIN_IN_A_BUCKET] = "globin_in_a_bucket",
    [collectibles.GOLDEN_SHOVEL] = "golden_shovel",
    [collectibles.MILKSHAKE] = "milkshake",
    [collectibles.FIRECRACKER_ROSE] = "firecracker_flower",
    [collectibles.SHARP_CURSOR] = "sharp_cursor",
    [collectibles.LA_CHANCLA] = "la_chancla",
    [collectibles.LYRA] = "lyra",
    [collectibles.EMPTY_SLOT] = "empty_slot",
    [collectibles.SHATTERED_ORB] = "shattered_orb",
    [collectibles.PRISMATIC_DICE] = "prismatic_dice",
    [collectibles.SPIRIT_BUM] = "spirit_bum",
    [collectibles.INNER_REFLECTION] = "celestial_mirror",
    [collectibles.SICKLE_CELL] = "sickle_cell",
    [collectibles.POT_OF_GOLD] = "pot_of_gold",
    [collectibles.FRAGILE_MIRROR] = "glass_idol",
    [collectibles.LEVITICUS] = "leviticus",
    [collectibles.BATTERY_ACID] = "battery_acid",
    [collectibles.DOGGY_BAG] = "doggy_bag",
    [collectibles.DADS_MITT] = "dads_mitt",
    [collectibles.LIL_BISHOP] = "lil_bishop",
    [collectibles.RAINBOW_FRAGMENT] = "rainbow_fragment",
    [collectibles.WITCH_DOCTOR_MASK] = "witch_doctor_mask",
    [collectibles.MIRROR_KEY] = "mirror_key",
    [collectibles.PRISMATIC_GOGGLES] = "prismatic_goggles",
}

local challengeToAchievement = {
    [enums.Challenges.ISAAC_CLICKER] = enums.Achievements.GOLDEN_COOKIE,
    [enums.Challenges.SPIRIT_SAGE] = enums.Achievements.SPIRIT_OF_ORDER,
    [enums.Challenges.WORLD_OF_LIGHT] = enums.Achievements.PRISMATIC_GOGGLES
}

---Creates saved table to track taken items
local function InitializeCollection()
    TSIL.SaveManager.AddPersistentVariable(
        MilkshakeVol1,
        "Milkshake1Collection",
        {
            [idToName[collectibles.GLOBIN_IN_A_BUCKET]] = false,
            [idToName[collectibles.GOLDEN_SHOVEL]] = false,
            [idToName[collectibles.MILKSHAKE]] = false,
            [idToName[collectibles.FIRECRACKER_ROSE]] = false,
            [idToName[collectibles.SHARP_CURSOR]] = false,
            [idToName[collectibles.LA_CHANCLA]] = false,
            [idToName[collectibles.LYRA]] = false,
            [idToName[collectibles.EMPTY_SLOT]] = false,
            [idToName[collectibles.SHATTERED_ORB]] = false,
            [idToName[collectibles.PRISMATIC_DICE]] = false,
            [idToName[collectibles.SPIRIT_BUM]] = false,
            [idToName[collectibles.INNER_REFLECTION]] = false,
            [idToName[collectibles.SICKLE_CELL]] = false,
            [idToName[collectibles.POT_OF_GOLD]] = false,
            [idToName[collectibles.FRAGILE_MIRROR]] = false,
            [idToName[collectibles.LEVITICUS]] = false,
            [idToName[collectibles.BATTERY_ACID]] = false,
            [idToName[collectibles.DOGGY_BAG]] = false,
            [idToName[collectibles.DADS_MITT]] = false,
            [idToName[collectibles.LIL_BISHOP]] = false,
            [idToName[collectibles.RAINBOW_FRAGMENT]] = false,
            [idToName[collectibles.WITCH_DOCTOR_MASK]] = false,
            [idToName[collectibles.MIRROR_KEY]] = false,
            [idToName[collectibles.PRISMATIC_GOGGLES]] = false,
        },
        TSIL.Enums.VariablePersistenceMode.NONE,
        true
    )
end

---Creates saved table to track unlock data
local function InitializeUnlockData()
    TSIL.SaveManager.AddPersistentVariable(
        MilkshakeVol1,
        "UnlockData",
        {
            [enums.Achievements.PRISMATIC_GOGGLES] = false,
            [enums.Achievements.GOLDEN_COOKIE] = false,
            [enums.Achievements.SPIRIT_OF_ORDER] = false,
            [enums.Achievements.GLASS_GOD] = false,
        },
        TSIL.Enums.VariablePersistenceMode.NONE,
        true
    )
end

---Checks if 100% completion has been met, if so displays the popup
---@param collection table
---@return boolean
function MilkshakeVol1.UnlockManager:ShouldUnlockGlassGod(collection)
    if MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.GLASS_GOD)
    or not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.PRISMATIC_GOGGLES)
    or not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.GOLDEN_COOKIE)
    or not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.SPIRIT_OF_ORDER) then
        return false
    end

    for _, hasBeenTaken in pairs(collection) do
        if hasBeenTaken == false then
            return false
        end
    end

    local glassGodUnlockSprite = MilkshakeVol1.UnlockManager:GetAchievementFilePath(enums.Achievements.GLASS_GOD)
    MilkshakeVol1.UnlockManager:UpdateAchievement(enums.Achievements.GLASS_GOD, true)
    MilkshakeVol1.UnlockManager:AddToAchievementQueue(glassGodUnlockSprite)

    return true
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

local collectibleToAchievement = {
    [enums.Collectibles.PRISMATIC_GOGGLES] = enums.Achievements.PRISMATIC_GOGGLES
}

---Unlocks all achievements or locks all of them
---@param unlock boolean true to unlock everything, false to lock everything
function MilkshakeVol1.UnlockManager:UpdateAllAchievements(unlock)
    for _, achievement in pairs(enums.Achievements) do
        local spriteFilePath  = MilkshakeVol1.UnlockManager:GetAchievementFilePath(achievement)
        MilkshakeVol1.UnlockManager:UpdateAchievement(achievement, unlock)
        MilkshakeVol1.UnlockManager:AddToAchievementQueue(spriteFilePath)
    end
end

---Gets the acheivement ID associated with a given collectible
---@param collectibleType number
---@return integer | nil
function MilkshakeVol1.UnlockManager:GetCollectibleAssociatedAchievement(collectibleType)
    if collectibleToAchievement[collectibleType] then
        return collectibleToAchievement[collectibleType]
    end
end

---@param npc EntityNPC
function unlockableManager:PostNpcDeath(npc)
    local stage = Game():GetLevel():GetStage()
    local challenge = Isaac.GetChallenge()

    if stage == LevelStage.STAGE6
    and npc.Type == EntityType.ENTITY_MEGA_SATAN_2  then
        if challenge == enums.Challenges.WORLD_OF_LIGHT
        and not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.PRISMATIC_GOGGLES) then
            local filePath = MilkshakeVol1.UnlockManager:GetAchievementFilePath(enums.Achievements.PRISMATIC_GOGGLES)
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
            local filePath = MilkshakeVol1.UnlockManager:GetAchievementFilePath(enums.Achievements.SPIRIT_OF_ORDER)
            MilkshakeVol1.UnlockManager:AddToAchievementQueue(filePath)
            MilkshakeVol1.UnlockManager:UpdateAchievement(
                enums.Achievements.SPIRIT_OF_ORDER,
                true
            )
            local collection = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "Milkshake1Collection")
            MilkshakeVol1.UnlockManager:ShouldUnlockGlassGod(collection)
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NPC_DEATH,
    unlockableManager.PostNpcDeath
)

function unlockableManager:PostItemAdded(_, collectibleType)
    if not TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "Milkshake1Collection") then
        InitializeCollection()
    end

    local collection = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "Milkshake1Collection")

    if collectibleType == enums.Collectibles.LEVITICUS_ALADAR
    or collectibleType == enums.Collectibles.LEVITICUS_FANCY then
        collectibleType = enums.Collectibles.LEVITICUS
    end

    local collectibleName = idToName[collectibleType]

    if collection[collectibleName] == false then
        collection[collectibleName] = true
    end

    MilkshakeVol1.UnlockManager:ShouldUnlockGlassGod(collection)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    unlockableManager.PostItemAdded
)

---@param pickup EntityPickup
function unlockableManager:PostPickupInit(pickup)
    local itemPool = Game():GetItemPool()
    local willSpindown = utility:GetData(pickup, "WillSpindown")

    if MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.GLASS_GOD) then
        return
    end

    if not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.PRISMATIC_GOGGLES)
    and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
    and pickup.SubType == enums.Collectibles.PRISMATIC_GOGGLES then
        itemPool:RemoveCollectible(pickup.SubType)

        if not willSpindown then
            local newCollectible = itemPool:GetCollectible(itemPool:GetLastPool(), true)
            pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newCollectible, true)
        end

    elseif not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.GOLDEN_COOKIE)
    and pickup.Variant == PickupVariant.PICKUP_TRINKET
    and pickup.SubType == enums.Trinkets.RAINBOW_COOKIE then
        local newTrinket = Game():GetItemPool():GetTrinket()
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, newTrinket, true)
 
    elseif not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.SPIRIT_OF_ORDER)
    and pickup.Variant == PickupVariant.PICKUP_TAROTCARD
    and pickup.SubType == enums.Orbs.ORDER then

    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    unlockableManager.PostPickupInit
)

---@param isContinued boolean
function unlockableManager:PostGameStarted(isContinued)
    if isContinued then
        return
    end

    local itemPool = Game():GetItemPool()

    if not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.PRISMATIC_GOGGLES) then
        itemPool:RemoveCollectible(enums.Collectibles.PRISMATIC_GOGGLES)
    end

    if not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(enums.Achievements.GOLDEN_COOKIE) then
        itemPool:RemoveTrinket(enums.Trinkets.RAINBOW_COOKIE)
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    unlockableManager.PostGameStarted
)

function unlockableManager:PostNewLevel()
    if not REPENTOGON then
        return
    end

     for challengeId, achievementId in pairs(challengeToAchievement) do
        ---@diagnostic disable-next-line: undefined-field
        if Isaac.IsChallengeDone(challengeId)
        and not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(achievementId) then
            TSIL.Utils.Functions.RunInFrames(function ()
                    local spriteFilePath  = MilkshakeVol1.UnlockManager:GetAchievementFilePath(achievementId)
                    MilkshakeVol1.UnlockManager:UpdateAchievement(achievementId, true)
                    MilkshakeVol1.UnlockManager:AddToAchievementQueue(spriteFilePath)
                end, 1, {})
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    unlockableManager.PostNewLevel
)