local enums = {}

enums.Collectibles = {
    GLOBIN_IN_A_BUCKET = Isaac.GetItemIdByName("Globin In A Bucket"),
    BLACK_EYE = Isaac.GetItemIdByName("Black Eye"),
    GOLDEN_SHOVEL = Isaac.GetItemIdByName("Golden Shovel"),
    DICE_DICE = Isaac.GetItemIdByName("Dice Dice"),
    MILKSHAKE = Isaac.GetItemIdByName("Milkshake!"),
    FIRECRACKER_ROSE = Isaac.GetItemIdByName("Firecracker Rose")
}

enums.Trinkets = {
    AMETHYST_SHARD = Isaac.GetTrinketIdByName("Amethyst Shard"),
    RUBY_SHARD = Isaac.GetTrinketIdByName("Ruby Shard"),
    SAPPHIRE_SHARD = Isaac.GetTrinketIdByName("Sapphire Shard"),
    EMERALD_SHARD = Isaac.GetTrinketIdByName("Emerald Shard")
}

enums.Cards = {
    AMETHYST_ORB = Isaac.GetCardIdByName("Spirit Of Arcana"),
    RUBY_ORB = Isaac.GetCardIdByName("Spirit Of Perception"),
    EMERALD_ORB = Isaac.GetCardIdByName("Spirit Of Foresight"),
    SAPPHIRE_ORB = Isaac.GetCardIdByName("Spirit Of Wisdom")
}

return enums
