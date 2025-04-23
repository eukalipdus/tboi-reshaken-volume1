local ItemHider = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local ITEM_BEFORE_LEVITICUS = enums.Collectibles.LEVITICUS - 1

local spindownForbiddenItems = {
    enums.Collectibles.UNCHARGED_MIRROR_KEY,
    enums.Collectibles.SPECIAL_BRENDA_FIRE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_PSYCHIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_NATURE_WISP,
    enums.Collectibles.SPECIAL_BRENDA_ELECTRIC_WISP,
    enums.Collectibles.SPECIAL_BRENDA_WATER_WISP,
    enums.Collectibles.SPECIAL_BRENDA_POISON_WISP,
    enums.Collectibles.SPECIAL_BRENDA_HOLY_WISP,
    enums.Collectibles.SPECIAL_BRENDA_TERRA_WISP
}

local leviticusVariants = {
    enums.Collectibles.LEVITICUS,
    enums.Collectibles.LEVITICUS_ALADAR,
    enums.Collectibles.LEVITICUS_FANCY
}

local unlockableItems = {
    enums.Collectibles.PRISMATIC_GOGGLES
}

function ItemHider:UseItem()
    local preSpindowncollectibles = Isaac.FindByType(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE
    )

    for _, currentCollectible in pairs(preSpindowncollectibles) do
        utility:SetData(
            currentCollectible,
            "WillSpindown",
            true
        )

        if TSIL.Utils.Tables.IsIn(leviticusVariants, currentCollectible.SubType) then
            utility:SetData(
                currentCollectible,
                "ForceSpindown",
                ITEM_BEFORE_LEVITICUS
            )
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, ItemHider.UseItem, CollectibleType.COLLECTIBLE_SPINDOWN_DICE)

function ItemHider:PostPickupInit(pickup)
    if not utility:GetData(pickup, "WillSpindown") then
        return
    end

    utility:SetData(pickup, "WillSpindown", false)

    local isForbidden = TSIL.Utils.Tables.IsIn(spindownForbiddenItems, pickup.SubType)
    local isUnlockable = TSIL.Utils.Tables.IsIn(unlockableItems, pickup.SubType)
    local forcedItemId = utility:GetData(pickup, "ForceSpindown")

    utility:SetData(pickup, "ForceSpindown", nil)

    if not pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE
    or not (isForbidden or isUnlockable or forcedItemId) then
        return
    end

    local newCollectibleType = CollectibleType.COLLECTIBLE_SAD_ONION

    if forcedItemId then
        newCollectibleType = forcedItemId
    else
        newCollectibleType = pickup.SubType - 1
    end

    if isUnlockable then
        local achievementToCheck = MilkshakeVol1.UnlockManager:GetCollectibleAssociatedAchievement(pickup.SubType)

        if not achievementToCheck then
            return
        end

        if not MilkshakeVol1.UnlockManager:IsAchievementUnlocked(achievementToCheck) then
            newCollectibleType = newCollectibleType - 1
        end
    end

    pickup:Morph(
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        newCollectibleType
    )
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ItemHider.PostPickupInit)