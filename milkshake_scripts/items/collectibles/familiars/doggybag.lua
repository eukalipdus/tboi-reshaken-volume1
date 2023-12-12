local doggyBag = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local DEAD_POOP = 1.0
local HOLD_RADIUS = 20
local POOP_STEP = 20
local EMPTY_PATH = "gfx/familiar_doggy_bag_empty.anm2"

local safePoops = {
    ["Normal"] = TSIL.Enums.PoopEntityVariant.NORMAL,
    ["Golden"] = TSIL.Enums.PoopEntityVariant.GOLDEN,
    ["White"] = TSIL.Enums.PoopEntityVariant.STONE,
    ["Corn"] = TSIL.Enums.PoopEntityVariant.CORNY,
    ["Burning"] = TSIL.Enums.PoopEntityVariant.BURNING,
    ["Stinky"] = TSIL.Enums.PoopEntityVariant.STINKY,
    ["Black"] = TSIL.Enums.PoopEntityVariant.BLACK,
    ["Holy"] = TSIL.Enums.PoopEntityVariant.HOLY,
    ["Rainbow"] = TSIL.Enums.PoopGridEntityVariant.RAINBOW,
    ["Charming"] = TSIL.Enums.PoopGridEntityVariant.CHARMING,
}

local poopWeights = {
    {chance = 1, value = "Normal"},
    {chance = 0.5, value = "Golden"},
    {chance = 1, value = "White"},
    {chance = 1, value = "Corn"},
    {chance = 1, value = "Burning"},
    {chance = 1, value = "Stinky"},
    {chance = 1, value = "Black"},
    {chance = 1, value = "Holy"},
    {chance = 0.5, value = "Rainbow"},
    {chance = 1, value = "Charming"},
}

local spritesheetPaths = {
    ["Normal"] = "gfx/familiar_doggy_bag.anm2",
    ["Golden"] = "gfx/familiar_doggy_bag_gold.anm2",
    ["White"] = "gfx/familiar_doggy_bag_stone.anm2",
    ["Corn"] = "gfx/familiar_doggy_bag_corny.anm2",
    ["Burning"] = "gfx/familiar_doggy_bag_fire.anm2",
    ["Stinky"] = "gfx/familiar_doggy_bag_stinky.anm2",
    ["Black"] = "gfx/familiar_doggy_bag_black.anm2",
    ["Holy"] = "gfx/familiar_doggy_bag_holy.anm2",
    ["Rainbow"] = "gfx/familiar_doggy_bag_rainbow.anm2",
    ["Charming"] = "gfx/familiar_doggy_bag_charming.anm2",
}

local function GetDoggyBags(player)
    local familiars = TSIL.Familiars.GetPlayerFamiliars(player)
    local doggyBags = TSIL.Utils.Tables.Filter(familiars, function (_, fam)
        return fam.Variant == enums.Familiars.DOGGY_BAG
    end)
    return doggyBags
end

local function SpawnPoop(bag)
    local poop
    local poopType = utility:GetData(bag, "PoopType")

    if poopType ~= "Rainbow" and poopType ~= "Charming" then
        poop = Isaac.Spawn(EntityType.ENTITY_POOP, safePoops[poopType], 0, bag.Position, Vector.Zero, bag)
    else
        poop = TSIL.GridSpecific.SpawnPoop(safePoops[poopType], Isaac.GetFreeNearPosition(bag.Position, POOP_STEP), false)
    end
    utility:SetData(bag, "PoopType", nil)
    utility:SetData(bag, "PlayerHit", true)
    utility:SetData(poop, "DoggyBagPoop", true)
end

local function FindSetIndex(allSets, playerIndex)
    for index, set in ipairs(allSets) do
        if set[1] == playerIndex then
            return index
        end
    end
    return -1
end

local function ApplyPoopType(bag, sprite, type)
    utility:SetData(bag, "PoopType", type)
    sprite:Load(spritesheetPaths[type], true)
    sprite:Play("Idle")
end

local function TrackDoggyBagPoop(player, poopType)
    if not TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "TrackedDoggyBags") then
        TSIL.SaveManager.AddPersistentVariable(MilkshakeVol1, "TrackedDoggyBags", {})
    end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local trackedSets = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "TrackedDoggyBags")
    local playerAndBags = {
        playerIndex,
        {}
    }

    if #trackedSets > 0 then
        local index = FindSetIndex(trackedSets, playerIndex)
        if index ~= -1 then
            playerAndBags = trackedSets[index]
        end
    end
    local nextBagIndex = #(playerAndBags[2]) + 1
    playerAndBags[2][nextBagIndex] = poopType
    table.insert(trackedSets, #trackedSets+1, playerAndBags)
    TSIL.SaveManager.SetPersistentVariable(MilkshakeVol1, "TrackedDoggyBags", trackedSets)
end

function doggyBag:PostNewRoomReordered()
    for i = 0, Game():GetNumPlayers() - 1 do
		local player = Game():GetPlayer(i)
        local doggyBags = GetDoggyBags(player)
        local rng =  player:GetCollectibleRNG(enums.Collectibles.DOGGY_BAG)
        for _, bag in ipairs(doggyBags) do
            local sprite = bag:GetSprite()
            if sprite:GetFilename() == EMPTY_PATH then
                local poopType = TSIL.Random.GetRandomElementFromWeightedList(rng, poopWeights)
                ApplyPoopType(bag, sprite, poopType)
                TrackDoggyBagPoop(player, poopType)
            end
        end
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_NEW_ROOM_REORDERED, doggyBag.PostNewRoomReordered)

