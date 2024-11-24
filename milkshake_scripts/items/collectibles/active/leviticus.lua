local enums = MilkshakeVol1.enums
local Leviticus = {}

---@class LeviticusSoulHeartInfo
---@field charges integer
---@field soundEffect SoundEffect | integer
---@field extraHeart LeviticusExtraHeartTypes
---@field isBlended boolean

---@enum LeviticusExtraHeartTypes
local EXTRA_HEART_TYPES = {
    SOUL = "soul",
    BLACK = "black",
    IMMORAL = "immoral"
}

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "UsedLeviticus",
    false,
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)

local LEVITICUS_MAX_CHARGES = Isaac.GetItemConfig():GetCollectible(enums.Collectibles.LEVITICUS).MaxCharges


---@type table<HeartSubType, LeviticusSoulHeartInfo>
local VANILLA_SOUL_HEARTS = {
    [HeartSubType.HEART_SOUL] = {
        charges = 2,
        soundEffect = SoundEffect.SOUND_HOLY,
        extraHeart = EXTRA_HEART_TYPES.SOUL,
        isBlended = false
    },
    [HeartSubType.HEART_BLACK] = {
        charges = 2,
        soundEffect = SoundEffect.SOUND_UNHOLY,
        extraHeart = EXTRA_HEART_TYPES.BLACK,
        isBlended = false
    },
    [HeartSubType.HEART_BLENDED] = {
        charges = 2,
        soundEffect = SoundEffect.SOUND_HOLY,
        extraHeart = EXTRA_HEART_TYPES.SOUL,
        isBlended = true
    },
    [HeartSubType.HEART_HALF_SOUL] = {
        charges = 1,
        soundEffect = SoundEffect.SOUND_HOLY,
        extraHeart = EXTRA_HEART_TYPES.SOUL,
        isBlended = false
    }
}

---@type table<PickupVariant, LeviticusSoulHeartInfo>
local FF_SOUL_HEARTS = {}
---@type table<CollectibleType, boolean>
local IMMORAL_ITEMS = {}
if FiendFolio then
    FF_SOUL_HEARTS = {
        [FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART] = {
            charges = 1,
            soundEffect = FiendFolio.Sounds.FiendHeartPickup,
            extraHeart = EXTRA_HEART_TYPES.IMMORAL,
            isBlended = false
        },
        [FiendFolio.PICKUP.VARIANT.IMMORAL_HEART] = {
            charges = 2,
            soundEffect = FiendFolio.Sounds.FiendHeartPickup,
            extraHeart = EXTRA_HEART_TYPES.IMMORAL,
            isBlended = false
        },
        [FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART] = {
            charges = 2,
            soundEffect = FiendFolio.Sounds.FiendHeartPickup,
            extraHeart = EXTRA_HEART_TYPES.IMMORAL,
            isBlended = true
        },
        [FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART] = {
            charges = 2,
            soundEffect = SoundEffect.SOUND_UNHOLY,
            extraHeart = EXTRA_HEART_TYPES.BLACK,
            isBlended = true
        },
        [FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART] = {
            charges = 1,
            soundEffect = SoundEffect.SOUND_UNHOLY,
            extraHeart = EXTRA_HEART_TYPES.BLACK,
            isBlended = true
        },
    }

    IMMORAL_ITEMS = {
        [FiendFolio.ITEM.COLLECTIBLE.FIEND_HEART] = true,
        [FiendFolio.ITEM.COLLECTIBLE.DEVILLED_EGG] = true
    }
end

local CHARACTERS_CANT_PICKUP_SOUL_HEARTS = {
    [PlayerType.PLAYER_THELOST] = true,
    [PlayerType.PLAYER_THELOST_B] = true,
    [PlayerType.PLAYER_KEEPER] = true,
    [PlayerType.PLAYER_KEEPER_B] = true
}


local LEVITICUS_ITEM_PER_OPTIONS = {
    [1] = enums.Collectibles.LEVITICUS,
    [2] = enums.Collectibles.LEVITICUS_ALADAR,
    [3] = enums.Collectibles.LEVITICUS_FANCY,
}
local LEVITICUS_ITEMS = {
    [enums.Collectibles.LEVITICUS] = true,
    [enums.Collectibles.LEVITICUS_ALADAR] = true,
    [enums.Collectibles.LEVITICUS_FANCY] = true,
}


