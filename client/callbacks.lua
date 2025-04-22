--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

RegisterNUICallback('getRoles', function(_, cb)
    local roles = {}
    
    TriggerServerEvent('lgc_panel:getRoles')
    
    local eventHandler
    eventHandler = RegisterNetEvent('lgc_panel:getRolesCallback', function(receivedRoles)
        log('Rôles reçus:', json.encode(receivedRoles), "debug")
        roles = receivedRoles
        
        cb({
            success = true,
            data = roles
        })
        
        RemoveEventHandler(eventHandler)
    end)
end)

RegisterNUICallback('createRole', function(data, cb)
    if not data.name or not data.label or not data.permissions then
        return cb({
            success = false,
            error = "Données invalides"
        })
    end

    TriggerServerEvent('lgc_panel:createRole', data)
    
    Wait(100)
    
    local roles = {}
    TriggerServerEvent('lgc_panel:getRoles')
    
    local eventHandler
    eventHandler = RegisterNetEvent('lgc_panel:getRolesCallback', function(receivedRoles)
        roles = receivedRoles
        
        cb({
            success = true,
            data = roles
        })
        
        RemoveEventHandler(eventHandler)
    end)
end)

RegisterNUICallback('updateRole', function(data, cb)
    TriggerServerEvent('lgc_panel:updateRole', data, function(success, error)
        cb({
            success = success,
            error = error
        })
    end)
end)

RegisterNUICallback('deleteRole', function(data, cb)
    TriggerServerEvent('lgc_panel:deleteRole', data)
    
    Wait(100)
    
    local roles = {}
    TriggerServerEvent('lgc_panel:getRoles')
    
    local eventHandler
    eventHandler = RegisterNetEvent('lgc_panel:getRolesCallback', function(receivedRoles)
        roles = receivedRoles
        
        cb({
            success = true,
            data = roles
        })
        
        RemoveEventHandler(eventHandler)
    end)
end) 