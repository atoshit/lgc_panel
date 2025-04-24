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
        local Players = QBCore.Functions.GetQBPlayers()

        for _, player in pairs(Players) do
            local identifier = player.PlayerData.license
            local role = lgc.permissionManager.userRoles:get("license:" .. identifier)
            local roleLabel = lgc.permissionManager.roles:get(role)?.label or "Pas de rôle trouvé"

            playersCache:set(player.PlayerData.source, {
                id = player.PlayerData.source,
                steamName = GetPlayerName(player.PlayerData.source),
                name = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname,
                identifier = identifier,
                role = roleLabel,
                job = {
                    name = player.PlayerData.job.name,
                    label = player.PlayerData.job.label,
                    grade = player.PlayerData.job.grade.level
                },
                group = QBCore.Functions.GetPermission(player.PlayerData.source)
            })
        end
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end

    RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
        local identifier = Player.PlayerData.license
        local role = lgc.permissionManager.userRoles:get("license:" .. identifier)
        local roleLabel = lgc.permissionManager.roles:get(role)?.label or "Pas de rôle trouvé"

        playersCache:set(Player.PlayerData.source, {
            id = Player.PlayerData.source,
            steamName = GetPlayerName(Player.PlayerData.source),
            name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            identifier = identifier,
            role = roleLabel,
            job = {
                name = Player.PlayerData.job.name,
                label = Player.PlayerData.job.label,
                grade = Player.PlayerData.job.grade.level
            },
            group = QBCore.Functions.GetPermission(Player.PlayerData.source)
        })

        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end)

    AddEventHandler('playerDropped', function()
        playersCache:remove(source)
        TriggerClientEvent('lgc_panel:playersUpdated', -1, playersCache:getAll())
    end)

    RegisterNetEvent('QBCore:Server:OnJobUpdate', function(source, job)
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

    RegisterNetEvent('lgc_panel:getPlayerInfo')
    AddEventHandler('lgc_panel:getPlayerInfo', function(playerId)
        local source = source
        
        local staffIdentifier = GetPlayerIdentifierByType(source, 'license')
        if not lgc.permissionManager:hasPermission(staffIdentifier, 'panel.players.view') then
            return
        end

        local Player = QBCore.Functions.GetPlayer(playerId)
        if not Player then return end

        local playerPed = GetPlayerPed(playerId)
        local playerInfo = {
            id = playerId,
            name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            steamName = GetPlayerName(playerId),
            job = {
                name = Player.PlayerData.job.name,
                label = Player.PlayerData.job.label,
                grade = Player.PlayerData.job.grade.level
            },
            group = QBCore.Functions.GetPermission(playerId),
            identifier = Player.PlayerData.license,
            steam = GetPlayerIdentifierByType(playerId, 'steam') or 'N/A',
            endpoint = GetPlayerEndpoint(playerId) or 'N/A',
            discord = GetPlayerIdentifierByType(playerId, 'discord') or 'N/A',
            stats = {
                health = GetEntityHealth(playerPed),
                armor = GetPedArmour(playerPed) or 0,
                hunger = Player.PlayerData.metadata.hunger or 100,
                thirst = Player.PlayerData.metadata.thirst or 100
            }
        }

        TriggerClientEvent('lgc_panel:receivePlayerInfo', source, playerInfo)
    end)
end