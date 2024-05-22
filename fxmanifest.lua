fx_version 'cerulean'
game 'gta5'

author 'NazriGenfil'
description 'Farming script for QBOX'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    -- 'config.lua' 
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

files {
    'config/client.lua',
    'config/server.lua'
}

-- this_is_a_map 'yes'
