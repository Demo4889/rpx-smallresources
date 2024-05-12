if Config.WeaponRecoilSystem then
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if IsPedShooting(ped) then
                local _,wep = GetCurrentPedWeapon(ped)
                if Config.Recoils[wep] and Config.Recoils[wep] ~= 0 then
                    TimeValue = 0
                    repeat
                        Wait(0)
                        GameplayCamPitch = GetGameplayCamRelativePitch()
                        if Config.Recoils[wep] > 0.1 then
                            SetGameplayCamRelativePitch(GameplayCamPitch+0.6, 1.2)
                            TimeValue = TimeValue+0.6
                        else
                            SetGameplayCamRelativePitch(GameplayCamPitch+0.016, 0.333)
                            TimeValue = TimeValue+0.1
                        end
                    until TimeValue >= Config.Recoils[wep]
                end
            end
            Wait(0)
        end
    end)
end