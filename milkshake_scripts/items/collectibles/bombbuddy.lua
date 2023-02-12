local bombBuddy = {}
local enums = require("milkshake_scripts.enums")

function bombBuddy:EvaluateCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.BOMB_BUDDY,
        enums.Familiars.BOMB_BUDDY
    )
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bombBuddy.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
function bombBuddy:FamiliarInit(familiar)
	--IDEK if i need this
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, bombBuddy.FamiliarInit, enums.Familiars.BOMB_BUDDY)

---@param familiar EntityFamiliar
function bombBuddy:FamiliarUpdate(familiar)
	familiar:FollowParent()
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bombBuddy.FamiliarUpdate, enums.Familiars.BOMB_BUDDY)