local function GetCurrentLeviticusItem()
    local leviticusOptions = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "LeviticusSprite"
    )

    return LEVITICUS_ITEM_PER_OPTIONS[leviticusOptions]
end

local leviticusTransitioning

---@param pickup EntityPickup
function Leviticus:OnCollectibleUpdate(pickup)
    if not LEVITICUS_ITEMS[pickup.SubType] then return end
    if LibraryExpanded and LibraryExpanded:IsLibraryCertificateRoom() then return end

    local currentItem = GetCurrentLeviticusItem()
    if pickup.SubType ~= currentItem then
        pickup:Morph(
            pickup.Type,
            pickup.Variant,
            currentItem,
            true,
            true,
            true
        )
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    Leviticus.OnCollectibleUpdate,
    PickupVariant.PICKUP_COLLECTIBLE
)


---@param player EntityPlayer
function Leviticus:OnPlayerUpdate(player)
    for activeSlot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET2, 1 do
        local item = player:GetActiveItem(activeSlot)

        if LEVITICUS_ITEMS[item] and item ~= GetCurrentLeviticusItem() then
            player:AddCollectible(
                GetCurrentLeviticusItem(),
                TSIL.Charge.GetTotalCharge(player, activeSlot),
                false,
                activeSlot
            )
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PLAYER_UPDATE,
    Leviticus.OnPlayerUpdate
)


local function CheckLeviticusActiveSlot(player)
    local overcharge = 0
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then overcharge = LEVITICUS_MAX_CHARGES end
    for i = 0, 3, 1 do
        if player:GetActiveItem(i) == GetCurrentLeviticusItem() and
        player:GetActiveCharge(i) + player:GetBatteryCharge(i) < LEVITICUS_MAX_CHARGES + overcharge then
            return i
        end
    end
    return nil
end


---@param player EntityPlayer
---@param soulHeartInfo LeviticusSoulHeartInfo
local function AddSoulHeartCharges(player, soulHeartInfo)
    local slot = CheckLeviticusActiveSlot(player)

    if not slot then return end

    if soulHeartInfo.soundEffect > 0 then
        SFXManager():Play(soulHeartInfo.soundEffect)
    end

    for _ = 0, soulHeartInfo.charges - 1, 1 do
        local overcharge = 0
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then overcharge = LEVITICUS_MAX_CHARGES end

        if slot and player:GetActiveCharge(slot) + player:GetBatteryCharge(slot) < LEVITICUS_MAX_CHARGES + overcharge then
            player:SetActiveCharge(player:GetActiveCharge(slot) + player:GetBatteryCharge(slot) + 1, slot)
        else
            if soulHeartInfo.extraHeart == EXTRA_HEART_TYPES.SOUL then
                player:AddSoulHearts(1)
            elseif soulHeartInfo.extraHeart == EXTRA_HEART_TYPES.BLACK then
                player:AddBlackHearts(1)
            elseif soulHeartInfo.extraHeart == EXTRA_HEART_TYPES.IMMORAL then
                FiendFolio:AddImmoralHearts(player, 1)
            end
        end

        slot = CheckLeviticusActiveSlot(player)
    end
end

local function RemovePickup(pickup)
    pickup = pickup:ToPickup()

    local sprite = pickup:GetSprite()
    sprite:RemoveOverlay()
    sprite:Play("Collect", true)
    pickup:Die()
end


---@param pickup EntityPickup
---@param collider Entity
function Leviticus:onPickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end

    if not player:HasCollectible(GetCurrentLeviticusItem()) then return end

    --Check if there is any slot with empty charges
    local leviticus_slot = CheckLeviticusActiveSlot(player)
    if leviticus_slot == nil then return end

    --Can player actually pick it up?
    -- if player:CanPickSoulHearts() and
    -- (
    --     player:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B and
    --     player:GetPlayerType() ~= PlayerType.PLAYER_THELOST
    -- ) then return end

    local soulHeartInfo

    if pickup.Variant == PickupVariant.PICKUP_HEART then
        soulHeartInfo = VANILLA_SOUL_HEARTS[pickup.SubType]
    elseif FiendFolio then
        soulHeartInfo = FF_SOUL_HEARTS[pickup.Variant]
    end

    if not soulHeartInfo then return end

    if pickup:IsShopItem() then
        --It's a shop item we can't pay for
        if pickup.Price > player:GetNumCoins() then
            return
        else
            player:AddCoins(-1 * pickup.Price)
        end
    end

    if soulHeartInfo.isBlended then
        --Special case for blended hearts
        local redHeartsToAdd = math.min(2, player:GetMaxHearts() - player:GetHearts())
        if redHeartsToAdd >= 2 then
            return
        elseif redHeartsToAdd == 1 then
            player:AddHearts(1)
            SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)

            soulHeartInfo = {
                charges = 1,
                soundEffect = soulHeartInfo.soundEffect,
                extraHeart = soulHeartInfo.extraHeart
            }
        end
    end

    AddSoulHeartCharges(player, soulHeartInfo)

    RemovePickup(pickup)

    return false
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_PICKUP_COLLISION,
    Leviticus.onPickupCollision
)


