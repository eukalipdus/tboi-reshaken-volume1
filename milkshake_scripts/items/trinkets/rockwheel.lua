local game = Game()
local enums = MilkshakeVol1.enums
local RockWheel = {}

function RockWheel:NPCUpdate(Entity)
    for i=0, game:GetNumPlayers() - 1, 1 do
        local player = game:GetPlayer(i)
        if player:HasTrinket(enums.Trinkets.ROCK_WHEEL) then
            if Entity.Type == EntityType.ENTITY_STONEHEAD           or   -- Regular / Ipecac / Triple
            Entity.Type == EntityType.ENTITY_CONSTANT_STONE_SHOOTER or   -- Constant / Cuadruple
            Entity.Type == EntityType.ENTITY_BRIMSTONE_HEAD         or   -- Brim
            Entity.Type == EntityType.ENTITY_GAPING_MAW             or   -- Magnet
            Entity.Type == EntityType.ENTITY_BROKEN_GAPING_MAW      or   -- Broken Magnet
            Entity.Type == EntityType.ENTITY_QUAKE_GRIMACE          then -- Quake Grimace
                Entity:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
            end
        end
    end
end

function RockWheel:EvaluateCache(Player, Flag)
    if Player:HasTrinket(enums.Trinkets.ROCK_WHEEL) then
        Player.MoveSpeed = Player.MoveSpeed + 0.05
    end
end

MilkshakeVol1:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, RockWheel.EvaluateCache, CacheFlag.CACHE_SPEED)
MilkshakeVol1:AddCallback(ModCallbacks.MC_NPC_UPDATE, RockWheel.NPCUpdate)
return RockWheel