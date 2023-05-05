local enums = milkshakeMod.enums

---@type bumPickups[]
local spiritBumPickups = {
	{reward = 1, value = {
		variant = PickupVariant.PICKUP_HEART,
		subtype = HeartSubType.HEART_HALF_SOUL
	}},
	{reward = 2, value = {
		variant = PickupVariant.PICKUP_HEART,
		subtype = HeartSubType.HEART_SOUL
	}},
	{reward = 2, value = {
		variant = PickupVariant.PICKUP_HEART,
		subtype = HeartSubType.HEART_BLENDED
	}},
	{reward = 2, value = {
		variant = PickupVariant.PICKUP_HEART,
		subtype = HeartSubType.HEART_BLACK
	}, spawn = {
		type = EntityType.ENTITY_PICKUP,
		variant = PickupVariant.PICKUP_TAROTCARD,
		subtype = Card.CARD_DEATH
	}},
}

if FiendFolio then
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 1,
		value = {
			variant = FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART,
			subtype = 0
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 2,
		value = {
			variant = FiendFolio.PICKUP.VARIANT.IMMORAL_HEART,
			subtype = 0
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 2,
		value = {
			variant = FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART,
			subtype = 0
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 2,
		value = {
			variant = FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART,
			subtype = 0
		},
		spawn = {
			type = EntityType.ENTITY_PICKUP,
			variant = PickupVariant.PICKUP_TAROTCARD,
			subtype = Card.CARD_DEATH
		}
	}
	spiritBumPickups[#spiritBumPickups+1] = {
		reward = 1,
		value = {
			variant = FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART,
			subtype = 0
		},
		spawn = {
			type = EntityType.ENTITY_PICKUP,
			variant = PickupVariant.PICKUP_TAROTCARD,
			subtype = Card.CARD_DEATH
		}
	}
end

BumAPI:AddBumFamiliar(enums.Familiars.SPIRIT_BUM, enums.Collectibles.SPIRIT_BUM, false, 3, spiritBumPickups, {
	{chance = 25, value = {
		type = EntityType.ENTITY_PICKUP,
		variant = PickupVariant.PICKUP_TAROTCARD,
		subtype = enums.Orbs.ELECTRIC
	}},
	{chance = 25, value = {
		type = EntityType.ENTITY_PICKUP,
		variant = PickupVariant.PICKUP_TAROTCARD,
		subtype = enums.Orbs.FIRE
	}},
	{chance = 25, value = {
		type = EntityType.ENTITY_PICKUP,
		variant = PickupVariant.PICKUP_TAROTCARD,
		subtype = enums.Orbs.NATURE
	}},
	{chance = 25, value = {
		type = EntityType.ENTITY_PICKUP,
		variant = PickupVariant.PICKUP_TAROTCARD,
		subtype = enums.Orbs.PSYCHIC
	}},
})