--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

RegisterNetEvent('lgc_panel:getRoles')
AddEventHandler('lgc_panel:getRoles', function()
    local source = source
    local roles = {}
    
    lgc.permissionManager.roles:forEach(function(name, role)
        roles[#roles + 1] = {
            name = name,
            label = role.label,
            permissions = role.permissions,
            created_by_name = role.created_by_name,
            created_at = role.created_at
        }
    end)

    TriggerClientEvent('lgc_panel:getRolesCallback', source, roles)
end)

RegisterNetEvent('lgc_panel:createRole')
AddEventHandler('lgc_panel:createRole', function(data)
    local source = source
    local playerName = GetPlayerName(source)
    local playerLicense = GetPlayerIdentifier(source, 0)
    
    if not data.name or not data.label or not data.permissions then
        return
    end

    if type(data.permissions) ~= "table" then
        data.permissions = {}
    end

    local defaultPermissions = {
        ['panel.access'] = false,
        ['panel.players.view'] = false,
        ['panel.players.kick'] = false,
        ['panel.players.ban'] = false,
        ['panel.reports.view'] = false,
        ['panel.reports.manage'] = false,
        ['panel.roles.manage'] = false
    }

    for k, v in pairs(defaultPermissions) do
        if data.permissions[k] == nil then
            data.permissions[k] = v
        end
    end

    local success = lgc.permissionManager:createRole(
        data.name, 
        data.label, 
        data.permissions,
        playerName,
        playerLicense
    )
    
    if success then
        TriggerClientEvent('lgc_panel:reloadRoles', -1)
    end
end)

RegisterNetEvent('lgc_panel:updateRole')
AddEventHandler('lgc_panel:updateRole', function(data)
    local source = source
    
    if not data.name or not data.permissions then
        return TriggerClientEvent('lgc_panel:updateRoleCallback', source, false, 'Données invalides')
    end

    local success = lgc.permissionManager:updateRolePermissions(data.name, data.permissions)
    TriggerClientEvent('lgc_panel:updateRoleCallback', source, success, not success and 'Rôle introuvable' or nil)
end)

RegisterNetEvent('lgc_panel:deleteRole')
AddEventHandler('lgc_panel:deleteRole', function(data)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)

    if not data.name then
        TriggerClientEvent('lgc_panel:deleteRoleCallback', source, false, 'Nom du rôle manquant')
        return
    end

    if data.name == 'admin' then
        TriggerClientEvent('lgc_panel:deleteRoleCallback', source, false, 'Le rôle administrateur ne peut pas être supprimé')
        return
    end

    local success = lgc.permissionManager:deleteRole(data.name)
    TriggerClientEvent('lgc_panel:deleteRoleCallback', source, success, not success and 'Rôle introuvable' or nil)
end)

function lgc.syncPlayerPermissions(playerId)
    if not playerId then return end
    
    local identifier = GetPlayerIdentifierByType(playerId, 'license')
    if not identifier then return end

    local roleName = lgc.permissionManager.userRoles:get(identifier)
    local role = roleName and lgc.permissionManager.roles:get(roleName)
    
    local playerInfo = {
        name = GetPlayerName(playerId),
        id = playerId,
        role = role and role.label or "Aucun rôle",
        permissions = role and role.permissions or {},
        reports = 5,
        bans = 8
    }

    TriggerClientEvent('lgc_panel:playerInfoCallback', playerId, playerInfo)
end

RegisterNetEvent('lgc_panel:getPlayerInfo')
AddEventHandler('lgc_panel:getPlayerInfo', function()
    local source = source
    lgc.syncPlayerPermissions(source)
end)

RegisterNetEvent('lgc_panel:checkAccess')
AddEventHandler('lgc_panel:checkAccess', function()
    local source = source
    local identifier = GetPlayerIdentifierByType(source, 'license')
    
    local roleName = lgc.permissionManager.userRoles:get(identifier)
    local hasAccess = roleName ~= nil
    
    TriggerClientEvent('lgc_panel:accessCallback', source, hasAccess)
end)

RegisterNetEvent('lgc_panel:getPlayers', function()
    local source = source
    if not lgc.permissionManager:hasPermission(GetPlayerIdentifierByType(source, 'license'), 'panel.players.view') then
        return TriggerClientEvent('lgc_panel:playersCallback', source, {})
    end

    local players, maxClients = lgc.getPlayers()
    if not players then players = {} end
    
    TriggerClientEvent('lgc_panel:playersCallback', source, players)
    TriggerClientEvent('lgc_panel:setPlayers', source, {
        action = 'setPlayers',
        players = players,
        maxClients = maxClients
    })
end)

