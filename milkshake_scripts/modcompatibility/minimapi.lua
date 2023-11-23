local enums = MilkshakeVol1.enums

MilkshakeVol1:AddModCompatibility("MinimapAPI", function ()
    local ICON_ANIM_PER_CARD = {
        [enums.Orbs.ELECTRIC] = "spiritElectric",
        [enums.Orbs.FIRE] = "spiritFire",
        [enums.Orbs.HOLY] = "spiritHoly",
        [enums.Orbs.NATURE] = "spiritNature",
        [enums.Orbs.POISON] = "spiritPoison",
        [enums.Orbs.PSYCHIC] = "spiritPsychic",
        [enums.Orbs.RANDOM] = "spiritChaos",
        [enums.Orbs.ROCK] = "spiritRock",
        [enums.Orbs.UNDEAD] = "spiritUndead",
        [enums.Orbs.UNHOLY] = "spiritUnholy",
        [enums.Orbs.WATER] = "spiritWater",
        --RIP tattered page
        --[enums.Cards.TATTERED_PAGE] = "gfx/tattered_page.anm2"
    }
    local anm2 = "gfx/ui/orb_mapicons.anm2"

    for orb, anim in pairs(ICON_ANIM_PER_CARD) do
        local spr = Sprite()
        spr:Load(anm2, true)

        local id = "Card" .. orb

        MinimapAPI:AddIcon(id, spr, anim, 0)
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