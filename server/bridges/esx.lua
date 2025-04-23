--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

if GetResourceState('es_extended') == 'missing' then 
    return 
else
    log('Chargement du bridge ESX...', "info")

    local ESX = exports['es_extended']:getSharedObject()
    local playersCache = Cache.new() 

    local function refreshPlayersCache()
        local xPlayers = ESX.GetExtendedPlayers()

        for i = 1, #xPlayers do
            local xPlayer = xPlayers[i]
            local identifier = xPlayer.identifier
            local role = lgc.permissionManager.userRoles:get("license:" .. identifier)
            local roleLabel = lgc.permissionManager.roles:get(role)?.label or "Pas de rôle trouvé"

            playersCache:set(xPlayer.source, {
                id = xPlayer.source,
                steamName = GetPlayerName(xPlayer.source),
                name = xPlayer.getName(),
                identifier = identifier,
                role = roleLabel,
                job = {
                    name = xPlayer.job.name,
                    label = xPlayer.job.label,
                    grade = xPlayer.job.grade
                },
                group = xPlayer.getGroup()
            })
        end
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end

    CreateThread(function()
        while not ESX or not lgc.permissionManager do 
            Wait(100) 
            log('Attente de l\'initialisation...', "debug")
        end
        
        log('Démarrage de l\'initialisation du cache des joueurs...', "info")
        
        local xPlayers = ESX.GetExtendedPlayers()

        for i = 1, #xPlayers do
            local xPlayer = xPlayers[i]
            local identifier = xPlayer.identifier
            log('Traitement du joueur ' .. identifier, "debug")
            
            local role = lgc.permissionManager.userRoles:get("license:" .. identifier)
            local roleLabel = lgc.permissionManager.roles:get(role)?.label or "Pas de rôle trouvé"
            
            playersCache:set(xPlayer.source, {
                id = xPlayer.source,
                steamName = GetPlayerName(xPlayer.source),
                name = xPlayer.getName(),
                identifier = identifier,
                role = roleLabel,
                job = {
                    name = xPlayer.job.name,
                    label = xPlayer.job.label,
                    grade = xPlayer.job.grade
                },
                group = xPlayer.getGroup()
            })
            
            log('Joueur ' .. identifier .. ' ajouté au cache', "debug")
        end
        
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
        log('Cache des joueurs initialisé avec ' .. #playersCache:getAll() .. ' joueurs', "info")
    end)

    AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
        local identifier = xPlayer.identifier
        local role = lgc.permissionManager.userRoles:get("license:" .. identifier)
        local roleLabel = lgc.permissionManager.roles:get(role).label

        playersCache:set(playerId, {
            id = playerId,
            steamName = GetPlayerName(playerId),
            name = xPlayer.getName(),
            identifier = identifier,
            role = roleLabel,
            job = {
                name = xPlayer.job.name,
                label = xPlayer.job.label,
                grade = xPlayer.job.grade
            },
            group = xPlayer.getGroup()
        })

        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end)

    AddEventHandler('esx:playerDropped', function(playerId)
        playersCache:remove(playerId)
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end)

    AddEventHandler('esx:setJob', function(playerId, job)
        local player = playersCache:get(playerId)
        if player then
            player.job = {
                name = job.name,
                label = job.label,
                grade = job.grade
            }
            playersCache:set(playerId, player)
            TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
        end
    end)

    function lgc.getPlayers()
        return playersCache:getAll(), GetConvarInt('sv_maxclients', 32)
    end
end