-- IT JUST WORKS
local mod = MilkshakeVol1

local globinInABucket = {}
local enums = MilkshakeVol1.enums


local globinTypes = {
    [1] = EntityType.ENTITY_GLOBIN,
    [2] = EntityType.ENTITY_BLACK_GLOBIN
}
-- uhh this makeks it so basically it uhh plays the right animation when  spawnnging the effectr
function mod:onNPCUpdate(entity, player)
    local sprite = entity:GetSprite()
    sprite:Play("globin", true)
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.onNPCUpdate, enums.Effects.GLOBIN_IN_A_BUCKET)


-- here is da stuff 2 make it do the things
function mod:onNPCUpdate(entity, player)
    local sprite = entity:GetSprite()
    if sprite:IsEventTriggered("idkhowtouseIsFinished()") then
        local globin = Isaac.Spawn(EntityType.ENTITY_GLOBIN, 0, 0, entity.Position, Vector(0,0), player)
        globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        globin:AddCharmed(EntityRef(player), -1)
    end
    if sprite:IsEventTriggered("DropSound") then
        entity.Velocity = entity.Velocity*0
    end
    if sprite:IsFinished("globin") then    
        entity:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.onNPCUpdate, enums.Effects.GLOBIN_IN_A_BUCKET)


-- use it and it spawns da thing
function globinInABucket:onUse(collectible, rng, player, flags, slot)
    if player == nil then return end
    player:AnimateCollectible(enums.Collectibles.GLOBIN_IN_A_BUCKET, "Pickup", "PlayerPickupSparkle")
    --local roll = rng:RandomInt(#globinTypes) + 1
    --local globin = Isaac.Spawn(globinTypes[roll], 0, 0, player.Position, Vector(0,0), player)
    --globin:AddCharmed(EntityRef(player), -1)
    local effectGlobinBucket = Isaac.Spawn(1000, enums.Effects.GLOBIN_IN_A_BUCKET, 0, player.Position, Vector(math.random(-7,7),math.random(-7,7)), player)
    --effectGlobinBucket:AddCharmed(EntityRef(player), -1)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, globinInABucket.onUse, enums.Collectibles.GLOBIN_IN_A_BUCKET)

-- WIP PART !! make them spawn as GOO!!
--[[function mod:setGlobinState(entity)
    local sprite = entity:GetSprite()
    if entity.State == NpcState.STATE_MOVE then
        entity.State = NpcState.STATE_IDLE
        sprite:Play("ReGen", true)
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.setGlobinState, EntityType.ENTITY_GLOBIN)]]



return {
    Discharge = true,
    Remove = false,
    ShowAnim = true,
}