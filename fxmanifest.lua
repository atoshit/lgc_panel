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
    'shared/init.lua',
    'shared/configs/*.lua',
    'shared/functions/*.lua',
}

server_scripts {
    'server/version.lua',
}

client_scripts {
    -- TODO: Add client files here
}