local FruitHeart = {}
local enums = require("milkshake_scripts.enums")


---@param player EntityPlayer
---@param collider Entity
function FruitHeart:OnPlayerCollision(player, collider)
    if collider.Type ~= EntityType.ENTITY_PICKUP then return end
    if collider.Variant ~= PickupVariant.PICKUP_HEART then return end
    if collider.SubType ~= enums.Hearts.FRUIT_HEART then return end

    if player:CanPickRedHearts() then
        player:AddHearts(1)
    else
        player:AddSoulHearts(1)
    end

    SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
    collider:GetSprite():Play("Collect", true)
    collider:Die()
    return true
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_PRE_PLAYER_COLLISION,
    FruitHeart.OnPlayerCollision
)