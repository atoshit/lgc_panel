--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

---@class PermissionManager
---@field private roles Cache
---@field private userRoles Cache
---@field private isDirty boolean
PermissionManager = {}
PermissionManager.__index = PermissionManager

function PermissionManager.new()
    local self = setmetatable({}, PermissionManager)
    self.roles = Cache.new()
    self.userRoles = Cache.new()
    self.isDirty = false
    return self
end

---Crée un nouveau rôle
---@param name string
---@param label string
---@param permissions table
---@param creatorName string
---@param creatorLicense string
---@return boolean
function PermissionManager:createRole(name, label, permissions, creatorName, creatorLicense)
    if self.roles:exists(name) then
        return false
    end

    local success = MySQL.insert.await('INSERT INTO lgc_roles (name, label, permissions, created_by_name, created_by_license) VALUES (?, ?, ?, ?, ?)', {
        name,
        label,
        json.encode(permissions),
        creatorName,
        creatorLicense
    })

    if success then
        self.roles:set(name, {
            name = name,
            label = label,
            permissions = permissions,
            created_by_name = creatorName,
            created_by_license = creatorLicense,
            created_at = os.time()
        })
        self.isDirty = true
        return true
    end

    return false
end

---Supprime un rôle
---@param name string
---@return boolean
function PermissionManager:deleteRole(name)
    if name == 'admin' then
        return false
    end

    if not self.roles:exists(name) then
        return false
    end

    self.roles:remove(name)

    self.userRoles:forEach(function(identifier, roleName)
        if roleName == name then
            self.userRoles:remove(identifier)
        end
    end)

    self.isDirty = true

    MySQL.query('DELETE FROM lgc_roles WHERE name = ?', {name})
    MySQL.query('DELETE FROM lgc_user_roles WHERE role = ?', {name})

    return true
end

---@param name string
---@param permissions table
---@return boolean
function PermissionManager:updateRolePermissions(name, permissions)
    if not self.roles:exists(name) then
        return false
    end

    local role = self.roles:get(name)
    role.permissions = permissions
    self.roles:set(name, role)
    self.isDirty = true
    return true
end

---Attribue un rôle à un utilisateur
---@param identifier string
---@param roleName string
---@return boolean
function PermissionManager:assignRole(identifier, roleName)
    if not self.roles:exists(roleName) then
        return false
    end

    local roleExists = MySQL.scalar.await('SELECT 1 FROM lgc_roles WHERE name = ?', {roleName})
    if not roleExists then
        print('^1[ERROR] Le rôle ' .. roleName .. ' n\'existe pas en base de données^0')
        return false
    end

    local exists = MySQL.scalar.await('SELECT 1 FROM lgc_user_roles WHERE identifier = ?', {identifier})
    
    local success
    if exists then
        success = MySQL.update.await('UPDATE lgc_user_roles SET role = ? WHERE identifier = ?', {
            roleName,
            identifier
        })
    else
        success = MySQL.insert.await('INSERT INTO lgc_user_roles (identifier, role) VALUES (?, ?)', {
            identifier,
            roleName
        })
    end

    if success then
        self.userRoles:set(identifier, roleName)
        self.isDirty = true
        return true
    end

    return false
end

---Retire un rôle à un utilisateur
---@param identifier string
---@return boolean
function PermissionManager:removeRole(identifier)
    local success = MySQL.query.await('DELETE FROM lgc_user_roles WHERE identifier = ?', {
        identifier
    })

    if success then
        self.userRoles:remove(identifier)
        self.isDirty = true
        return true
    end

    return false
end

---Vérifie si un utilisateur a une permission
---@param identifier string
---@param permission string
---@return boolean
function PermissionManager:hasPermission(identifier, permission)
    local roleName = self.userRoles:get(identifier)
    if not roleName then
        return false
    end

    local role = self.roles:get(roleName)
    if not role then
        return false
    end

    return role.permissions[permission] == true
end

function PermissionManager:loadData()
    local roles = MySQL.query.await('SELECT * FROM lgc_roles')
    if not roles then
        print('^1[ERROR] Impossible de charger les rôles depuis la base de données^0')
        return
    end

    local userRoles = MySQL.query.await('SELECT * FROM lgc_user_roles')
    if not userRoles then
        print('^1[ERROR] Impossible de charger les assignations de rôles depuis la base de données^0')
        return
    end

    for i = 1, #roles do
        local role = roles[i]
        self.roles:set(role.name, {
            name = role.name,
            label = role.label,
            permissions = json.decode(role.permissions),
            created_by_name = role.created_by_name,
            created_by_license = role.created_by_license,
            created_at = role.created_at
        })
    end

    for i = 1, #userRoles do
        local userRole = userRoles[i]
        if self.roles:exists(userRole.role) then
            self.userRoles:set(userRole.identifier, userRole.role)
        else
            print('^3[WARNING] Rôle invalide trouvé pour ' .. userRole.identifier .. '^0')
        end
    end

    print('^2[SUCCESS] Données chargées : ' .. #roles .. ' rôles et ' .. #userRoles .. ' assignations^0')
end

function PermissionManager:saveIfNeeded()
    if not self.isDirty then
        return
    end

    print('^3[INFO] Sauvegarde des rôles en cours...^0')
    
    self.roles:forEach(function(name, role)
        local exists = MySQL.scalar.await('SELECT 1 FROM lgc_roles WHERE name = ?', {name})
        
        if exists then
            MySQL.update('UPDATE lgc_roles SET label = ?, permissions = ?, created_by_name = ?, created_by_license = ? WHERE name = ?', {
                role.label,
                json.encode(role.permissions),
                role.created_by_name,
                role.created_by_license,
                name
            })
        else
            MySQL.insert('INSERT INTO lgc_roles (name, label, permissions, created_by_name, created_by_license) VALUES (?, ?, ?, ?, ?)', {
                name,
                role.label,
                json.encode(role.permissions),
                role.created_by_name,
                role.created_by_license
            })
        end
    end)

    self.userRoles:forEach(function(identifier, roleName)
        local exists = MySQL.scalar.await('SELECT 1 FROM lgc_user_roles WHERE identifier = ?', {identifier})
        
        if exists then
            MySQL.update('UPDATE lgc_user_roles SET role = ? WHERE identifier = ?', {
                roleName,
                identifier
            })
        else
            MySQL.insert('INSERT INTO lgc_user_roles (identifier, role) VALUES (?, ?)', {
                identifier,
                roleName
            })
        end
    end)

    self.isDirty = false
    print('^2[SUCCESS] Données sauvegardées avec succès^0')
end

return PermissionManager 