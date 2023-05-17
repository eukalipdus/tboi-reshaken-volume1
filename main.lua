MilkshakeVol1 = RegisterMod("Milkshake!", 1)

require("loi_milkshake.TSIL").Init("loi_milkshake")

include("milkshake_scripts.enums")
include("milkshake_scripts.utility")

include("milkshake_scripts.bumAPI.core")

local eid = include("milkshake_scripts.modcompatibility.eid")
eid:addEid()

--Mod compatibility
include("milkshake_scripts.modcompatibility.modCompat")
include("milkshake_scripts.modcompatibility.epiphany")
include("milkshake_scripts.modcompatibility.fiendFolio")

-- Collectibles
include("milkshake_scripts.items.collectibles.passive.blackeye")
include("milkshake_scripts.items.collectibles.familiars.spiritbum")
include("milkshake_scripts.items.collectibles.active.dicedice")
include("milkshake_scripts.items.collectibles.active.emptyslot")
include("milkshake_scripts.items.collectibles.familiars.fingore")
include("milkshake_scripts.items.collectibles.passive.firecrackerrose")
include("milkshake_scripts.items.collectibles.familiars.fragilemirror")
include("milkshake_scripts.items.collectibles.passive.glassheart")
include("milkshake_scripts.items.collectibles.active.globininabucket")
include("milkshake_scripts.items.collectibles.active.goldenshovel")
include("milkshake_scripts.items.collectibles.familiars.innerreflection")
include("milkshake_scripts.items.collectibles.passive.lachancla")
include("milkshake_scripts.items.collectibles.passive.lyra")
include("milkshake_scripts.items.collectibles.passive.milkshake")
include("milkshake_scripts.items.collectibles.passive.potofgold")
include("milkshake_scripts.items.collectibles.active.prismaticDice")
include("milkshake_scripts.items.collectibles.familiars.sharpcursor")
include("milkshake_scripts.items.collectibles.active.shatteredorb")
include("milkshake_scripts.items.collectibles.passive.sicklecell")
include("milkshake_scripts.items.collectibles.active.leviticus")
include("milkshake_scripts.items.collectibles.passive.balancedbreakfast")
include("milkshake_scripts.items.collectibles.passive.heartybreakfast")
include("milkshake_scripts.items.collectibles.passive.spoiledbreakfast")
include("milkshake_scripts.items.collectibles.passive.batteryacid")
include("milkshake_scripts.items.collectibles.passive.dadsmitt")
include("milkshake_scripts.items.collectibles.familiars.doggybag")

-- Trinkets
include("milkshake_scripts.items.trinkets.amethystshard")
include("milkshake_scripts.items.trinkets.rubyshard")
include("milkshake_scripts.items.trinkets.sapphireshard")
include("milkshake_scripts.items.trinkets.emeraldshard")
include("milkshake_scripts.items.trinkets.tungstencube")
include("milkshake_scripts.items.trinkets.acidpenny")
include("milkshake_scripts.items.trinkets.crystalpenny")
include("milkshake_scripts.items.trinkets.rockwheel")

--Pick ups
include("milkshake_scripts.items.pick ups.psychicorb")
include("milkshake_scripts.items.pick ups.chaosorb")
include("milkshake_scripts.items.pick ups.natureorb")
include("milkshake_scripts.items.pick ups.fruitheart")
include("milkshake_scripts.items.pick ups.fireorb")
include("milkshake_scripts.items.pick ups.electricorb")
include("milkshake_scripts.items.pick ups.spiritorbs")
include("milkshake_scripts.items.pick ups.tatteredpage")
include("milkshake_scripts.items.pick ups.specialpennies")


--Slots
include("milkshake_scripts.slots.spiritklinbrenda")