local game = Game()
local rng = RNG()
local enums = milkshakeMod.enums

function milkshakeMod:PrePickupCollision(Pickup, Collider, _)
    for i=0, game:GetNumPlayers() - 1, 1 do
        local player = game:GetPlayer(i)
        if player:HasTrinket(enums.Trinkets.CRYSTAL_PENNY, false) then
            --[[local TarotCards ={
                Card.CARD_FOOL,
                Card.CARD_MAGICIAN,
                Card.CARD_HIGH_PRIESTESS,
                Card.CARD_EMPRESS,
                Card.CARD_EMPEROR,
                Card.CARD_HIEROPHANT,
                Card.CARD_LOVERS,
                Card.CARD_CHARIOT,
                Card.CARD_JUSTICE,
                Card.CARD_HERMIT,
                Card.CARD_WHEEL_OF_FORTUNE,
                Card.CARD_STRENGTH,
                Card.CARD_HANGED_MAN,
                Card.CARD_DEATH,
                Card.CARD_TEMPERANCE,
                Card.CA *realization*
            }]]
            
            local roll = rng:RandomInt(100) + 1
            local RollForThaTarotCards = rng:RandomInt(22) + 1
            if roll <= 8 * Pickup:GetCoinValue() then
                
                Isaac.Spawn(5, PickupVariant.PICKUP_TAROTCARD, RollForThaTarotCards, Isaac.GetFreeNearPosition(Pickup.Position, 40), Vector.Zero, nil)
            end 
        end
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, milkshakeMod.PrePickupCollision, PickupVariant.PICKUP_COIN)