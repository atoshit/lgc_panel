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

    RegisterNetEvent('lgc_panel:getPlayerInfo')
    AddEventHandler('lgc_panel:getPlayerInfo', function(playerId)
        local source = source
        
        local staffIdentifier = GetPlayerIdentifierByType(source, 'license')
        if not lgc.permissionManager:hasPermission(staffIdentifier, 'panel.players.view') then
            return
        end

        local xPlayer = ESX.GetPlayerFromId(playerId)

        if not xPlayer then return end

        local thirst = 100
        local hunger = 100

        TriggerEvent('esx_status:getStatus', playerId, 'hunger', function(hunger)
            hunger = hunger.percent
        end)

        TriggerEvent('esx_status:getStatus', playerId, 'thirst', function(thirst)
            thirst = thirst.percent
        end)

        local playerPed = GetPlayerPed(playerId)
        local playerInfo = {
            id = playerId,
            name = xPlayer.getName(),
            steamName = GetPlayerName(playerId),
            job = {
                name = xPlayer.job.name,
                label = xPlayer.job.label,
                grade = xPlayer.job.grade
            },
            group = xPlayer.getGroup(),
            identifier = xPlayer.identifier,
            steam = GetPlayerIdentifierByType(playerId, 'steam') or 'N/A',
            endpoint = GetPlayerEndpoint(playerId) or 'N/A',
            discord = GetPlayerIdentifierByType(playerId, 'discord') or 'N/A',
            stats = {
                health = GetEntityHealth(playerPed),
                armor = GetPedArmour(playerPed) or 0,
                hunger = hunger,
                thirst = thirst
            }
        }

        print(json.encode(playerInfo))

        TriggerClientEvent('lgc_panel:receivePlayerInfo', source, playerInfo)
    end)
end