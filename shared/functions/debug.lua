local debugLevel <const> = CONF.log.debug
local errorLevel <const> = CONF.log.error
local prefix <const> = ("^7[%s:%s] ^7%s")
local lgcName <const> = lgc.name

---@param message string
---@param level "warn" | "info" | "debug"
function log(message, level)
    if level == "warn" and debugLevel >= 1 then
        return print(prefix:format(lgcName, "warn", message))
    elseif level == "info" and debugLevel >= 2 then
        return print(prefix:format(lgcName, "info", message))
    elseif level == "debug" and debugLevel >= 3 then
        return print(prefix:format(lgcName, "debug", message))
    elseif not level then
        return print(prefix:format(lgcName, "none", message))
    end
end

---@param message string
function err(message)
    if errorLevel == 1 then
        return error(prefix:format(lgcName, "error", message))
    end
end
