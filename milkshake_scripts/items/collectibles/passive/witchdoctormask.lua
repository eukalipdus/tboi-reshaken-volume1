local witchDoctorMask = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local NO_PILL = 0
local FF_PILL_BEGIN = 101
local FF_PILL_END = 120
local NON_P1_SCALE = Vector(0.5, 0.5)
local SPAWN_DISTANCE = 40

local movePillHudPerPlayer = {
    --Vector(394, 147),
    Vector(-12, -12), --player 1 bottom right
    Vector(-153, -270), --player 2 top right
    Vector(-420, -12), --player 3 bottom left
    Vector(-100, -12), --player 4 bottom right but slightly less

}

local function CreatePillOverlay()
    local orbPillHud = Sprite()
    orbPillHud:Load("gfx/ui/ui_orbpills.anm2", true)
    orbPillHud:Play("HUD")
    return orbPillHud
end

local function CreateFFPillOverlay()
    local orbPillHud = Sprite()
    orbPillHud:Load("gfx/ui/ui_fforbpills.anm2", true)
    orbPillHud:Play("HUD")
    return orbPillHud
end

local playersCurrentPills = {}

local orbPillHuds = {
    CreatePillOverlay(),
    CreatePillOverlay(),
    CreatePillOverlay(),
    CreatePillOverlay(),
}

local ffOrbPillHuds = {
    CreateFFPillOverlay(),
    CreateFFPillOverlay(),
    CreateFFPillOverlay(),
    CreateFFPillOverlay(),
}

local playerAnchor = {
    "bottomright",
    "bottomright",
    "bottomright",
    "bottomright",
}

