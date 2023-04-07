local game = Game()
local rng = RNG()
local enums = milkshakeMod.enums

function milkshakeMod:PrePickupCollision(Pickup, Collider, _)
	if Collider:ToPlayer() and Pickup.SubType ~= 6 then
        local player = Collider:ToPlayer()
        if player:HasTrinket(enums.Trinkets.CRYSTAL_PENNY) then
            local roll = rng:RandomInt(100) + 1
            local RollForThaTarotCards = rng:RandomInt(22) + 1

            local CoinType = {
                {8, CoinSubType.COIN_PENNY},
                {16, CoinSubType.COIN_NICKEL},
                {48, CoinSubType.COIN_DIME},
                {15, CoinSubType.COIN_DOUBLEPACK},
                {8, CoinSubType.COIN_LUCKYPENNY},
                {8, CoinSubType.COIN_GOLDEN},
            }
            for _, CoinType in ipairs(CoinType) do
                if roll <= CoinType[1] and Pickup.SubType == CoinType[2] then
                    Isaac.Spawn(5, PickupVariant.PICKUP_TAROTCARD, RollForThaTarotCards, Isaac.GetFreeNearPosition(Pickup.Position, 40), Vector.Zero, nil)
                end
            end 
        end
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, milkshakeMod.PrePickupCollision, PickupVariant.PICKUP_COIN)