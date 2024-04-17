-- AFK Kick Time Limit (in seconds)
local sid = GetPlayerServerId(PlayerId())
local IsLoggedIn, group

AddStateBagChangeHandler('isLoggedIn', ('player:%s'):format(sid), function(_, _, value)
    IsLoggedIn = value
    if group then return end
    exports['rpx-core']:TriggerCallback('rpx-afkkick:server:GetPermissionGroup', function(UserGroup)
        group = UserGroup or 'user'
    end)
end)

CreateThread(function()
    local prevPos, time
    local secondsUntilKick = 1800
    local timeMinutes = {
        ['900'] = 'minutes',
        ['600'] = 'minutes',
        ['300'] = 'minutes',
        ['150'] = 'minutes',
        ['60'] = 'minutes',
        ['30'] = 'seconds',
        ['20'] = 'seconds',
        ['10'] = 'seconds',
    }
	while true do
		Wait(10000)
        if IsLoggedIn then
            if group == "user" then
                local currentPos = GetEntityCoords(PlayerPedId())
                if prevPos then
                    if currentPos == prevPos then
                        if time then
                            if time > 0 then
                                local _type = timeMinutes[tostring(time)]
                                if _type == 'minutes' then
                                    lib.notify({title = "AFK", description = "You will be dropped in ".. math.ceil(time / 60) .. ' minutes for being AFK', icon = "fas fa-clock"})
                                elseif _type == 'seconds' then
                                    lib.notify({title = "AFK", description = "You will be dropped in " .. time .. ' seconds for being AFK', icon = "fas fa-clock"})
                                end
                                time -= 10
                            else
                                TriggerServerEvent("rpx-afkkick:server:AFKKick")
                            end
                        else
                            time = secondsUntilKick
                        end
                    else
                        time = secondsUntilKick
                    end
                end
                prevPos = currentPos
            end
        end
    end
end)