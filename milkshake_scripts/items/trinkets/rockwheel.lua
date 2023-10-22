local game = Game()
local enums = MilkshakeVol1.enums
local RockWheel = {}

local SPEED_BONUS = 0.1

local GRIMACES = TSIL.Utils.Tables.ConstructDictionaryFromTable({
    EntityType.ENTITY_STONEHEAD,
    EntityType.ENTITY_CONSTANT_STONE_SHOOTER,
    EntityType.ENTITY_BRIMSTONE_HEAD,
    EntityType.ENTITY_GAPING_MAW,
    EntityType.ENTITY_BROKEN_GAPING_MAW,
    EntityType.ENTITY_QUAKE_GRIMACE,
})

---@param npc EntityNPC
function RockWheel:NPCInit(npc)
    if not GRIMACES[npc.Type] then
        return
    end
    if not TSIL.Players.DoesAnyPlayerHasTrinket(enums.Trinkets.ROCK_WHEEL) then
        return
    end

    npc:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
end

---@param player EntityPlayer
---@param flag CacheFlag
function RockWheel:EvaluateCache(player, flag)
    if player:HasTrinket(enums.Trinkets.ROCK_WHEEL) then
        player.MoveSpeed = player.MoveSpeed + SPEED_BONUS * player:GetTrinketMultiplier(enums.Trinkets.ROCK_WHEEL)
    end
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, RockWheel.EvaluateCache, CacheFlag.CACHE_SPEED)
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_INIT, RockWheel.NPCInit)
return RockWheel