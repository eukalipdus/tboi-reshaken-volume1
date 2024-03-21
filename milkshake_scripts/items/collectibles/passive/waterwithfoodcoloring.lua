local waterWithFoodColoring = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local cursesToAdd = {
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN,
    LevelCurse.CURSE_OF_MAZE,
    LevelCurse.CURSE_OF_BLIND
}

local UPDATE_CHANCE = 35
local MIN_MULTI = 0.5
local MAX_MULTI = 0.9
local PINK_TEAR_COLOR = Color(1, 1, 1, 1, 0.196, 0, 0)
PINK_TEAR_COLOR:SetColorize(1, 0, 1, .05)

local function AddAllCurses()
    if not TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.WATER_WITH_FOOD_COLORING) then return end
    for _, curse in pairs(cursesToAdd) do
        Game():GetLevel():AddCurse(curse, false)
    end
end

function waterWithFoodColoring:PostNpcInit(npc)
    if not TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.WATER_WITH_FOOD_COLORING) then return end
    npc:MakeChampion(npc.InitSeed, -1, true)
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NPC_INIT, waterWithFoodColoring.PostNpcInit)

function waterWithFoodColoring:PostNewLevel()
    AddAllCurses()
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, waterWithFoodColoring.PostNewLevel)

function waterWithFoodColoring:PostPlayerCollectibleAdded(player, collectible, firstTime)
    if collectible ~= enums.Collectibles.WATER_WITH_FOOD_COLORING
    or ((firstTime == false) and #(TSIL.Players.GetPlayersOfType(PlayerType.PLAYER_ISAAC_B)) > 0)
    or player.Variant == 1 then return end
    AddAllCurses()
end
MilkshakeVol1:AddCallback(TSIL.Enums.CustomCallback.POST_PLAYER_COLLECTIBLE_ADDED, waterWithFoodColoring.PostPlayerCollectibleAdded)

local antiRecursion
function waterWithFoodColoring:EntityTakeDmg(entity, amount, flags, source, countdown)
    local player = entity:ToPlayer()
    if player:HasCollectible(enums.Collectibles.WATER_WITH_FOOD_COLORING) then
        if antiRecursion then
            antiRecursion = false
        else
            antiRecursion = true
            player:TakeDamage(amount * 2, flags, source, countdown)
            return false
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, waterWithFoodColoring.EntityTakeDmg, EntityType.ENTITY_PLAYER)

function waterWithFoodColoring:EvaluateCache(player, cacheFlag)
    if not player:HasCollectible(enums.Collectibles.WATER_WITH_FOOD_COLORING) then return end

    local rng = TSIL.RNG.CopyRNG(player:GetCollectibleRNG(enums.Collectibles.WATER_WITH_FOOD_COLORING))
    local itemNum = player:GetCollectibleNum(enums.Collectibles.WATER_WITH_FOOD_COLORING)

    local speed = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local tears = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local dmg = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local range = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local shotspeed = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)
    local luck = MilkshakeVol1.API:GetStatMultiplier(rng, itemNum, MIN_MULTI, MAX_MULTI)

    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = ((player.MaxFireDelay + 1) / tears) - 1
    end

    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * dmg
    end

    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * speed
    end

    if cacheFlag == CacheFlag.CACHE_LUCK and player.Luck > 0 then
        player.Luck = player.Luck * luck
    end

    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearRange = player.TearRange * range
    end

    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed * shotspeed
    end

    if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
        player.TearColor = PINK_TEAR_COLOR
    end
end
MilkshakeVol1:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE + 2000, waterWithFoodColoring.EvaluateCache)


function waterWithFoodColoring:PostUpdate()
    if not TSIL.Players.DoesAnyPlayerHasItem(enums.Collectibles.WATER_WITH_FOOD_COLORING) then return end
    --local rng = TSIL.RNG.NewRNG(TSIL.RNG.GetRandomSeed())
    if TSIL.Random.GetRandomInt(1, 100) >= UPDATE_CHANCE then
        Game():Update()
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_UPDATE, waterWithFoodColoring.PostUpdate)