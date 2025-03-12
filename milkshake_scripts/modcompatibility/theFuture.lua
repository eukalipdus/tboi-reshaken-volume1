MilkshakeVol1:AddModCompatibility("TheFuture", function()
    local OrbsPerFutureEntities = {
        -- {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 15, variant = 123, subtype = 0}, -- s. blob
        -- {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 123, subtype = 0}, -- flippant
        -- {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 123, subtype = 1}, -- flippant inverted
        -- {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 123, subtype = 2}, -- flippant pacer
        -- {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 123, subtype = 3}, -- flippant pacer inverted
        -- {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 123, subtype = 4}, -- flippant gusher
        -- {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 123, subtype = 5}, -- flippant gusher inverted

        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 124, subtype = 0}, -- ogle
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 130, subtype = 0}, -- custom ogle
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 125, subtype = 0}, -- rubber
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 126, subtype = 0}, -- warp pipe head
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 127, subtype = 0}, -- warp pipe ass

        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 128, subtype = 0}, -- ecomagnet
        {orb = MilkshakeVol1.enums.Orbs.ELECTRIC, type = 391, variant = 129, subtype = 0}, -- retinara
        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 131, subtype = 0}, -- fecalection
        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 132, subtype = 0}, -- fecalection ghost
        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 133, subtype = 0}, -- rewind

        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 134, subtype = 0}, -- spookie
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 134, subtype = 1}, -- wicked spookie
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 134, subtype = 2}, -- ol' spookie
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 135, subtype = 0}, -- future tumor
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 135, subtype = 1}, -- future tumor small
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 136, subtype = 0}, -- kuko
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 137, subtype = 0}, -- kuko jr.
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 300, subtype = 0}, -- wailer (the future)
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 138, subtype = 0}, -- family baby
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 140, subtype = 0}, -- mongrel
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 141, subtype = 0}, -- betus
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 142, subtype = 0}, -- metabolite
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 143, subtype = 0}, -- metabulon

        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 144}, -- mantis

        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 145, subtype = 0}, -- pile o' bones
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 146, subtype = 0}, -- ferryman
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 147, subtype = 0}, -- monger
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 148, subtype = 0}, -- half monger

        {orb = MilkshakeVol1.enums.Orbs.WATER, type = 391, variant = 149, subtype = 0}, -- anchorfish
        {orb = MilkshakeVol1.enums.Orbs.WATER, type = 391, variant = 150, subtype = 0}, -- anchorfish head

        {orb = MilkshakeVol1.enums.Orbs.ROCK, type = 391, variant = 151, subtype = 0}, -- selfish knight
        {orb = MilkshakeVol1.enums.Orbs.ROCK, type = 391, variant = 151, subtype = 1}, -- selfish knight inverted

        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 152, subtype = 0}, -- moretug
        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 153, subtype = 0}, -- future turret
        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 154, subtype = 0}, -- frayer
        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 155, subtype = 0}, -- oswald
        {orb = MilkshakeVol1.enums.Orbs.PSYCHIC, type = 391, variant = 156, subtype = 0}, -- stevis

        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 157, subtype = 0}, -- sisyphus
        {orb = MilkshakeVol1.enums.Orbs.UNDEAD, type = 391, variant = 160, subtype = 0}, -- carcinoma heart
          }
          MilkshakeVol1.API:AddOrbsPerEnemyForShatteredOrb(OrbsPerFutureEntities)
          
  end)