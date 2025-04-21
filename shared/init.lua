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
            return error("^1[Logic Panel] ^7oxmysql is not started. Initalizing failed.")
        end

        lgc.mysql = {}

        print("^2[Logic Panel] ^7Resource initalized on server.")
    else
        print("^2[Logic Panel] ^7Resource initalized on client.")
    end
end

if not Initialize() then
    return error("^1[Logic Panel] ^7Resource failed to initalize.")
end