if CustomHealthAPI then
    local playersPickedUpImmoralItems = {}

    ---@param player EntityPlayer
    ---@param item CollectibleType
    function Leviticus.PreCollectiblePickup(player, item)
        if IMMORAL_ITEMS[item] then
            local playerIndex = TSIL.Players.GetPlayerIndex(player)
            playersPickedUpImmoralItems[playerIndex] = true
        end
    end
    MilkshakeVol1:AddCallback(
        TSIL.Enums.CustomCallback.PRE_ITEM_PICKUP,
        Leviticus.PreCollectiblePickup,
        {
            nil,
            nil,
            nil,
            TSIL.Enums.InventoryType.COLLECTIBLE
        }
    )

    function Leviticus.PreHealthAddCHAPI(player, key, hp)
        local playerIndex = TSIL.Players.GetPlayerIndex(player)
        if key == "SOUL_HEART" and hp == 2 and playersPickedUpImmoralItems[playerIndex] then
            playersPickedUpImmoralItems[playerIndex] = nil
            return
        end

        if not player:HasCollectible(GetCurrentLeviticusItem()) then return end

        local leviticus_slot = CheckLeviticusActiveSlot(player)
        if leviticus_slot == nil then return end

        if hp < 0 then return end

        if key == "SOUL_HEART" then
            AddSoulHeartCharges(player, {
                charges = hp,
                extraHeart = EXTRA_HEART_TYPES.SOUL,
                soundEffect = -1,
                isBlended = false
            })
            return true
        elseif key == "BLACK_HEART" then
            AddSoulHeartCharges(player, {
                charges = hp,
                extraHeart = EXTRA_HEART_TYPES.BLACK,
                soundEffect = -1,
                isBlended = false
            })
            return true
        elseif key == "IMMORAL_HEART" then
            AddSoulHeartCharges(player, {
                charges = hp,
                extraHeart = EXTRA_HEART_TYPES.IMMORAL,
                soundEffect = -1,
                isBlended = false
            })
            return true
        end
    end

    CustomHealthAPI.Library.AddCallback(
        "Milkshake",
        CustomHealthAPI.Enums.Callbacks.PRE_ADD_HEALTH,
        0,
        Leviticus.PreHealthAddCHAPI
    )
else
    ---@param player EntityPlayer
    ---@param healthType HealthType
    ---@param old integer
    ---@param new integer
    function Leviticus:OnHealthChanged(player, healthType, old, new)
        if not player:HasCollectible(GetCurrentLeviticusItem()) then return end

        local leviticus_slot = CheckLeviticusActiveSlot(player)
        if leviticus_slot == nil then return end

        local heartsAdded = new - old
        if heartsAdded < 0 then
            return
        end

        if healthType == TSIL.Enums.HealthType.SOUL then
            player:AddSoulHearts(-heartsAdded)
            AddSoulHeartCharges(player, {
                charges = heartsAdded,
                extraHeart = EXTRA_HEART_TYPES.SOUL,
                soundEffect = -1,
                isBlended = false
            })
        elseif healthType == TSIL.Enums.HealthType.BLACK then
            player:AddBlackHearts(-heartsAdded)
            AddSoulHeartCharges(player, {
                charges = heartsAdded,
                extraHeart = EXTRA_HEART_TYPES.BLACK,
                soundEffect = -1,
                isBlended = false
            })
        end
    end
    MilkshakeVol1:AddCallback(
        TSIL.Enums.CustomCallback.POST_PLAYER_HEALTH_CHANGED,
        Leviticus.OnHealthChanged
    )
end

