-- IT JUST WORKS
local mod = MilkshakeVol1

local globinInABucket = {}
local enums = MilkshakeVol1.enums
--[[local globinTypes = {
    [1] = EntityType.ENTITY_GLOBIN,
    [2] = EntityType.ENTITY_BLACK_GLOBIN
}]]

local globinz = {
    globin = {
        type = 24,
        variant = 0
    },
    gazing_globin = {
        type = 24,
        variant = 1
    },
    dank_globin = {
        type = 24,
        variant = 2
    },
    dark_globin = {
        type = 278,
        variant = 0
    },
    cursed_globin = {
        type = 24,
        variant = 3
    },
    conglobberate_small = {
        type = Isaac.GetEntityTypeByName("Conglobberate (Small)"),
        variant = Isaac.GetEntityVariantByName("Conglobberate (Small)")
    },
    spoilie = {
        type = Isaac.GetEntityTypeByName("Spoilie"),
        variant = Isaac.GetEntityVariantByName("Spoilie")
    }
}
local variantChance = 33
--do i spawn a variant this use?
local sillyvariable = false
local variantCorpse = 0


-- spawn effect on use
function globinInABucket:onUse(collectible, rng, player, flags, slot)
    if player == nil then return end
    player:AnimateCollectible(enums.Collectibles.GLOBIN_IN_A_BUCKET, "Pickup", "PlayerPickupSparkle")
    --local roll = rng:RandomInt(#globinTypes) + 1
    --local globin = Isaac.Spawn(globinTypes[roll], 0, 0, player.Position, Vector(0,0), player)
    if math.random(0,100) <= variantChance then
        sillyvariable = true
    end
    local effectGlobinBucket = Isaac.Spawn(1000, enums.Effects.GLOBIN_IN_A_BUCKET, 0, player.Position, Vector(math.random(-7,7),math.random(-7,7)), player)
    
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, globinInABucket.onUse, enums.Collectibles.GLOBIN_IN_A_BUCKET)


-- effect animaation manangement
function mod:onNPCUpdate(entity, player)
    local backdrop = Game():GetRoom():GetBackdropType()
    local sprite = entity:GetSprite()
    if sillyvariable == true then
    --gazing
        if backdrop == BackdropType.CAVES or backdrop == BackdropType.CATACOMBS or backdrop == BackdropType.FLOODED_CAVES then
            sprite:Play("gazing_globin", true)
    --dank
        elseif backdrop == BackdropType.DANK_DEPTHS then
            sprite:Play("dank_globin", true)
    --dark
        elseif backdrop == BackdropType.SHEOL then
            sprite:Play("dark_globin", true)
    --cursed (mausoleum)
        elseif backdrop == BackdropType.MAUSOLEUM_ENTRANCE or backdrop == BackdropType.MAUSOLEUM or backdrop == BackdropType.MAUSOLEUM2 or backdrop == BackdropType.MAUSOLEUM3 or backdrop == BackdropType.MAUSOLEUM4 then
            sprite:Play("cursed_globin_mausolleaum", true)
    --cursed (gehenna)
        elseif backdrop == BackdropType.GEHENNA then
            sprite:Play("cursed_globin_ghhehgnana", true)
        elseif FiendFolio then
            if backdrop == BackdropType.CORPSE_ENTRANCE or backdrop == BackdropType.CORPSE or backdrop == BackdropType.CORPSE2 or backdrop == BackdropType.CORPSE3 then
                if math.random(1,2) == 1 then
                    variantCorpse = 0
                    sprite:Play("conglobberate_small", true)
                else
                    variantCorpse = 1
                    sprite:Play("spoilie", true)
                end
            end

    --default
        else
            
        end
    else
        sprite:Play("globin", true)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.onNPCUpdate, enums.Effects.GLOBIN_IN_A_BUCKET)


-- effect behavior
function mod:onNPCUpdate(entity, player)

    local sprite = entity:GetSprite()
    -- spawn globin!!!
    if sprite:IsEventTriggered("idkhowtouseIsFinished()") then
        local backdrop = Game():GetRoom():GetBackdropType()
        if sillyvariable == true then
                --gazing
        
            if backdrop == BackdropType.CAVES or backdrop == BackdropType.CATACOMBS or backdrop == BackdropType.FLOODED_CAVES then
                local globin = Isaac.Spawn(globinz.gazing_globin.type, globinz.gazing_globin.variant, 0, entity.Position, Vector(0,0), player)
                --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                globin:AddCharmed(EntityRef(player), -1)
            --dank
            elseif backdrop == BackdropType.DANK_DEPTHS then
                local globin = Isaac.Spawn(globinz.dank_globin.type, globinz.dank_globin.variant, 0, entity.Position, Vector(0,0), player)
                --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                globin:AddCharmed(EntityRef(player), -1)
            --dark
            elseif backdrop == BackdropType.SHEOL then
                local globin = Isaac.Spawn(globinz.dark_globin.type, globinz.dark_globin.variant, 0, entity.Position, Vector(0,0), player)
                --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                globin:AddCharmed(EntityRef(player), -1) 
            --cursed
            elseif backdrop == BackdropType.MAUSOLEUM_ENTRANCE or backdrop == BackdropType.MAUSOLEUM or backdrop == BackdropType.MAUSOLEUM2 or backdrop == BackdropType.MAUSOLEUM3 or backdrop == BackdropType.MAUSOLEUM4 or backdrop == BackdropType.GEHENNA then
                local globin = Isaac.Spawn(globinz.cursed_globin.type, globinz.cursed_globin.variant, 0, entity.Position, Vector(0,0), player)
                --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                globin:AddCharmed(EntityRef(player), -1)
            elseif FiendFolio and backdrop == BackdropType.CORPSE_ENTRANCE or backdrop == BackdropType.CORPSE or backdrop == BackdropType.CORPSE2 or backdrop == BackdropType.CORPSE3 then
                if variantCorpse == 0 then
                    local globin = Isaac.Spawn(globinz.conglobberate_small.type, globinz.conglobberate_small.variant, 0, entity.Position, Vector(0,0), player)
                    --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    globin:AddCharmed(EntityRef(player), -1)
                else
                    local globin = Isaac.Spawn(globinz.spoilie.type, globinz.spoilie.variant, 0, entity.Position, Vector(0,0), player)
                    --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    globin:AddCharmed(EntityRef(player), -1)
                end
            --default
            else
                local globin = Isaac.Spawn(globinz.globin.type, globinz.globin.variant, 0, entity.Position, Vector(0,0), player)
                --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                globin:AddCharmed(EntityRef(player), -1)
            end
            
        else
            local globin = Isaac.Spawn(globinz.globin.type, globinz.globin.variant, 0, entity.Position, Vector(0,0), player)
            --globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            globin:AddCharmed(EntityRef(player), -1)
        
        end
    end



    -- dropsound event
    if sprite:IsEventTriggered("DropSound") then
        entity.Velocity = entity.Velocity*0
    end
    -- DIE!!!1!
    if sprite:IsFinished() then    
        entity:Remove()
        sillyvariable = false
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.onNPCUpdate, enums.Effects.GLOBIN_IN_A_BUCKET)




-- WIP PART !! make them spawn as GOO!!
--[[function mod:setGlobinState(entity)
    local sprite = entity:GetSprite()
    if entity.State == NpcState.STATE_MOVE then
        entity.State = NpcState.STATE_IDLE
        sprite:Play("ReGen", true)
    end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.setGlobinState, EntityType.ENTITY_GLOBIN)]]


-- ?
return {
    Discharge = true,
    Remove = false,
    ShowAnim = true,
}