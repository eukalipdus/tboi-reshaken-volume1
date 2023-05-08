---@type function[]
local modCompatibilities = {}

---Adds a function that will only run once when all mods are loaded
---@param funct function
function MilkshakeVol1:AddModCompatibility(funct)
    modCompatibilities[#modCompatibilities+1] = funct
end


local hasRunCompatibility = false
MilkshakeVol1:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_INIT, math.mininteger, function ()
    if hasRunCompatibility then return end
    hasRunCompatibility = true

    for _, funct in ipairs(modCompatibilities) do
        funct()
    end
end)