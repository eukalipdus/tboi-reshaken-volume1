local potOfGold = {}
local enums = MilkshakeVol1.enums

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
function MilkshakeVol1:AddRainbowPenny(variant, subtype, onPickup)
    rainbowPennies[#rainbowPennies+1] = {
        variant = variant,
        subtype = subtype,
        onPickup = onPickup
    }
end


function potOfGold:onPlayerEffectUpdate(player)
    if not player then return end
    if not player:HasCollectible(MilkshakeVol1.enums.Collectibles.POT_OF_GOLD) then return end

    local pickups = TSIL.EntitySpecific.GetPickups()
    for _, pickup in pairs(pickups) do
        if pickup.Variant == PickupVariant.PICKUP_KEY or pickup.Variant == PickupVariant.PICKUP_BOMB then
            local rng = player:GetCollectibleRNG(enums.Collectibles.POT_OF_GOLD)
            local chosenCoin = TSIL.Random.GetRandomElementsFromTable(rainbowPennies, 1, rng)[1]

            pickup:Remove()
            TSIL.EntitySpecific.SpawnPickup(chosenCoin.variant, chosenCoin.subtype, pickup.Position, Vector.Zero, player)
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, potOfGold.onPlayerEffectUpdate)


---@param pickup EntityPickup
---@param collider Entity
function potOfGold:prePickupCollision(pickup, collider)
    local player = collider:ToPlayer()
    if not player then return end

    local rainbowPenny = TSIL.Utils.Tables.FindFirst(rainbowPennies, function (_, rainbowPenny)
        return rainbowPenny.variant == pickup.Variant and rainbowPenny.subtype == pickup.SubType
    end)

    if not rainbowPenny then return end

    rainbowPenny.onPickup(pickup, player)

    pickup:Die()

    --Needs to be set to one so it doesn't grant the player 99 coins
    pickup.SubType = 1
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, potOfGold.prePickupCollision)


return potOfGold