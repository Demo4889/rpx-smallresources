local config = Config

-- SetWeatherType(weatherType, true, true, true, transition_time, false)
Citizen.CreateThread(function()
    while true do
        local curWeather = GetCurrWeatherState()
        local randomWeather = Citizen.InvokeNative(0x1359C181BC625503)
        if curWeather ~= randomWeather then
            SetWeatherType(randomWeather, true, true, true, config.WeatherTransition, false)
        end
        Wait(config.WeatherChanges * 1000)
    end
end)