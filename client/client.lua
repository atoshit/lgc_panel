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