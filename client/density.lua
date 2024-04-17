config = Config

CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            Citizen.InvokeNative(0xC0258742B034DFAF, config.animals)
            Citizen.InvokeNative(0xBA0980B5C0A11924, config.peds)
            Citizen.InvokeNative(0xAB0D553FE20A6E25, config.peds)
            Citizen.InvokeNative(0xDB48E99F8E064E56, config.animals)
            Citizen.InvokeNative(0x28CB6391ACEDD9DB, config.peds)
            Citizen.InvokeNative(0x7A556143A1C03898, config.peds)

            Citizen.InvokeNative(0xFEDFA97638D61D4A, config.vehicles)
            Citizen.InvokeNative(0x1F91D44490E1EA0C, config.vehicles)
            Citizen.InvokeNative(0x606374EBFC27B133, config.vehicles)

            Wait(5)
        else
            Wait(5000)
        end
    end
end)