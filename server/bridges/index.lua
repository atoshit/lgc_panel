--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local function detectFramework()
    if GetResourceState('es_extended') ~= 'missing' then
        log('Framework détecté : ESX', "info")
        return 'esx'
    elseif GetResourceState('qb-core') ~= 'missing' then
        log('Framework détecté : QBCore', "info")
        return 'qbcore'
    end
    return nil
end

local framework = detectFramework()
if not framework then
    return err('Aucun framework compatible détecté (ESX ou QBCore requis)')
end