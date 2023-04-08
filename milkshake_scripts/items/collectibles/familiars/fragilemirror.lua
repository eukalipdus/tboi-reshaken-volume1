local FragileMirror = {}
local enums = milkshakeMod.enums


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
    "builder",
    "caveman",
    "checkmate",
    "cupcake",
    "cupcake_unit",
    "dogma",
    "eggplant",
    "error",
    "fall_from_grace",
    "fiend",
    "flowey",
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
    "whymsy",
    "worm",
    "yippie"
}
local MAX_HITPOINTS = 3
local ROOMS_UNTIL_UNBROKEN = 3

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "FragileMirrorHitPoints",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "FragileMirrorRevivesUsedPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "FragileMirrorsBrokenPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)


---Returns the unbroken mirror found
---@param player EntityPlayer
---@return EntityFamiliar?
local function HasAnyUnbrokenMirror(player)
    local familiars = TSIL.Familiars.GetPlayerFamiliars(player)
    local fragileMirrors = TSIL.Utils.Tables.Filter(familiars, function(_, familiar)
        return familiar.Variant == enums.Familiars.FRAGILE_MIRROR
    end)

    local hitPointsFragileMirrors = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
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
            milkshakeMod,
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
            milkshakeMod,
            "FragileMirrorsBrokenPerPlayer"
        )

        local mirrorsBroken = mirrorsBrokenPerPlayer[playerIndex]
        if mirrorsBroken == nil then
            mirrorsBroken = {}
        end

        mirrorsBroken[#mirrorsBroken + 1] = ROOMS_UNTIL_UNBROKEN
        mirrorsBrokenPerPlayer[playerIndex] = mirrorsBroken
    end

    SFXManager():Play(SoundEffect.SOUND_MIRROR_BREAK, 1, 2, false, 1.3)
    familiar:Remove()
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS | CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
end


---@param familiar EntityFamiliar
local function TryUpdateAnimation(familiar)
    local initSeed = familiar.InitSeed

    local hitPointsFragileMirrors = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
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
        milkshakeMod,
        "FragileMirrorRevivesUsedPerPlayer"
    )

    local usedRevives = usedRevivesPerPlayer[playerIndex]
    if usedRevives == nil then
        usedRevives = 0
    end

    local mirrorsBrokenPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
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
milkshakeMod:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    FragileMirror.OnFamiliarCache,
    CacheFlag.CACHE_FAMILIARS
)

---@param player EntityPlayer
function FragileMirror:OnLuckCache(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local mirrorsBrokenPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "FragileMirrorsBrokenPerPlayer"
    )

    local mirrorsBroken = mirrorsBrokenPerPlayer[playerIndex]
    if mirrorsBroken == nil then
        mirrorsBroken = {}
    end

    player.Luck = player.Luck - #mirrorsBroken
end
milkshakeMod:AddCallback(
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
milkshakeMod:AddCallback(
    ModCallbacks.MC_FAMILIAR_INIT,
    FragileMirror.OnFamiliarInit,
    enums.Familiars.FRAGILE_MIRROR
)


---@param familiar EntityFamiliar
function FragileMirror:OnFamiliarUpdate(familiar)
    familiar:FollowParent()
end
milkshakeMod:AddCallback(
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
    local hitPointsPerFamiliar = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
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
    if entity.Type == EntityType.ENTITY_PROJECTILE then
        return CheckCollisionWithProjectile(familiar, entity:ToProjectile())
    end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
    FragileMirror.OnFamiliarCollision,
    enums.Familiars.FRAGILE_MIRROR
)


local isRevivingWithFragileMirror = false
local familiarsUsed = {}


---@param player EntityPlayer
function FragileMirror:PreCustomRevive(player)
    local unbrokenMirror = HasAnyUnbrokenMirror(player)

    if not unbrokenMirror then return end

    isRevivingWithFragileMirror = true
    familiarsUsed[#familiarsUsed + 1] = unbrokenMirror

    return TSIL.Enums.CustomReviveType.SAME_ROOM
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.PRE_CUSTOM_REVIVE,
    FragileMirror.PreCustomRevive
)


---@param player EntityPlayer
function FragileMirror:PostCustomRevive(player)
    if not isRevivingWithFragileMirror then return end

    SFXManager():Play(SoundEffect.SOUND_SUPERHOLY)
    player:AddSoulHearts(2)
    player:AnimateCollectible(enums.Collectibles.FRAGILE_MIRROR)
    local mirrorUsed = table.remove(familiarsUsed, 1)
    BreakMirror(mirrorUsed, true)
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_CUSTOM_REVIVE,
    FragileMirror.PostCustomRevive
)


function FragileMirror:OnRoomClear()
    local players = TSIL.Players.GetPlayers()

    local mirrorsBrokenPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
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
                    newMirrorsBroken[#newMirrorsBroken+1] = roomsUntilRespawn
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
milkshakeMod:AddCallback(
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
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_NEW_LEVEL,
    FragileMirror.OnNewLevel
)
