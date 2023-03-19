local FragileMirror = {}
local enums = milkshakeMod.enums


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
    "FragileMirrorRevivesPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)


---@param player EntityPlayer
---@return integer
local function GetMirrorFamiliarNum(player)
    local effects = player:GetEffects()
    local maxFamiliarNumber = player:GetCollectibleNum(enums.Collectibles.FRAGILE_MIRROR) +
    effects:GetCollectibleEffectNum(enums.Collectibles.FRAGILE_MIRROR)

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local fragileMirrorRevivesPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "FragileMirrorRevivesPerPlayer"
    )

    local revivesUsed = fragileMirrorRevivesPerPlayer[playerIndex]

    if revivesUsed == nil then
        fragileMirrorRevivesPerPlayer[playerIndex] = 0
        revivesUsed = 0
    end

    local targetFragileMirrorNum = math.max(0, maxFamiliarNumber - revivesUsed)

    return targetFragileMirrorNum
end


---@param player EntityPlayer
---@return integer
local function GetRemainingMirrorRevives(player)
    local playerFamiliars = TSIL.Familiars.GetPlayerFamiliars(player)

    local playerMirrors = TSIL.Utils.Tables.Filter(playerFamiliars, function (_, familiar)
        return familiar.Variant == enums.Familiars.FRAGILE_MIRROR
    end)

    return #playerMirrors
end


---@param player EntityPlayer
function FragileMirror:OnFamiliarCache(player)
    local targetFragileMirrorNum = GetMirrorFamiliarNum(player)

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


---@param familiar EntityFamiliar
function FragileMirror:OnFamiliarInit(familiar)
    familiar:AddToFollowers()
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

    projectile:Kill()
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

---@param player EntityPlayer
function FragileMirror:PreCustomRevive(player)
    local revivesLeft = GetRemainingMirrorRevives(player)

    if revivesLeft <= 0 then return end

    isRevivingWithFragileMirror = true

    return TSIL.Enums.CustomReviveType.SAME_ROOM
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.PRE_CUSTOM_REVIVE,
    FragileMirror.PreCustomRevive
)


---@param player EntityPlayer
function FragileMirror:PostCustomRevive(player)
    if not isRevivingWithFragileMirror then return end

    player:AnimateCollectible(enums.Collectibles.FRAGILE_MIRROR)
    player:AddCacheFlags(CacheFlag.CACHE_FAMILIARS)
    player:EvaluateItems()
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_CUSTOM_REVIVE,
    FragileMirror.PostCustomRevive
)