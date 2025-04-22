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