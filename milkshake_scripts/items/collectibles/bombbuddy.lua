local bombBuddy = {}
local enums = require("milkshake_scripts.enums")
local utility = require("milkshake_scripts.utility")

utility:AddBumFamiliar(enums.Familiars.BOMB_BUM)

function bombBuddy:EvaluateCache(player)
    TSIL.Familiars.CheckFamiliarFromCollectibles(
        player,
        enums.Collectibles.BOMB_BUM,
        enums.Familiars.BOMB_BUM
    )
end
milkshakeMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, bombBuddy.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

--[[
---@param familiar EntityFamiliar
function bombBuddy:FamiliarInit(familiar)
	--IDEK if i need this
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, bombBuddy.FamiliarInit, enums.Familiars.BOMB_BUM)

---@param familiar EntityFamiliar
function bombBuddy:FamiliarUpdate(familiar)
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bombBuddy.FamiliarUpdate, enums.Familiars.BOMB_BUM)

---@param familiar EntityFamiliar
function bombBuddy:FamiliarUpdate2(familiar)
	print(familiar)
	print(familiar.Parent)
	print(familiar.Parent:ToPlayer())
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, bombBuddy.FamiliarUpdate2)]]