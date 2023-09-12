local BrendaWaterWisp = {}

local LASER_DURATION = 30

---@param tear EntityTear
function BrendaWaterWisp:OnTearInit(tear)
    local spawner = tear.SpawnerEntity
    if not spawner then return end
    if spawner.Type ~= EntityType.ENTITY_FAMILIAR
    or spawner.Variant ~= FamiliarVariant.WISP
    or spawner.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_WATER_WISP then
        return
    end


    local wisp = spawner:ToFamiliar()
    local direction = TSIL.Direction.AngleToDirection(tear.Velocity:GetAngleDegrees())
    local shootAngle = TSIL.Direction.DirectionToDegrees(direction)

    local laser = EntityLaser.ShootAngle(
        LaserVariant.SHOOP,
        wisp.Position,
        shootAngle,
        LASER_DURATION,
        Vector(0, -18),
        wisp
    )
    laser:AddTearFlags(tear.TearFlags)
    laser.CollisionDamage = 2

    tear:Remove()

    laser:Update()
    laser.SpriteScale = Vector(0.65, 0.65)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_TEAR_INIT,
    BrendaWaterWisp.OnTearInit
)