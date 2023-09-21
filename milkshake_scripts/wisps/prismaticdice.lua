local prismaticDice = {}
local enums = MilkshakeVol1.enums

local wispPrisms = {}

function prismaticDice:PreUseItem(_, _, player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        local prism = TSIL.EntitySpecific.SpawnFamiliar(FamiliarVariant.ANGELIC_PRISM, 0, player.Position, Vector.Zero, player):ToFamiliar()
        local wisp = TSIL.EntitySpecific.SpawnFamiliar(FamiliarVariant.WISP,
                                                       enums.Collectibles.PRISMATIC_DICE,
                                                       prism.Position,
                                                       Vector.Zero,
                                                       player):ToFamiliar()
        table.insert(wispPrisms, {WispPtr = GetPtrHash(wisp), PrismPtr = GetPtrHash(prism)})
        wisp:RemoveFromOrbit()
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, prismaticDice.PreUseItem, enums.Collectibles.PRISMATIC_DICE)

function prismaticDice:FamiliarUpdate(familiar)
    if familiar.SubType ~= enums.Collectibles.PRISMATIC_DICE then return end
    local index
    for i, table in ipairs(wispPrisms) do
        if table.WispPtr == GetPtrHash(familiar) then
            index = i
        end
    end
    if not index then return end
    local prisms = TSIL.Entities.GetEntities(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ANGELIC_PRISM)
    for _, orbital in ipairs(prisms) do
        if GetPtrHash(orbital) == wispPrisms[index].PrismPtr then
            familiar.Position = orbital.Position
        end
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, prismaticDice.FamiliarUpdate)

function prismaticDice:PostNewRoom()
    local prisms = TSIL.Entities.GetEntities(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ANGELIC_PRISM)
    for _, currentPrism in ipairs(prisms) do
        for _, storedPrism in ipairs(wispPrisms) do
            print(GetPtrHash(currentPrism))
            print(storedPrism.PrismPtr)
            if GetPtrHash(currentPrism) == storedPrism.PrismPtr then
                currentPrism:Remove()
            end
        end
    end
    wispPrisms = {}
    --local player = wispPrisms[0].Player
    local wisps = TSIL.Entities.GetEntities(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, enums.Collectibles.PRISMATIC_DICE)
    for _, currentWisp in ipairs(wisps) do
        local prism = TSIL.EntitySpecific.SpawnFamiliar(FamiliarVariant.ANGELIC_PRISM, 0, currentWisp.Position, Vector.Zero, currentWisp):ToFamiliar()
        table.insert(wispPrisms, {WispPtr = GetPtrHash(currentWisp), PrismPtr = GetPtrHash(prism)})
    end
end
MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, prismaticDice.PostNewRoom)

return prismaticDice