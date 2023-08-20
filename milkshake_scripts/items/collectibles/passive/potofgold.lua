local potOfGold = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local PENNY_CONVERT_CHANCE = 50

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
---@return number
function MilkshakeVol1.API:GetRainbowPenny(rng)
    return TSIL.Random.GetRandomElementsFromTable(rainbowPennies, 1, rng)[1]
end

function potOfGold:PostPEffectUpdate(player)
    if not player:HasCollectible(MilkshakeVol1.enums.Collectibles.POT_OF_GOLD) then return end
    local rng = player:GetCollectibleRNG(enums.Collectibles.POT_OF_GOLD)
    local pickups = TSIL.EntitySpecific.GetPickups()
    for _, pickup in pairs(pickups) do

        if pickup.Variant == PickupVariant.PICKUP_KEY
        or pickup.Variant == PickupVariant.PICKUP_BOMB then
            local chosenCoin = TSIL.Random.GetRandomElementsFromTable(rainbowPennies, 1, rng)[1]
            pickup:Remove()
            local coin = TSIL.EntitySpecific.SpawnPickup(chosenCoin.variant, chosenCoin.subtype, pickup.Position, Vector.Zero, player):ToPickup()
            coin.AutoUpdatePrice = false
            coin.Price = pickup.Price
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, potOfGold.PostPEffectUpdate)

function potOfGold:PostPickupInit(pickup)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if  player:HasCollectible(enums.Collectibles.POT_OF_GOLD)
        and not utility:DidEntityExist()
        and pickup.Variant == PickupVariant.PICKUP_COIN then
            local rng = player:GetCollectibleRNG(enums.Collectibles.POT_OF_GOLD)
            local roll = rng:RandomInt(100) + 1
            if roll >= PENNY_CONVERT_CHANCE then
                local chosenCoin = TSIL.Random.GetRandomElementsFromTable(rainbowPennies, 1, rng)[1]
                pickup:Remove()
                TSIL.EntitySpecific.SpawnPickup(chosenCoin.variant, chosenCoin.subtype, pickup.Position, Vector.Zero, player)
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, potOfGold.PostPickupInit)

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

function potOfGold:PostPEffectUpdate()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.POT_OF_GOLD)
        and player:HasCollectible(CollectibleType.COLLECTIBLE_POUND_OF_FLESH) then
            for _, entity in pairs(Isaac.GetRoomEntities()) do
                if entity:ToPickup() then
                    local pickup = entity:ToPickup()
                    pickup.AutoUpdatePrice = true
                end
            end
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, potOfGold.PostPEffectUpdate)

return potOfGold