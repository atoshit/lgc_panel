--[[
    https://github.com/atoshit/lgc_panel

    Copyright © 2025 Logic. Studios <https://github.com/atoshit>
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'Logic. Studios (Atoshi)'
description 'Logic Panel is an in-game server management panel for FiveM. It allows admins to create and manage gangs, jobs, zones, and other server elements directly from the game.'
version 'v0.0.1'
repository 'atoshit/lgc_panel'

dependencies {
    'oxmysql'
}

shared_scripts {
    'shared/core.lua',
    'shared/configs/*.lua',
    'shared/functions/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/classes/Cache.lua',
    'server/classes/PermissionManager.lua',
    'server/bridges/index.lua',
    'server/bridges/esx.lua',
    'server/bridges/qbcore.lua',
    'server/init.lua',
    'server/version.lua',
    'server/events.lua',
    'server/commands.lua'
}

client_scripts {
    'client/*.lua'
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/static/css/*',
    'web/build/static/js/*',
    'web/build/static/media/*',
    'web/build/asset-manifest.json'
}