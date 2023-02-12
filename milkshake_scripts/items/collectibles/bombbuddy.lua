local bombBuddy = {}
local enums = require("milkshake_scripts.enums")

function bombBuddy:EvaluateCache(player)
	print(enums.Collectibles.BOMB_BUM)
	print(enums.Familiars.BOMB_BUM)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.BOMB_BUM,
        enums.Familiars.BOMB_BUM
    )
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bombBuddy.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
function bombBuddy:FamiliarInit(familiar)
	--IDEK if i need this
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, bombBuddy.FamiliarInit, enums.Familiars.BOMB_BUM)

---@param familiar EntityFamiliar
function bombBuddy:FamiliarUpdate(familiar)
	familiar:FollowParent()
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bombBuddy.FamiliarUpdate, enums.Familiars.BOMB_BUM)