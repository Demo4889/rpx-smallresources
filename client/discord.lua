CreateThread(function()
    while true do
        SetDiscordAppId(Config.Discord.discordId)
        SetDiscordRichPresenceAsset(Config.Discord.discordAsset)
        SetDiscordRichPresenceAssetText(Config.Discord.discordAssetText)

        while not GlobalState.PlayerCount do
            Wait(500)
        end
        local pId = GetPlayerServerId(PlayerId())
        local pName = GetPlayerName(PlayerId())
        SetRichPresence(GlobalState.PlayerCount.." / "..GlobalState.MaxPlayers.." - ID: "..pId.." | "..pName)

        SetDiscordRichPresenceAction(0, "Join Server!", "redm://connect/localhost:30120")
        Wait(60000) -- 1 min update
        PlayerCount = nil
    end
end)