---@param player EntityPlayer
---@param collectibleType CollectibleType
function Leviticus:OnItemAdded(player, collectibleType)
    local playerType = player:GetPlayerType()
    if not CHARACTERS_CANT_PICKUP_SOUL_HEARTS[playerType] then return end

    local itemConfig = Isaac.GetItemConfig()
    local collectibleConfig = itemConfig:GetCollectible(collectibleType)

    if not collectibleConfig then return end

    if collectibleConfig.AddSoulHearts > 0 then
        AddSoulHeartCharges(player, {
            charges = collectibleConfig.AddSoulHearts,
            soundEffect = -1,
            extraHeart = EXTRA_HEART_TYPES.SOUL,
            isBlended = false
        })
    end

    if collectibleConfig.AddBlackHearts > 0 then
        AddSoulHeartCharges(player, {
            charges = collectibleConfig.AddBlackHearts,
            soundEffect = -1,
            extraHeart = EXTRA_HEART_TYPES.BLACK,
            isBlended = false
        })
    end
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    Leviticus.OnItemAdded
)

-- This is probably bad to do
local LEVITICUS_ANGEL_ROOMS = {
    29004,
    29005,
    29006,
    29007,
    29008,
}

---@param player EntityPlayer
---@param useFlags UseFlag
function Leviticus:onLeviticusUse(_, _, player, useFlags)
    if TSIL.Utils.Flags.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then return end

    -- light:FollowParent(player)

    local usedLeviticus = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "UsedLeviticus"
    )

    if usedLeviticus == true then 
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = true,
        } 
    end

    TSIL.SaveManager.SetPersistentVariable(
        MilkshakeVol1,
        "UsedLeviticus",
        true
    )

    local data = MilkshakeVol1.utility:GetDataEx(player, "LeviticusBeam")

    data.Used = true

    local light

    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        light = TSIL.EntitySpecific.SpawnEffect(MilkshakeVol1.enums.Effects.LEVITICUS_LIGHT, 0, player.Position)
        light:FollowParent(player)
    end, 3)

    TSIL.Utils.Functions.RunInFramesTemporary(function ()
        data.Used = false

        if not light or not light:Exists() then return end

        local players = Isaac.FindByType(EntityType.ENTITY_PLAYER)

        ---@param a Entity
        ---@param b Entity
        table.sort(players, function (a, b)
            return a.Position:Distance(light.Position) < b.Position:Distance(light.Position)
        end)

        ---@type EntityPlayer[]
        local filtered = {}

        for _, v in ipairs(players) do
            ---@diagnostic disable-next-line: cast-local-type
            v = v:ToPlayer() ---@cast v EntityPlayer

            if not v:IsDead() then
                table.insert(filtered, v)
            end
        end

        for i, v in ipairs(filtered) do
            local data = MilkshakeVol1.utility:GetDataEx(v, "LeviticusBeam")

            data.Queued = true

            TSIL.Utils.Functions.RunInFramesTemporary(function ()
                data.LightTravelPos = light.Position
                data.DisableDamage = true

                v:AnimateLightTravel()
                v:AddCacheFlags(CacheFlag.CACHE_FLYING)
                v:EvaluateItems()
            end, (i - 1) * 5 + 1)
        end
    end, 15)

    SFXManager():Play(SoundEffect.SOUND_SUPERHOLY)

    return true
end
for _, item in pairs(LEVITICUS_ITEM_PER_OPTIONS) do
    MilkshakeVol1:AddCallback(
        ModCallbacks.MC_USE_ITEM,
        Leviticus.onLeviticusUse,
        item
    )
end

---@param player EntityPlayer
local function Cancel(player)
    local data = MilkshakeVol1.utility:GetDataEx(player, "LeviticusBeam")

    data.State = nil
    data.LightTravelPos = nil
    data.Queued = nil

    player:AddCacheFlags(CacheFlag.CACHE_FLYING)
    player:EvaluateItems()

    TSIL.Utils.Functions.RunInFrames(function ()
        data.DisableDamage = false
    end, 2)
end

