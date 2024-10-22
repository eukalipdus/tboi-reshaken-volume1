local PrismaticSpinupDice = {}
local enums = MilkshakeVol1.enums

local SCHEDULE_FRAMES = 2
local SPLIT_COLOR_FRAMES = 2
local WHITE = Color(1, 1, 1, 1, 255, 255, 255)
local ORANGE = Color(242/255, 174/255, 0, 0.5)
local SOLID_ORANGE = Color(242/255, 174/255, 0, 1)
local GREEN = Color(32/255, 135/255, 79/255, 0.5)
local SOLID_GREEN = Color(32/255, 135/255, 79/255, 1)
local COLORS = {
    {ORANGE, SOLID_ORANGE},
    {GREEN, SOLID_GREEN}
}

local function ScaledCosine(num)
    return math.ceil(math.abs(CollectibleType.NUM_COLLECTIBLES * math.cos(num)))
end

---@param player EntityPlayer
---@param useFlags integer
---@return boolean
function PrismaticSpinupDice:UseItem(_, _, player, useFlags)
    if useFlags & UseFlag.USE_CARBATTERY ~= 0 then
        return true
    end

    local collectibles = TSIL.PickupSpecific.GetCollectibles()
    for _, entity in pairs(collectibles) do
        local collectible = entity:ToPickup()

        TSIL.Utils.Functions.RunInFramesTemporary(function ()
            if collectible.SubType == CollectibleType.COLLECTIBLE_DADS_NOTE then
                return
            end

            collectible:Remove()
            collectible:SetColor(WHITE, SPLIT_COLOR_FRAMES, 1, false, false)
            collectible:Remove()
            SFXManager():Play(SoundEffect.SOUND_MIRROR_EXIT, 1, 2, false, 0.5)

            local absoluteStage = Game():GetLevel():GetAbsoluteStage()
            local someUselessNumber = collectible.SubType + (player:GetPlayerType() * 10) - (absoluteStage * 10)
            local newCollectibleId = ScaledCosine(someUselessNumber)

            local forcedCollectibles = {
                newCollectibleId,
                ScaledCosine(newCollectibleId)
            }

            MilkshakeVol1.API:SplitCollectible(player, collectible, -1, nil, forcedCollectibles, COLORS)
        end, SCHEDULE_FRAMES)
    end
    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, PrismaticSpinupDice.UseItem, enums.Collectibles.PRISMATIC_SPINUP_DICE)