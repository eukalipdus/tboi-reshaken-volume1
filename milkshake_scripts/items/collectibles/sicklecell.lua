local enums = milkshakeMod.enums
local SickleCell = {}

local sickle = Isaac.GetItemIdByName("Sickle Cell");
local ironbar = Isaac.GetItemIdByName("Iron Bar");
local ludovico = Isaac.GetItemIdByName("The Ludovico Technique");
local deathstouch = Isaac.GetItemIdByName("Death's Touch");
local sickleTear = Isaac.GetEntityVariantByName("Sickle Cell Tear")
StoneTearAnimScaleThresholds = {0, 0.675, 0.925, 1.2, 1.695, 2.275}

function milkshakeMod:GetTearAnimationNumber(tear)
    local size = 1
    local list = StoneTearAnimScaleThresholds
    for i = 1, #list do
        if tear.Scale > list[i] then
            size = i
        end
    end
    return size
end

-- changes tear color and gives piercing if you have sickle cell
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function milkshakeMod:onCache(player, cacheFlag)
    if not player:HasCollectible(sickle) then
        return
    end

    if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        player.TearColor = Color(0.75, 0, 0, 1, 0.2, 0, 0)
    end

    if cacheFlag == CacheFlag.CACHE_TEARFLAG then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING
    end
end

-- On frame 1 of tear update, Multipies Tear size by 1.2, or 1.4 if you have death's touch, Visually changes the sickle cell tear sprite and animation based on the tear size
function milkshakeMod:replaceTear(tear)
    local player = TSIL.Players.GetPlayerFromEntity(tear)
    if player == nil then
        return
    end
    if not player:HasCollectible(sickle) then
        return
    end
    local data = tear:GetData()
    if tear.Variant ~= sickleTear then
        return
    end
    if tear.FrameCount > 0 then
        return
    end

    data.isSickleTear = true
    local tearSizeMult = 1.2
    if player:HasCollectible(deathstouch) then
        tearSizeMult = 1.4
    end

    tear:GetSprite():Play("Stone" .. milkshakeMod:GetTearAnimationNumber(tear) .. "Move")
    --  print(GetTearAnimationNumber(tear))
    tear.Scale = math.max(1.0, tear.Scale * tearSizeMult)

    if tear.Scale > 4.0 then
        tear.SpriteScale = Vector(math.max(0.3, tear.Scale * 0.03), math.max(0.3, tear.Scale * 0.03))
    else
        tear.SpriteScale = Vector.One / tear.Scale
    end
    -- print(tear.Scale)
    -- print(tear.SpriteScale)

end

-- changes tear variant to sickle tear on tear init
milkshakeMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, function(_, tear)
    local spawner = tear.SpawnerEntity
    if not spawner then
        return
    end
    local player = spawner:ToPlayer()
    if not player then
        return
    end
    if not player:HasCollectible(sickle) then
        return
    end
    tear:ChangeVariant(sickleTear)
    tear:Update()

end)

-- plays sound and effect when sickle tear dies
function milkshakeMod:tearDie(tear)
    if tear.Type ~= EntityType.ENTITY_TEAR then
        return
    end
    -- if TSIL.Rooms.IsLeavingRoom() == true then return end
    if tear.Variant ~= sickleTear then
        return
    end
    local poof = TSIL.EntitySpecific.SpawnEffect(EffectVariant.TEAR_POOF_A, 0, tear.Position)
    local newColor = Color(0.75, 0, 0, 1, 0.2, 0, 0)
    poof.Color = newColor
    SFXManager():Play(SoundEffect.SOUND_TEARIMPACTS)
end

--applies bleed on entity damaged by sickle tear, plays sound effect 
function milkshakeMod:onGenericDamage(source, entity, data)
    if data.isSickleTear == true then
        if entity:IsEnemy() and entity:IsVulnerableEnemy() then
            SFXManager():Play(SoundEffect.SOUND_MEATY_DEATHS)

            if not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or
                entity:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT)) then
                entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
                entity:SetColor(Color(10, 0, 0, 1, 0, 0, 0), 10, 2, true, false)
                entity:BloodExplode()
            end
        end
    end
end

--checks if entity was damaged by tear, bomb, or effect(?) idk i copied this lol
milkshakeMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, damage, flags, source, countdown)
    local data = ent:GetData()
    if ent:ToNPC() then
        if source == nil then
            -- do nothing
        elseif source.Type == EntityType.ENTITY_TEAR or
            (source.Type == EntityType.ENTITY_BOMBDROP and flags == flags | DamageFlag.DAMAGE_EXPLOSION) or
            (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL) or
            (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.ROCKET) then
            local data = source.Entity:GetData()
            milkshakeMod:onGenericDamage(source, ent, data)

        end
    end
end)

milkshakeMod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE + 2001, -- Very low priority so the multiplier works with mods
    SickleCell.onCache)
milkshakeMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, SickleCell.replaceTear)

milkshakeMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, SickleCell.tearDie)