function doggyBag:PostPEffectUpdate(player)
    if not player:HasCollectible(enums.Collectibles.DOGGY_BAG) then return end
    local entityPoops = TSIL.Entities.GetEntities(EntityType.ENTITY_POOP)
    local playerSprite = player:GetSprite()
    for _, poop in ipairs(entityPoops) do
        local canHold = (not player:IsHoldingItem() and poop.HitPoints > DEAD_POOP and playerSprite:GetFrame() > 0)
        if (player.Position):Distance(poop.Position) <= HOLD_RADIUS
        and canHold then
            if poop.Variant == TSIL.Enums.PoopEntityVariant.CORNY then
                poop:Remove()
                player:UsePoopSpell(PoopSpellType.SPELL_CORNY)
            elseif canHold then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_MOMS_BRACELET)
            end
        end
    end

    local gridPoops = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_POOP)
    for _, poop in ipairs(gridPoops) do
        if (player.Position):Distance(poop.Position) <= (HOLD_RADIUS * 1.5) then
            local canHold =  (not player:IsHoldingItem() and poop.State ~= TSIL.Enums.PoopState.DESTROYED and playerSprite:GetFrame() > 0)
            if poop.Variant == TSIL.Enums.PoopGridEntityVariant.CORN
            and canHold then
                poop:Remove()
                player:UsePoopSpell(PoopSpellType.SPELL_CORNY)
            elseif canHold then
                player:UseActiveItem(CollectibleType.COLLECTIBLE_MOMS_BRACELET)
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, doggyBag.PostPEffectUpdate)

function doggyBag:EntityTakeDmg(entity)
    if not entity then return end
    local player = entity:ToPlayer()
    if not player then return end
    if player:HasCollectible(enums.Collectibles.DOGGY_BAG) then
        local doggyBags = GetDoggyBags(player)
        for _, bag in ipairs(doggyBags) do
            if utility:GetData(bag, "PoopType") then
                bag:GetSprite():Play("Spawn")

                local trackedSets = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "TrackedDoggyBags")
                local index = FindSetIndex(trackedSets, TSIL.Players.GetPlayerIndex(player))
                if index ~= -1 then
                    for poopTypeIdx, type in ipairs(trackedSets[index][2]) do
                        if type == utility:GetData(bag, "PoopType") then
                            table.remove(trackedSets[index][2], poopTypeIdx)
                        end
                    end
                end
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, doggyBag.EntityTakeDmg, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function doggyBag:EvaluateCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.DOGGY_BAG,
        enums.Familiars.DOGGY_BAG
    )
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, doggyBag.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

---@param bag EntityFamiliar
function doggyBag:FamiliarInit(bag)
    bag:AddToFollowers()
    local sprite = bag:GetSprite()
    if sprite:GetFilename() == EMPTY_PATH
    and not utility:SetData(bag, "PlayerHit") then
        local player = bag.Player
        local bagCount = 1
        if utility:GetData(player, "BagCount") then
            bagCount = utility:GetData(player, "BagCount")
            utility:SetData(player, "BagCount", bagCount + 1)
        else
            utility:SetData(player, "BagCount", 1)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, doggyBag.FamiliarInit, enums.Familiars.DOGGY_BAG)

---@param bag EntityFamiliar
function doggyBag:FamiliarUpdate(bag)
    bag:FollowParent()
    local sprite = bag:GetSprite()
    if sprite:IsEventTriggered("Spawn") then
        SpawnPoop(bag)
    elseif sprite:IsFinished("Spawn") then
        sprite:Load(EMPTY_PATH, true)
        sprite:LoadGraphics()
        sprite:Play("Idle")
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, doggyBag.FamiliarUpdate, enums.Familiars.DOGGY_BAG)

function doggyBag:PostGameStartedReordered(isContinued)
    if isContinued then
        local trackedSets = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "TrackedDoggyBags")
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            local index = FindSetIndex(trackedSets, TSIL.Players.GetPlayerIndex(player))
            local doggyBags = GetDoggyBags(player)
            for currentBag, bag in pairs(doggyBags) do
                if index ~= -1 then
                    ApplyPoopType(bag, bag:GetSprite(), trackedSets[index][2][currentBag])
                end
            end
        end
    else
        TSIL.SaveManager.RemovePersistentVariable(MilkshakeVol1, "TrackedDoggyBags")
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GAME_STARTED_REORDERED, doggyBag.PostGameStartedReordered)