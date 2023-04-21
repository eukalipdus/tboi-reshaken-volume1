milkshakeMod = RegisterMod("Milkshake!", 1)

require("loi_milkshake.TSIL").Init("loi_milkshake")

milkshakeMod.enums = require("reshaken_scripts.enums")
milkshakeMod.utility = require("reshaken_scripts.utility")
require("reshaken_scripts.bumAPI.core")

local eid = require("reshaken_scripts.modcompatibility.eid")
eid:addEid()

-- Collectibles
require("reshaken_scripts.items.collectibles.passive.blackeye")
require("reshaken_scripts.items.collectibles.familiars.spiritbum")
require("reshaken_scripts.items.collectibles.active.dicedice")
require("reshaken_scripts.items.collectibles.active.emptyslot")
require("reshaken_scripts.items.collectibles.familiars.fingore")
require("reshaken_scripts.items.collectibles.passive.firecrackerrose")
require("reshaken_scripts.items.collectibles.familiars.fragilemirror")
require("reshaken_scripts.items.collectibles.passive.glassheart")
require("reshaken_scripts.items.collectibles.active.globininabucket")
require("reshaken_scripts.items.collectibles.active.goldenshovel")
require("reshaken_scripts.items.collectibles.familiars.innerreflection")
require("reshaken_scripts.items.collectibles.passive.lachancla")
require("reshaken_scripts.items.collectibles.passive.lyra")
require("reshaken_scripts.items.collectibles.passive.milkshake")
require("reshaken_scripts.items.collectibles.passive.potofgold")
require("reshaken_scripts.items.collectibles.active.prismaticDice")
require("reshaken_scripts.items.collectibles.familiars.sharpcursor")
require("reshaken_scripts.items.collectibles.active.shatteredorb")
require("reshaken_scripts.items.collectibles.passive.sicklecell")
require("reshaken_scripts.items.collectibles.active.leviticus")
require("reshaken_scripts.items.collectibles.passive.balancedbreakfast")
require("reshaken_scripts.items.collectibles.passive.heartybreakfast")
require("reshaken_scripts.items.collectibles.passive.spoiledbreakfast")
require("reshaken_scripts.items.collectibles.passive.batteryacid")

-- Trinkets
require("reshaken_scripts.items.trinkets.amethystshard")
require("reshaken_scripts.items.trinkets.rubyshard")
require("reshaken_scripts.items.trinkets.sapphireshard")
require("reshaken_scripts.items.trinkets.emeraldshard")
require("reshaken_scripts.items.trinkets.tungstencube")
require("reshaken_scripts.items.trinkets.acidpenny")
require("reshaken_scripts.items.trinkets.crystalpenny")
require("reshaken_scripts.items.trinkets.rockwheel")

--Pick ups
require("reshaken_scripts.items.pick ups.amethystorb")
require("reshaken_scripts.items.pick ups.chaosorb")
require("reshaken_scripts.items.pick ups.emeraldorb")
require("reshaken_scripts.items.pick ups.fruitheart")
require("reshaken_scripts.items.pick ups.rubyorb")
require("reshaken_scripts.items.pick ups.sapphireOrb")
require("reshaken_scripts.items.pick ups.spiritorbs")
require("reshaken_scripts.items.pick ups.tatteredpage")
require("reshaken_scripts.items.pick ups.specialpennies")


--Slots
require("reshaken_scripts.slots.spiritklinbrenda")