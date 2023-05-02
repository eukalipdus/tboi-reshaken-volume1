local enums = milkshakeMod.enums
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
    milkshakeMod,
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

function Leviticus:onLeviticusUse(_, _, player)
    if ComplianceImmortal then
        ComplianceImmortal.AddImmortalHearts(player, 2)
    else
        player:AddEternalHearts(1)
    end

    if LibraryExpanded then
        if LibraryExpanded:GetTBOATB(player) > 0 then
            for _ = 1, LibraryExpanded:GetTBOATB(player) + 2 do
                player:UseActiveItem(CollectibleType.COLLECTIBLE_CRACK_THE_SKY, UseFlag.USE_NOANIM | UseFlag.USE_MIMIC)
            end
        end
    end

    SFXManager():Play(SoundEffect.SOUND_SUPERHOLY)

    TSIL.SaveManager.SetPersistentVariable(
        milkshakeMod,
        "UsedLeviticus",
        true
    )

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    Leviticus.onLeviticusUse,
    enums.Collectibles.LEVITICUS
)


local function CheckLeviticusActiveSlot(player)
    for i = 0, 4, 1 do
        if player:GetActiveItem(i) == enums.Collectibles.LEVITICUS and
        player:GetActiveCharge(i) < LEVITICUS_MAX_CHARGES then
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
        if slot and player:GetActiveCharge(slot) < LEVITICUS_MAX_CHARGES then
            player:SetActiveCharge(player:GetActiveCharge(slot) + 1, slot)
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

    if not player:HasCollectible(enums.Collectibles.LEVITICUS) then return end

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
milkshakeMod:AddCallback(
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
    milkshakeMod:AddCallback(
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

        if not player:HasCollectible(enums.Collectibles.LEVITICUS) then return end

        local leviticus_slot = CheckLeviticusActiveSlot(player)
        if leviticus_slot == nil then return end

        if hp < 0 then return end

        if key == "SOUL_HEART" then
            AddSoulHeartCharges(player, {
                charges = hp,
                extraHeart = EXTRA_HEART_TYPES.SOUL,
                soundEffect = -1
            })
            return true
        elseif key == "BLACK_HEART" then
            AddSoulHeartCharges(player, {
                charges = hp,
                extraHeart = EXTRA_HEART_TYPES.BLACK,
                soundEffect = -1
            })
            return true
        elseif key == "IMMORAL_HEART" then
            AddSoulHeartCharges(player, {
                charges = hp,
                extraHeart = EXTRA_HEART_TYPES.IMMORAL,
                soundEffect = -1
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
        if not player:HasCollectible(enums.Collectibles.LEVITICUS) then return end

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
                soundEffect = -1
            })
        elseif healthType == TSIL.Enums.HealthType.BLACK then
            player:AddBlackHearts(-heartsAdded)
            AddSoulHeartCharges(player, {
                charges = heartsAdded,
                extraHeart = EXTRA_HEART_TYPES.BLACK,
                soundEffect = -1
            })
        end
    end
    milkshakeMod:AddCallback(
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
            extraHeart = EXTRA_HEART_TYPES.SOUL
        })
    end

    if collectibleConfig.AddBlackHearts > 0 then
        AddSoulHeartCharges(player, {
            charges = collectibleConfig.AddBlackHearts,
            soundEffect = -1,
            extraHeart = EXTRA_HEART_TYPES.BLACK
        })
    end
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED,
    Leviticus.OnItemAdded
)


function Leviticus:onItemSpawn(itemPoolType, _, seed)
    local roomType = Game():GetRoom():GetType()
    if roomType ~= RoomType.ROOM_BOSS then return end
    if itemPoolType ~= ItemPoolType.POOL_BOSS then return end

    local usedLeviticus = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "UsedLeviticus"
    )

    if not usedLeviticus then return end

    local ItemPool = Game():GetItemPool()

    local randomAngelItemID = ItemPool:GetCollectible(ItemPoolType.POOL_ANGEL, true, seed)

    return randomAngelItemID
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_PRE_GET_COLLECTIBLE,
    Leviticus.onItemSpawn
)


function Leviticus:onAngelBossItemSpawn(pickup)
    if TSIL.Players.DoesAnyPlayerHasItem(CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION) then return end

    if pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end
    if pickup.SubType == CollectibleType.COLLECTIBLE_NULL then return end
    local roomType = Game():GetRoom():GetType()
    if roomType ~= RoomType.ROOM_BOSS then return end
    local usedLeviticus = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "UsedLeviticus"
    )

    if not usedLeviticus then return end
    if Game():GetItemPool():GetLastPool() ~= ItemPoolType.POOL_ANGEL then return end
    if Game():GetDevilRoomDeals() < 1 then return end
    if pickup:IsShopItem() then return end

    pickup.AutoUpdatePrice = false
    pickup.Price = 15
    if Isaac.GetItemConfig():GetCollectible(pickup.SubType).Quality > 3 then
        pickup.Price = 30
    end
    pickup.ShopItemId = -1
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    Leviticus.onAngelBossItemSpawn
)