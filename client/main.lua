--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local panelConfig <const> = CONF.panel
local isVisible = false

local function togglePanel()
    isVisible = not isVisible
    
    local playerInfo = {
        name = GetPlayerName(PlayerId()),
        id = GetPlayerServerId(PlayerId()),
        role = "Administrateur",
        reports = 10,
        bans = 15 
    }

    SendNUIMessage({
        action = 'setVisible',
        data = {
            show = isVisible,
            timestamp = GetGameTimer(),
            version = lgc.version,
            playerInfo = playerInfo
        }
    })

    if isVisible then
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)
    else
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end

RegisterNetEvent('lgc_panel:togglePanel')
AddEventHandler('lgc_panel:togglePanel', togglePanel)

RegisterCommand(panelConfig.command, function()
    togglePanel()
end)

RegisterKeyMapping(panelConfig.command, panelConfig.title, 'keyboard', panelConfig.key)

RegisterNUICallback('closePanel', function(data, cb)
    isVisible = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    cb({})
end)

RegisterNetEvent('lgc_panel:reloadRoles')
AddEventHandler('lgc_panel:reloadRoles', function()
    SendNUIMessage({
        action = 'reloadRoles'
    })
end)