---@param player EntityPlayer
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function (_, player)
    local data = MilkshakeVol1.utility:GetDataEx(player, "LeviticusBeam") if not data.LightTravelPos then return end

    if player:IsDead() then
        Cancel(player)
        return
    end

    local sprite = player:GetSprite()
    local animation = sprite:GetAnimation()
    ---@type Vector
    local diff = data.LightTravelPos - player.Position

    player.Velocity = diff:Resized(math.min(diff:Length() * 0.1, 17.5))

    if data.State == 2 then
        local players = Isaac.FindByType(EntityType.ENTITY_PLAYER)

        for i, v in ipairs(players) do
            local vData = MilkshakeVol1.utility:GetDataEx(v, "LeviticusBeam") if vData.Queued then
                ---@diagnostic disable-next-line: cast-local-type
                v = v:ToPlayer() ---@cast v EntityPlayer

                if vData.State ~= 2 then
                    break
                end

                if i == #players then
                    for _, _v in ipairs(players) do
                        ---@diagnostic disable-next-line: cast-local-type
                        _v = _v:ToPlayer() ---@cast _v EntityPlayer
                        Cancel(_v)
                    end

                    if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
                        leviticusTransitioning = true
                        Isaac.ExecuteCommand("goto s.angel." .. LEVITICUS_ANGEL_ROOMS[v:GetCollectibleRNG(MilkshakeVol1.enums.Collectibles.LEVITICUS):RandomInt(#LEVITICUS_ANGEL_ROOMS) + 1])
                    else
                        -- Devil room
                    end
                end
            end
        end

        player:SetColor(Color(1, 1, 1, 0), 2, 100, false, false)
    elseif (animation == "LightTravel" and sprite:GetFrame() >= 34 and data.State ~= 2) or player:IsExtraAnimationFinished() then
        data.State = 2
    end
end)

---@param entity Entity
---@param hook InputHook
MilkshakeVol1:AddCallback(ModCallbacks.MC_INPUT_ACTION, function (_, entity, hook)
    if not entity then return end
    local data = MilkshakeVol1.utility:GetDataEx(entity, "LeviticusBeam") if not (data.Used or data.LightTravelPos) then return end

    if hook ~= InputHook.GET_ACTION_VALUE then
        return false
    end

    return 0
end)

---@param entity Entity
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function (_, entity)
    if not MilkshakeVol1.utility:GetDataEx(entity, "LeviticusBeam").DisableDamage then return end
    return false
end)

---@param player EntityPlayer
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, function (_, player)
    if not MilkshakeVol1.utility:GetDataEx(player, "LeviticusBeam").DisableDamage then return end
    return true
end)

---@param player EntityPlayer
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function (_, player)
    if not MilkshakeVol1.utility:GetDataEx(player, "LeviticusBeam").LightTravelPos then return end
    player.CanFly = true
end, CacheFlag.CACHE_FLYING)

MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function ()
    for _, v in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
        local player = v:ToPlayer() ---@cast player EntityPlayer

        local data = MilkshakeVol1.utility:GetDataEx(player, "LeviticusBeam")

        data.Used = false

        if data.LightTravelPos then
            player:StopExtraAnimation()
            Cancel(player)
        end
    end

    if leviticusTransitioning then
        if Game():GetRoom():GetType() == RoomType.ROOM_ANGEL then
            local holyCard

            local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
            local truePickups = {}
            local itemIdx

            for i, v in ipairs(pickups) do
                if v.Variant == PickupVariant.PICKUP_COLLECTIBLE and v:ToPickup().Price == 0 then
                    itemIdx = i
                else
                    table.insert(truePickups, v)
                end
            end

            local rng = TSIL.RNG.NewRNG(Game():GetRoom():GetDecorationSeed())

            local holyCardIdx = rng:RandomInt(#truePickups) + 1

            if itemIdx then
                table.insert(truePickups, pickups[itemIdx])
            end

            for i, v in ipairs(truePickups) do
                if i == #truePickups then
                    break
                end

                ---@diagnostic disable-next-line: cast-local-type
                v = v:ToPickup() ---@cast v EntityPickup

                if v.Price > 0 then
                    if v.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                        for i = 1, 100 do
                            v:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_SHOPITEM, 0, false, true, true)

                            if v.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then
                                v.AutoUpdatePrice = true
                                v.Price = 5
                                break
                            end
                        end
                    end
                elseif v.Variant == PickupVariant.PICKUP_TAROTCARD and MilkshakeVol1.utility:IsSpiritOrb(v.SubType) then
                    v.AutoUpdatePrice = true
                    v.Price = 5
                end

                if i == holyCardIdx then
                    v:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_HOLY, false, true)
                    v.AutoUpdatePrice = true
                    v.Price = 5
                end
            end
        end
    end

    leviticusTransitioning = nil
end)
        -- https://tenor.com/view/sneedmode-sneed-sneedgang-gif-19457380