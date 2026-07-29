local enums = MilkshakeVol1.enums
local SharpCursor = {}


local CURSOR_TRAVEL_TIME = 50


function SharpCursor:OnFamiliarCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.SHARP_CURSOR,
        enums.Familiars.SHARP_CURSOR
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    SharpCursor.OnFamiliarCache,
    CacheFlag.CACHE_FAMILIARS
)


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "SharpCursorDataMap",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
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
    if not Options.MouseControl and Game().Challenge ~= enums.Challenges.ISAAC_CLICKER then return false end

    return TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SharpCursorFollowMouse"
    )
end


---@param familiar EntityFamiliar
local function GetCursorData(familiar)
    local SharpCursorDataMap = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
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
        return npc:IsVulnerableEnemy() and
        not (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) or
        npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY_BALL))
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
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    SharpCursor.OnSharpCursorUpdate,
    enums.Familiars.SHARP_CURSOR
)


---@param familiar EntityFamiliar
---@param player EntityPlayer
local function ClickDamageEnemies(familiar, player)
    local damage = player.Damage * 0.1

    if Game().Challenge == enums.Challenges.ISAAC_CLICKER then
        damage = damage * 2.857
    end

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
            position = Isaac.WorldToScreen(familiar.Position) + Vector(4, math.random(0, 30))
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

    local clickSFXEnabled = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SharpCursorClickSound"
    )
    if clickSFXEnabled then
        SFXManager():Play(enums.Sounds.CLICK)
    end

    familiarSpr:Play("Click", true)

    ClickDamageEnemies(familiar, player)
    ClickGridEntities(familiar, player)
end


local WasMousePressed = false
local WasShootPressed = false

---@param familiar EntityFamiliar
function SharpCursor:OnSharpCursorRender(familiar)
    if Game():IsPaused() then return end

    local player = familiar.Player

    local clickButton = false

    if ShouldActivateMouseMode(player) then
        local mousePos = Input.GetMousePosition(false)
        if Game():GetRoom():IsMirrorWorld() then
            mousePos = Vector(Isaac.GetScreenWidth() * Isaac.GetScreenPointScale() - mousePos.X, mousePos.Y)
        end
        mousePos = Isaac.ScreenToWorld(mousePos)
        familiar.Velocity = mousePos - familiar.Position

        local isMousePressed = Input.IsMouseBtnPressed(Mouse.MOUSE_BUTTON_1)

        if not WasMousePressed then
            clickButton = isMousePressed
        end

        WasMousePressed = isMousePressed
    else
        local shootActions = TSIL.Input.GetShootActions()

        local isShootPressed = false
        for _, action in ipairs(shootActions) do
            if Input.IsActionPressed(action, player.ControllerIndex) then
                isShootPressed = true
                break
            end
        end

        if not WasShootPressed then
            clickButton = isShootPressed
        end

        WasShootPressed = isShootPressed
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
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    SharpCursor.OnSharpCursorRender,
    enums.Familiars.SHARP_CURSOR
)


local DOUBLE_TAP_FRAME_WINDOW = 8
local doubleTapFrame = 0

function SharpCursor:OnUpdate()
    if doubleTapFrame > 0 then
        doubleTapFrame = doubleTapFrame - 1
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_UPDATE, SharpCursor.OnUpdate)


---@param player EntityPlayer
function SharpCursor:OnPlayerRender(player)
    if not Options.MouseControl then return end
    local effects = player:GetEffects()
    if not player:HasCollectible(enums.Collectibles.SHARP_CURSOR)
    and not effects:HasCollectibleEffect(enums.Collectibles.SHARP_CURSOR) then return end

    if player.ControllerIndex ~= 0 then return end
    if not Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0) then return end

    if doubleTapFrame <= 0 then
        doubleTapFrame = DOUBLE_TAP_FRAME_WINDOW
        return
    end

    local currentFollowMouse = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "SharpCursorFollowMouse"
    )

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "SharpCursorFollowMouse",
        not currentFollowMouse
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PLAYER_RENDER,
    SharpCursor.OnPlayerRender
)

local sharpCursorFont = Font()
sharpCursorFont:Load("font/pftempestasevencondensed.fnt")

function SharpCursor:OnRender()
    TSIL.Utils.Tables.ForEach(SharpCursorDamageTexts, function (_, sharpCursorText)
        local color = KColor(1, 0.7, 0.7, sharpCursorText.alpha)

        sharpCursorFont:DrawStringScaled(
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
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_RENDER,
    SharpCursor.OnRender
)