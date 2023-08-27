local BrendaElectricWisp = {}


---@param wisp EntityFamiliar
---@return EntityFamiliar?
local function GetNewConnectedWisp(wisp)
    local player = wisp.Player
    local playerIndex = TSIL.Players.GetPlayerIndex(player)
    local ptrHash = GetPtrHash(wisp)

    local wisps = TSIL.EntitySpecific.GetFamiliars(FamiliarVariant.WISP)
    local otherPlayerWisps = TSIL.Utils.Tables.Filter(wisps, function (_, otherWisp)
        local otherPlayer = otherWisp.Player
        local otherPlayerIndex = TSIL.Players.GetPlayerIndex(otherPlayer)
        local otherPtrHash = GetPtrHash(otherWisp)

        return otherPlayerIndex == playerIndex and otherPtrHash ~= ptrHash
    end)

    if #otherPlayerWisps == 0 then
        return
    end

    table.sort(otherPlayerWisps, function (a, b)
        local aPtr = GetPtrHash(a)
        local bPtr = GetPtrHash(b)

        return aPtr < bPtr
    end)

    local rng = TSIL.RNG.NewRNG(wisp.InitSeed)
    return TSIL.Random.GetRandomElementsFromTable(otherPlayerWisps, 1, rng)[1]
end


---@param connectedWisp EntityFamiliar?
local function ShouldGetNewWisp(connectedWisp)
    if not connectedWisp then return true end

    return not connectedWisp:Exists()
end


---@param wisp EntityFamiliar
---@return EntityFamiliar?
local function GetConnectedWisp(wisp)
    ---@type EntityFamiliar?
    local connectedWisp = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        wisp,
        "ConnectedWisp"
    )

    if ShouldGetNewWisp(connectedWisp) then
        connectedWisp = GetNewConnectedWisp(wisp)
        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            wisp,
            "ConnectedWisp",
            connectedWisp
        )
    end

    return connectedWisp
end


---@param wisp EntityFamiliar
---@return EntityLaser
local function GetElectricLaser(wisp)
    ---@type EntityLaser?
    local electricLaser = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        wisp,
        "ElectricLaser"
    )

    if not electricLaser or not electricLaser:Exists() then
        electricLaser = TSIL.EntitySpecific.SpawnLaser(
            LaserVariant.ELECTRIC,
            0,
            wisp.Position,
            Vector.Zero,
            wisp
        )
        TSIL.Entities.SetEntityData(
            MilkshakeVol1,
            wisp,
            "ElectricLaser",
            electricLaser
        )
    end

    return electricLaser
end


---@param wisp EntityFamiliar
---@return Vector
local function GetFixedWispPos(wisp)
    return Vector(wisp.Position.X, wisp.Position.Y - 15)
end


---@param wisp EntityFamiliar
---@param connectedWisp EntityFamiliar
local function ConnectWisps(wisp, connectedWisp)
    local laser = GetElectricLaser(wisp)

    laser.Parent = wisp

    local startPoint = GetFixedWispPos(wisp)
    local endPoint = GetFixedWispPos(connectedWisp)

    laser.ParentOffset = Vector(0, startPoint.Y - wisp.Position.Y)
    laser.MaxDistance = startPoint:Distance(endPoint)
    laser.Angle = (endPoint - startPoint):GetAngleDegrees()
end


---@param wisp EntityFamiliar
local function RemoveElectricLaser(wisp)
    ---@type EntityLaser?
    local electricLaser = TSIL.Entities.GetEntityData(
        MilkshakeVol1,
        wisp,
        "ElectricLaser"
    )

    if electricLaser then
        electricLaser:Remove()
    end
end


---@param wisp EntityFamiliar
function BrendaElectricWisp:OnWispUpdate(wisp)
    if wisp.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_ELECTRIC_WISP then return end

    local connectedWisp = GetConnectedWisp(wisp)
    if not connectedWisp then
        RemoveElectricLaser(wisp)
        return
    end

    ConnectWisps(wisp, connectedWisp)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_FAMILIAR_UPDATE,
    BrendaElectricWisp.OnWispUpdate,
    FamiliarVariant.WISP
)


---@param entity Entity
function BrendaElectricWisp:OnEntityRemove(entity)
    local familiar = entity:ToFamiliar()
    if familiar.Variant ~= FamiliarVariant.WISP then return end
    if familiar.SubType ~= MilkshakeVol1.enums.Collectibles.SPECIAL_BRENDA_ELECTRIC_WISP then return end

    RemoveElectricLaser(familiar)
end
MilkshakeVol1:AddCallback(
    ModCallbacks.MC_POST_ENTITY_REMOVE,
    BrendaElectricWisp.OnEntityRemove,
    EntityType.ENTITY_FAMILIAR
)