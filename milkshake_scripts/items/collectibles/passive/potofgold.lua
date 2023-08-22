local potOfGold = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local PENNY_CONVERT_CHANCE = 0.5

---@class RainbowPenny
---@field variant PickupVariant
---@field subtype integer
---@field onPickup fun(pickup: EntityPickup, player: EntityPlayer)

---@type RainbowPenny[]
local rainbowPennies = {}

---Adds a special penny to the pool of pennies spawnable by Pot Of Gold
---@param variant PickupVariant
---@param subtype integer
---@param onPickup fun(pickup: EntityPickup, player: EntityPlayer)
function MilkshakeVol1.API:AddRainbowPenny(variant, subtype, onPickup)
    rainbowPennies[#rainbowPennies+1] = {
        variant = variant,
        subtype = subtype,
        onPickup = onPickup
    }
end

---Gives a random type of rainbow penny
---NOTE: Access the Variant through returnedNumber.variant, and SubType through returnedNumber.subtype
---@param rng RNG
---@return RainbowPenny
function MilkshakeVol1.API:GetRainbowPenny(rng)
    return TSIL.Random.GetRandomElementsFromTable(rainbowPennies, 1, rng)[1]
end


---@param pickup EntityPickup
local function TryReplacePickupWithRainbowPenny(pickup)
    if pickup.Variant ~= PickupVariant.PICKUP_KEY
    and pickup.Variant ~= PickupVariant.PICKUP_BOMB then return end
    if not TSIL.Players.DoesAnyPlayerHasItem(MilkshakeVol1.enums.Collectibles.POT_OF_GOLD) then return end

    local rng = TSIL.RNG.NewRNG(pickup.InitSeed)

    if rng:RandomFloat() < PENNY_CONVERT_CHANCE then
        local chosenCoin = MilkshakeVol1.API:GetRainbowPenny(rng)

        pickup:Morph(
            pickup.Type,
            chosenCoin.variant,
            chosenCoin.subtype,
            true,
            false
        )
    end
end



---@param pickup EntityPickup
function potOfGold:OnPickupUpdate(pickup)
    TryReplacePickupWithRainbowPenny(pickup)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_UPDATE,
    potOfGold.OnPickupUpdate
)


function potOfGold:PostPickupInit(pickup)
    TryReplacePickupWithRainbowPenny(pickup)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_PICKUP_INIT,
    potOfGold.PostPickupInit
)


-- function potOfGold:PostPEffectUpdate(player)
--     if not player:HasCollectible(MilkshakeVol1.enums.Collectibles.POT_OF_GOLD) then return end
--     local rng = player:GetCollectibleRNG(enums.Collectibles.POT_OF_GOLD)
--     local pickups = TSIL.EntitySpecific.GetPickups()

--     for _, pickup in pairs(pickups) do
--         if pickup.Variant == PickupVariant.PICKUP_KEY
--         or pickup.Variant == PickupVariant.PICKUP_BOMB then
--             local chosenCoin = TSIL.Random.GetRandomElementsFromTable(rainbowPennies, 1, rng)[1]
--             pickup:Remove()
--             local coin = TSIL.EntitySpecific.SpawnPickup(chosenCoin.variant, chosenCoin.subtype, pickup.Position, Vector.Zero, player):ToPickup()
--             coin.AutoUpdatePrice = false
--             coin.Price = pickup.Price
--         end
--     end
-- end
-- MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, potOfGold.PostPEffectUpdate)

---@param pickup EntityPickup
---@param collider Entity
function potOfGold:PrePickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end

    local rainbowPenny = TSIL.Utils.Tables.FindFirst(rainbowPennies, function (_, rainbowPenny)
        return rainbowPenny.variant == pickup.Variant and rainbowPenny.subtype == pickup.SubType
    end)

    if not rainbowPenny then return end

    rainbowPenny.onPickup(pickup, player)

    pickup:Die()

    MilkshakeVol1.utility:SetData(pickup, "IsRainbowPenny", true)
    pickup.SubType = CoinSubType.COIN_PENNY
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, potOfGold.PrePickupCollision)

return potOfGold