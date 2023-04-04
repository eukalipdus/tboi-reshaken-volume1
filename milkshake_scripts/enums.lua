local enums = {}

enums.Collectibles = {
    BLACK_EYE = Isaac.GetItemIdByName("Black Eye"),
    SPIRIT_BUM = Isaac.GetItemIdByName("Spirit Bum"),
    DICE_DICE = Isaac.GetItemIdByName("Dice Dice"),
    EMPTY_SLOT = Isaac.GetItemIdByName("Empty Slot"),
    FINGORE = Isaac.GetItemIdByName("Scripulous Fingore"),
    FIRECRACKER_ROSE = Isaac.GetItemIdByName("Firecracker Flower"),
    GLASS_HEART = Isaac.GetItemIdByName("Glass Heart"),
    GLOBIN_IN_A_BUCKET = Isaac.GetItemIdByName("Globin In A Bucket"),
    GOLDEN_SHOVEL = Isaac.GetItemIdByName("Golden Shovel"),
	INNER_REFLECTION = Isaac.GetItemIdByName("Inner Reflection"),
    LA_CHANCLA = Isaac.GetItemIdByName("La Chancla"),
    MILKSHAKE = Isaac.GetItemIdByName("Milkshake!"),
    SHARP_CURSOR = Isaac.GetItemIdByName("Sharp Cursor"),
    PRISMATIC_DICE = Isaac.GetItemIdByName("Prismatic Dice"),
    SHATTERED_ORB = Isaac.GetItemIdByName("Shattered Orb"),
    LYRA = Isaac.GetItemIdByName("Lyra"),
    POT_OF_GOLD = Isaac.GetItemIdByName("Pot of Gold"),
    FRAGILE_MIRROR = Isaac.GetItemIdByName("Fragile Mirror"),
    SPOILED_BREAKFAST = Isaac.GetItemIdByName("Spoiled Breakfast"),
    BALANCED_BREAKFAST = Isaac.GetItemIdByName("Balanced Breakfast"),
    HEARTY_BREAKFAST = Isaac.GetItemIdByName("Hearty Breakfast"),
}

enums.Trinkets = {
    AMETHYST_SHARD = Isaac.GetTrinketIdByName("Amethyst Shard"),
    RUBY_SHARD = Isaac.GetTrinketIdByName("Ruby Shard"),
    SAPPHIRE_SHARD = Isaac.GetTrinketIdByName("Sapphire Shard"),
    EMERALD_SHARD = Isaac.GetTrinketIdByName("Emerald Shard"),
    TUNGSTEN_CUBE = Isaac.GetTrinketIdByName("Tungsten Cube"),
    ACID_PENNY = Isaac.GetTrinketIdByName("Acid Penny"),
    CRYSTAL_PENNY = Isaac.GetTrinketIdByName("Crystal Penny"),
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
    SPIRIT_BUM = Isaac.GetEntityVariantByName("Spirit Bum Familiar"),
    FINGORE = Isaac.GetEntityVariantByName("Scripulous Fingore"),
    SHARP_CURSOR = Isaac.GetEntityVariantByName("Sharp Cursor"),
    FRAGILE_MIRROR = Isaac.GetEntityVariantByName("Fragile Mirror"),
    INNER_REFLECTION = Isaac.GetEntityVariantByName("Inner Reflection"),
}

enums.Effects = {
    VINES = Isaac.GetEntityVariantByName("Vine"),
    SHATTERED_ORB = Isaac.GetEntityVariantByName("Shattered Orb"),
    CLAIRVOYANCE_AURA = Isaac.GetEntityVariantByName("Clairvoyance Aura"),
    REFLECTED_PROJECTILE_GLOW = Isaac.GetEntityVariantByName("Reflected Projectile Glow"),
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