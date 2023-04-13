local enums = milkshakeMod.enums
local bumAPI = milkshakeMod.bumAPI

local spiritBumPickups = {
	{reward = 1, value = {5, 10, 8}}, --half soul
	{reward = 2, value = {5, 10, 3}}, --soul
    {reward = 2, value = {5, 10, 10}}, --blended
	{reward = 2, value = {5, 10, 6}, spawn = {5, 300, 14}}, --black, spawn death card
}

if FiendFolio then
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 1,
		value = {
			EntityType.ENTITY_PICKUP,
			FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART,
			0
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 2,
		value = {
			EntityType.ENTITY_PICKUP,
			FiendFolio.PICKUP.VARIANT.IMMORAL_HEART,
			0
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 2,
		value = {
			EntityType.ENTITY_PICKUP,
			FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART,
			0
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 2,
		value = {
			EntityType.ENTITY_PICKUP,
			FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART,
			0
		},
		spawn = {
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_TAROTCARD,
			Card.CARD_DEATH
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 1,
		value = {
			EntityType.ENTITY_PICKUP,
			FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART,
			0
		},
		spawn = {
			EntityType.ENTITY_PICKUP,
			PickupVariant.PICKUP_TAROTCARD,
			Card.CARD_DEATH
		}
	}
end

bumAPI:AddBumFamiliar(enums.Familiars.SPIRIT_BUM, enums.Collectibles.SPIRIT_BUM, false, 3, spiritBumPickups, {
	{chance = 25, value = {5, 300, enums.Cards.AMETHYST_ORB}},
	{chance = 25, value = {5, 300, enums.Cards.EMERALD_ORB}},
	{chance = 25, value = {5, 300, enums.Cards.RUBY_ORB}},
	{chance = 25, value = {5, 300, enums.Cards.SAPPHIRE_ORB}},
})