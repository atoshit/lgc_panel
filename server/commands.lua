--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

-- Fonction utilitaire pour obtenir l'identifiant d'un joueur
local function GetPlayerIdentifierFromSource(source)
    if not source or source == 0 then return nil end
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        if string.match(identifier, "license:") then
            return identifier
        end
    end
    return nil
end

-- Fonction utilitaire pour synchroniser les permissions d'un joueur
local function syncPlayerPermissions(playerId)
    if not playerId then return end
    
    local identifier = GetPlayerIdentifierByType(playerId, 'license')
    if not identifier then return end

    -- Récupérer le rôle du joueur
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

-- Commande pour attribuer un rôle à un joueur
RegisterCommand('rank', function(source, args)
    -- Vérifier que la commande est exécutée depuis la console
    if source ~= 0 then
        return print('^1[ERROR] Cette commande ne peut être exécutée que depuis la console^0')
    end

    -- Vérifier les arguments
    if #args < 2 then
        return print('^3[USAGE] rank <id/license> <role>^0')
    end

    local target = args[1]
    local roleName = args[2]
    local identifier

    -- Vérifier si c'est un ID de joueur connecté
    if tonumber(target) then
        local playerId = tonumber(target)
        identifier = GetPlayerIdentifierByType(playerId, 'license')
        if not identifier then
            return print('^1[ERROR] Joueur non trouvé avec l\'ID ' .. target .. '^0')
        end
    else
        -- Sinon, considérer comme un identifiant license
        identifier = target
    end

    -- Vérifier si le rôle existe
    if not lgc.permissionManager.roles:exists(roleName) then
        return print('^1[ERROR] Le rôle ' .. roleName .. ' n\'existe pas^0')
    end

    -- Attribuer le rôle
    local success = lgc.permissionManager:assignRole(identifier, roleName)
    
    if success then
        if tonumber(target) then
            local playerName = GetPlayerName(tonumber(target))
            print('^2[SUCCESS] Le rôle ' .. roleName .. ' a été attribué à ' .. playerName .. ' (' .. identifier .. ')^0')
            -- Synchroniser les permissions du joueur
            syncPlayerPermissions(tonumber(target))
        else
            print('^2[SUCCESS] Le rôle ' .. roleName .. ' a été attribué à ' .. identifier .. '^0')
        end
    else
        print('^1[ERROR] Impossible d\'attribuer le rôle^0')
    end
end)

-- Commande pour retirer un rôle à un joueur
RegisterCommand('unrank', function(source, args)
    -- Vérifier que la commande est exécutée depuis la console
    if source ~= 0 then
        return print('^1[ERROR] Cette commande ne peut être exécutée que depuis la console^0')
    end

    -- Vérifier les arguments
    if #args < 1 then
        return print('^3[USAGE] unrank <id/license>^0')
    end

    local target = args[1]
    local identifier

    -- Vérifier si c'est un ID de joueur connecté
    if tonumber(target) then
        local playerId = tonumber(target)
        identifier = GetPlayerIdentifierByType(playerId, 'license')
        if not identifier then
            return print('^1[ERROR] Joueur non trouvé avec l\'ID ' .. target .. '^0')
        end
    else
        -- Sinon, considérer comme un identifiant license
        identifier = target
    end

    -- Retirer le rôle
    local success = lgc.permissionManager:removeRole(identifier)

    if success then
        if tonumber(target) then
            local playerName = GetPlayerName(tonumber(target))
            print('^2[SUCCESS] Le rôle a été retiré de ' .. playerName .. ' (' .. identifier .. ')^0')
            -- Synchroniser les permissions du joueur
            syncPlayerPermissions(tonumber(target))
            -- Forcer la fermeture du panel
            TriggerClientEvent('lgc_panel:forceClose', tonumber(target))
        else
            print('^2[SUCCESS] Le rôle a été retiré de ' .. identifier .. '^0')
        end
    else
        print('^1[ERROR] Impossible de retirer le rôle^0')
    end
end)

-- Commande pour lister les rôles disponibles
RegisterCommand('roles', function(source)
    -- Vérifier que la commande est exécutée depuis la console
    if source ~= 0 then
        return print('^1[ERROR] Cette commande ne peut être exécutée que depuis la console^0')
    end

    print('^3[INFO] Liste des rôles disponibles:^0')
    lgc.permissionManager.roles:forEach(function(name, role)
        print(string.format('^5%s^0 (^2%s^0)', name, role.label))
    end)
end)
