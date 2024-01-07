local enums = MilkshakeVol1.enums
local SickleCell = {}

local BLEED_DURATION = 30 * 6 --30 fps * 6 seconds
local StoneTearAnimScaleThresholds = { 0, 0.675, 0.925, 1.2, 1.695, 2.275, 2.8 }


---@param tear Entity
---@return boolean
local function IsSickleTear(tear)
    return TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        tear,
        "IsSickleTear"
    ) == true --So we don't return nil
end


local function GetTearAnimationNumber(tear)
    local size = 1
    local list = StoneTearAnimScaleThresholds
    for i = 1, #list do
        if tear.Scale > list[i] then
            size = i-1
        end
        size = math.max(1, size)
    end
    return size
end


---@param tear EntityTear
function MakeTearSickle(tear)
    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        tear,
        "IsSickleTear",
        true
    )

    local isLudo = tear:HasTearFlags(TearFlags.TEAR_LUDOVICO)

    if isLudo then
        local sprite = tear:GetSprite()
        sprite:Load("gfx/tears/tear_sicklecell.anm2", true)
        local animNum = GetTearAnimationNumber(tear)
        sprite:Play("Stone" .. animNum .. "Move", true)
        return
    end

    local tearSizeMult = 1.2
    if tear.Variant == TearVariant.SCHYTHE then
        tear:ChangeVariant(TearVariant.BLUE)
    end

    if tear.Variant ~= TearVariant.BLUE
    and tear.Variant ~= TearVariant.BLOOD then return end

    tear.Scale = tear.Scale * tearSizeMult
    tear.Scale = math.max(0.658, tear.Scale)

    local sprite = tear:GetSprite()
    sprite:Load("gfx/tears/tear_sicklecell.anm2", true)
    local animNum = GetTearAnimationNumber(tear)
    sprite:Play("Stone" .. animNum .. "Move", true)
end


-- changes tear color and gives piercing if you have sickle cell
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function SickleCell:onCache(player, cacheFlag)
    if not player:HasCollectible(enums.Collectibles.SICKLE_CELL) then
        return
    end

    if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        player.TearColor = Color(0.75, 0, 0, 1, 0.2, 0, 0)
    end

    if cacheFlag == CacheFlag.CACHE_TEARFLAG then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    SickleCell.onCache
)


-- On frame 1 of tear update, Multipies Tear size by 1.2, or 1.4 if you have death's touch, Visually changes the sickle cell tear sprite and animation based on the tear size
---@param tear EntityTear
function SickleCell:replaceTear(tear)
    local spawner = tear.SpawnerEntity
    if not spawner then return end
    local player = spawner:ToPlayer()
    if player == nil then return end
    if not player:HasCollectible(enums.Collectibles.SICKLE_CELL) then return end

    MakeTearSickle(tear)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_TEAR_INIT_LATE,
    SickleCell.replaceTear
)


---@param entity Entity
local function AddSickleBleed(entity)
    entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
    entity:SetColor(Color(1.2, 0.6, 0.6, 1, 0, 0, 0), BLEED_DURATION, 2, false, false)
    entity:BloodExplode()

    TSIL.Entities.SetEntityData(
        MilkshakeVol1,
        entity,
        "SickleCellBleedFrame",
        Game():GetFrameCount()
    )
end


---@param entity Entity
---@param source Entity
local function OnTearDamage(entity, source)
    if not IsSickleTear(source) then return end

    AddSickleBleed(entity)
end


---@param entity Entity
---@param source Entity
local function OnKnifeDamage(entity, source)
    local player = TSIL.Players.GetPlayerFromEntity(source)

    if not player then return end
    if not player:HasCollectible(enums.Collectibles.SICKLE_CELL) then return end

    AddSickleBleed(entity)
end


---@param entity Entity
---@param source Entity
local function OnLaserDamage(entity, source)
    if not source then return end
    local player = source:ToPlayer()
    if not player then return end

    if not player:HasCollectible(enums.Collectibles.SICKLE_CELL) then return end

    AddSickleBleed(entity)
end


---@param entity Entity
---@param source Entity
local function OnBombDamage(entity, source)
    local bomb = source:ToBomb()
    if not bomb then return end
    if not bomb.IsFetus then return end

    local player = TSIL.Players.GetPlayerFromEntity(source)

    if not player then return end
    if not player:HasCollectible(enums.Collectibles.SICKLE_CELL) then return end

    AddSickleBleed(entity)
end


--checks if entity was damaged by tear, bomb, or effect(?) idk i copied this lol
---@param entity Entity
---@param flags integer
---@param source EntityRef
function SickleCell:OnEntityDamage(entity, _, flags, source)
    if not entity:ToNPC() then return end
    if not (entity:IsEnemy() and entity:IsVulnerableEnemy()) then return end

    if source.Type == EntityType.ENTITY_TEAR and IsSickleTear(source.Entity)  then
        SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS, 0.8)
    end
    if entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or
        entity:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT) then
        return
    end

    if source.Type == EntityType.ENTITY_TEAR then
        OnTearDamage(entity, source.Entity)
    elseif source.Type == EntityType.ENTITY_KNIFE then
        OnKnifeDamage(entity, source.Entity)
    elseif TSIL.Utils.Flags.HasFlags(flags, DamageFlag.DAMAGE_LASER) then
        OnLaserDamage(entity, source.Entity)
    elseif source.Type == EntityType.ENTITY_BOMB then
        OnBombDamage(entity, source.Entity)
    end
end

MilkshakeVol1:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    SickleCell.OnEntityDamage
)


---@param npc EntityNPC
function SickleCell:OnNPCUpdate(npc)
    local sickleCellBleedFrame = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        npc,
        "SickleCellBleedFrame"
    )
    if not sickleCellBleedFrame then return end

    local currentFrame = Game():GetFrameCount()
    local currentDuration = currentFrame - sickleCellBleedFrame

    if currentDuration >= BLEED_DURATION then
        npc:ClearEntityFlags(EntityFlag.FLAG_BLEED_OUT)
        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            npc,
            "SickleCellBleedFrame",
            nil
        )
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_NPC_UPDATE,
    SickleCell.OnNPCUpdate
)


---@param player EntityPlayer
function SickleCell:OnSickleCellItemAdded(player)
    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local tears = TSIL.EntitySpecific.GetTears()

    local ludoTears = TSIL.Utils.Tables.Filter(tears, function (_, tear)
        local tearSpawner = TSIL.Players.GetPlayerFromEntity(tear)
        ---@diagnostic disable-next-line: param-type-mismatch
        return tear:HasTearFlags(TearFlags.TEAR_LUDOVICO) and
            not IsSickleTear(tear) and
            tearSpawner ~= nil and
            TSIL.Players.GetPlayerIndex(tearSpawner) == playerIndex
    end)

    TSIL.Utils.Tables.ForEach(ludoTears, function (_, tear)
        MakeTearSickle(tear)
    end)
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    SickleCell.OnSickleCellItemAdded,
    {
        nil,
        nil,
        enums.Collectibles.SICKLE_CELL
    }
)