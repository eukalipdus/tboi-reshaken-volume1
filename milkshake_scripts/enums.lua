local enums = {}

enums.Collectibles = {
    GLOBIN_IN_A_BUCKET = Isaac.GetItemIdByName("Globin In A Bucket"),
    BLACK_EYE = Isaac.GetItemIdByName("Black Eye"),
    GOLDEN_SHOVEL = Isaac.GetItemIdByName("Golden Shovel"),
    DICE_DICE = Isaac.GetItemIdByName("Dice Dice"),
    MILKSHAKE = Isaac.GetItemIdByName("Milkshake!"),
    FIRECRACKER_ROSE = Isaac.GetItemIdByName("Firecracker Rose"),
    SHARP_CURSOR = Isaac.GetItemIdByName("Sharp Cursor"),
    LA_CHANCLA = Isaac.GetItemIdByName("La Chancla"),
    EMPTY_SLOT = Isaac.GetItemIdByName("Empty Slot")
}

enums.Trinkets = {
    AMETHYST_SHARD = Isaac.GetTrinketIdByName("Amethyst Shard"),
    RUBY_SHARD = Isaac.GetTrinketIdByName("Ruby Shard"),
    SAPPHIRE_SHARD = Isaac.GetTrinketIdByName("Sapphire Shard"),
    EMERALD_SHARD = Isaac.GetTrinketIdByName("Emerald Shard"),
    TUNGSTEN_CUBE = Isaac.GetTrinketIdByName("Tungsten Cube")
}

enums.Cards = {
    AMETHYST_ORB = Isaac.GetCardIdByName("Spirit Of Arcana"),
    RUBY_ORB = Isaac.GetCardIdByName("Spirit Of Perception"),
    EMERALD_ORB = Isaac.GetCardIdByName("Spirit Of Foresight"),
    SAPPHIRE_ORB = Isaac.GetCardIdByName("Spirit Of Wisdom"),
    TATTERED_PAGE = Isaac.GetCardIdByName("Tattered Page")
}

enums.Familiars = {
    SHARP_CURSOR = Isaac.GetEntityVariantByName("Sharp Cursor")
}

enums.Effects = {
    VINES = Isaac.GetEntityVariantByName("Vine")
}

enums.Sounds = {
    CLICK = Isaac.GetSoundIdByName("sharp cursor click")
}

return enums
