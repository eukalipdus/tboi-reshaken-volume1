local GlobinInABucketWisp = {}

local RESPAWN_CHANCE = 0.5

local SkipWisp = {}

---@param entity Entity
function GlobinInABucketWisp:OnFamiliarRemove(entity)
    if entity.Variant ~= FamiliarVariant.WISP then return end
    if entity.SubType ~= MilkshakeVol1.enums.Collectibles.GLOBIN_IN_A_BUCKET then return end

    local wisp = entity:ToFamiliar()
    if not wisp then return end

    if SkipWisp[wisp.InitSeed] then
        SkipWisp[wisp.InitSeed] = nil
        return
    end

    SkipWisp[wisp.InitSeed] = true

    local rng = TSIL.RNG.NewRNG(wisp.InitSeed)
    if rng:RandomFloat() >= RESPAWN_CHANCE then return end

    local player = wisp.Player

    TSIL.Utils.Functions.RunInFrames(
        function()
            player:AddWisp(
                MilkshakeVol1.enums.Collectibles.GLOBIN_IN_A_BUCKET,
                wisp.Position
            )
        end,
        1
    )
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    GlobinInABucketWisp.OnFamiliarRemove,
    EntityType.ENTITY_FAMILIAR
)
