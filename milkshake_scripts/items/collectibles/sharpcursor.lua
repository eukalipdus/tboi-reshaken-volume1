local enums = require "milkshake_scripts.enums"
local SharpCursor = {}


local CURSOR_TRAVEL_TIME = 50


function SharpCursor:OnFamiliarCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.SHARP_CURSOR,
        enums.Familiars.SHARP_CURSOR
    )
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    SharpCursor.OnFamiliarCache,
    CacheFlag.CACHE_FAMILIARS
)


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "SharpCursorDataMap",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)
TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "SharpCursorFollowMouse",
    true,
    TSIL.Enums.VariablePersistenceMode.NONE
)

---@class SharpCursorText
---@field text string
---@field frame integer
---@field alpha number
---@field position Vector

---@type SharpCursorText[]
local SharpCursorDamageTexts = {}


---@param player EntityPlayer
---@return boolean
local function ShouldActivateMouseMode(player)
    if player.ControllerIndex ~= 0 then return false end
    if not Options.MouseControl then return false end

    return TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "SharpCursorFollowMouse"
    )
end


---@param familiar EntityFamiliar
local function GetCursorData(familiar)
    local SharpCursorDataMap = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "SharpCursorDataMap"
    )

    local SharpCursorData = SharpCursorDataMap[tostring(familiar.InitSeed)]

    if SharpCursorData == nil then
        SharpCursorData = {
            travelTime = 0,
            targetEnemy = nil
        }
        SharpCursorDataMap[tostring(familiar.InitSeed)] = SharpCursorData
    end

    return SharpCursorData
end


---@param familiar EntityFamiliar
---@param player EntityPlayer
local function GetCursorTravelTime(familiar, player)
    local familiars = TSIL.Familiars.GetPlayerFamiliars(player)
    local sharpCursors = TSIL.Utils.Tables.Filter(familiars, function (_, otherFamiliar)
        return otherFamiliar.Variant == enums.Familiars.SHARP_CURSOR
    end)

    local travelTime = CURSOR_TRAVEL_TIME

    for _, otherFamiliar in ipairs(sharpCursors) do
        if otherFamiliar.InitSeed < familiar.InitSeed then
            travelTime = travelTime + 6
        end
    end

    return travelTime
end


---@param player EntityPlayer
---@return Entity?
local function GetFurthestEnemyFromPlayer(player)
    local npcs = TSIL.EntitySpecific.GetNPCs(-1, -1, -1, true)
    local enemies = TSIL.Utils.Tables.Filter(npcs, function (_, npc)
        return npc:IsVulnerableEnemy()
    end)

    if #enemies == 0 then return end

    table.sort(enemies, function (a, b)
        if a == nil then return false end
        if b == nil then return true end
        return a.Position:DistanceSquared(player.Position) > b.Position:DistanceSquared(player.Position)
    end)

    return enemies[1]
end



---@param familiar EntityFamiliar
function SharpCursor:OnSharpCursorUpdate(familiar)
    local familiarSpr = familiar:GetSprite()
    if familiarSpr:IsFinished("Click") then
        familiarSpr:Play("Idle", true)
    end

    familiar.DepthOffset = 90

    local player = familiar.Player

    --If mouse control is activated, we don't move the cursor ourselves
    if ShouldActivateMouseMode(player) then return end

    local totalTravelTime = GetCursorTravelTime(familiar, player)

    local data = GetCursorData(familiar)

    local furthestEnemy = GetFurthestEnemyFromPlayer(player)

    if furthestEnemy == nil then
        furthestEnemy = player

        if (data.targetEnemy == nil or data.targetEnemy > 0) then
            data.targetEnemy = -1
            data.travelTime = 0
        end
    elseif data.targetEnemy == nil or data.targetEnemy ~= GetPtrHash(furthestEnemy) then
        data.travelTime = 0
        data.targetEnemy = GetPtrHash(furthestEnemy)
    end

    if data.travelTime > totalTravelTime then
        familiar.Position = furthestEnemy.Position
        familiar.Velocity = furthestEnemy.Velocity
    else
        local Ease = TSIL.Utils.Easings.EaseInOutQuad
        local Lerp = TSIL.Utils.Math.Lerp

        local xStart = familiar.Position.X
        local xTarget = furthestEnemy.Position.X
        local xNew = Lerp(xStart, xTarget, Ease(data.travelTime / totalTravelTime))

        local yStart = familiar.Position.Y
        local yTarget = furthestEnemy.Position.Y
        local yNew = Lerp(yStart, yTarget, Ease(data.travelTime / totalTravelTime))

        familiar.Velocity = Vector(xNew, yNew) - familiar.Position

        data.travelTime = data.travelTime + 1
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    SharpCursor.OnSharpCursorUpdate,
    enums.Familiars.SHARP_CURSOR
)


---@param familiar EntityFamiliar
---@param player EntityPlayer
local function ClickDamageEnemies(familiar, player)
    local damage = player.Damage * 0.1

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        damage = damage * 2
    end

    local damageRounded = TSIL.Utils.Math.Round(damage, 2)

    local nearEnemies = Isaac.FindInRadius(familiar.Position, 10, EntityPartition.ENEMY)

    for _, enemy in ipairs(nearEnemies) do
        enemy:TakeDamage(
            damage,
            0,
            EntityRef(familiar),
            -1
        )
    end

    if #nearEnemies > 0 then
        SharpCursorDamageTexts[#SharpCursorDamageTexts+1] = {
            alpha = 1,
            frame = math.random(0, 20),
            text = tostring(damageRounded),
            position = Isaac.WorldToScreen(familiar.Position) + Vector(4, 4)
        }
    end
