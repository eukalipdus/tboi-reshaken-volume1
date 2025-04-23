local FragileMirror = {}
local enums = MilkshakeVol1.enums


local FRAGILE_MIRROR_SPRITES = {
    "amongus",
    "andre",
    "andre2",
    "angel",
    "apollo",
    "awooga",
    "balloon_baby",
    "big_ben",
    "birdley",
    "block",
    "body",
    "borb",
    "builder",
    "caveman",
    "checkmate",
    "cupcake",
    "cupcake_unit",
    "devil",
    "dogma",
    "eggplant",
    "error",
    "fall_from_grace",
    "fiend",
    "flowey",
    "flowey2",
    "fused_souls",
    "gate",
    "glizzy_chin",
    "godhead",
    "Grayfruit",
    "greg",
    "heart",
    "horfy",
    "host",
    "house",
    "marise",
    "milkshake",
    "mind",
    "mirror_frisk",
    "moai",
    "morsel",
    "mr_uncanny",
    "numbers",
    "paul",
    "pawn",
    "peat",
    "pepperman",
    "pizzahead",
    "red_baby",
    "red_baby2",
    "robobaby",
    "saxxy",
    "seth",
    "shattering_of_humanity",
    "sinister",
    "solomon",
    "soul",
    "terraria_tree",
    "thinker",
    "totem",
    "triangle",
    "trophy",
    "uzzah",
    "wario",
    "warpheart",
    "wayne",
    "whimsy",
    "worm",
    "yippie"
}
local MAX_HITPOINTS = 3
local ROOMS_UNTIL_UNBROKEN = 1
local INVINCIBILITY_FRAMES = 30

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "FragileMirrorHitPoints",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "FragileMirrorIFrames",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "FragileMirrorRevivesUsedPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "FragileMirrorsBrokenPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "PlayerQueueInfoRender",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "PlayersRevivingFromDevilDeal",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)


---Returns the unbroken mirror found
---@param player EntityPlayer
---@return EntityFamiliar?
function MilkshakeVol1.API:HasAnyUnbrokenMirror(player)
    local familiars = TSIL.Familiars.GetPlayerFamiliars(player)
    local fragileMirrors = TSIL.Utils.Tables.Filter(familiars, function(_, familiar)
        return familiar.Variant == enums.Familiars.FRAGILE_MIRROR
    end)

    local hitPointsFragileMirrors = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorHitPoints"
    )

    local unbrokenMirror = TSIL.Utils.Tables.FindFirst(fragileMirrors, function(_, familiar)
        local initSeed = familiar.InitSeed

        --Must have some hp left (Shouldn't happen but fallback)
        local hitPoints = hitPointsFragileMirrors[initSeed]
        if hitPoints and hitPoints <= 0 then return false end

        return true
    end)

    return unbrokenMirror
end


---@param familiar EntityFamiliar
---@param isRevive boolean
local function BreakMirror(familiar, isRevive)
    local player = familiar.Player
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    if isRevive then
        local usedRevivesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "FragileMirrorRevivesUsedPerPlayer"
        )

        local usedRevives = usedRevivesPerPlayer[playerIndex]
        if usedRevives == nil then
            usedRevives = 0
        end

        usedRevives = usedRevives + 1
        usedRevivesPerPlayer[playerIndex] = usedRevives
    else
        local mirrorsBrokenPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "FragileMirrorsBrokenPerPlayer"
        )

        local mirrorsBroken = mirrorsBrokenPerPlayer[playerIndex]
        if mirrorsBroken == nil then
            mirrorsBroken = {}
        end

        mirrorsBroken[#mirrorsBroken + 1] = ROOMS_UNTIL_UNBROKEN
        mirrorsBrokenPerPlayer[playerIndex] = mirrorsBroken
    end

    TSIL.EntitySpecific.SpawnEffect(
        enums.Effects.GLASS_IDOL_SHATTER,
        0,
        familiar.Position
    )
    SFXManager():Play(SoundEffect.SOUND_MIRROR_BREAK, 1, 2, false, 1.3)
    familiar:Remove()
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS | CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
end


---@param familiar EntityFamiliar
local function TryUpdateAnimation(familiar)
    local initSeed = familiar.InitSeed

    local hitPointsFragileMirrors = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorHitPoints"
    )

    local hitPoints = hitPointsFragileMirrors[initSeed]

    if not hitPoints then
        hitPoints = MAX_HITPOINTS
        hitPointsFragileMirrors[initSeed] = MAX_HITPOINTS
    end

    if hitPoints == 0 then
        hitPoints = 1
    end

    local animToPlay = "Idle" .. hitPoints

    local sprite = familiar:GetSprite()
    local currentAnim = sprite:GetAnimation()

    if currentAnim ~= animToPlay then
        sprite:Play(animToPlay, true)
    end
