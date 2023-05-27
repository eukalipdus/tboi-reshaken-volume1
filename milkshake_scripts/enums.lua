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
	INNER_REFLECTION = Isaac.GetItemIdByName("Celestial Mirror"),
    LA_CHANCLA = Isaac.GetItemIdByName("La Chancla"),
    MILKSHAKE = Isaac.GetItemIdByName("Milkshake!"),
    SHARP_CURSOR = Isaac.GetItemIdByName("Sharp Cursor"),
    PRISMATIC_DICE = Isaac.GetItemIdByName("Prismatic Dice"),
    SHATTERED_ORB = Isaac.GetItemIdByName("Shattered Orb"),
    LYRA = Isaac.GetItemIdByName("Lyra"),
    POT_OF_GOLD = Isaac.GetItemIdByName("Pot of Gold"),
    FRAGILE_MIRROR = Isaac.GetItemIdByName("Glass Idol"),
    SPOILED_BREAKFAST = Isaac.GetItemIdByName("Spoiled Breakfast"),
    BALANCED_BREAKFAST = Isaac.GetItemIdByName("Balanced Breakfast"),
    HEARTY_BREAKFAST = Isaac.GetItemIdByName("Hearty Breakfast"),
    LEVITICUS = Isaac.GetItemIdByName("Leviticus"),
    SICKLE_CELL = Isaac.GetItemIdByName("Sickle Cell"),
    BATTERY_ACID = Isaac.GetItemIdByName("Battery Acid"),
    DADS_MITT = Isaac.GetItemIdByName("Dad's Mitt"),
    DOGGY_BAG = Isaac.GetItemIdByName("Doggy Bag"),
    LIL_BISHOP = Isaac.GetItemIdByName("Lil Bishop"),
}

enums.Trinkets = {
    AMETHYST_SHARD = Isaac.GetTrinketIdByName("Amethyst Shard"),
    RUBY_SHARD = Isaac.GetTrinketIdByName("Ruby Shard"),
    TOURMALINE_SHARD = Isaac.GetTrinketIdByName("Tourmaline Shard"),
    EMERALD_SHARD = Isaac.GetTrinketIdByName("Emerald Shard"),
    TUNGSTEN_CUBE = Isaac.GetTrinketIdByName("Tungsten Cube"),
    ACID_PENNY = Isaac.GetTrinketIdByName("Acid Penny"),
    CRYSTAL_PENNY = Isaac.GetTrinketIdByName("Crystal Penny"),
    ROCK_WHEEL = Isaac.GetTrinketIdByName("Rock Wheel"),
    PERIDOT_SHARD = Isaac.GetTrinketIdByName("Peridot Shard"),
    GARNET_SHARD = Isaac.GetTrinketIdByName("Garnet Shard"),
    ONYX_SHARD = Isaac.GetTrinketIdByName("Onyx Shard"),
    DIAMOND_SHARD = Isaac.GetTrinketIdByName("Diamond Shard"),
    SAPPHIRE_SHARD = Isaac.GetTrinketIdByName("Sapphire Shard"),
}

enums.Cards = {
    TATTERED_PAGE = Isaac.GetCardIdByName("Tattered Page"),
}

enums.Familiars = {
    SPIRIT_BUM = Isaac.GetEntityVariantByName("Spirit Bum Familiar"),
    FINGORE = Isaac.GetEntityVariantByName("Scripulous Fingore"),
    SHARP_CURSOR = Isaac.GetEntityVariantByName("Sharp Cursor"),
    FRAGILE_MIRROR = Isaac.GetEntityVariantByName("Fragile Mirror"),
    INNER_REFLECTION = Isaac.GetEntityVariantByName("Inner Reflection"),
    DOGGY_BAG = Isaac.GetEntityVariantByName("Doggy Bag"),
    LIL_BISHOP = Isaac.GetEntityVariantByName("Lil Bishop"),
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

enums.Slots = {
    SPIRIT_KLIN_BRENDA = Isaac.GetEntityVariantByName("Spirit Klin Brenda")
}

enums.Coins = {
    ROTTEN_PENNY = 3405,
    FLAT_PENNY = 3406,
    BURNT_PENNY = 3407,
    BUTT_PENNY = 3408,
    CHARGED_PENNY = 3409,
    CURSED_PENNY = 3410,
    BLOODY_PENNY = 3411,
    BLESSED_PENNY = 3412,
    COUNTERFEIT_PENNY = 3413,
    ACID_PENNY = 3414,
    CRYSTAL_PENNY = 3415,
    SHARP_PENNY = 3416,
    EGG_PENNY = 3417,
    FUZZY_PENNY = 3418,
}

enums.Orbs = {
    FIRE = Isaac.GetCardIdByName("Spirit Of Inferno"),
    ELECTRIC = Isaac.GetCardIdByName("Spirit Of Conductivity"),
    NATURE = Isaac.GetCardIdByName("Spirit Of Druidity"),
    PSYCHIC = Isaac.GetCardIdByName("Spirit Of Clairvoyance"),
    RANDOM = Isaac.GetCardIdByName("Spirit Of Chaos"),
    HOLY = Isaac.GetCardIdByName("Spirit Of Salvation"),
    UNHOLY = Isaac.GetCardIdByName("Spirit Of Sacrilege"),
    POISON = Isaac.GetCardIdByName("Spirit Of Virulence"),
    UNDEAD = Isaac.GetCardIdByName("Spirit Of Revengance"),
    WATER = Isaac.GetCardIdByName("Spirit Of Deluge"),
}


---@enum MilkshakeCallbacks
enums.Callbacks = {
    --Called from the `MC_USE_CARD` callback whenever a spirit orb is used.
	--
	--Params:
	--
	-- * orb - Card
    -- * player - EntityPlayer
    -- * isLyra - boolean
	--
	--Optional args:
	--
	-- * orb - Card
    ON_ORB_USE = "MILKSHAKE_CB_ON_ORB_USE"
}

MilkshakeVol1.enums = enums