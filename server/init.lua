--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

---@param resource string
---@return boolean
local function IsResourceStarted(resource)
    return GetResourceState(resource) == "started"
end

if not IsResourceStarted("oxmysql") then
    return error("^1[Logic Panel] oxmysql is not started. Initalizing failed.")
end

local queries = {
    [[
        CREATE TABLE IF NOT EXISTS `lgc_roles` (
            `name` VARCHAR(50) NOT NULL,
            `label` VARCHAR(50) NOT NULL,
            `permissions` LONGTEXT NOT NULL,
            `created_by_name` VARCHAR(50) NOT NULL,
            `created_by_license` VARCHAR(50) NOT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`name`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `lgc_user_roles` (
            `identifier` VARCHAR(50) NOT NULL,
            `role` VARCHAR(50) NOT NULL,
            PRIMARY KEY (`identifier`),
            FOREIGN KEY (`role`) REFERENCES `lgc_roles`(`name`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]]
}

for i = 1, #queries do
    local query = queries[i]
    MySQL.query(query)
end

lgc.permissionManager = PermissionManager.new()

CreateThread(function()
    Wait(1000) 
    lgc.permissionManager:loadData()

    if not lgc.permissionManager.roles:exists('admin') then
        print('^3[INFO] Création du rôle administrateur...^0')
        local success = lgc.permissionManager:createRole('admin', 'Administrateur', {
            ['panel.access'] = true,
            ['panel.players.view'] = true,
            ['panel.players.kick'] = true,
            ['panel.players.ban'] = true,
            ['panel.reports.view'] = true,
            ['panel.reports.manage'] = true,
            ['panel.roles.manage'] = true
        }, 'Console', 'Console')
        if success then
            print('^2[SUCCESS] Rôle administrateur créé avec succès^0')
        else
            print('^1[ERROR] Échec de la création du rôle administrateur^0')
        end
    end
end)

print("^2[Logic Panel] ^7Resource initalized on server.")
print("^2[Logic Panel] ^7Version: ^7" .. lgc.version)
print("^2[Logic Panel] ^7Author: ^7" .. lgc.author)
print("^2[Logic Panel] ^7Description: ^7" .. lgc.description)
print("^2[Logic Panel] ^7Repository: ^7" .. lgc.repository)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if lgc.permissionManager then
            print('^3[INFO] Sauvegarde des données en cours...^0')
            lgc.permissionManager:saveIfNeeded()
            print('^2[SUCCESS] Données sauvegardées avec succès^0')
        end
    end
end) 