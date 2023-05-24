local doggyBag = {}
local enums = MilkshakeVol1.enums
local sfx = SFXManager()

local FLIES_TO_SPAWN = 1
local FLIES_TO_SPAWN_BFFS = 2
local DIPS_TO_SPAWN = 2
local DIPS_TO_SPAWN_BFFS = 4

local POISON_RADIUS = 60
local POISON_DAMAGE = 3
local POISON_DAMAGE_BFFS = POISON_DAMAGE * 2
local POISON_DURATION = 20
local POISON_CHECK_COOLDOWN = 10

---@param bag EntityFamiliar
local function DoggyBagPoison(bag)
    local damage
    if bag.Player and bag.Player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        damage = POISON_DAMAGE_BFFS
    else
        damage = POISON_DAMAGE
    end
    for _, enemy in ipairs(Isaac.FindInRadius(bag.Position, POISON_RADIUS, EntityPartition.ENEMY)) do
        if enemy:IsVulnerableEnemy() and not enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            enemy:AddPoison(EntityRef(bag), POISON_DURATION, damage)
        end
    end
end

---@param bag EntityFamiliar
local function DoggyBagTrigger(bag)
    local player = bag.Player
    if not player then --I have no idea if playerless familiars are even possible, but better safe than sorry.
        return end

    local dipsToSpawn
    local fliesToSpawn
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
        dipsToSpawn = DIPS_TO_SPAWN_BFFS
        fliesToSpawn = FLIES_TO_SPAWN_BFFS
    else
        dipsToSpawn = DIPS_TO_SPAWN
        fliesToSpawn = FLIES_TO_SPAWN
    end

---@diagnostic disable-next-line: param-type-mismatch
    player:AddBlueFlies(fliesToSpawn, bag.Position, nil)
    for i = 1, dipsToSpawn do
        player:AddFriendlyDip(0, bag.Position)
    end
    sfx:Play(SoundEffect.SOUND_PLOP)
end

function doggyBag:PostRoomClear()
    for _, bag in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, enums.Familiars.DOGGY_BAG)) do
        bag:GetSprite():Play("Spawn")
    end
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_ROOM_CLEAR_CHANGED, doggyBag.PostRoomClear)
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_GREED_MODE_WAVE, doggyBag.PostRoomClear)

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
    if bag.FrameCount%POISON_CHECK_COOLDOWN == 0 then
        DoggyBagPoison(bag)
    end
    local sprite = bag:GetSprite()
    if sprite:IsEventTriggered("Spawn") then
        DoggyBagTrigger(bag)
    elseif sprite:IsFinished("Spawn") then
        sprite:Play("FloatDown")
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, doggyBag.FamiliarUpdate, enums.Familiars.DOGGY_BAG)