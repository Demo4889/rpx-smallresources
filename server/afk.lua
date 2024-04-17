RPX = exports['rpx-core']:GetObject()

RegisterNetEvent('rpx-afkkick:server:AFKKick', function()
    local src = source
	DropPlayer(src, 'You Have Been Kicked For Being AFK')
end)

exports['rpx-core']:CreateCallback('rpx-afkkick:server:GetPermissionGroup', function(source, cb)
    local src = source
    local group = RPX.Permissions.GetPermissionGroup(src)
    cb(group)
end)