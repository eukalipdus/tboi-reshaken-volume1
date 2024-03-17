local AchievementChecker = {}
--To ensure unique MilkshakeVol1 name
--local MilkshakeVol1 = RegisterMod("AchievementChecker" .. tostring(AchievementChecker), 1)

local ACHIEVEMENT_TRACKERS = {}
local TRINKET_PER_ACHIEVEMENT = {}

-- local function RemoveAchievementTrinkets()
--     local itemPool = Game():GetItemPool()

--     for trinket, _ in pairs(ACHIEVEMENT_TRACKERS) do
--         itemPool:RemoveTrinket(trinket)
--     end
-- end

-- MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function ()
--     RemoveAchievementTrinkets()
-- end)

-- local antiRecursion

-- MilkshakeVol1:AddCallback(ModCallbacks.MC_GET_TRINKET, function (_, trinket)
--     if ACHIEVEMENT_TRACKERS[trinket] and not antiRecursion then
--         antiRecursion = true

--         RemoveAchievementTrinkets()

--         local itemPool = Game():GetItemPool()
--         local new = itemPool:GetTrinket()

--         antiRecursion = false

--         return new
--     end
-- end)

-- ---@param pickup EntityPickup
-- local function CheckToReplaceTrinket(pickup)
--     if ACHIEVEMENT_TRACKERS[pickup.SubType] then
--         local itemPool = Game():GetItemPool()
--         local trinket = itemPool:GetTrinket()
--         pickup:Morph(pickup.Type, pickup.Variant, trinket, true, false, true)
--     end
-- end

-- MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function (_, pickup)
--     CheckToReplaceTrinket(pickup)
-- end, PickupVariant.PICKUP_TRINKET)

-- MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function (_, pickup)
--     CheckToReplaceTrinket(pickup)
-- end, PickupVariant.PICKUP_TRINKET)


---Adds a trinket tied to an achievement that will be used to check if the achievement is unlocked.
---
---To create a custom trinket tied to an achievement add this in your items.xml:
---```xml
---<trinket name="Unique name" description="" achievement="[id of the achievement]"/>
---```
---@param trinket TrinketType
function AchievementChecker:AddTrackerTrinket(trinket)
    local itemConfig = Isaac.GetItemConfig()
    local trinketInfo = itemConfig:GetTrinket(trinket)
    local achievement = trinketInfo.AchievementID

    if not achievement or achievement <= 1 then
        print("[ACHIEVEMENT TRACKER - ERROR] Trying to register a trinket that isn't tied to an achievement: " .. trinket)
        return
    end

    if trinketInfo.Hidden then
        print("[ACHIEVEMENT TRACKER - ERROR] Trying to register a hidden trinket will never show as available: " .. trinket)
        return
    end

    ACHIEVEMENT_TRACKERS[trinket] = true
    TRINKET_PER_ACHIEVEMENT[trinketInfo.AchievementID] = trinket
end


---Helper function to check if a vanilla achievement is unlocked.
---@param achievement integer
---@return boolean
function AchievementChecker:IsAchievementUnlocked(achievement)
    local trinket = TRINKET_PER_ACHIEVEMENT[achievement]

    local itemConfig = Isaac.GetItemConfig()
    local trinketInfo = itemConfig:GetTrinket(trinket)

    return trinketInfo:IsAvailable()
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function (rng, spawnPos)
    local room = Game():GetRoom()
    local roomType = room:GetType()
    if roomType ~= RoomType.ROOM_BOSS then return end
    if not TSIL.Players.DoesAnyPlayerHasTrinket(MilkshakeVol1.enums.Trinkets.TRACK_ALT_PATH_UNLOCK) then return end
    TSIL.Utils.Functions.RunInFrames(function ()
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_DADS_KEY, UseFlag.USE_NOANIM, -1)
    end, 20)
    

end, PickupVariant.PICKUP_TRINKET)


return AchievementChecker