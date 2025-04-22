--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

if GetResourceState('qb-core') == 'missing' then 
    return
else
    log('Chargement du bridge QBCore...', "info")
    local QBCore = exports['qb-core']:GetCoreObject()
    local playersCache = Cache.new()

    local function refreshPlayersCache()
        local qbPlayers = QBCore.Functions.GetQBPlayers()

        for i = 1, #qbPlayers do
            local qPlayer = qbPlayers[i]
            local identifier = qPlayer.PlayerData.license
            local role = lgc.permissionManager.userRoles:get(identifier)
            local roleLabel = lgc.permissionManager.roles:get(role).label

            playersCache:set(qPlayer.PlayerData.source, {
                id = qPlayer.PlayerData.source,
                steamName = GetPlayerName(qPlayer.PlayerData.source),
                name = qPlayer.PlayerData.charinfo.firstname .. ' ' .. qPlayer.PlayerData.charinfo.lastname,
                identifier = identifier,
                role = roleLabel,
                job = {
                    name = qPlayer.PlayerData.job.name,
                    label = qPlayer.PlayerData.job.label,
                    grade = qPlayer.PlayerData.job.grade.level
                },
                group = qPlayer.PlayerData.group
            })
        end
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end

    CreateThread(function()
        while not QBCore or not lgc.permissionManager do 
            Wait(100)
            log('Attente de l\'initialisation...', "debug")
        end
        
        log('Démarrage de l\'initialisation du cache des joueurs...', "info")
        
        local Players = QBCore.Functions.GetQBPlayers()

        for i = 1, #Players do
            local qPlayer = Players[i]
            local identifier = qPlayer.PlayerData.license
            
            local role = lgc.permissionManager.userRoles:get(identifier)
            local roleLabel = lgc.permissionManager.roles:get(role)?.label or "Pas de rôle trouvé"

            playersCache:set(qPlayer.PlayerData.source, {
                id = qPlayer.PlayerData.source,
                steamName = GetPlayerName(qPlayer.PlayerData.source),
                name = qPlayer.PlayerData.charinfo.firstname .. ' ' .. qPlayer.PlayerData.charinfo.lastname,
                identifier = identifier,
                role = roleLabel,
                job = {
                    name = qPlayer.PlayerData.job.name,
                    label = qPlayer.PlayerData.job.label,
                    grade = qPlayer.PlayerData.job.grade.level
                },
                group = qPlayer.PlayerData.group
            })
            
            log('Joueur ' .. identifier .. ' ajouté au cache', "debug")
        end
        
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
        log('Cache des joueurs initialisé avec ' .. #playersCache:getAll() .. ' joueurs', "info")
    end)

    AddEventHandler('QBCore:Server:PlayerLoaded', function(qPlayer)
        local identifier = qPlayer.PlayerData.license
        local role = lgc.permissionManager.userRoles:get(identifier)
        local roleLabel = lgc.permissionManager.roles:get(role).label

        playersCache:set(qPlayer.PlayerData.source, {
            id = qPlayer.PlayerData.source,
            steamName = GetPlayerName(qPlayer.PlayerData.source),
            name = qPlayer.PlayerData.charinfo.firstname .. ' ' .. qPlayer.PlayerData.charinfo.lastname,
            identifier = identifier,
            role = roleLabel,
            job = {
                name = qPlayer.PlayerData.job.name,
                label = qPlayer.PlayerData.job.label,
                grade = qPlayer.PlayerData.job.grade.level
            },
            group = qPlayer.PlayerData.group
        })
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end)

    AddEventHandler('QBCore:Server:PlayerUnload', function(source)
        playersCache:remove(source)
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end)

    AddEventHandler('QBCore:Server:OnJobUpdate', function(source, job)
        local player = playersCache:get(source)
        if player then
            player.job = {
                name = job.name,
                label = job.label,
                grade = job.grade.level
            }
            playersCache:set(source, player)
            TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
        end
    end)

    function lgc.getPlayers()
        return playersCache:getAll(), GetConvarInt('sv_maxclients', 32)
    end
end