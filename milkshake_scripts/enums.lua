local enums = {}

enums.Collectibles = {
    BLACK_EYE = Isaac.GetItemIdByName("Black Eye"),
    BOMB_BUM = Isaac.GetItemIdByName("Bomb Bum"),
    DICE_DICE = Isaac.GetItemIdByName("Dice Dice"),
    EMPTY_SLOT = Isaac.GetItemIdByName("Empty Slot"),
    FIRECRACKER_ROSE = Isaac.GetItemIdByName("Firecracker Rose"),
    GLASS_HEART = Isaac.GetItemIdByName("Glass Heart"),
    GLOBIN_IN_A_BUCKET = Isaac.GetItemIdByName("Globin In A Bucket"),
    GOLDEN_SHOVEL = Isaac.GetItemIdByName("Golden Shovel"),
    LA_CHANCLA = Isaac.GetItemIdByName("La Chancla"),
    MILKSHAKE = Isaac.GetItemIdByName("Milkshake!"),
    SHARP_CURSOR = Isaac.GetItemIdByName("Sharp Cursor"),
    SHATTERED_DICE = Isaac.GetItemIdByName("Shattered Dice"),
    SHATTERED_ORB = Isaac.GetItemIdByName("Shattered Orb"),
}

enums.Trinkets = {
    AMETHYST_SHARD = Isaac.GetTrinketIdByName("Amethyst Shard"),
    RUBY_SHARD = Isaac.GetTrinketIdByName("Ruby Shard"),
    SAPPHIRE_SHARD = Isaac.GetTrinketIdByName("Sapphire Shard"),
    EMERALD_SHARD = Isaac.GetTrinketIdByName("Emerald Shard"),
    TUNGSTEN_CUBE = Isaac.GetTrinketIdByName("Tungsten Cube"),
}

enums.Cards = {
    AMETHYST_ORB = Isaac.GetCardIdByName("Spirit Of Clairvoyance"),
    RANDOM_ORB = Isaac.GetCardIdByName("Spirit Of Chaos"),
    EMERALD_ORB = Isaac.GetCardIdByName("Spirit Of Druidity"),
    RUBY_ORB = Isaac.GetCardIdByName("Spirit Of Inferno"),
    SAPPHIRE_ORB = Isaac.GetCardIdByName("Spirit Of Conductivity"),
    TATTERED_PAGE = Isaac.GetCardIdByName("Tattered Page"),
}

enums.Familiars = {
    SHARP_CURSOR = Isaac.GetEntityVariantByName("Sharp Cursor"),
    BOMB_BUM = Isaac.GetEntityVariantByName("Bomb Bum Familiar"),
}

enums.Effects = {
    VINES = Isaac.GetEntityVariantByName("Vine"),
    SHATTERED_ORB = Isaac.GetEntityVariantByName("Shattered Orb"),
    CLAIRVOYANCE_AURA = Isaac.GetEntityVariantByName("Clairvoyance Aura"),
}

enums.Sounds = {
    CLICK = Isaac.GetSoundIdByName("sharp cursor click"),
}

enums.Costumes = {
    CLAIRVOYANCE_ORB = Isaac.GetCostumeIdByPath("gfx/characters/clairvoyance_orb.anm2"),
}

enums.Hearts = {
    FRUIT_HEART = 743,
}

return enums