end


local BreakableGridEntities = {
    [GridEntityType.GRID_ROCK] = true,
    [GridEntityType.GRID_ROCKT] = true,
    [GridEntityType.GRID_ROCK_BOMB] = true,
    [GridEntityType.GRID_ROCK_ALT] = true,
    [GridEntityType.GRID_ROCK_SS] = true,
    [GridEntityType.GRID_ROCK_SPIKED] = true,
    [GridEntityType.GRID_ROCK_ALT2] = true,
    [GridEntityType.GRID_ROCK_GOLD] = true,
}
local DamageableGridEntities = {
    [GridEntityType.GRID_TNT] = true,
    [GridEntityType.GRID_POOP] = true
}

---@param familiar EntityFamiliar
---@param player EntityPlayer
local function ClickGridEntities(familiar, player)
    local room = Game():GetRoom()
    local gridEntity = room:GetGridEntityFromPos(familiar.Position)

    if not gridEntity then return end

    local gridType = gridEntity:GetType()

    if BreakableGridEntities[gridType] and player:HasCollectible(CollectibleType.COLLECTIBLE_TERRA) then
        gridEntity:Destroy()
    elseif DamageableGridEntities[gridType] then
        gridEntity:Hurt(1)
    end
end


---@param familiar EntityFamiliar
local function ClickCursor(familiar)
    local player = familiar.Player
    local familiarSpr = familiar:GetSprite()

    SFXManager():Play(enums.Sounds.CLICK)
    familiarSpr:Play("Click", true)

    ClickDamageEnemies(familiar, player)
    ClickGridEntities(familiar, player)
end


local WasMousePressed = false

---@param familiar EntityFamiliar
function SharpCursor:OnSharpCursorRender(familiar)
    if Game():IsPaused() then return end

    local player = familiar.Player

    local clickButton = false

    if ShouldActivateMouseMode(player) then
        local mousePos = Input.GetMousePosition(true)
        familiar.Velocity = mousePos - familiar.Position

        local isMousePressed = Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_1)

        if not WasMousePressed then
            clickButton = isMousePressed
        end

        WasMousePressed = isMousePressed
    else
        local shootActions = TSIL.Input.GetShootActions()

        for _, action in ipairs(shootActions) do
            if Input.IsActionTriggered(action, player.ControllerIndex) then
                clickButton = true
                break
            end
        end
    end

    if not clickButton then return end

    ClickCursor(familiar)

    if ShouldActivateMouseMode(player) then
        --If mouse controls are activated, manually make all other
        --sharp cursors click, since the mouse button triggered thing
        --makes it so it doenst work with multiple of them.
        local familiars = TSIL.Familiars.GetPlayerFamiliars(player)
        local sharpCursors = TSIL.Utils.Tables.Filter(familiars, function (_, otherFamiliar)
            return otherFamiliar.Variant == enums.Familiars.SHARP_CURSOR and
            otherFamiliar.InitSeed ~= familiar.InitSeed
        end)

        TSIL.Utils.Tables.ForEach(sharpCursors, function (_, otherFamiliar)
            ClickCursor(otherFamiliar)
        end)
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_FAMILIAR_RENDER,
    SharpCursor.OnSharpCursorRender,
    enums.Familiars.SHARP_CURSOR
)


---@param player EntityPlayer
function SharpCursor:OnPlayerRender(player)
    if not Options.MouseControl then return end
    if not player:HasCollectible(enums.Collectibles.SHARP_CURSOR) then return end
    if player.ControllerIndex ~= 0 then return end
    if not Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0) then return end

    local currentFollowMouse = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "SharpCursorFollowMouse"
    )

    TSIL.SaveManager.SetPersistentVariable(
        milkshakeMod,
        "SharpCursorFollowMouse",
        not currentFollowMouse
    )
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PLAYER_RENDER,
    SharpCursor.OnPlayerRender
)


function SharpCursor:OnRender()
    local font = Font()
    font:Load("font/pftempestasevencondensed.fnt")

    TSIL.Utils.Tables.ForEach(SharpCursorDamageTexts, function (_, sharpCursorText)
        local color = KColor(1, 0.7, 0.7, sharpCursorText.alpha)

        font:DrawStringScaled(
            sharpCursorText.text,
            sharpCursorText.position.X + math.sin(sharpCursorText.frame/6) * 1.6,
            sharpCursorText.position.Y,
            0.7,
            0.7,
            color
        )

        if not Game():IsPaused() then
            sharpCursorText.alpha = sharpCursorText.alpha - 0.01
            sharpCursorText.frame = sharpCursorText.frame + 1
            sharpCursorText.position = Vector(sharpCursorText.position.X, sharpCursorText.position.Y - 0.5)
        end
    end)

    SharpCursorDamageTexts = TSIL.Utils.Tables.Filter(SharpCursorDamageTexts, function (_, sharpCursorText)
        return sharpCursorText.alpha > 0
    end)
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    SharpCursor.OnRender
)