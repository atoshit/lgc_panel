--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

RegisterCommand(CONF.panel.command, function(source, args)
    local player = source
    -- TODO: Ajouter la vérification des permissions ici
    TriggerClientEvent('lgc_panel:togglePanel', player)
end)
