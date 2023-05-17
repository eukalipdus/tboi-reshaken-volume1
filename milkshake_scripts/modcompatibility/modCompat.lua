---@type {funct: function, exists: fun(): boolean}[]
local modCompatibilities = {}

---Adds a function that will only run once when all mods are loaded.
---@param mod string | fun(): boolean Name of the global variable to check if the mod exists, or funtion that checks if it does.
---@param funct function
function MilkshakeVol1:AddModCompatibility(mod, funct)
    if type(mod) == "string" then
        mod = function ()
            return _G[mod] ~= nil
        end
    end

    modCompatibilities[#modCompatibilities+1] = {
        funct = funct,
        exists = mod
    }
end


local hasRunCompatibility = false
MilkshakeVol1:AddPriorityCallback(ModCallbacks.MC_POST_PLAYER_INIT, math.mininteger, function ()
    if hasRunCompatibility then return end
    hasRunCompatibility = true

    for _, modCompat in ipairs(modCompatibilities) do
        if modCompat.exists() then
            modCompat.funct()
        end
    end
end)