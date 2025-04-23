local achievementPopup = {}
local enums = MilkshakeVol1.enums

local UPDATE_DELAY = 2
local ACHIEVEMENT_LAYER = 3
local IDLE_TIME = 60

--local gamePaused
local soundPlayed = false
--local forceUnpause
local popupSprite = Sprite()
popupSprite:Load("gfx/ui/achievement/achievements.anm2", true)
popupSprite:Play("Appear")

local achievementQueue = {}

local achievementFilePaths = {
    [enums.Achievements.PRISMATIC_GOGGLES] = "gfx/ui/achievement/achievement_prismaticgoggles.png",
    [enums.Achievements.GOLDEN_COOKIE] = "gfx/ui/achievement/achievement_rainbowcookie.png",
    [enums.Achievements.SPIRIT_OF_ORDER] = "gfx/ui/achievement/achievement_spiritoforder.png",
    [enums.Achievements.GLASS_GOD] = "gfx/ui/achievement/achievement_glassgod.png",
}

---Returns the file path for a given achievement
---@param acheivementId integer
function MilkshakeVol1.UnlockManager:GetAchievementFilePath(acheivementId)
    return achievementFilePaths[acheivementId]
end

---Adds an achievement popup to the queue
---@param filePath string
function MilkshakeVol1.UnlockManager:AddToAchievementQueue(filePath)
    table.insert(achievementQueue, filePath)
end

function achievementPopup:PostRender()
    if #achievementQueue == 0 then
        return
    end

    --gamePaused = true

    TSIL.Pause.Pause()

    for i = 0, Game():GetNumPlayers() - 1 do
        Isaac.GetPlayer(i).ControlsEnabled = false
    end

    popupSprite:ReplaceSpritesheet(ACHIEVEMENT_LAYER, achievementQueue[1])
    popupSprite:LoadGraphics()
    popupSprite:Render(Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) / 2)

    if Game():GetFrameCount() % UPDATE_DELAY == 0 then
        popupSprite:Update()
    end

    if popupSprite:IsFinished("Appear")
    and not soundPlayed then
        TSIL.Utils.Functions.RunInFrames(function ()
            popupSprite:Play("Dissapear")
        end, IDLE_TIME, {})
        SFXManager():Play(SoundEffect.SOUND_BOOK_PAGE_TURN_12)
        soundPlayed = true
    end

    if popupSprite:IsFinished("Dissapear") then
        table.remove(achievementQueue, 1)
        popupSprite:Play("Appear")
        soundPlayed = false

        if #achievementQueue == 0 then
            for i = 0, Game():GetNumPlayers() - 1 do
                Isaac.GetPlayer(i).ControlsEnabled = true
            end
            TSIL.Pause.Unpause()
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_RENDER, achievementPopup.PostRender)

-- ---@param buttonAction integer
-- ---@return number
-- function achievementPopup:InputAction(_, _, buttonAction)
--     if TSIL.Pause.IsPaused()
--     and forceUnpause
--     and buttonAction == ButtonAction.ACTION_SHOOTLEFT then
--         return 0.75
--     end
-- end
-- MilkshakeVol1:AddCallback(
--     ModCallbacks.MC_INPUT_ACTION,
--     achievementPopup.InputAction,
--     InputHook.GET_ACTION_VALUE
-- )

-- ---@param projectile EntityProjectile
-- function achievementPopup:PostProjectileUpdate(projectile)
--     if gamePaused then
--         projectile.Position = utility:GetData(projectile, "OriginalPosition")
--     end
-- end
-- MilkshakeVol1:AddCallback(
--     ModCallbacks.MC_POST_PROJECTILE_UPDATE,
--     achievementPopup.PostProjectileUpdate
-- )

-- function achievementPopup:PostPEffectUpdate()
--     if gamePaused then
--         for _, entity in pairs(Isaac.GetRoomEntities()) do
--             if entity.Type == EntityType.ENTITY_PROJECTILE
--             and not utility:GetData(entity, "OriginalPosition") then
--                 utility:SetData(entity, "OriginalPosition", entity.Position)
--             end
--         end
--     end
-- end
-- MilkshakeVol1:AddCallback(
--     ModCallbacks.MC_POST_PEFFECT_UPDATE,
--     achievementPopup.PostPEffectUpdate
-- )