end


---@param player EntityPlayer
local function GetTargetFragileMirrorCount(player)
    local effects = player:GetEffects()
    local maxFragileMirrorNum = player:GetCollectibleNum(enums.Collectibles.FRAGILE_MIRROR) +
        effects:GetCollectibleEffectNum(enums.Collectibles.FRAGILE_MIRROR)

    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local usedRevivesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorRevivesUsedPerPlayer"
    )

    local usedRevives = usedRevivesPerPlayer[playerIndex]
    if usedRevives == nil then
        usedRevives = 0
    end

    local mirrorsBrokenPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorsBrokenPerPlayer"
    )

    local mirrorsBroken = mirrorsBrokenPerPlayer[playerIndex]
    if mirrorsBroken == nil then
        mirrorsBroken = {}
    end

    local totalBrokenMirrors = usedRevives + #mirrorsBroken

    local mirrorsToSpawn = maxFragileMirrorNum - totalBrokenMirrors

    return math.max(0, mirrorsToSpawn)
end


---@param player EntityPlayer
function FragileMirror:OnFamiliarCache(player)
    local targetFragileMirrorNum = GetTargetFragileMirrorCount(player)

    TSIL.Familiars.CheckFamiliar(
        player,
        enums.Collectibles.FRAGILE_MIRROR,
        targetFragileMirrorNum,
        enums.Familiars.FRAGILE_MIRROR
    )
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    FragileMirror.OnFamiliarCache,
    CacheFlag.CACHE_FAMILIARS
)

---@param player EntityPlayer
function FragileMirror:OnLuckCache(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local mirrorsBrokenPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorsBrokenPerPlayer"
    )

    local mirrorsBroken = mirrorsBrokenPerPlayer[playerIndex]
    if mirrorsBroken == nil then
        mirrorsBroken = {}
    end

    player.Luck = player.Luck - #mirrorsBroken
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    FragileMirror.OnLuckCache,
    CacheFlag.CACHE_LUCK
)


---@param familiar EntityFamiliar
function FragileMirror:OnFamiliarInit(familiar)
    familiar:AddToFollowers()

    local sprite = familiar:GetSprite()
    local rng = TSIL.RNG.NewRNG(familiar.InitSeed)
    local spriteSheet = TSIL.Random.GetRandomElementsFromTable(FRAGILE_MIRROR_SPRITES, 1, rng)[1]
    sprite:ReplaceSpritesheet(0, "gfx/familiar/glass_idol/" .. spriteSheet .. ".png")
    sprite:LoadGraphics()

    TryUpdateAnimation(familiar)
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_FAMILIAR_INIT,
    FragileMirror.OnFamiliarInit,
    enums.Familiars.FRAGILE_MIRROR
)


---@param familiar EntityFamiliar
function FragileMirror:OnFamiliarUpdate(familiar)
    local fragileMirrorIFrames = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorIFrames"
    )

    local initSeed = familiar.InitSeed
    local iFrames = fragileMirrorIFrames[initSeed]

    if iFrames then
        iFrames = iFrames - 1

        if iFrames <= 0 then
            iFrames = nil
        end

        fragileMirrorIFrames[initSeed] = iFrames
    end

    familiar:FollowParent()
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    FragileMirror.OnFamiliarUpdate,
    enums.Familiars.FRAGILE_MIRROR
)

