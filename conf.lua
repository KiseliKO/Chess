local boardModule = require "core.board"
local conf = {}

function love.conf(t)
    t.indentity = nil
    t.version = "11.5"

    t.modules.video = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch= false

    t.window.title = "Chess 2.0"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = true
    t.window.vsync = 0
end


function conf.init()
    -- love.window.setMode(800, 600, {resizable=true, vsync=0, minwidth=400, minheight=300})

    BoardSize = 8
    TileSize = 60
    tile = boardModule.init(BoardSize)
end

return conf