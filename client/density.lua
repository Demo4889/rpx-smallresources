CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            Citizen.InvokeNative(0xC0258742B034DFAF, Config.Density.animals)
            Citizen.InvokeNative(0xBA0980B5C0A11924, Config.Density.peds)
            Citizen.InvokeNative(0xAB0D553FE20A6E25, Config.Density.peds)
            Citizen.InvokeNative(0xDB48E99F8E064E56, Config.Density.animals)
            Citizen.InvokeNative(0x28CB6391ACEDD9DB, Config.Density.peds)
            Citizen.InvokeNative(0x7A556143A1C03898, Config.Density.peds)

            Citizen.InvokeNative(0xFEDFA97638D61D4A, Config.Density.vehicles)
            Citizen.InvokeNative(0x1F91D44490E1EA0C, Config.Density.vehicles)
            Citizen.InvokeNative(0x606374EBFC27B133, Config.Density.vehicles)

            Wait(5)
        else
            Wait(5000)
        end
    end
end)