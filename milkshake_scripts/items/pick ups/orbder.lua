local sprite = Sprite()
sprite:Load("gfx/ui/ui_orderspiritoverlay.anm2", true)
sprite:Play(sprite:GetDefaultAnimation(), true)
sprite.Offset = Vector(-1, 0)

local SPIRIT_ORDER_SPAWN_CHANCE = 0.04

---@param player EntityPlayer
function MilkshakeVol1.API:GetSelectedOrderOrb(player)
    return MilkshakeVol1.utility:GetDataEx(player, "SpiritOfOrder").SelectedOrb or 1
end

---@param player EntityPlayer
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function (_, player)
    if player:GetCard(0) ~= MilkshakeVol1.enums.Orbs.ORDER then return end

    local data = MilkshakeVol1.utility:GetDataEx(player, "SpiritOfOrder")

    data.SelectedOrb = data.SelectedOrb or 1

    if not Input.IsActionTriggered(ButtonAction.ACTION_DROP, player.ControllerIndex) then return end

    data.SelectedOrb = data.SelectedOrb + 1

    if data.SelectedOrb > #MilkshakeVol1.enums.OrbsExcludingOrder then
        data.SelectedOrb = 1
    end

    SFXManager():Play(SoundEffect.SOUND_GOLD_HEART_DROP, 1, 2, false, 1 + data.SelectedOrb * 0.1)
end)

---@param player EntityPlayer
---@param flags UseFlag
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_CARD, function (_, _, player, flags)
    SFXManager():Play(MilkshakeVol1.enums.Sounds.ORB_CAPTURE)
    SFXManager():Play(MilkshakeVol1.enums.Sounds.SPIRIT_ORDER)

    if not player:HasCollectible(MilkshakeVol1.enums.Collectibles.LYRA) then
        MilkshakeVol1:UseSpiritOrb(MilkshakeVol1.enums.OrbsExcludingOrder[MilkshakeVol1.API:GetSelectedOrderOrb(player)], player, MilkshakeVol1.enums.UseOrbFlags.NO_SOUND)
    end
end, MilkshakeVol1.enums.Orbs.ORDER)


---@param pickup EntityPickup
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, function (_, pickup)
    if not MilkshakeVol1.utility:IsSpiritOrb(pickup.SubType) then return end
    if pickup.SubType == MilkshakeVol1.enums.Orbs.ORDER then return end
    if not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(MilkshakeVol1.enums.Achievements.SPIRIT_OF_ORDER) then return end
    if not (Game():GetRoom():GetFrameCount() < 1 and Game():GetRoom():IsFirstVisit()) then return end

    local rng = TSIL.RNG.NewRNG(pickup.InitSeed) if rng:RandomFloat() > SPIRIT_ORDER_SPAWN_CHANCE then return end

    pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, MilkshakeVol1.enums.Orbs.ORDER, true, true)
end, PickupVariant.PICKUP_TAROTCARD)

HudHelper.RegisterHUDElement({
    ItemID = MilkshakeVol1.enums.Orbs.ORDER,
    OnRender = function(player, index, layout, position, alpha, scale)
        sprite.Color = Color(alpha, alpha, alpha)
        sprite.Scale = Vector(scale, scale)
        sprite:SetFrame(MilkshakeVol1.API:GetSelectedOrderOrb(player) - 1)
        sprite:Render(position)
    end,
}, HudHelper.HUDType.CARD_ID)