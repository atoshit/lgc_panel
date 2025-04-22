RegisterNetEvent('lgc_panel:playersCallback', function(players)
    SendNUIMessage({
        action = 'setPlayers',
        players = players
    })
end)

RegisterNetEvent('lgc_panel:setPlayers', function(data)
    SendNUIMessage(data)
end) 