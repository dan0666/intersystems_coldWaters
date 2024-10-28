fx_version 'cerulean'
game 'gta5'
author 'International systems'
description 'ColdWater damage'
version '1.0'
lua54 'yes'

client_scripts {
    'client/*.lua'
}

shared_scripts {
    'config.lua'
} 

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/sounds/*.ogg'
}

escrow_ignore {
    'config.lua',
    'client/*'
}
