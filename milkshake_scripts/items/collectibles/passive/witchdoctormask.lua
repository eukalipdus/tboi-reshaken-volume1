local witchDoctorMask = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local HORSE_PILL_INC = 2048
local NO_PILL = 0
local FF_PILL_BEGIN = 101
local FF_PILL_END = 120
local NON_P1_SCALE = Vector(0.5, 0.5)
local SPAWN_DISTANCE = 40

local addToVector = {
    Vector(-12, -12),
    Vector(394, 147),
}

local function CreatePillOverlay()
    local orbPillHud = Sprite()
    orbPillHud:Load("gfx/ui/ui_orbpills.anm2", true)
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

local playerAnchor = {
    "bottomright",
}

local matchingPills = {
    [PillColor.PILL_BLUE_BLUE] = enums.Orbs.WATER,
    [PillColor.PILL_WHITE_BLUE] = enums.Orbs.HOLY,
    [PillColor.PILL_ORANGE_ORANGE] = enums.Orbs.RANDOM,
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
    [PillColor.PILL_BLUE_BLUE + HORSE_PILL_INC] = enums.Orbs.WATER,
    [PillColor.PILL_WHITE_BLUE + HORSE_PILL_INC] = enums.Orbs.HOLY,
    [PillColor.PILL_ORANGE_ORANGE + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_WHITE + HORSE_PILL_INC] = enums.Orbs.UNDEAD,
    [PillColor.PILL_REDDOTS_RED + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_PINK_RED + HORSE_PILL_INC] = enums.Orbs.UNHOLY,
    [PillColor.PILL_BLUE_CADETBLUE + HORSE_PILL_INC] = enums.Orbs.PSYCHIC,
    [PillColor.PILL_YELLOW_ORANGE + HORSE_PILL_INC] = enums.Orbs.POISON,
    [PillColor.PILL_ORANGEDOTS_WHITE + HORSE_PILL_INC] = enums.Orbs.FIRE,
    [PillColor.PILL_WHITE_AZURE + HORSE_PILL_INC] = enums.Orbs.ELECTRIC,
    [PillColor.PILL_BLACK_YELLOW + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_WHITE_BLACK + HORSE_PILL_INC] = enums.Orbs.NATURE,
    [PillColor.PILL_WHITE_YELLOW + HORSE_PILL_INC] = enums.Orbs.RANDOM,
    [PillColor.PILL_GOLD + HORSE_PILL_INC] = enums.Orbs.RANDOM,

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
}

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
    matchingPills[pillColor + HORSE_PILL_INC] = spiritOrb
end

function witchDoctorMask:UsePill(_, player)
    if player:HasCollectible(enums.Collectibles.WITCH_DOCTOR_MASK) then
        --local colorToEffect = {}
        --for i = 1, PillColor.NUM_STANDARD_PILLS do
        --    colorToEffect[Game():GetItemPool():GetPillEffect(i, player)] = i
        --end
        local pillColor = playersCurrentPills[GetPtrHash(player)] --colorToEffect[pillEffect]
        if TSIL.Pills.IsHorsePill(pillColor) then
            utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", true)
        end
        local spiritOrb = matchingPills[pillColor]
        if not spiritOrb then
            spiritOrb = enums.Orbs.RANDOM
        end
        player:UseCard(spiritOrb, UseFlag.USE_NOANIM)
        --utility:SetTemporaryPlayerData(player, "IsUsingDoublePowerOrb", false) seems like it should be done but could mess with lyra?
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
                if pickup.SubType < FF_PILL_BEGIN then
                    pickup:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/spirit pills ground.png")

                elseif pickup.SubType >= FF_PILL_BEGIN and pickup.SubType <= FF_PILL_END then
                    pickup:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/spirit pillsFF.png")
                end
                pickup:GetSprite():LoadGraphics()
                utility:SetData(pickup, "SpiritPillSprite", true)
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, witchDoctorMask.PostPickupUpdate)

function witchDoctorMask:PostRender()
    if Game():GetHUD():IsVisible() then
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i)
            local heldPill = player:GetPill(0)
            if player:HasCollectible(enums.Collectibles.WITCH_DOCTOR_MASK)
            and heldPill ~= 0 then

                if player:GetPlayerType() ~= PlayerType.PLAYER_JACOB
                and player:GetPlayerType() ~= PlayerType.PLAYER_ESAU then
                    local position = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight()) + addToVector[i]
                    local x, y = utility:HUDOffset(position.X, position.Y, playerAnchor[i])
                    position = Vector(x,y)
                    orbPillHuds[i]:Render(position)
                    orbPillHuds[i]:SetFrame(GetFrameFromId(heldPill, pillAnimFrames) - 1)
                end

                if i > 1 then
                    orbPillHuds[i].Scale = NON_P1_SCALE
                end
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, witchDoctorMask.PostRender)

function witchDoctorMask:PostItemPickup(player, collectible)
    if collectible ~= enums.Collectibles.WITCH_DOCTOR_MASK then return end
    local roll = TSIL.Random.GetRandomInt(1, PillColor.NUM_PILLS)
    local spawnPos = Isaac.GetFreeNearPosition(player.Position, SPAWN_DISTANCE)
    TSIL.PickupSpecific.SpawnPill(roll, spawnPos)
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_ITEM_PICKUP, witchDoctorMask.PostItemPickup)

return witchDoctorMask