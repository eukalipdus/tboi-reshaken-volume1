local doggyBag = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local HOLD_RADIUS = 20

local function GetDoggyBags(player)
    local familiars = TSIL.Familiars.GetPlayerFamiliars(player)
    local doggyBags = TSIL.Utils.Tables.Filter(familiars, function (_, fam)
        return fam.Variant == enums.Familiars.DOGGY_BAG
    end)
    return doggyBags
end

local function SpawnPoop(bag)
    local poop = Isaac.Spawn(EntityType.ENTITY_POOP, utility:GetData(bag, "PoopType"), 0, bag.Position, Vector.Zero, bag)
    utility:SetData(bag, "PoopType", nil)
    utility:SetData(poop, "DoggyBagPoop", true)
end

function doggyBag:PostNewRoom()
    for i = 0, Game():GetNumPlayers() - 1 do
		local player = Game():GetPlayer(i)
        local doggyBags = GetDoggyBags(player)
        local rng =  player:GetCollectibleRNG(enums.Collectibles.DOGGY_BAG)
        for _, bag in ipairs(doggyBags) do
            local poopType = TSIL.Random.GetRandomElementsFromTable(TSIL.Enums.PoopEntityVariant, 1, rng)
            utility:SetData(bag, "PoopType", poopType[1])
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, doggyBag.PostNewRoom)

function doggyBag:PostPEffectUpdate(player)
    local entityPoops = TSIL.Entities.GetEntities(EntityType.ENTITY_POOP)
    for _, poop in ipairs(entityPoops) do
        if (player.Position):Distance(poop.Position) <= HOLD_RADIUS
        and not player:IsHoldingItem() then
            if poop.Variant == TSIL.Enums.PoopEntityVariant.CORNY then
                poop:Remove()
                player:UsePoopSpell(PoopSpellType.SPELL_CORNY)
            else
                player:UseActiveItem(CollectibleType.COLLECTIBLE_MOMS_BRACELET)
            end
        end
    end

    local gridPoops = TSIL.GridEntities.GetGridEntities(GridEntityType.GRID_POOP)
    for _, poop in ipairs(gridPoops) do
        if (player.Position):Distance(poop.Position) <= (HOLD_RADIUS * 1.5) then
            if poop.Variant == TSIL.Enums.PoopGridEntityVariant.CORN
            and not player:IsHoldingItem() then
                poop:Remove()
                player:UsePoopSpell(PoopSpellType.SPELL_CORNY)
            else
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
        sprite:Play("Idle")
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, doggyBag.FamiliarUpdate, enums.Familiars.DOGGY_BAG)