---@param familiar EntityFamiliar
---@param projectile EntityProjectile
local function CheckCollisionWithProjectile(familiar, projectile)
    if projectile:HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) then return end

    projectile:Die()

    local initSeed = familiar.InitSeed

    local fragileMirrorIFrames = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorIFrames"
    )
    local iFrames = fragileMirrorIFrames[initSeed]

    if iFrames then return end

    fragileMirrorIFrames[initSeed] = INVINCIBILITY_FRAMES

    local hitPointsPerFamiliar = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorHitPoints"
    )
    local hitPoints = hitPointsPerFamiliar[initSeed]

    if not hitPoints then
        hitPoints = MAX_HITPOINTS
    end

    hitPoints = hitPoints - 1

    if hitPoints == 0 then
        BreakMirror(familiar, false)
        return
    end

    hitPointsPerFamiliar[initSeed] = hitPoints

    TryUpdateAnimation(familiar)

    return false
end


---@param familiar EntityFamiliar
---@param entity Entity
function FragileMirror:OnFamiliarCollision(familiar, entity)
    local projectile = entity:ToProjectile()
    if projectile then
        return CheckCollisionWithProjectile(familiar, projectile)
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
    FragileMirror.OnFamiliarCollision,
    enums.Familiars.FRAGILE_MIRROR
)


local isRevivingWithFragileMirror = false
local familiarsUsed = {}


---@param player EntityPlayer
local function RevivingEffects(player)
    SFXManager():Play(SoundEffect.SOUND_SUPERHOLY)
    player:AddSoulHearts(2)
    player:AnimateCollectible(enums.Collectibles.FRAGILE_MIRROR)
    local mirrorUsed = table.remove(familiarsUsed, 1)
    BreakMirror(mirrorUsed, true)
    player:UseActiveItem(
        CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
        UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER
    )
end


---@param player EntityPlayer
function FragileMirror:PreCustomRevive(player)
    local unbrokenMirror = MilkshakeVol1.API:HasAnyUnbrokenMirror(player)

    if not unbrokenMirror then return end

    isRevivingWithFragileMirror = true
    familiarsUsed[#familiarsUsed + 1] = unbrokenMirror

    return TSIL.Enums.CustomReviveType.SAME_ROOM
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.PRE_CUSTOM_REVIVE,
    FragileMirror.PreCustomRevive
)


---@param player EntityPlayer
function FragileMirror:PostCustomRevive(player)
    if not isRevivingWithFragileMirror then return end

    RevivingEffects(player)
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_CUSTOM_REVIVE,
    FragileMirror.PostCustomRevive
)


