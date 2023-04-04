local game = Game()
local rng = RNG()
local enums = milkshakeMod.enums

function milkshakeMod:PrePickupCollision(Pickup, Collider, _)
    for i=0, game:GetNumPlayers() - 1, 1 do
        local player = game:GetPlayer(i)
        if player:HasTrinket(enums.Trinkets.ACID_PENNY) then
            local roll = rng:RandomInt(100) + 1
            if roll <= 8 * Pickup:GetCoinValue() then
                Isaac.Spawn(5, PickupVariant.PICKUP_PILL, 0, Isaac.GetFreeNearPosition(Pickup.Position, 40), Vector.Zero, nil)
            end 
        end
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, milkshakeMod.PrePickupCollision, PickupVariant.PICKUP_COIN)