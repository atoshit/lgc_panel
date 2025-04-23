--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local function syncPlayerPermissions(playerId)
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

RegisterCommand('rank', function(source, args)
    if source ~= 0 then
        return print('^1[ERROR] Cette commande ne peut être exécutée que depuis la console^0')
    end

    if #args < 2 then
        return print('^3[USAGE] rank <id/license> <role>^0')
    end

    local target = args[1]
    local roleName = args[2]
    local identifier

    if tonumber(target) then
        local playerId = tonumber(target)
        identifier = GetPlayerIdentifierByType(playerId, 'license')
        if not identifier then
            return print('^1[ERROR] Joueur non trouvé avec l\'ID ' .. target .. '^0')
        end
    else
        identifier = target
    end

    if not lgc.permissionManager.roles:exists(roleName) then
        return print('^1[ERROR] Le rôle ' .. roleName .. ' n\'existe pas^0')
    end

    local success = lgc.permissionManager:assignRole(identifier, roleName)
    
    if success then
        if tonumber(target) then
            local playerName = GetPlayerName(tonumber(target))
            log('^2[SUCCESS] Le rôle ' .. roleName .. ' a été attribué à ' .. playerName .. ' (' .. identifier .. ')^0', "info")
            syncPlayerPermissions(tonumber(target))
        else
            log('^2[SUCCESS] Le rôle ' .. roleName .. ' a été attribué à ' .. identifier .. '^0', "info")
        end
    else
        log('Impossible d\'attribuer le rôle^0', "warn")
    end
end)

RegisterCommand('unrank', function(source, args)
    if source ~= 0 then
        return print('^1[ERROR] Cette commande ne peut être exécutée que depuis la console^0')
    end

    if #args < 1 then
        return print('^3[USAGE] unrank <id/license>^0')
    end

    local target = args[1]
    local identifier

    if tonumber(target) then
        local playerId = tonumber(target)
        identifier = GetPlayerIdentifierByType(playerId, 'license')
        if not identifier then
            return print('^1[ERROR] Joueur non trouvé avec l\'ID ' .. target .. '^0')
        end
    else
        identifier = target
    end

    local success = lgc.permissionManager:removeRole(identifier)

    if success then
        if tonumber(target) then
            local playerName = GetPlayerName(tonumber(target))
            print('^2[SUCCESS] Le rôle a été retiré de ' .. playerName .. ' (' .. identifier .. ')^0')
            syncPlayerPermissions(tonumber(target))
            TriggerClientEvent('lgc_panel:forceClose', tonumber(target))
        else
            print('^2[SUCCESS] Le rôle a été retiré de ' .. identifier .. '^0')
        end
    else
        print('^1[ERROR] Impossible de retirer le rôle^0')
    end
end)

RegisterCommand('roles', function(source)
    if source ~= 0 then
        return print('^1[ERROR] Cette commande ne peut être exécutée que depuis la console^0')
    end

    print('^3[INFO] Liste des rôles disponibles:^0')
    lgc.permissionManager.roles:forEach(function(name, role)
        print(string.format('^5%s^0 (^2%s^0)', name, role.label))
    end)
end)
