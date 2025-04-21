--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

local CONF <const> = {
    log = {
        debug = 3, -- 0: No debug, 1: Warn, 2: Info, 3: Debug
        error = 1, -- 0: No error, 1: Error
    },

    panel = {
        key = 'f10',
        command = 'panel',
        title = 'Panel d\'administration',
        description = 'Ouvrir le panel d\'administration'
    }
}
_ENV.CONF = CONF
