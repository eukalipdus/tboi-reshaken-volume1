local SpiritKlin = {}
local enums = milkshakeMod.enums


---@param brenda Entity
function SpiritKlin:OnBrendaUpdate(brenda)
    local sprite = brenda:GetSprite()

    if brenda.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
        sprite:Play("Broken", false)
        return
    end

    if sprite:IsFinished("Wiggle") then
        sprite:Play("Prize", true)
    end

    if sprite:IsFinished("Prize") then
        sprite:Play("Idle")
    end
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_SLOT_UPDATE,
    SpiritKlin.OnBrendaUpdate,
    enums.Slots.SPIRIT_KLIN_BRENDA
)


---@param brenda Entity
---@param player EntityPlayer
function SpiritKlin:OnBrendaCollision(brenda, player)
    local sprite = brenda:GetSprite()
    if sprite:GetAnimation() ~= "Idle" then return end

    local soulCharge = player:GetSoulCharge()
    local soulHearts = player:GetSoulHearts()
    if soulCharge < 1 and soulHearts < 1 then return end

    if soulCharge >= 1 then
        player:AddSoulCharge(-1)
    else
        player:AddSoulHearts(-1)
    end

    sprite:Play("Wiggle", true)
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.PRE_SLOT_COLLISION,
    SpiritKlin.OnBrendaCollision,
    enums.Slots.SPIRIT_KLIN_BRENDA
)


---@param brenda Entity
function SpiritKlin:OnBrendaPrize(brenda)
    -- local rng = brenda:GetDropRNG()

    -- local orbToPay = TSIL.Random.GetRandomElementsFromTable(
    --     ORBS,
    --     1,
    --     rng
    -- )[1]

    -- TSIL.EntitySpecific.SpawnPickup(
    --     PickupVariant.PICKUP_TAROTCARD,
    --     orbToPay,
    --     brenda.Position,
    --     Vector(6, 0):Rotated(rng:RandomInt(360))
    -- )
end
milkshakeMod:AddCallback(
    TSIL.Enums.CustomCallback.POST_SLOT_PRIZE,
    SpiritKlin.OnBrendaPrize,
    enums.Slots.SPIRIT_KLIN_BRENDA
)