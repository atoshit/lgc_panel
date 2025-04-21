local CONF <const> = {
    log = {
        debug = 3, -- 0: No debug, 1: Warn, 2: Info, 3: Debug
        error = 1, -- 0: No error, 1: Error
    }
}

_ENV.CONF = CONF
