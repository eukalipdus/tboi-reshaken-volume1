local BrendaHolyWisp = {}


local HOLY_LIGHT_CHANCE = 0.05


---@param tear EntityTear
function BrendaHolyWisp:OnTearInit(tear)
    local spawner = tear.SpawnerEntity

    if not spawner then return end

    if spawner.Type ~= EntityType.ENTITY_FAMILIAR
    or spawner.Variant ~= FamiliarVariant.WISP
    or spawner.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_HOLY_WISP then
        return
    end

    if tear:HasTearFlags(TearFlags.TEAR_LIGHT_FROM_HEAVEN) then return end

    local rng = TSIL.RNG.NewRNG(tear.InitSeed)
    if rng:RandomFloat() >= HOLY_LIGHT_CHANCE then return end

    local newTear = TSIL.EntitySpecific.SpawnTear(
        tear.Variant,
        tear.SubType,
        tear.Position,
        tear.Velocity,
        tear.SpawnerEntity
    )

    newTear.Height = tear.Height
    newTear.FallingSpeed = tear.FallingSpeed
    newTear.FallingAcceleration = tear.FallingAcceleration
    newTear.CollisionDamage = tear.CollisionDamage
    newTear.Color = tear.Color
    newTear.Scale = tear.Scale
    newTear.TearFlags = tear.TearFlags

    newTear:ResetSpriteScale()
    newTear:AddTearFlags(TearFlags.TEAR_LIGHT_FROM_HEAVEN)
    newTear:Update()

    tear:Remove()
end
MilkshakeVol1:AddCallback(
    TSIL.Enums.CustomCallback.POST_TEAR_INIT_LATE,
    BrendaHolyWisp.OnTearInit
)