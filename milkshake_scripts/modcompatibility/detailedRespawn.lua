MilkshakeVol1:AddModCompatibility("DetailedRespawnGlobalAPI", function()

    local glassIdol = {
		name = "Glass Idol",
		hasAltSprite = true,
		itemId = MilkshakeVol1.enums.Collectibles.FRAGILE_MIRROR,
        condition = function(self, player)
            return MilkshakeVol1.API:HasAnyUnbrokenMirror(player)
        end

	}
    DetailedRespawnGlobalAPI.AddCustomRespawn(nil, glassIdol, DetailedRespawnGlobalAPI.RespawnPosition.Last)
end)