local utility = {}
local enums = require("milkshake_scripts.enums")

-- Used specifically for the shard set of trinkets, will spawn their respective drop alongside tinted rock drops
function utility:shardTrinkets(trinket, player)
    local BASE_CHANCE = 50
    local velocity = Vector(2,2)
    for gridIndex = 1, Game():GetRoom():GetGridSize() do
        local grid = Game():GetRoom():GetGridEntity(gridIndex)
        if grid then
            if grid:GetType() == GridEntityType.GRID_ROCKT and grid.State == 2 then -- Destroyed

                local rng = player:GetTrinketRNG(trinket)
                local roll = rng:RandomInt(100)

                if trinket == enums.Trinkets.AMETHYST_SHARD then
                    local rune = Game():GetItemPool():GetCard(Random() + 1, false, true, true)
                    if roll <= BASE_CHANCE then
						---@diagnostic disable-next-line: param-type-mismatch
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, rune, grid.Position, velocity, nil)
                    end

                elseif trinket == enums.Trinkets.RUBY_SHARD then
                    if roll <= BASE_CHANCE then
						---@diagnostic disable-next-line: param-type-mismatch
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, grid.Position, velocity, nil)
                    end
                
                elseif trinket == enums.Trinkets.SAPPHIRE_SHARD then
                    if roll <= BASE_CHANCE then
                        local cardsRollable = {}
                        for i = 1, 21 do -- Create table of tarot cards only
                            cardsRollable[i] = i
                        end

                        local rng = player:GetTrinketRNG(trinket)
                        local randomCard = rng:RandomInt(#cardsRollable)
						---@diagnostic disable-next-line: param-type-mismatch
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, randomCard, grid.Position, velocity, nil)
                    end
                end
                grid.State = -1
            end
        end
    end
end


---Returns the tears stat after adding some value
---
---Provided by Hybrid
---@param firedelay number
---@param val number
---@return number
function utility:TearsUp(firedelay, val)
    local currentTears = 30 / (firedelay + 1)
    local newTears = currentTears + val
    return math.max((30 / newTears) - 1, -0.99)
end

local NotGetData = {}
---Acts as a replacement for Entity:GetData()
---@param entity Entity
---@param identifier string
---@return table
function utility:GetData(entity, identifier)
	if (not NotGetData[GetPtrHash(entity)]) then NotGetData[GetPtrHash(entity)] = {} end
	return NotGetData[GetPtrHash(entity)][identifier]
end
---Acts as a replacement for Entity:GetData()
---@param entity Entity
---@param identifier string
---@param data nil
---@return boolean
function utility:SetData(entity, identifier, data)
	if (not NotGetData[GetPtrHash(entity)]) then NotGetData[GetPtrHash(entity)] = {} return false end
	NotGetData[GetPtrHash(entity)][identifier] = data
	return true
end

function utility:PreGameExit()
	NotGetData = {}
end
milkshakeMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, utility.PreGameExit)

local BumFamiliars = {}
---Custom function to define a familiar variant as a "Bum Familiar"
---
function utility:AddBumFamiliar(familiarVariant)
	BumFamiliars[familiarVariant] = true
end

---@param familiar EntityFamiliar
function utility:BumFamiliarInit(familiar)
	if (BumFamiliars[familiar.Variant]) then
		local player = familiar.SpawnerEntity
		---@diagnostic disable-next-line: param-type-mismatch
		local BumChain = utility:GetData(player, "BumChain") or (utility:SetData(player, "BumChain", {}) and utility:GetData(player, "BumChain"))
		
		---@diagnostic disable-next-line: assign-type-mismatch
		if #BumChain == 0 then familiar.Parent = player
		else familiar.Parent = BumChain[#BumChain] end

		BumChain[#BumChain+1] = familiar
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, utility.BumFamiliarInit)

---@param familiar EntityFamiliar
function utility:BumFamiliarUpdate(familiar)
	if (BumFamiliars[familiar.Variant] and (familiar.Variant ~= FamiliarVariant.BUMBO or familiar.Coins < 6))then
		local newPos = familiar.Parent.Position - familiar.Position
		if (familiar.Parent:ToPlayer() and newPos:DistanceSquared(Vector.Zero) < 65*65) then newPos = Vector.Zero
		elseif (newPos:DistanceSquared(Vector.Zero) < 40*40) then newPos = Vector.Zero end
		newPos:Resize(3)
		---@diagnostic disable-next-line: assign-type-mismatch
		--familiar.Position = familiar.Position + newPos
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, utility.BumFamiliarUpdate)

---@param familiar EntityFamiliar
---@param collider Entity
---@param low boolean
function utility:BumFamiliarCollide(familiar, collider, low)
	if (BumFamiliars[familiar.Variant] and (familiar.Variant ~= FamiliarVariant.BUMBO or familiar.Coins < 6))then
		return false
	end
end
milkshakeMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, utility.BumFamiliarCollide)

utility:AddBumFamiliar(FamiliarVariant.BUMBO) --Hm.
utility:AddBumFamiliar(FamiliarVariant.BUM_FRIEND)
--utility:AddBumFamiliar(FamiliarVariant.DARK_BUM)
--utility:AddBumFamiliar(FamiliarVariant.KEY_BUM)
utility:AddBumFamiliar(FamiliarVariant.SUPER_BUM)

return utility