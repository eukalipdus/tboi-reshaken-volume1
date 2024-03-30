local glassHeads = {
    SPHERE = Isaac.GetEntityVariantByName("Glass Head Corpse"),
    FLASK = Isaac.GetEntityVariantByName("Flask Head Corpse"),
    BEER = Isaac.GetEntityVariantByName("Beer Head Corpse"),
    WINE = Isaac.GetEntityVariantByName("Wine Head Corpse"),
}

---@param effect EntityEffect
---@return boolean
local function isGlasshead(effect)
    return TSIL.Utils.Tables.IsIn(glassHeads, effect.Variant)
end

local glassheadToTimeout = {
    [glassHeads.SPHERE] = 300,
    [glassHeads.FLASK] = 400,
    [glassHeads.BEER] = 200,
    [glassHeads.WINE] = 100,
}

---@param effect EntityEffect
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function (_, effect)
    if not isGlasshead(effect) then
        return
    end

    local sprite = effect:GetSprite()

    if effect.Variant ~= glassHeads.FLASK then
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

    local room = Game():GetRoom()

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