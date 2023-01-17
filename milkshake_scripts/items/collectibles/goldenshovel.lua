local goldenShovel = {}
local enums = require("milkshake_scripts.enums")

local goldenShovelData = {

    PICKUP_VELOCITY = Vector(2,2),
    PIT_STEP = 20

}

local function concat(seq1, seq2)
    for _, elem in ipairs(seq2) do
      table.insert(seq1, elem)
    end
    return seq1
  end
  local game = Game()
  local sfx = SFXManager()
  local shovel_effect_radius = 65
  local GridPoopVariantGold = 3
  local GridPoopVariantRed = 1

local function car_bat_mul(player)
  if player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY) then
    return 2.0
  end
      return 1
    end



 local function spawn_gold_effects(player, radius)
    local position = player.Position
    local crater = game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_CRATER, position, Vector.Zero, player, 0, player.InitSeed)
    local gold_color = Color(0.9, 0.8, 0, 1, 0.8, 0.7, 0)
    local crater_sprite = crater:GetSprite()
    local particle_speed = (4 * car_bat_mul(player))
    crater:SetColor(gold_color, 150, 1, false, false)
    crater_sprite.Scale = (Vector.One * car_bat_mul(player) * 1.5)
    sfx:Play(SoundEffect.SOUND_ULTRA_GREED_COIN_DESTROY)
    game:SpawnParticles(position, EffectVariant.COIN_PARTICLE, 20, particle_speed)
    return game:SpawnParticles(position, EffectVariant.GOLD_PARTICLE, 40, particle_speed)
  end

local function transmute_grid(player)
    local get = GridEntityType
    local room = game:GetRoom()
    local p = room:GetGridIndex(player.Position)
    local width = room:GetGridWidth()
    local north = ( - width)
    local south = width
    local east = -1
    local west = 1
    local grid_positions = {(west + west + p), (west + p), p, (east + p), (east + east + p), (north + west + p), (north + p), (north + east + p), (south + west + p), (south + p), (south + east + p)}
    local extra_horn_positions
      extra_horn_positions = {}
    local all_positions = concat(grid_positions, extra_horn_positions)
    for _, idx in ipairs(all_positions) do
      local entity = room:GetGridEntity(idx)
      local function spawn(type, variant)
        entity:Destroy(true)
        return room:SpawnGridEntity(idx, type, variant, player.InitSeed, entity.VarData)
      end
      if (entity and (entity:GetType() == get.GRID_ROCK)) then
        spawn(get.GRID_ROCK_GOLD, 0)
      elseif (entity and (entity:GetType() == get.GRID_POOP)) then
        entity:SetVariant(GridPoopVariantRed)
        spawn(get.GRID_POOP, GridPoopVariantGold)
      end
    end
    return nil
  end


