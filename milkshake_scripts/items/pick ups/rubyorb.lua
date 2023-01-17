local RubyOrb = {}
local enums = require "milkshake_scripts.enums"


---@param player EntityPlayer
---@param flags integer
function RubyOrb:OnRubyOrbUse(_, player, flags)
    local initialDoorNum = #TSIL.Doors.GetDoors()

    ---@diagnostic disable-next-line: param-type-mismatch
    player:UseCard(Card.CARD_CRACKED_KEY, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)

    local currentDoorNum = #TSIL.Doors.GetDoors()

    if initialDoorNum == currentDoorNum and not TSIL.Utils.Flags.HasFlags(flags, UseFlag.USE_MIMIC) then
        player:AddCard(enums.Cards.RUBY_ORB)
    end
end
milkshakeMod:AddCallback(ModCallbacks.MC_USE_CARD, RubyOrb.OnRubyOrbUse, enums.Cards.RUBY_ORB)