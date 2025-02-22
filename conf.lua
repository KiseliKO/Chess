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
    BoardSize = 8
    TileSize = 60
end

return conf