local function transmute(player, entity)
    local transform
    local function _9_(from, _7_)
      local _arg_8_ = _7_
      local subtype = _arg_8_["s"]
      local type = _arg_8_["t"]
      local variant = _arg_8_["v"]
      local _local_10_ = from
      local InitSeed = _local_10_["InitSeed"]
      local Position = _local_10_["Position"]
      local SpawnerEntity = _local_10_["SpawnerEntity"]
      local Velocity = _local_10_["Velocity"]
      local pickup = from:ToPickup()
      from:Remove()
      if pickup then
        pickup:Morph(type, variant, subtype, true, true, true)
      else
        game:Spawn(type, variant, Position, Velocity, SpawnerEntity, subtype, InitSeed)
      end
      return game:SpawnParticles(Position, EffectVariant.POOF01, 1, 0)
    end
    transform = _9_
    local _let_12_ = entity
    local s = _let_12_["SubType"]
    local t = _let_12_["Type"]
    local v = _let_12_["Variant"]
    local pkup = EntityType.ENTITY_PICKUP
    local bmb = EntityType.ENTITY_BOMBDROP
    local pv = PickupVariant
    local ct = CollectibleType
    local col = pv.PICKUP_COLLECTIBLE
    local bv = BombVariant
    local fam = EntityType.ENTITY_FAMILIAR
    local dip = FamiliarVariant.DIP
    local clot = FamiliarVariant.BLOOD_BABY
    local target
    if ((t == pkup) and (v == pv.PICKUP_HEART)) then
      target = {s = HeartSubType.HEART_GOLDEN, t = t, v = v}
    elseif ((t == pkup) and (v == pv.PICKUP_COIN)) then
      target = {s = CoinSubType.COIN_GOLDEN, t = t, v = v}
    elseif ((t == pkup) and (v == pv.PICKUP_KEY)) then
      target = {s = KeySubType.KEY_GOLDEN, t = t, v = v}
    elseif ((t == pkup) and (v == pv.PICKUP_BOMB)) then
      target = {s = BombSubType.BOMB_GOLDEN, t = t, v = v}
    elseif ((t == pkup) and (v == pv.PICKUP_PILL)) then
      target = {s = PillColor.PILL_GOLD, t = t, v = v}
    elseif ((t == pkup) and (v == pv.PICKUP_LIL_BATTERY)) then
      target = {s = BatterySubType.BATTERY_GOLDEN, t = t, v = v}
    elseif ((t == pkup) and (v == pv.PICKUP_TRINKET)) then
      target = {s = (entity.SubType | TrinketType.TRINKET_GOLDEN_FLAG), t = t, v = v}
    elseif ((t == pkup) and (v == pv.PICKUP_CHEST)) then
      target = {s = s, t = t, v = PickupVariant.PICKUP_LOCKEDCHEST}
    elseif ((t == pkup) and (v == pv.PICKUP_BOMBCHEST)) then
      target = {s = s, t = t, v = PickupVariant.PICKUP_LOCKEDCHEST}
    elseif ((t == pkup) and (v == pv.PICKUP_WOODENCHEST)) then
      target = {s = s, t = t, v = PickupVariant.PICKUP_LOCKEDCHEST}
    elseif ((t == pkup) and (v == pv.PICKUP_REDCHEST)) then
      target = {s = s, t = t, v = PickupVariant.PICKUP_LOCKEDCHEST}
    elseif ((t == pkup) and (v == col) and (s == ct.COLLECTIBLE_RAZOR_BLADE)) then
      target = {s = ct.COLLECTIBLE_GOLDEN_RAZOR, t = t, v = v}
    elseif ((t == pkup) and (v == col) and (s == ct.COLLECTIBLE_TELEPORT)) then
      target = {s = ct.COLLECTIBLE_TELEPORT_2, t = t, v = v}
    elseif ((t == pkup) and (v == col) and (s == ct.COLLECTIBLE_THERES_OPTIONS)) then
      target = {s = ct.COLLECTIBLE_MORE_OPTIONS, t = t, v = v}
    elseif ((t == pkup) and (v == col) and (s == ct.COLLECTIBLE_OPTIONS)) then
      target = {s = ct.COLLECTIBLE_MORE_OPTIONS, t = t, v = v}
    elseif ((t == pkup) and (v == col) and (s == ct.COLLECTIBLE_COUPON)) then
      target = {s = ct.COLLECTIBLE_MEMBER_CARD, t = t, v = v}
    elseif ((t == pkup) and (v == col) and (s == ct.COLLECTIBLE_IRON_BAR)) then
      target = {s = ct.COLLECTIBLE_MIDAS_TOUCH, t = t, v = v}
    elseif ((t == bmb) and (v == bv.BOMB_TROLL)) then
      target = {s = s, t = t, v = bv.BOMB_GOLDENTROLL}
    elseif ((t == bmb) and (v == bv.BOMB_SUPERTROLL)) then
      target = {s = s, t = t, v = bv.BOMB_GOLDENTROLL}
    elseif ((t == fam) and (v == dip)) then
      target = {s = 3, t = t, v = v}
    elseif ((t == fam) and (v == clot)) then
      target = {s = 4, t = t, v = v}
    elseif entity:IsActiveEnemy() then
      target = entity:AddMidasFreeze(EntityRef(player), (240 * car_bat_mul(player)), nil)
    else
    target = nil
    end
    if target then
      return transform(entity, target)
    end
  end

  function goldenShovel:onUse(collectible, rng, player)
    if not player then return end
  --  Game():GetRoom():TurnGold()
    local pit = Isaac.Spawn(1000, 146,1,player.Position, Vector.Zero, nil) -- Maybe get rid of this when re-entering the room?
	pit:ToEffect():SetTimeout(1000)
	pit:GetSprite().Color = Color(0.7, 0.6, 0, 1, 0, 0, 0)

    local effect_radius = (shovel_effect_radius * car_bat_mul(player))
    spawn_gold_effects(player, effect_radius)
    transmute_grid(player)
    local affected_entities = Isaac.FindInRadius(player.Position, effect_radius)
    for _0, entity in pairs(affected_entities) do
      transmute(player, entity)
    end
    return {
      Discharge = true,
      Remove = false,
      ShowAnim = true
    }
    end



milkshakeMod:AddCallback(ModCallbacks.MC_USE_ITEM, goldenShovel.onUse, enums.Collectibles.GOLDEN_SHOVEL)

return goldenShovel