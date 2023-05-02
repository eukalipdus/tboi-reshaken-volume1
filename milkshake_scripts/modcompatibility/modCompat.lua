---@type function[]
local modCompatibilities = {}

---Adds a function that will only run once when all mods are loaded
---@param funct function
function milkshakeMod:AddModCompatibility(funct)
    modCompatibilities[#modCompatibilities+1] = funct
end


local hasRunCompatibility = false
milkshakeMod:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_INIT, math.mininteger, function ()
    if hasRunCompatibility then return end
    hasRunCompatibility = true

    for _, funct in ipairs(modCompatibilities) do
        funct()
    end
end)