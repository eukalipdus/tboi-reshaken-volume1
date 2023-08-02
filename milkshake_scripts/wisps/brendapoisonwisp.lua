local BrendaPoisonWisp = {}


local CREEP_FREQUENCY = 4
local CREEP_DURATION = 45


---@param wisp EntityFamiliar
function BrendaPoisonWisp:OnWispUpdate(wisp)
    if wisp.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_POISON_WISP then return end
    if wisp.FrameCount % CREEP_FREQUENCY ~= 0 then return end

    local creep = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.PLAYER_CREEP_RED,
        0,
        wisp.Position,
        Vector.Zero,
        wisp.Player
    )
    local creepColor = Color(1, 1, 1)
    creepColor:SetColorize(6, 6, 0, 1)
    creep.Color = creepColor
    creep:SetTimeout(CREEP_DURATION)

    creep:Update()
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    BrendaPoisonWisp.OnWispUpdate,
    FamiliarVariant.WISP
)