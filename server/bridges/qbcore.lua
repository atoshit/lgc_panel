if GetResourceState('qb-core') == 'missing' then 
    return
else
    log('Chargement du bridge QBCore...', "info")
    local QBCore = exports['qb-core']:GetCoreObject()

    function lgc.getPlayers()
        local players = {}
        local qbPlayers = QBCore.Functions.GetQBPlayers()

        for i = 1, #qbPlayers do
            local qPlayer = qbPlayers[i]
            local identifier = qPlayer.PlayerData.license
            local role = lgc.permissionManager.userRoles:get(identifier)

            players[#players + 1] = {
                id = qPlayer.PlayerData.source,
                name = qPlayer.PlayerData.charinfo.firstname .. ' ' .. qPlayer.PlayerData.charinfo.lastname,
                identifier = identifier,
                role = role,
                job = {
                    name = qPlayer.PlayerData.job.name,
                    label = qPlayer.PlayerData.job.label,
                    grade = qPlayer.PlayerData.job.grade.level
                },
                group = qPlayer.PlayerData.group
            }

            log('Joueur ' .. qPlayer.PlayerData.source .. ' chargé', "info")
        end

        return players
    end 
end