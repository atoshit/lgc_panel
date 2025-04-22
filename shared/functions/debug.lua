--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local debugLevel <const> = CONF.log.debug
local errorLevel <const> = CONF.log.error
local prefix <const> = ("%s[%s:%s] ^7%s")
local lgcName <const> = lgc.env

---@param message string
---@param level "warn" | "info" | "debug"
function log(message, level)
    if level == "warn" and debugLevel >= 1 then
        return print(prefix:format("^3", lgcName, "warn", message))
    elseif level == "info" and debugLevel >= 2 then
        return print(prefix:format("^5", lgcName, "info", message))
    elseif level == "debug" and debugLevel >= 3 then
        return print(prefix:format("^6", lgcName, "debug", message))
    elseif not level then
        return print(prefix:format("^7", lgcName, "none", message))
    end
end

---@param message string
function err(message)
    if errorLevel == 1 then
        return error(prefix:format(lgcName, "error", message))
    end
end
