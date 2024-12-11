MilkshakeVol1:AddCallback(ModCallbacks.MC_POST_RENDER, function ()
    local max = 0
    for _ = 1, 10000000, 1 do
        local a = math.random()
        if a > max then
            max = a
        end
    end
end)