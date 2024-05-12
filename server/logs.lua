local RPX = exports['rpx-core']:GetObject()
local LogData = {}
local LogTypes = {
    ['default'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['framework'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['banking'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['inventory'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['money'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['anticheat'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['job'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['shops'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
    ['stable'] = 'https://discord.com/api/webhooks/1235743393473106038/A-4tVtQL4eGboZJVmqoesLXDpk4uBodi5HonRpQKCEG0Z5VWGJAoyyvweBCzm0ocV3X3',
}

local Colors = {
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ['lightgreen'] = 9498256,
    ['purple'] = 8388736
}

local logQueue = {}

RegisterNetEvent('rpx-log:server:CreateLog', function(name, message, title, color, tagEveryone, imageUrl)
    if Config.Logs == 'local' then
        local date = os.date("%d/%m/%Y %X")
        local log = "[" .. date .. "] [" .. type .. "] " .. message
        if not LogTypes[type] then
            return
        end
        if not LogData[type] then
            LogData[type] = {}
        end
        table.insert(LogData[type], log)
        print("[RPX Logs] ".. log)
    elseif Config.Logs == 'discord' then
        local postData = {}
        local tag = tagEveryone or false

        if not LogTypes[name] then
            print('Tried to call a log that isn\'t configured with the name of ' .. name)
            return
        end
        local webHook = LogTypes[name] ~= '' and LogTypes[name] or LogTypes['default']
        local embedData = {
            {
                ['title'] = title,
                ['color'] = Colors[color] or Colors['default'],
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = message,
                ['author'] = {
                    ['name'] = 'RPX-Core Logs',
                    ['icon_url'] = 'https://avatars.githubusercontent.com/u/130105567?s=200&v=4',
                },
                ['image'] = imageUrl and imageUrl ~= '' and { ['url'] = imageUrl } or nil,
            }
        }

        if not logQueue[name] then logQueue[name] = {} end
        logQueue[name][#logQueue[name] + 1] = { webhook = webHook, data = embedData }

        if #logQueue[name] >= 10 then
            if tag then
                postData = { username = 'RPX Logs', content = '@everyone', embeds = {} }
            else
                postData = { username = 'RPX Logs', embeds = {} }
            end
            for i = 1, #logQueue[name] do postData.embeds[#postData.embeds + 1] = logQueue[name][i].data[1] end
            PerformHttpRequest(logQueue[name][1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
            logQueue[name] = {}
        end
    elseif Config.Logs == 'fivemanage' then
        local FiveManageAPIKey = GetConvar('FIVEMANAGE_LOGS_API_KEY', 'false')
        if FiveManageAPIKey == 'false' then
            print('You need to set the FiveManage API key in your server.cfg')
            return
        end
        local extraData = {
            level = tagEveryone and 'warn' or 'info', -- info, warn, error or debug
            message = title,                          -- any string
            metadata = {                              -- a table or object with any properties you want
                description = message,
                playerId = source,
                playerLicense = GetPlayerIdentifierByType(source, 'license'),
                playerDiscord = GetPlayerIdentifierByType(source, 'discord')
            },
            resource = GetInvokingResource(),
        }
        PerformHttpRequest('https://api.fivemanage.com/api/logs', function(statusCode, response, headers)
            -- Uncomment the following line to enable debugging
            -- print(statusCode, response, json.encode(headers))
        end, 'POST', json.encode(extraData), {
            ['Authorization'] = FiveManageAPIKey,
            ['Content-Type'] = 'application/json',
        })
    end
end)

if Config.Logs == 'discord' then
    Citizen.CreateThread(function()
        local timer = 0
        while true do
            Wait(1000)
            timer = timer + 1
            if timer >= 60 then -- If 60 seconds have passed, post the logs
                timer = 0
                for name, queue in pairs(logQueue) do
                    if #queue > 0 then
                        local postData = { username = 'RPX Logs', embeds = {} }
                        for i = 1, #queue do
                            postData.embeds[#postData.embeds + 1] = queue[i].data[1]
                        end
                        PerformHttpRequest(queue[1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
                        logQueue[name] = {}
                    end
                end
            end
        end
    end)
elseif Config.Logs == 'local' then
    AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
        if eventData.secondsRemaining == 60 then
            CreateThread(function()
                for k,v in pairs(LogTypes) do
                    SaveResourceFile(GetCurrentResourceName(), k .. ".log", json.encode(LogData[k]), -1)
                end
            end)
        end
    end)
end