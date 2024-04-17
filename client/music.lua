local RPX = exports['rpx-core']:GetObject()
local songName = nil

playSong = function(songName)
    Citizen.InvokeNative(0x1E5185B72EF5158A, songName) -- PrepareMusicEvent(eventName)
    Citizen.InvokeNative(0x706D57B0F50DA710, songName) -- TriggerMusicEvent(eventName)
end

RegisterCommand('playmusic', function(source, args, rawCommand)
    songName = args[1]
    if songName == '' or songName == nil then
        return lib.notify({title = "Music", description = "You need to enter a song to play", type = "error"})
    end

    if AudioIsMusicPlaying() then
        lib.notify({title = "Music", description = "You're already playing music", type = "error"})
        return
    end

    playSong(songName)
end)

RegisterCommand('stopmusic', function(source, args, rawCommand)
    if AudioIsMusicPlaying() then
        if songName ~= nil then
            Citizen.InvokeNative(0x706D57B0F50DA710, "MC_MUSIC_STOP")  -- TriggerMusicEvent(eventName)
            songName = nil
        else
            lib.notify({title = "Music", description = "No song playing", type = "error"})
        end
    end
end)

CreateThread(function()
    Wait(1000)
    TriggerEvent('chat:addSuggestion', '/playmusic', 'Starts playing music', {
        { name = 'song', help = 'song event from https://github.com/femga/rdr3_discoveries/blob/master/audio/music_events/music_events.lua' },
    })
    TriggerEvent('chat:addSuggestion', '/stopmusic', 'Stops music from playing')
end)