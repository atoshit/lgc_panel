if GetResourceState('es_extended') == 'missing' then 
    return 
else
    log('Chargement du bridge ESX...', "info")

    local ESX = exports['es_extended']:getSharedObject()

    function lgc.getPlayers()
        local players = {}
        local xPlayers = ESX.GetExtendedPlayers()
        local maxClients = GetConvarInt('sv_maxclients', 32) 
    
        for i = 1, #xPlayers do
            local xPlayer = xPlayers[i]
            local identifier = xPlayer.identifier
            local role = lgc.permissionManager.userRoles:get(identifier)
    
            players[#players + 1] = {
                id = xPlayer.source,
                steamName = GetPlayerName(xPlayer.source),
                name = xPlayer.getName(),
                identifier = identifier,
                role = role,
                job = {
                    name = xPlayer.job.name,
                    label = xPlayer.job.label,
                    grade = xPlayer.job.grade
                },
                group = xPlayer.getGroup()
            }

            log('Joueur ' .. xPlayer.source .. ' chargé', "info")
        end
    
        return players, maxClients 
    end 
end