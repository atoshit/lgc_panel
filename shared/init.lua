--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local SERVICE <const> = (IsDuplicityVersion() and "server") or "client"
local GetResourceMetadata <const> = GetResourceMetadata

local METADATA <const> = {
    name = "Logic Panel",
    env = GetCurrentResourceName(),
    version = GetResourceMetadata(GetCurrentResourceName(), "version"),
    author = GetResourceMetadata(GetCurrentResourceName(), "author"),
    description = GetResourceMetadata(GetCurrentResourceName(), "description"),
    repository = GetResourceMetadata(GetCurrentResourceName(), "repository"),
    service = SERVICE,
}

---@param resource string
---@return boolean
local function IsResourceStarted(resource)
    return GetResourceState(resource) == "started"
end

local function Initialize()
    local lgc = setmetatable({}, {
        __index = METADATA,
        __newindex = function(self, name, value)
            rawset(self, name, value)
        end,
        __tostring = function(self)
            return ("%s: %s"):format(self.name, self.version)
        end
    })

    _ENV.lgc = lgc

    if SERVICE == "server" then
        if not IsResourceStarted("oxmysql") then
            error("^1[Logic Panel] oxmysql is not started. Initalizing failed.")
            return false
        end

        lgc.mysql = {}

        print("^2[Logic Panel] ^7Resource initalized on server.")
        print("^2[Logic Panel] ^7Version: ^7" .. lgc.version)
        print("^2[Logic Panel] ^7Author: ^7" .. lgc.author)
        print("^2[Logic Panel] ^7Description: ^7" .. lgc.description)
        print("^2[Logic Panel] ^7Repository: ^7" .. lgc.repository)
        return true
    else
        print("^2[Logic Panel] ^7Resource initalized on client.")
        print("^2[Logic Panel] ^7Version: ^7" .. lgc.version)
        print("^2[Logic Panel] ^7Author: ^7" .. lgc.author)
        print("^2[Logic Panel] ^7Description: ^7" .. lgc.description)
        print("^2[Logic Panel] ^7Repository: ^7" .. lgc.repository)
        return true
    end
end

if not Initialize() then
    return error("^1[Logic Panel] Resource failed to initalize.")
end