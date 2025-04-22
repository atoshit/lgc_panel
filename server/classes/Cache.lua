--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

---@class Cache
---@field private data table
Cache = {}
Cache.__index = Cache

function Cache.new()
    local self = setmetatable({}, Cache)
    self.data = {}
    return self
end

function Cache:set(key, value)
    self.data[key] = value
end

function Cache:get(key)
    return self.data[key]
end

function Cache:remove(key)
    self.data[key] = nil
end

function Cache:exists(key)
    return self.data[key] ~= nil
end

function Cache:clear()
    self.data = {}
end

function Cache:getAll()
    return self.data
end

function Cache:forEach(callback)
    for k, v in pairs(self.data) do
        callback(k, v)
    end
end

return Cache 