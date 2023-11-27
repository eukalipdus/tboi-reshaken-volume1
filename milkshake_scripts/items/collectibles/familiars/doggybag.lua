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

local poopStrings = {
    "Normal",
    "Golden",
    "White",
    "Corn",
    "Burning",
    "Stinky",
    "Black",
    "Holy",
    "Rainbow",
    "Charming",
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
    utility:SetData(poop, "DoggyBagPoop", true)
end

function doggyBag:PostNewRoom()
    for i = 0, Game():GetNumPlayers() - 1 do
		local player = Game():GetPlayer(i)
        local doggyBags = GetDoggyBags(player)
        local rng =  player:GetCollectibleRNG(enums.Collectibles.DOGGY_BAG)
        for _, bag in ipairs(doggyBags) do
            local poopType = TSIL.Random.GetRandomElementsFromTable(poopStrings, 1, rng)
            utility:SetData(bag, "PoopType", poopType[1])
            local sprite = bag:GetSprite()
            sprite:Load(spritesheetPaths[poopType[1]], true)
            sprite:Play("Idle")
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, doggyBag.PostNewRoom)

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