local matchingPills = {
    [PillColor.PILL_BLUE_BLUE] = enums.Orbs.WATER,
    [PillColor.PILL_WHITE_BLUE] = enums.Orbs.HOLY,
    [PillColor.PILL_ORANGE_ORANGE] = enums.Orbs.ROCK,
    [PillColor.PILL_WHITE_WHITE] = enums.Orbs.UNDEAD,
    [PillColor.PILL_REDDOTS_RED] = enums.Orbs.RANDOM,
    [PillColor.PILL_PINK_RED] = enums.Orbs.UNHOLY,
    [PillColor.PILL_BLUE_CADETBLUE] = enums.Orbs.PSYCHIC,
    [PillColor.PILL_YELLOW_ORANGE] = enums.Orbs.POISON,
    [PillColor.PILL_ORANGEDOTS_WHITE] = enums.Orbs.FIRE,
    [PillColor.PILL_WHITE_AZURE] = enums.Orbs.ELECTRIC,
    [PillColor.PILL_BLACK_YELLOW] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_BLACK] = enums.Orbs.NATURE,
    [PillColor.PILL_WHITE_YELLOW] = enums.Orbs.RANDOM,
    [PillColor.PILL_GOLD] = enums.Orbs.RANDOM,
    [PillColor.PILL_BLUE_BLUE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.WATER,
    [PillColor.PILL_WHITE_BLUE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.HOLY,
    [PillColor.PILL_ORANGE_ORANGE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.ROCK,
    [PillColor.PILL_WHITE_WHITE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.UNDEAD,
    [PillColor.PILL_REDDOTS_RED | PillColor.PILL_GIANT_FLAG] = enums.Orbs.RANDOM,
    [PillColor.PILL_PINK_RED | PillColor.PILL_GIANT_FLAG] = enums.Orbs.UNHOLY,
    [PillColor.PILL_BLUE_CADETBLUE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.PSYCHIC,
    [PillColor.PILL_YELLOW_ORANGE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.POISON,
    [PillColor.PILL_ORANGEDOTS_WHITE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.FIRE,
    [PillColor.PILL_WHITE_AZURE | PillColor.PILL_GIANT_FLAG] = enums.Orbs.ELECTRIC,
    [PillColor.PILL_BLACK_YELLOW | PillColor.PILL_GIANT_FLAG] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_BLACK | PillColor.PILL_GIANT_FLAG] = enums.Orbs.NATURE,
    [PillColor.PILL_WHITE_YELLOW | PillColor.PILL_GIANT_FLAG] = enums.Orbs.RANDOM,
    [PillColor.PILL_GOLD | PillColor.PILL_GIANT_FLAG] = enums.Orbs.RANDOM,

}

local pillAnimFrames = {
    PillColor.PILL_BLUE_BLUE,
    PillColor.PILL_WHITE_BLUE,
    PillColor.PILL_ORANGE_ORANGE,
    PillColor.PILL_WHITE_WHITE,
    PillColor.PILL_REDDOTS_RED,
    PillColor.PILL_PINK_RED,
    PillColor.PILL_BLUE_CADETBLUE,
    PillColor.PILL_YELLOW_ORANGE,
    PillColor.PILL_ORANGEDOTS_WHITE,
    PillColor.PILL_WHITE_AZURE,
    PillColor.PILL_BLACK_YELLOW,
    PillColor.PILL_WHITE_BLACK,
    PillColor.PILL_WHITE_YELLOW,
    PillColor.PILL_BLUE_BLUE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_WHITE_BLUE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_ORANGE_ORANGE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_WHITE_WHITE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_REDDOTS_RED | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_PINK_RED | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_BLUE_CADETBLUE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_YELLOW_ORANGE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_ORANGEDOTS_WHITE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_WHITE_AZURE | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_BLACK_YELLOW | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_WHITE_BLACK | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_GOLD,
    PillColor.PILL_GOLD | PillColor.PILL_GIANT_FLAG,
    PillColor.PILL_WHITE_YELLOW | PillColor.PILL_GIANT_FLAG,
}

local ffPillAnimFrames = {
    101,
    102,
    103,
    104,
    105,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    118,
    119,
    120,
    99, -- PLACEHOLDER
    999, -- PLACEHOLDER
    101 | PillColor.PILL_GIANT_FLAG,
    102 | PillColor.PILL_GIANT_FLAG,
    103 | PillColor.PILL_GIANT_FLAG,
    104 | PillColor.PILL_GIANT_FLAG,
    105 | PillColor.PILL_GIANT_FLAG,
    106 | PillColor.PILL_GIANT_FLAG,
    107 | PillColor.PILL_GIANT_FLAG,
    108 | PillColor.PILL_GIANT_FLAG,
    109 | PillColor.PILL_GIANT_FLAG,
    110 | PillColor.PILL_GIANT_FLAG,
    111 | PillColor.PILL_GIANT_FLAG,
    112 | PillColor.PILL_GIANT_FLAG,
    113 | PillColor.PILL_GIANT_FLAG,
    114 | PillColor.PILL_GIANT_FLAG,
    115 | PillColor.PILL_GIANT_FLAG,
    116 | PillColor.PILL_GIANT_FLAG,
    117 | PillColor.PILL_GIANT_FLAG,
    118 | PillColor.PILL_GIANT_FLAG,
    119 | PillColor.PILL_GIANT_FLAG,
    120 | PillColor.PILL_GIANT_FLAG,
    9999, -- PLACEHOLDER
    99999, -- PLACEHOLDER
}

local function IsFiendFolioPill(id)
    for _, ffPillId in ipairs(ffPillAnimFrames) do
        if id == ffPillId then return true end
    end
    return false
end

local function GetFrameFromId(pillColor, frameTable)
    for index, pillToCheck in ipairs(frameTable) do
        if pillColor == pillToCheck then
            return index
        end
    end
end

--- Adds a pill color and its horse pill variant and gives it a corresponding spirit orb
---@param pillColor integer
---@param spiritOrb number
function MilkshakeVol1.API:AddOrbsPerPill(pillColor, spiritOrb)
    matchingPills[pillColor] = spiritOrb
    matchingPills[pillColor | PillColor.PILL_GIANT_FLAG] = spiritOrb
end

function witchDoctorMask:UsePill(_, player)
    if player:HasCollectible(enums.Collectibles.WITCH_DOCTOR_MASK) then
        --local colorToEffect = {}
        --for i = 1, PillColor.NUM_STANDARD_PILLS do
        --    colorToEffect[Game():GetItemPool():GetPillEffect(i, player)] = i
        --end
        local pillColor = playersCurrentPills[GetPtrHash(player)] --colorToEffect[pillEffect]
        local spiritOrb = matchingPills[pillColor]
        if not spiritOrb then
            spiritOrb = enums.Orbs.RANDOM
        end
        local flags = enums.UseOrbFlags.NO_SOUND
        if TSIL.Pills.IsHorsePill(pillColor) then
            flags = flags | enums.UseOrbFlags.DOUBLE_POWER
        end
        MilkshakeVol1:UseSpiritOrb(spiritOrb, player, flags)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_PILL, witchDoctorMask.UsePill)

function witchDoctorMask:PostPEffectUpdate(player)
    if player:GetPill(0) == NO_PILL then return end
    playersCurrentPills[GetPtrHash(player)] = player:GetPill(0)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, witchDoctorMask.PostPEffectUpdate)

function witchDoctorMask:PostPickupUpdate(pickup)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.WITCH_DOCTOR_MASK)
        and pickup.Variant == PickupVariant.PICKUP_PILL then
            if not utility:GetData(pickup, "SpiritPillSprite") then
                local sprite = pickup:GetSprite()
                if pickup.SubType < FF_PILL_BEGIN
                or (pickup.SubType > PillColor.PILL_GIANT_FLAG and not (pickup.SubType > (FF_PILL_BEGIN | PillColor.PILL_GIANT_FLAG))) then
                    sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/spirit pills ground.png")

                elseif (pickup.SubType >= FF_PILL_BEGIN and pickup.SubType <= FF_PILL_END)
                or (pickup.SubType >= (FF_PILL_BEGIN | PillColor.PILL_GIANT_FLAG) and pickup.SubType <= (FF_PILL_END | PillColor.PILL_GIANT_FLAG)) then
                    sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/spirit pillsFF.png")
                end
                sprite:LoadGraphics()
                utility:SetData(pickup, "SpiritPillSprite", true)
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, witchDoctorMask.PostPickupUpdate)

function witchDoctorMask:GetShaderParams()
    if Game():GetHUD():IsVisible() then
        local players = TSIL.Players.GetPlayers()
        for i, player in ipairs(players) do
            local heldPill = player:GetPill(0)
            if player:HasCollectible(enums.Collectibles.WITCH_DOCTOR_MASK)
            and heldPill ~= 0 then
                local isFiendFolio = IsFiendFolioPill(heldPill)

                if player:GetPlayerType() ~= PlayerType.PLAYER_JACOB
                and player:GetPlayerType() ~= PlayerType.PLAYER_ESAU then
                    local position = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) + movePillHudPerPlayer[i]
                    local x, y = utility:HUDOffset(position.X, position.Y, playerAnchor[i])
                    position = Vector(x,y)
                    if isFiendFolio then
                        ffOrbPillHuds[i]:Render(position)
                        ffOrbPillHuds[i]:SetFrame(GetFrameFromId(heldPill, ffPillAnimFrames) - 1)
                        ffOrbPillHuds[i]:Play("HUD")
                    else
                        orbPillHuds[i]:Render(position)
                        orbPillHuds[i]:SetFrame(GetFrameFromId(heldPill, pillAnimFrames) - 1)
                        print(GetFrameFromId(heldPill, pillAnimFrames) - 1)
                        orbPillHuds[i]:Play("HUD")
                    end
                end

                if i > 1 then
                    if isFiendFolio then
                        orbPillHuds[i].Scale = NON_P1_SCALE
                    else
                        ffOrbPillHuds[i].Scale = NON_P1_SCALE
                    end
                end
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, witchDoctorMask.GetShaderParams)

function witchDoctorMask:PostPlayerCollectibleAdded(player, collectible, firstTime)
    if collectible ~= enums.Collectibles.WITCH_DOCTOR_MASK
    or ((firstTime == false) and #(TSIL.Players.GetPlayersOfType(PlayerType.PLAYER_ISAAC_B)) > 0) then return end
    local roll = TSIL.Random.GetRandomInt(1, PillColor.NUM_PILLS)
    local spawnPos = Isaac.GetFreeNearPosition(player.Position, SPAWN_DISTANCE)
    TSIL.PickupSpecific.SpawnPill(roll, spawnPos)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, witchDoctorMask.PostPlayerCollectibleAdded)

return witchDoctorMask