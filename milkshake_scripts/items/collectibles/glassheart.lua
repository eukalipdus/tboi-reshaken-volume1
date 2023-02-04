local GlassHeart = {}
local enums = require("milkshake_scripts.enums")


TSIL.SaveManager.AddPersistentVariable(
    milkshakeMod,
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

    local player = entity:ToPlayer()
    if not player then return end
	if not player:HasCollectible(enums.Collectibles.GLASS_HEART) then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playersTookDamage = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersTookDamageThisRoomGlassHeart"
    )

    --Player already took damage
    if TSIL.Utils.Tables.IsIn(playersTookDamage, playerIndex) then return end

    playersTookDamage[#playersTookDamage+1] = playerIndex

    IsTakingExtraDamage = true
    player:TakeDamage(4, DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(player), -1)
    IsTakingExtraDamage = false
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_ENTITY_TAKE_DMG,
    GlassHeart.CrystalHeart,
    EntityType.ENTITY_PLAYER
)


---@param player EntityPlayer
local function OnPlayerRoomClear(player)
    if not player:HasCollectible(enums.Collectibles.GLASS_HEART) then return end

    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local playersTookDamage = TSIL.SaveManager.GetPersistentVariable(
        milkshakeMod,
        "PlayersTookDamageThisRoomGlassHeart"
    )

    --Player took damage
    if TSIL.Utils.Tables.IsIn(playersTookDamage, playerIndex) then return end

    local redHeartsToAdd = math.min(2, player:GetMaxHearts() - player:GetHearts())
    local soulHeartsToAdd = 2 - redHeartsToAdd

    player:AddHearts(redHeartsToAdd)
    player:AddSoulHearts(soulHeartsToAdd)
end


function GlassHeart:CrystalDodgeHeal()
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		OnPlayerRoomClear(player)
	end
end
milkshakeMod:AddCallback(
    ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
    GlassHeart.CrystalDodgeHeal
)