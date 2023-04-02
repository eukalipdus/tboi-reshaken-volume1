local enums = milkshakeMod.enums
local bumAPI = milkshakeMod.bumAPI

bumAPI:AddBumFamiliar(enums.Familiars.SPIRIT_BUM, enums.Collectibles.SPIRIT_BUM, false, 3, {
	{reward = 1, value = {5, 10, 8}}, --half soul
	{reward = 2, value = {5, 10, 3}}, --soul
	{reward = 2, value = {5, 10, 6}, spawn = {5, 300, 14}}, --black, spawn death card
}, {
	{chance = 25, value = {5, 300, enums.Cards.AMETHYST_ORB}},
	{chance = 25, value = {5, 300, enums.Cards.EMERALD_ORB}},
	{chance = 25, value = {5, 300, enums.Cards.RUBY_ORB}},
	{chance = 25, value = {5, 300, enums.Cards.SAPPHIRE_ORB}},
})