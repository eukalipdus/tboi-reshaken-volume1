local goldenShovel = {}
local enums = MilkshakeVol1.enums
local utility = MilkshakeVol1.utility

local MEGA_CHEST_ACHIEVEMENT_ID = 601
local CHEST_VELOCITY_MULTIPLIER = 15

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
---@param shouldBelialSynergy boolean
local function SpawnGoldEffects(position, shouldBelialSynergy)
    local goldColor = Color(0.9, 0.8, 0, 1, 0.8, 0.7, 0)
    local redColor = Color(0.1, 0, 0, 0.5, 0.1, 0, 0)
    local blackColor = Color(0.1, 0, 0, 0.2, 0.1, 0, 0)
    local particle_speed = 4

    local crater = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.BOMB_CRATER,
        0,
        position
    )
    local craterSprite = crater:GetSprite()
    craterSprite.Scale = (Vector.One * 1.5)

    SFXManager():Play(SoundEffect.SOUND_SHOVEL_DIG)

    if shouldBelialSynergy then
        local smallCrater = TSIL.EntitySpecific.SpawnEffect(
            EffectVariant.BOMB_CRATER,
            0,
            position
        )
        local smallCraterSprite = smallCrater:GetSprite()
        smallCraterSprite.Scale = (Vector.One * 0.6)

        crater:SetColor(blackColor, 150, 1, false, false)
        smallCrater:SetColor(redColor, 150, 1, false, false)
        SFXManager():Play(SoundEffect.SOUND_BLACK_POOF)
        Game():SpawnParticles(position, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 20, particle_speed)
    else
        crater:SetColor(goldColor, 150, 1, false, false)
        SFXManager():Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
        Game():SpawnParticles(position, EffectVariant.COIN_PARTICLE, 20, particle_speed)
        Game():SpawnParticles(position, EffectVariant.GOLD_PARTICLE, 40, particle_speed)
    end
end


---@param position Vector
---@param shouldBelialSynergy boolean
local function SpawnDirtPile(position, shouldBelialSynergy)
    local pit = TSIL.EntitySpecific.SpawnEffect(
        EffectVariant.DIRT_PILE,
        1,
        position
    )
    pit:SetTimeout(1000)
    if shouldBelialSynergy then
        pit:GetSprite().Color = Color(0.7, 0, 0.1, 1, 0, 0, 0)
    else
        pit:GetSprite().Color = Color(0.7, 0.6, 0, 1, 0, 0, 0)
    end
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

---@param player EntityPlayer
---@param position Vector
---@param shouldBelialSynergy boolean
local function SpawnChest(player, position, shouldBelialSynergy)
    local room = Game():GetRoom()
    local megaChestUnlocked = MilkshakeVol1.AchievementChecker:IsAchievementUnlocked(MEGA_CHEST_ACHIEVEMENT_ID)
    local spawnPos = room:FindFreePickupSpawnPosition(position, 1, true, false)

    if shouldBelialSynergy then
        for _ = 1, 3 do
            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_REDCHEST,
                ChestSubType.CHEST_CLOSED,
                spawnPos,
                RandomVector() * CHEST_VELOCITY_MULTIPLIER
            ):ToPickup()
            --chest:TryOpenChest()
        end

        TSIL.PickupSpecific.SpawnHeart(
            HeartSubType.HEART_BLACK,
            spawnPos,
            RandomVector()
        )
    else
        if megaChestUnlocked then
            TSIL.EntitySpecific.SpawnPickup(
                PickupVariant.PICKUP_MEGACHEST,
                0,
                spawnPos,
                RandomVector() * CHEST_VELOCITY_MULTIPLIER
            )
        else
            for _ = 1, 2 do
                TSIL.EntitySpecific.SpawnPickup(
                    PickupVariant.PICKUP_LOCKEDCHEST,
                    ChestSubType.CHEST_CLOSED,
                    spawnPos
                ):ToPickup()
                --chest:TryOpenChest()
            end
        end
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

    local shouldBelialSynergy = utility:IsJudasBirthright(player)
    SpawnGoldEffects(player.Position, shouldBelialSynergy)

    if not TrySpawnSecretMemberShop(player.Position) then
        SpawnDirtPile(player.Position, shouldBelialSynergy)
        SpawnChest(player, player.Position, shouldBelialSynergy)
    end

    return true
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, goldenShovel.onUse, enums.Collectibles.GOLDEN_SHOVEL)


return goldenShovel