---@param player EntityPlayer
---@param itemInfo ItemConfigItem
local function CheckIfPlayerWillDieFromItem(player, itemInfo)
    --The lost can pick up free devil deals
    if TSIL.Players.IsTheLost(player) then return end

    --The item will grant at least one heart
    if itemInfo.AddBlackHearts > 0 and itemInfo.AddMaxHearts > 0 and itemInfo.AddSoulHearts > 0 then return end
    --The player has some health
    if TSIL.Players.GetPlayerNumHitsRemaining(player) > 0 then return end

    local unbrokenMirror = MilkshakeVol1.API:HasAnyUnbrokenMirror(player)

    if not unbrokenMirror then return end

    isRevivingWithFragileMirror = true
    familiarsUsed[#familiarsUsed + 1] = unbrokenMirror

    ---@diagnostic disable-next-line: param-type-mismatch
    player:UseCard(Card.CARD_SOUL_LAZARUS, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playersReviving = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayersRevivingFromDevilDeal"
    )
    playersReviving[playerIndex] = true
end


---@param player EntityPlayer
---@param pickingUpItem table
local function QueueEmpty(player, pickingUpItem)
    if pickingUpItem.ID == CollectibleType.COLLECTIBLE_NULL or
        pickingUpItem.Type == ItemType.ITEM_NULL then
        return
    end

    if pickingUpItem.Type ~= ItemType.ITEM_TRINKET then
        local itemConfig = Isaac.GetItemConfig()
        local itemInfo = itemConfig:GetCollectible(pickingUpItem.ID)
        CheckIfPlayerWillDieFromItem(player, itemInfo)
    end

    pickingUpItem.Type = ItemType.ITEM_NULL
    pickingUpItem.ID = CollectibleType.COLLECTIBLE_NULL
end


---@param player EntityPlayer
---@param pickingUpItem table
local function QueueNotEmpty(player, pickingUpItem)
    local queuedItem = player.QueuedItem.Item;
    if queuedItem == nil or queuedItem.Type == ItemType.ITEM_NULL then
        return
    end

    if queuedItem.Type ~= pickingUpItem.Type or
        queuedItem.ID ~= pickingUpItem.ID then
        pickingUpItem.ID = queuedItem.ID
        pickingUpItem.Type = queuedItem.Type
    end
end


---@param player EntityPlayer
function FragileMirror:OnPlayerRender(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local prevQueuedItemPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayerQueueInfoRender"
    )
    local pickingUpItem = prevQueuedItemPerPlayer[playerIndex]

    if pickingUpItem == nil then
        pickingUpItem = {
            ID = CollectibleType.COLLECTIBLE_NULL,
            Type = ItemType.ITEM_NULL
        }

        prevQueuedItemPerPlayer[playerIndex] = pickingUpItem
    end

    if player:IsItemQueueEmpty() then
        QueueEmpty(player, pickingUpItem)
    else
        QueueNotEmpty(player, pickingUpItem)
    end
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_RENDER_REORDERED,
    FragileMirror.OnPlayerRender
)


---@param player EntityPlayer
function FragileMirror:OnPeffectUpdate(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playersReviving = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayersRevivingFromDevilDeal"
    )

    if not playersReviving[playerIndex] then return end
    playersReviving[playerIndex] = nil

    RevivingEffects(player)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PEFFECT_UPDATE_REORDERED,
    FragileMirror.OnPeffectUpdate
)


function FragileMirror:OnRoomClear()
    local players = TSIL.Players.GetPlayers()

    local mirrorsBrokenPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "FragileMirrorsBrokenPerPlayer"
    )

    for _, player in ipairs(players) do
        local playerIndex = TSIL.Players.GetPlayerIndex(player)
        local mirrorsBroken = mirrorsBrokenPerPlayer[playerIndex]

        if mirrorsBroken then
            local newMirrorsBroken = {}

            for _, roomsUntilRespawn in ipairs(mirrorsBroken) do
                roomsUntilRespawn = roomsUntilRespawn - 1
                if roomsUntilRespawn > 0 then
                    newMirrorsBroken[#newMirrorsBroken + 1] = roomsUntilRespawn
                end
            end

            if #newMirrorsBroken == 0 then
                mirrorsBrokenPerPlayer[playerIndex] = nil
            else
                mirrorsBrokenPerPlayer[playerIndex] = newMirrorsBroken
            end
        end

        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS | CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_ROOM_CLEAR_CHANGED,
    FragileMirror.OnRoomClear,
    true
)


function FragileMirror:OnNewLevel()
    local players = TSIL.Players.GetPlayers()

    for _, player in ipairs(players) do
        player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS | CacheFlag.CACHE_LUCK)
        player:EvaluateItems()
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    FragileMirror.OnNewLevel
)


function FragileMirror:OnNewRoom()
    local fragileMirrors = TSIL.EntitySpecific.GetFamiliars(enums.Familiars.FRAGILE_MIRROR)

    for _, familiar in ipairs(fragileMirrors) do
        TryUpdateAnimation(familiar)
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    FragileMirror.OnNewRoom
)


---@param effect EntityEffect
function FragileMirror:OnGlassIdolShatterUpdate(effect)
    local sprite = effect:GetSprite()

    if sprite:IsFinished("Appear")
    and effect.Variant == enums.Effects.GLASS_IDOL_SHATTER then
        effect:Remove()
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_EFFECT_UPDATE,
    FragileMirror.OnGlassIdolShatterUpdate
)