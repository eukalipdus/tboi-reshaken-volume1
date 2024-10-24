local PrismaticSpinupDice = {}
local enums = MilkshakeVol1.enums

local SCHEDULE_FRAMES = 2
local SPLIT_COLOR_FRAMES = 2
local COLOR_ALPHA = 0.5
local WHITE = Color(1, 1, 1, 1, 255, 255, 255)

---Returns Cos(x), scaling by the number of collectibles, then rounded up
---@param num number
---@return integer
local function ScaledCosine(num)
    local totalCollectibleCount = #TSIL.Collectibles.GetCollectibles()
    return math.ceil(math.abs(totalCollectibleCount * math.cos(num)))
end

---@param player EntityPlayer
---@param useFlags integer
---@return boolean
function PrismaticSpinupDice:UseItem(_, rng, player, useFlags)
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

            local firstSplitCollectible = ScaledCosine(collectible.SubType)
            local secondSplitCollectible = ScaledCosine(firstSplitCollectible)

            local forcedCollectibles = {
                firstSplitCollectible,
                secondSplitCollectible
            }

            local colorOne = TSIL.Color.GetRandomColor(rng)
            local colorOneTrans = colorOne
            colorOneTrans.A = COLOR_ALPHA

            local colorTwo = TSIL.Color.GetRandomColor(rng)
            local colorTwoTrans = colorTwo
            colorTwoTrans.A = COLOR_ALPHA

            local colors = {
                {colorOne, colorOneTrans},
                {colorTwo, colorTwoTrans}
            }

            MilkshakeVol1.API:SplitCollectible(player, collectible, -1, nil, forcedCollectibles, colors)
        end, SCHEDULE_FRAMES)
    end
    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, PrismaticSpinupDice.UseItem, enums.Collectibles.PRISMATIC_SPINUP_DICE)