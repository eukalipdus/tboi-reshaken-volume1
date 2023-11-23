MilkshakeVol1:AddModCompatibility("ComplianceImmortal", function ()
    if EID then
        EID:addCollectible(
            MilkshakeVol1.enums.Collectibles.LEVITICUS,
            "{{SoulHeart}} Must be charged by picking up soul hearts" ..
            "#{{ImmortalHeart}} +1 Immortal Heart" ..
            "#{{AngelRoom}} Using the item before a boss fight makes the boss reward an angel item" ..
            "#{{DevilRoom}} The angel item will cost money if a devil deal was taken previously",
            "Leviticus",
            "en_us"
        )

        EID:addCollectible(
            MilkshakeVol1.enums.Collectibles.LEVITICUS,
            "{{SoulHeart}} Debe ser cargado usando corazones de alma" ..
            "#{{ImmortalHeart}} +1 Corazón Inmortal" ..
            "#{{AngelRoom}} Usar el objeto antes de la pelea contra el jefe hace que la recompensa sea un objeto de ángel" ..
            "#{{DevilRoom}} El objeto costará dinero si se ha tomado un pacto con el diablo",
            "Levítico",
            "spa"
        )

        EID:addCollectible(
            MilkshakeVol1.enums.Collectibles.LEVITICUS,
            "{{SoulHeart}} Must be charged by picking up soul hearts" ..
            "#{{ImmortalHeart}} +1 Immortal Heart" ..
            "#{{AngelRoom}} Using the item before a boss fight makes the boss reward an angel item" ..
            "#{{DevilRoom}} The angel item will cost money if a devil deal was taken previously",
            "Leviticus",
            "ru"
        )
    end
end)