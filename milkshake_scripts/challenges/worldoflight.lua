local worldOfLight = {}
local enums = MilkshakeVol1.enums

local INTERVAL_SECONDS = 60
local ONE_SECOND = 30

local MIN_ITEMS = 3
local ICON_RENDER_X = 35
local ICON_RENDER_Y = 34
local TEXT_RENDER_X = 51
local TEXT_RENDER_Y = 35
local TIMES_CAN_FAIL = 100
local PUSH_ABOVE_ISAAC = Vector(0, -25)

local itemBlacklist = {
    CollectibleType.COLLECTIBLE_KEY_PIECE_1,
    CollectibleType.COLLECTIBLE_KEY_PIECE_2,
    CollectibleType.COLLECTIBLE_POLAROID,
    CollectibleType.COLLECTIBLE_NEGATIVE,
    enums.Collectibles.PRISMATIC_DICE,
}

local renderItems = {}

local timerSprite = Sprite()
timerSprite:Load("gfx/ui/ui_woltimer.anm2", true)
timerSprite:Play("Idle")

--- If there is an item, such as a story one that SHOULD NOT be removed during this challenge
---@param collectibleId integer
function MilkshakeVol1.AddToWorldOfLightBlacklist(collectibleId)
    table.insert(itemBlacklist, collectibleId)
end

--- Get a collectible sprite and make it play a fading animation above Isaac
---@param player EntityPlayer
---@param collectibleId integer
local function AnimateCollectibleLoss(player, collectibleId)
    local collectibleConfig = Isaac:GetItemConfig():GetCollectible(collectibleId)
    local sprite = Sprite()
    sprite:Load("gfx/wol_collectible.anm2", true)
    sprite:ReplaceSpritesheet(1, collectibleConfig.GfxFileName)
    sprite:LoadGraphics()
    sprite:Play("Fade", true)
    player:AnimateSad()
    table.insert(renderItems, {Sprite = sprite, Player = player})
end

--- Removes a random collectible from a player that is not blacklisted
---@param player EntityPlayer
---@return boolean - true if removed, false otherwise
local function RemoveRandomCollectible(player)
    local inventory = TSIL.Players.GetPlayerInventory(player, TSIL.Enums.InventoryType.COLLECTIBLE)
    if #inventory < MIN_ITEMS then return false end
    local rng = player:GetDropRNG()
    local roll
    local itr = 0

    repeat roll = TSIL.Random.GetRandomInt(1, #inventory, rng)
        itr = itr + 1
        if itr == TIMES_CAN_FAIL then return false end
    until not TSIL.Utils.Tables.IsIn(itemBlacklist, inventory[roll].Id)
 
    AnimateCollectibleLoss(player, inventory[roll].Id)
    player:RemoveCollectible(inventory[roll].Id)
    return true
end

function worldOfLight:PostPlayerInit(player)
    if Game().Challenge == enums.Challenges.WORLD_OF_LIGHT then
        player:AddCollectible(enums.Collectibles.PRISMATIC_DICE)
        local prismaticDiceCharges = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.PRISMATIC_DICE).MaxCharges
        player:SetActiveCharge(prismaticDiceCharges)
        TSIL.SaveManager.AddPersistentVariable(MilkshakeVol1, "WoLItemRemovalTimer", INTERVAL_SECONDS, TSIL.Enums.VariablePersistenceMode.RESET_RUN)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, worldOfLight.PostPlayerInit)

function worldOfLight:PostNewRoom()
    if not Game():GetRoom():IsFirstVisit()
    or Game().Challenge ~= enums.Challenges.WORLD_OF_LIGHT then return end
    local collectibles = TSIL.PickupSpecific.GetCollectibles()
    for _, currentCollectible in ipairs(collectibles) do
        local quality = Isaac.GetItemConfig():GetCollectible(currentCollectible.SubType).Quality
        TSIL.Utils.Functions.RunInFrames(function ()
            currentCollectible:Remove()
            MilkshakeVol1.API:SplitCollectible(Isaac.GetPlayer(), currentCollectible:ToPickup(), quality, quality)
            SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT)
        end, 1, {})
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, worldOfLight.PostNewRoom)

function worldOfLight:PostPEffectUpdate(player)
    if Game().Challenge ~= enums.Challenges.WORLD_OF_LIGHT then return end
    if Game():GetFrameCount() % ONE_SECOND == 0 and Game():GetFrameCount() > ONE_SECOND
    and player:GetCollectibleCount() > MIN_ITEMS then
        local timer = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "WoLItemRemovalTimer")
        if not timer then return end

        timer = timer - 1
        if timer <= 0 then
            TSIL.SaveManager.SetPersistentVariable(MilkshakeVol1, "WoLItemRemovalTimer", INTERVAL_SECONDS)
            for _, player in ipairs(TSIL.Players.GetPlayers()) do
                RemoveRandomCollectible(player)
            end
        else
            TSIL.SaveManager.SetPersistentVariable(MilkshakeVol1, "WoLItemRemovalTimer", timer)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, worldOfLight.PostPEffectUpdate)

function worldOfLight:PostRender()
    if Game().Challenge ~= enums.Challenges.WORLD_OF_LIGHT
    or not Game():GetHUD():IsVisible() then return end
    local timer = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "WoLItemRemovalTimer")
    --Isaac.RenderScaledText(timer, RENDER_X, RENDER_Y, SCALE_X, SCALE_Y, 1, 0, 0 , 1)
    local font = Font()
    font:Load("font/pftempestasevencondensed.fnt")
    font:DrawString(timer, TEXT_RENDER_X, TEXT_RENDER_Y, KColor(1,1,1,1), 0, true)
    for idx, collectibleSprite in ipairs(renderItems) do
        if collectibleSprite.Sprite:IsFinished("Fade") then
            table.remove(renderItems, idx)
        end
        collectibleSprite.Sprite:Render(Isaac.WorldToScreen((collectibleSprite.Player).Position + PUSH_ABOVE_ISAAC))
        collectibleSprite.Sprite:Update()
    end
    timerSprite:Render(Vector(ICON_RENDER_X, ICON_RENDER_Y))
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_RENDER, worldOfLight.PostRender)

return worldOfLight