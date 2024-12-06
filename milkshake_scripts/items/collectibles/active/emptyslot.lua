local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility
local EmptySlot = {}

local DMG_BONUS = 0.066

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "EmptySlotCoinsPerPlayer",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

local function UpdateCoinDMGBonus(player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end


---@param rng RNG
---@param player EntityPlayer
function EmptySlot:OnEmptySlotUse(_, rng, player, useFlags)
    if TSIL.Utils.Flags.HasFlags(useFlags, UseFlag.USE_CARBATTERY) then
        return
    end

    if player:GetNumCoins() < 1 then
        return {
            Discharge = false,
            Remove = false,
            ShowAnim = false,
        }
    end
    player:AddCoins(-1)

    local playerIndex = TSIL.Players.GetPlayerIndex(player)

    local emptySlotCoinsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "EmptySlotCoinsPerPlayer"
    )
    local playerCoins = emptySlotCoinsPerPlayer[playerIndex]
    if not playerCoins then
        emptySlotCoinsPerPlayer[playerIndex] = 0
        playerCoins = 0
    end

    playerCoins = playerCoins + 1
    emptySlotCoinsPerPlayer[playerIndex] = playerCoins

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE) then
        UpdateCoinDMGBonus(player)
    end

    local chance = 0.015
    if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
        chance = chance * 2
    end

    if playerCoins > 10 and rng:RandomFloat() < 0.015 or playerCoins > 100 then
        local crater = TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.BOMB_CRATER,
            0,
            player.Position
        )
        local gold_color = Color(0.9, 0.8, 0, 1, 0.8, 0.7, 0)
        crater:SetColor(gold_color, 150, 1, false, false)
        SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
        SFXManager():Play(SoundEffect.SOUND_BOSS1_EXPLOSIONS)

        playerCoins = playerCoins * 2

        while playerCoins > 50 do
            local angle = TSIL.Random.GetRandomInt(0, 360, rng)
            local speed = TSIL.Random.GetRandomFloat(6, 11, rng)
            local velocity = Vector.FromAngle(angle) * speed

            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_COIN,
                CoinSubType.COIN_NICKEL,
                player.Position,
                velocity
            )

            playerCoins = playerCoins - 5
        end

        for _ = 1, playerCoins, 1 do
            local angle = TSIL.Random.GetRandomInt(0, 360, rng)
            local speed = TSIL.Random.GetRandomFloat(6, 11, rng)
            local velocity = Vector.FromAngle(angle) * speed

            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_COIN,
                CoinSubType.COIN_PENNY,
                player.Position,
                velocity
            )
        end

        emptySlotCoinsPerPlayer[playerIndex] = 0
        UpdateCoinDMGBonus(player)
        return {
            Discharge = false,
            Remove = true,
            ShowAnim = true,
        }
    end

    SFXManager():Play(SoundEffect.SOUND_COIN_INSERT, 1, 2, false, TSIL.Random.GetRandomFloat(0.9, 1.1))
    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true,
    }
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    EmptySlot.OnEmptySlotUse,
    enums.Collectibles.EMPTY_SLOT
)

function EmptySlot:EvaluateCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE
    and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE)
    and player:HasCollectible(enums.Collectibles.EMPTY_SLOT) then
        local emptySlotCoinsPerPlayer = TSIL.SaveManager.GetPersistentVariable(
            MilkshakeVol1,
            "EmptySlotCoinsPerPlayer"
        )
        local playerCoins = emptySlotCoinsPerPlayer[TSIL.Players.GetPlayerIndex(player)]
        player.Damage = player.Damage + (DMG_BONUS * playerCoins)
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EmptySlot.EvaluateCache)