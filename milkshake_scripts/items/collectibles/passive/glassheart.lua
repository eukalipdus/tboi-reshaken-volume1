local GlassHeart = {}
local enums = MilkshakeVol1.enums


TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "PlayersTookDamageThisRoomGlassHeart",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_ROOM
)

local IsTakingExtraDamage = false

---@param entity Entity
---@param damageFlags DamageFlag
function GlassHeart:CrystalHeart(entity, _, damageFlags)
    if IsTakingExtraDamage then return end

    if TSIL.Utils.Flags.HasFlags(damageFlags, DamageFlag.DAMAGE_NO_MODIFIERS) then return end
    if TSIL.Utils.Flags.HasFlags(damageFlags, DamageFlag.DAMAGE_NO_PENALTIES) then return end
    if TSIL.Utils.Flags.HasFlags(damageFlags, DamageFlag.DAMAGE_FAKE) then return end
    if TSIL.Utils.Flags.HasFlags(damageFlags, DamageFlag.DAMAGE_RED_HEARTS) then return end

    local player = entity:ToPlayer()
    if not player then return end
	if not player:HasCollectible(enums.Collectibles.GLASS_HEART) then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playersTookDamage = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayersTookDamageThisRoomGlassHeart"
    )

    --Player already took damage
    if TSIL.Utils.Tables.IsIn(playersTookDamage, playerIndex) then return end

    playersTookDamage[#playersTookDamage+1] = playerIndex

    IsTakingExtraDamage = true
    player:TakeDamage(4, DamageFlag.DAMAGE_NOKILL, EntityRef(player), -1)
    SFXManager():Play(SoundEffect.SOUND_GLASS_BREAK)
    IsTakingExtraDamage = false
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    GlassHeart.CrystalHeart,
    EntityType.ENTITY_PLAYER
)


---@param player EntityPlayer
local function OnPlayerRoomClear(player)
    if not player:HasCollectible(enums.Collectibles.GLASS_HEART) then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playersTookDamage = TSIL.SaveManager.GetPersistentVariable(
        MilkshakeVol1,
        "PlayersTookDamageThisRoomGlassHeart"
    )

    --Player took damage
    if TSIL.Utils.Tables.IsIn(playersTookDamage, playerIndex) then return end

    local redHeartsToAdd = math.min(1, player:GetMaxHearts() - player:GetHearts())
    local soulHeartsToAdd = 1 - redHeartsToAdd

    if player:GetMaxHearts() - player:GetHearts() == 0 then
        SFXManager():Play(SoundEffect.SOUND_HOLY)
    else 
        SFXManager():Play(SoundEffect.SOUND_VAMP_GULP)
    end
    player:AddHearts(redHeartsToAdd)
    player:AddSoulHearts(soulHeartsToAdd)
end


function GlassHeart:CrystalDodgeHeal()
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		OnPlayerRoomClear(player)
	end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    GlassHeart.CrystalDodgeHeal
)