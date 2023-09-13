local GlassItemPool = {}

MilkshakeVol1.enums.ItemPools.GLASS = TSIL.CustomItemPools.RegisterCustomItemPool({
    {Collectible = CollectibleType.COLLECTIBLE_TECH_X, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1},
    {Collectible = CollectibleType.COLLECTIBLE_GROWTH_HORMONES, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1},
    {Collectible = CollectibleType.COLLECTIBLE_GLASS_CANNON, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1},
    {Collectible = CollectibleType.COLLECTIBLE_GLASS_EYE, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1},
    {Collectible = MilkshakeVol1.enums.Collectibles.FRAGILE_MIRROR, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1},
    {Collectible = MilkshakeVol1.enums.Collectibles.INNER_REFLECTION, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1},
})
---@type table<CollectibleType, fun():boolean>
local IsUnlockedPerItem = {}


---@param items {Collectible: CollectibleType, Weight: number, DecreaseBy: number, RemoveOn: number, IsUnlocked: nil|fun(): boolean}[]
function MilkshakeVol1.API.AddItemsToGlassPool(items)
    for _, item in ipairs(items) do
        TSIL.CustomItemPools.AddCollectibleToRegisteredPool(
            MilkshakeVol1.enums.ItemPools.GLASS,
            {
                Collectible = item.Collectible,
                Weight = item.Weight,
                DecreaseBy = item.DecreaseBy,
                RemoveOn = item.RemoveOn
            }
        )
        IsUnlockedPerItem[item.Collectible] = item.IsUnlocked
    end
end


---@param collectible CollectibleType
local function DefaultIsUnlocked(collectible)
    local itemConfig = Isaac.GetItemConfig()
    local itemInfo = itemConfig:GetCollectible(collectible)

    return itemInfo:IsAvailable()
end


function GlassItemPool:OnGameStart(isContinue)
    if isContinue then return end

    local items = TSIL.CustomItemPools.GetCollectibleEntriesInItemPool(MilkshakeVol1.enums.ItemPools.GLASS)
    for _, item in ipairs(items) do
        local isUnlocked = IsUnlockedPerItem[item.Collectible]
        if not DefaultIsUnlocked(item.Collectible) or (isUnlocked and not isUnlocked()) then
            TSIL.CustomItemPools.RemoveCollectible(
                MilkshakeVol1.enums.ItemPools.GLASS,
                item.Collectible
            )
        end
    end
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_GAME_STARTED,
    GlassItemPool.OnGameStart
)