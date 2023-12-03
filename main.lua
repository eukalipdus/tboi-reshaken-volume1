MilkshakeVol1 = RegisterMod("Milkshake!", 1)

require("loi_milkshake.TSIL").Init("loi_milkshake")

include("milkshake_scripts.enums")
include("milkshake_scripts.utility")
MilkshakeVol1.API = {}

--include("milkshake_scripts.bumAPI.core")

--Mod compatibility
include("milkshake_scripts.modcompatibility.modCompat")
include("milkshake_scripts.modcompatibility.crabbyCretins")
include("milkshake_scripts.modcompatibility.eclipsed")
include("milkshake_scripts.modcompatibility.eid")
include("milkshake_scripts.modcompatibility.epiphany")
include("milkshake_scripts.modcompatibility.fiendFolio")
include("milkshake_scripts.modcompatibility.immortalHearts")
include("milkshake_scripts.modcompatibility.minimapi")
include("milkshake_scripts.modcompatibility.retribution")

-- Custom callbacks
include("milkshake_scripts.custom_callbacks.chest_opened")

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
include("milkshake_scripts.items.collectibles.familiars.lilbishop")
include("milkshake_scripts.items.collectibles.passive.witchdoctormask")
include("milkshake_scripts.items.collectibles.passive.rainbowfragment")
include("milkshake_scripts.items.collectibles.active.mirrorkey")

-- Trinkets
include("milkshake_scripts.items.trinkets.amethystshard")
include("milkshake_scripts.items.trinkets.rubyshard")
include("milkshake_scripts.items.trinkets.sapphireshard")
include("milkshake_scripts.items.trinkets.emeraldshard")
include("milkshake_scripts.items.trinkets.tungstencube")
include("milkshake_scripts.items.trinkets.acidpenny")
include("milkshake_scripts.items.trinkets.crystalpenny")
include("milkshake_scripts.items.trinkets.peridotshard")
include("milkshake_scripts.items.trinkets.garnetshard")
include("milkshake_scripts.items.trinkets.onyxshard")
include("milkshake_scripts.items.trinkets.diamondshard")
include("milkshake_scripts.items.trinkets.tourmalineshard")
include("milkshake_scripts.items.trinkets.ambershard")
include("milkshake_scripts.items.trinkets.rockwheel")

--Pick ups
include("milkshake_scripts.items.pick ups.cardspawner")
include("milkshake_scripts.items.pick ups.psychicorb")
include("milkshake_scripts.items.pick ups.chaosorb")
include("milkshake_scripts.items.pick ups.natureorb")
include("milkshake_scripts.items.pick ups.fruitheart")
include("milkshake_scripts.items.pick ups.holyorb")
include("milkshake_scripts.items.pick ups.fireorb")
include("milkshake_scripts.items.pick ups.electricorb")
include("milkshake_scripts.items.pick ups.spiritorbs")
include("milkshake_scripts.items.pick ups.tatteredpage")
include("milkshake_scripts.items.pick ups.specialpennies")
include("milkshake_scripts.items.pick ups.delugeOrb")
include("milkshake_scripts.items.pick ups.revenanceOrb")
include("milkshake_scripts.items.pick ups.toxicorb")
include("milkshake_scripts.items.pick ups.unholyorb")
include("milkshake_scripts.items.pick ups.rockorb")


--Pools
include("milkshake_scripts.pools.glasspool")

--Slots
include("milkshake_scripts.slots.spiritklinbrenda")


--Wisps
include("milkshake_scripts.wisps.brendaelectricwisp")
include("milkshake_scripts.wisps.brendafirewisp")
include("milkshake_scripts.wisps.brendaholywisp")
include("milkshake_scripts.wisps.brendanaturewisp")
include("milkshake_scripts.wisps.brendapoisonwisp")
include("milkshake_scripts.wisps.brendawaterwisp")
include("milkshake_scripts.wisps.globininabucket")
include("milkshake_scripts.wisps.goldenshovel")
include("milkshake_scripts.wisps.leviticus")
include("milkshake_scripts.wisps.prismaticdice")

--Locusts
include("milkshake_scripts.locusts.prismaticdice")
include("milkshake_scripts.locusts.celestialmirror")
include("milkshake_scripts.locusts.sicklecell")

--Enemies
include("milkshake_scripts.enemies.beerhead")
include("milkshake_scripts.enemies.flaskhead")
include("milkshake_scripts.enemies.glassheads")
include("milkshake_scripts.enemies.winehead")

--Misc
include("milkshake_scripts.shardrockoverlay")
include("milkshake_scripts.nonreplaceabletnt")


--- Shader crash fix
--- Credits to Cucco
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
    if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
        Isaac.ExecuteCommand("reloadshaders")
    end
end)