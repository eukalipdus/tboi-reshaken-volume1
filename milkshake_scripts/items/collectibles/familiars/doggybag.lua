local doggyBag = {}
local enums = MilkshakeVol1.enums
local sfx = SFXManager()

local FLIES_TO_SPAWN = 1
local FLIES_TO_SPAWN_BFFS = 2
local DIPS_TO_SPAWN = 2
local DIPS_TO_SPAWN_BFFS = 4

local CLOUD_ALPHA = 0.3
local CLOUD_OFFSET = Vector(0,-11)

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
    local aura = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.FART_RING,
        0,
        bag.Position,
        Vector.Zero,
        bag
    ):ToEffect()
    aura:FollowParent(bag)
    aura:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
    aura.Color = Color(1, 1, 1, CLOUD_ALPHA)
    aura.ParentOffset = CLOUD_OFFSET
    bag.Child = aura
    bag:AddToFollowers()
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, doggyBag.FamiliarInit, enums.Familiars.DOGGY_BAG)

---@param bag EntityFamiliar
function doggyBag:FamiliarUpdate(bag)
    bag:FollowParent()
    local sprite = bag:GetSprite()
    if sprite:IsEventTriggered("Spawn") then
        DoggyBagTrigger(bag)
    elseif sprite:IsFinished("Spawn") then
        sprite:Play("Idle")
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, doggyBag.FamiliarUpdate, enums.Familiars.DOGGY_BAG)

function doggyBag:RemoveCloud(bag)
    if bag.Variant ~= enums.Familiars.DOGGY_BAG or not bag.Child then
        return end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, doggyBag.RemoveCloud, EntityType.ENTITY_FAMILIAR)