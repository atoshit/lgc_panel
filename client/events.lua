--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local callbacks = {}

local function handleCallback(name, ...)
    if callbacks[name] then
        callbacks[name](...)
        callbacks[name] = nil
    end
end

function RegisterCallback(name, cb)
    callbacks[name] = cb
end

RegisterNetEvent('lgc_panel:getRolesCallback')
AddEventHandler('lgc_panel:getRolesCallback', function(roles)
    handleCallback('getRoles', roles)
end)

RegisterNetEvent('lgc_panel:createRoleCallback')
AddEventHandler('lgc_panel:createRoleCallback', function(success, error)
    handleCallback('createRole', success, error)
end)

RegisterNetEvent('lgc_panel:updateRoleCallback')
AddEventHandler('lgc_panel:updateRoleCallback', function(success, error)
    handleCallback('updateRole', success, error)
end)

RegisterNetEvent('lgc_panel:deleteRoleCallback')
AddEventHandler('lgc_panel:deleteRoleCallback', function(success, error)
    handleCallback('deleteRole', success, error)
end) 