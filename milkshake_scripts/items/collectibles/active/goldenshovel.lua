local goldenShovel = {}
local enums = MilkshakeVol1.enums

local goldenShovelData = {
    FREEZE_DURATION = 180,
    GOLD_PICKUP_CHANCE = 10,
    DOUBLE_CHEST_CHANCE = 50,
    PICKUP_VELOCITY = Vector(2,2),
    PIT_STEP = 20,
    PICKUP_STEP = 30,
    DOUBLE_CHEST_STEP = 10
}
local skipNextShovelUse = false

---@param position Vector
local function SpawnGoldEffects(position)
    local goldColor = Color(0.9, 0.8, 0, 1, 0.8, 0.7, 0)

    local crater = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.BOMB_CRATER,
        0,
        position
    )
    crater:SetColor(goldColor, 150, 1, false, false)
    local craterSprite = crater:GetSprite()
    craterSprite.Scale = (Vector.One * 1.5)

    SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
    SFXManager():Play(SoundEffect.SOUND_SHOVEL_DIG)

    local particle_speed = 4
    Game():SpawnParticles(position, EffectVariant.COIN_PARTICLE, 20, particle_speed)
    Game():SpawnParticles(position, EffectVariant.GOLD_PARTICLE, 40, particle_speed)
end


---@param position Vector
local function SpawnDirtPile(position)
    local pit = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.DIRT_PILE,
        1,
        position
    )
    pit:SetTimeout(1000)
    pit:GetSprite().Color = Color(0.7, 0.6, 0, 1, 0, 0, 0)
end


---@param rng RNG
---@param position Vector
local function SpawnGoldenPickup(rng, position)
    local room = Game():GetRoom()
    local spawnPos = room:FindFreePickupSpawnPosition(position, 1, true, false)
    local roll = TSIL.Random.GetRandomInt(0, 3, rng)

    local variant = PickupVariant.PICKUP_BOMB
    local subtype = BombSubType.BOMB_GOLDEN

    if roll == 1 then
        variant = PickupVariant.PICKUP_KEY
        subtype = KeySubType.KEY_GOLDEN
    elseif roll == 2 then
        variant = PickupVariant.PICKUP_HEART
        subtype = HeartSubType.HEART_GOLDEN
    elseif roll == 3 then
        variant = PickupVariant.PICKUP_COIN
        subtype = CoinSubType.COIN_GOLDEN
    end
    
    TSIL.EntitySpecific.SpawnPickup(
        variant,
        subtype,
        spawnPos,
        goldenShovelData.PICKUP_VELOCITY:Rotated(TSIL.Random.GetRandomInt(0, 360, rng))
    )
end


---@param rng RNG
---@param position Vector
local function SpawnGoldenChests(rng, position)
    local room = Game():GetRoom()
    local roll = TSIL.Random.GetRandomInt(0, 1, rng)

    for _ = 1, roll + 1, 1 do
        local spawnPos = room:FindFreePickupSpawnPosition(position, 1, true, false)

        TSIL.EntitySpecific.SpawnPickup(
            PickupVariant.PICKUP_LOCKEDCHEST,
            ChestSubType.CHEST_CLOSED,
            spawnPos
        )
    end
end


---@param position Vector
---@return boolean
local function TrySpawnSecretMemberShop(position)
    local room = Game():GetRoom()
    local gridEntity = room:GetGridEntityFromPos(position)

    if not gridEntity or gridEntity:GetType() ~= GridEntityType.GRID_DECORATION then return false end

    --Because we update the room, the Use Item callback will trigger again
    --We need to use a flag to keep track of this
    skipNextShovelUse = true
    TSIL.GridEntities.SpawnGridEntity(
        GridEntityType.GRID_STAIRS,
        TSIL.Enums.CrawlSpaceVariant.SECRET_SHOP,
        position,
        true
    )

    return true
end


---@param rng RNG
---@param player EntityPlayer
function goldenShovel:onUse(_, rng, player)
    if skipNextShovelUse then
        skipNextShovelUse = false
        return
    end

    if not player then return end

    SpawnGoldEffects(player.Position)

    if not TrySpawnSecretMemberShop(player.Position) then
        SpawnDirtPile(player.Position)
        SpawnGoldenPickup(rng, player.Position)
        SpawnGoldenChests(rng, player.Position)
    end

    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, goldenShovel.onUse, enums.Collectibles.GOLDEN_SHOVEL)


return goldenShovel