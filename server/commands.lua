RegisterCommand(CONF.panel.command, function(source, args)
    local player = source
    -- TODO: Ajouter la vérification des permissions ici
    TriggerClientEvent('lgc_panel:togglePanel', player)
end)
