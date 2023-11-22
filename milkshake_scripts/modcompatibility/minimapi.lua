local enums = MilkshakeVol1.enums

MilkshakeVol1:AddModCompatibility("MinimapAPI", function ()
    local ICON_ANM2_PER_CARD = {
        [enums.Orbs.ELECTRIC] = "gfx/spirit_conductivity.anm2",
        [enums.Orbs.FIRE] = "gfx/spirit_inferno.anm2",
        [enums.Orbs.HOLY] = "gfx/spirit_salvation.anm2",
        [enums.Orbs.NATURE] = "gfx/spirit_druidity.anm2",
        [enums.Orbs.POISON] = "gfx/spirit_biohazard.anm2",
        [enums.Orbs.PSYCHIC] = "gfx/spirit_clairvoyance.anm2",
        [enums.Orbs.RANDOM] = "gfx/spirit_chaos.anm2",
        [enums.Orbs.ROCK] = "gfx/spirit_terra.anm2",
        [enums.Orbs.UNDEAD] = "gfx/spirit_undead.anm2",
        [enums.Orbs.UNHOLY] = "gfx/spirit_demonic.anm2",
        [enums.Orbs.WATER] = "gfx/spirit_water.anm2",
        [enums.Cards.TATTERED_PAGE] = "gfx/tattered_page.anm2"
    }

    for orb, anm2 in pairs(ICON_ANM2_PER_CARD) do
        local spr = Sprite()
        spr:Load(anm2, true)

        local id = "Card" .. orb

        MinimapAPI:AddIcon(id, spr, "HUDSmall", 0)
        MinimapAPI:AddPickup(
            id,
            id,
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_TAROTCARD,
            orb,
            MinimapAPI.PickupNotCollected,
            "cards",
            10000
        )
    end
end)