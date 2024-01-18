local spiritSage = {}
local enums = MilkshakeVol1.enums

local ALT_PATH_ACHIEVEMENT = 407
local UPDATE_DELAY = 2
local ACHIEVEMENT_LAYER = 3

local popupSprite = Sprite()
popupSprite:Load("gfx/ui/achievement/achievements.anm2", true)
popupSprite:Play("Appear")

function spiritSage:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.SPIRIT_SAGE then
        player:AddCollectible(CollectibleType.COLLECTIBLE_POLYDACTYLY, 0, false)
        player:AddCollectible(enums.Collectibles.LYRA)
        TSIL.Utils.Functions.RunInFrames(function ()
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_LEMEGETON, true, ActiveSlot.SLOT_POCKET)
            player:SetPocketActiveItem(enums.Collectibles.SHATTERED_ORB)
            local shatteredOrbCharges = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.SHATTERED_ORB).MaxCharges
            player:SetActiveCharge(shatteredOrbCharges)
        end, 1, {})
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, spiritSage.PostPlayerInit)

function spiritSage:PostRender()
    if not MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(ALT_PATH_ACHIEVEMENT) then
        popupSprite:ReplaceSpritesheet(ACHIEVEMENT_LAYER, "gfx/ui/spiritsage_warning.png")
        popupSprite:LoadGraphics()
        popupSprite:Render(Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) / 2)

        if Game():GetFrameCount() % UPDATE_DELAY == 0
        and not popupSprite:IsFinished("Appear") then
            popupSprite:Update()
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_RENDER, spiritSage.PostRender)
return spiritSage