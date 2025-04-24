--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

RegisterNetEvent('lgc_panel:playersUpdated', function(players)
    SendNUIMessage({
        action = 'setPlayers',
        players = players
    })
end)

RegisterNetEvent('lgc_panel:setPlayers', function(data)
    SendNUIMessage(data)
end)

RegisterNUICallback('getPlayerInfo', function(data, cb)
    TriggerServerEvent('lgc_panel:getPlayerInfo', data.playerId)
    cb({
        success = true,
        data = {}
    })
end)

RegisterNetEvent('lgc_panel:receivePlayerInfo')
AddEventHandler('lgc_panel:receivePlayerInfo', function(playerInfo)
    SendNUIMessage({
        type = 'playerInfoUpdate',
        data = playerInfo
    })
end) 