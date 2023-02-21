local diceDice = {}
local enums = milkshakeMod.enums
local timesToActivate = 3

local diceCollectibles = {
    CollectibleType.COLLECTIBLE_D1,
    CollectibleType.COLLECTIBLE_D4,
    CollectibleType.COLLECTIBLE_D6,
    CollectibleType.COLLECTIBLE_ETERNAL_D6,
    CollectibleType.COLLECTIBLE_D7,
    CollectibleType.COLLECTIBLE_D8,
    CollectibleType.COLLECTIBLE_D10,
    CollectibleType.COLLECTIBLE_D12,
    CollectibleType.COLLECTIBLE_D20,
    CollectibleType.COLLECTIBLE_D100,
    CollectibleType.COLLECTIBLE_SPINDOWN_DICE
}

function diceDice:onUse(collectible, rng, player)
    if not player then return end
    player:AnimateCollectible(enums.Collectibles.DICE_DICE, "Pickup", "PlayerPickupSparkle")
    for i = 1, timesToActivate do
        local roll = rng:RandomInt(#diceCollectibles) + 1 -- To remove the possibility of 0
        player:UseActiveItem(diceCollectibles[roll], UseFlag.USE_NOANIM)
    end
end

milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, diceDice.onUse, enums.Collectibles.DICE_DICE)
return diceDice