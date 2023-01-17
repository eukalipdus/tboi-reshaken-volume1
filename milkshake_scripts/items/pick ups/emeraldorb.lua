local emeraldOrb = {}
local enums = require("milkshake_scripts.enums")


---@param player EntityPlayer
function emeraldOrb:onUse(_, player)
    if not player then return end
    player:AnimateHappy()
    -- player:UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS, UseFlag.USE_NOANIM)
    -- player:SetCard(0, 0)
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, emeraldOrb.onUse, enums.Cards.EMERALD_ORB)


return emeraldOrb