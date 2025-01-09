MilkshakeVol1:AddModCompatibility("CustomHealthAPI", function ()
    local playerHearts = 0
    local playerRedHearts = 0

    function MilkshakeVol1:FFPrePotatoPeelerFix(item, rng, player)
        if FiendFolio then
            playerHearts = player:GetMaxHearts()
            playerRedHearts = player:GetHearts()
        end
    end
    MilkshakeVol1:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, MilkshakeVol1.FFPrePotatoPeelerFix, CollectibleType.COLLECTIBLE_POTATO_PEELER)

    function MilkshakeVol1:FFPotatoPeelerFix(item, rng, player)     
        if player:GetMaxHearts() < (playerHearts - 2) then
            player:AddMaxHearts(2)
        end
        if player:GetHearts() < (playerRedHearts - 2) then
            player:AddHearts(2)
        end
        if playerHearts <= 4 and playerRedHearts <= 2 then
            if playerRedHearts == 2 then
                player:AddHearts(2)
            else
                player:AddHearts(1)
            end
        end
    end

    MilkshakeVol1:AddCallback(ModCallbacks.MC_USE_ITEM, MilkshakeVol1.FFPotatoPeelerFix, CollectibleType.COLLECTIBLE_POTATO_PEELER)
end)