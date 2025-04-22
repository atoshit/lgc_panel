--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local panelConfig <const> = CONF.panel
local isVisible = false

local function togglePanel()
    -- Vérifier d'abord si le joueur a un rôle
    TriggerServerEvent('lgc_panel:checkAccess')
end

RegisterNetEvent('lgc_panel:accessCallback')
AddEventHandler('lgc_panel:accessCallback', function(hasAccess)
    if hasAccess then
        isVisible = not isVisible
        TriggerServerEvent('lgc_panel:getPlayerInfo')
    end
end)

RegisterNetEvent('lgc_panel:playerInfoCallback')
AddEventHandler('lgc_panel:playerInfoCallback', function(playerInfo)
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
end)

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

RegisterNetEvent('lgc_panel:forceClose')
AddEventHandler('lgc_panel:forceClose', function()
    if isVisible then
        isVisible = false
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        SendNUIMessage({
            action = 'setVisible',
            data = {
                show = false
            }
        })
    end
end)