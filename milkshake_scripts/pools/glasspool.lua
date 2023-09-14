local GlassItemPool = {}

MilkshakeVol1.enums.ItemPools.GLASS = TSIL.CustomItemPools.RegisterCustomItemPool({
    { Collectible = CollectibleType.COLLECTIBLE_MY_REFLECTION,         Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_HOURGLASS,             Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_CHOCOLATE_MILK,        Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_HOLY_WATER,            Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_20_20,                 Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_THE_JAR,               Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_CRYSTAL_BALL,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_LOST_CONTACT,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_CURSED_EYE,            Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID,     Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_ISAACS_TEARS,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_GLASS_CANNON,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_SCATTER_BOMBS,         Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_NIGHT_LIGHT,           Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_JAR_OF_FLIES,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_MILK,                  Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_SHARD_OF_GLASS,        Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_ANGELIC_PRISM,         Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_FREE_LEMONADE,         Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR,       Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_CRACKED_ORB,           Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_JAR_OF_WISPS,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_ESAU_JR,               Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_EVERYTHING_JAR,        Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_GLASS_EYE,             Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_CHEMICAL_PEEL,         Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_STOP_WATCH,            Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_BROKEN_WATCH,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_POKE_GO,               Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_MAGIC_8_BALL,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_TECHNOLOGY,            Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_TECH_X,                Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,       Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_MOMS_PERFUME,          Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_HOLY_MANTLE,           Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_COMPASS,               Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_EVIL_CHARM,            Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = CollectibleType.COLLECTIBLE_SPRINKLER,             Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = MilkshakeVol1.enums.Collectibles.MILKSHAKE,        Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = MilkshakeVol1.enums.Collectibles.FRAGILE_MIRROR,   Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = MilkshakeVol1.enums.Collectibles.PRISMATIC_DICE,   Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
    { Collectible = MilkshakeVol1.enums.Collectibles.INNER_REFLECTION, Weight = 1, DecreaseBy = 1, RemoveOn = 0.1 },
})
---@type table<CollectibleType, fun():boolean>
local IsUnlockedPerItem = {}


---Adds items to the Glass Item Pool.
---@param items {Collectible: CollectibleType, Weight: number, DecreaseBy: number, RemoveOn: number, IsUnlocked: nil|fun(): boolean}[]
function MilkshakeVol1.API:AddItemsToGlassPool(items)
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
