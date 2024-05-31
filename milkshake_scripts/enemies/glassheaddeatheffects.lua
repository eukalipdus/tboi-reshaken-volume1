local game = Game()

---@param effect EntityEffect
---@return boolean
local function isGlasshead(effect)
    return TSIL.Utils.Tables.IsIn(MilkshakeVol1.enums.GlassHeadDeathEffectVariant, effect.Variant)
end

local glassheadToTimeout = {
    [MilkshakeVol1.enums.GlassHeadDeathEffectVariant.SPHERE] = 300,
    [MilkshakeVol1.enums.GlassHeadDeathEffectVariant.FLASK] = 400,
    [MilkshakeVol1.enums.GlassHeadDeathEffectVariant.FLASK_PROJECTILE] = 400,
    [MilkshakeVol1.enums.GlassHeadDeathEffectVariant.BEER] = 200,
    [MilkshakeVol1.enums.GlassHeadDeathEffectVariant.WINE] = 100,
}

---@param effect EntityEffect
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function (_, effect)
    if not isGlasshead(effect) then
        return
    end

    local sprite = effect:GetSprite()

    if effect.Variant == MilkshakeVol1.enums.GlassHeadDeathEffectVariant.FLASK_PROJECTILE then
        sprite:Play("Death", true)
    elseif effect.Variant ~= MilkshakeVol1.enums.GlassHeadDeathEffectVariant.FLASK then
        sprite:Play("Death", true)

        repeat
            sprite:Update()
        until sprite:IsEventTriggered("Smash")
    else
        sprite:Play("Throw", true)

        repeat
            sprite:Update()
        until sprite:IsEventTriggered("Throw")
    end

    sprite:Update()
end)

---@param effect EntityEffect
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function (_, effect)
    if not isGlasshead(effect) then
        return
    end

    local room = game:GetRoom()

    if not (room:IsClear() or effect.FrameCount >= glassheadToTimeout[effect.Variant]) then
        return
    end

    local sprite = effect:GetSprite()

    ---@diagnostic disable-next-line: missing-parameter
    if not sprite:IsFinished() then
        return
    end

    sprite.Color = Color.Lerp(sprite.Color, Color(0,0,0,0,0,0,0), .2)

    if sprite.Color.A < .1 then
        effect:Remove()
    end
end)