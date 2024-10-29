local PrismaticSpinupDice = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local SCHEDULE_FRAMES = 2
local SPLIT_COLOR_FRAMES = 2
local COLOR_ALPHA = 0.5
local WHITE = Color(1, 1, 1, 1, 255, 255, 255)

TSIL.SaveManager.AddPersistentVariable(
    MilkshakeVol1,
    "CosineCollectibles",
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_RUN
)

---Returns Cos(x), scaling by the number of collectibles, then rounded up
---@param num number
---@return integer
local function ScaledCosine(num)
    local totalCollectibleCount = #TSIL.Collectibles.GetCollectibles()
    return math.ceil(math.abs(totalCollectibleCount * math.cos(num)))
end

---Removes all collectibles created by Prismatic Cosine Dice
local function RemoveAllCosineDiceCollectibles()
    local cosineCollectibles = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "CosineCollectibles")

    if not cosineCollectibles then
        return
    end

    local collectibles = TSIL.PickupSpecific.GetCollectibles()

    for _, currentCollectible in pairs(collectibles) do
        local pickupIndex = tonumber(TSIL.Pickups.GetPickupIndex(currentCollectible))
        if TSIL.Utils.Tables.IsIn(cosineCollectibles, pickupIndex) then
            currentCollectible:Remove()
        end
    end
    cosineCollectibles = {}
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
            if collectible.SubType == CollectibleType.COLLECTIBLE_DADS_NOTE
            or collectible.SubType == CollectibleType.COLLECTIBLE_NULL then
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

            local splitCollectibles = MilkshakeVol1.API:SplitCollectible(
                player,
                collectible,
                -1,
                nil,
                forcedCollectibles,
                colors
            )

            local cosineCollectibles = TSIL.SaveManager.GetPersistentVariable(MilkshakeVol1, "CosineCollectibles")

            for _, currentCollectible in pairs(splitCollectibles) do
                local pickupIndex = TSIL.Pickups.GetPickupIndex(currentCollectible)
                table.insert(cosineCollectibles, pickupIndex)
            end

            if not splitCollectibles then
                return
            end

            utility:SetData(
                splitCollectibles[1],
                "CosineCollectible",
                true
            )

            utility:SetData(
                splitCollectibles[2],
                "CosineCollectible",
                false
            )

            utility:SetData(
                splitCollectibles[1],
                "CosineCollectibleTwin",
                splitCollectibles[2]
            )

            utility:SetData(
                splitCollectibles[2],
                "CosineCollectibleTwin",
                splitCollectibles[1]
            )

        end, SCHEDULE_FRAMES)
    end
    return true
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_USE_ITEM,
    PrismaticSpinupDice.UseItem,
    enums.Collectibles.PRISMATIC_SPINUP_DICE
)

---@param pickup EntityPickup
---@param collider Entity
function PrismaticSpinupDice:PrePickupCollision(pickup, collider)
    local player = collider:ToPlayer()

    if not collider then
        return
    end

    if utility:GetData(pickup, "CosineCollectibleEffects") then
        return
    end

    if utility:GetData(pickup, "CosineCollectible") == false then
        local correctPickup = utility:GetData(pickup, "CosineCollectibleTwin")

        if not correctPickup then
            return
        end

        for _, currentPickup in pairs({pickup, correctPickup}) do
            currentPickup:Remove()
            TSIL.EntitySpecific.SpawnEffect(
                EffectVariant.POOF01,
                0,
                currentPickup.Position,
                Vector.Zero,
                pickup
            )
        end

        player:AnimateSad()
        return true

    elseif utility:GetData(pickup, "CosineCollectible") == true then
        local decoyPickup = utility:GetData(pickup, "CosineCollectibleTwin")

        if not decoyPickup then
            return
        end

        decoyPickup:Remove()
        TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.POOF01,
            0,
            decoyPickup.Position,
            Vector.Zero,
            pickup
        )
    end

    utility:SetData(pickup, "CosineCollectibleEffects", true)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_PICKUP_COLLISION,
    PrismaticSpinupDice.PrePickupCollision
)

function PrismaticSpinupDice:PostNewRoom()
    RemoveAllCosineDiceCollectibles()
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    PrismaticSpinupDice.PostNewRoom
)

function PrismaticSpinupDice:PreGameExit()
    RemoveAllCosineDiceCollectibles()
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_PRE_GAME_EXIT,
    PrismaticSpinupDice.PreGameExit
)