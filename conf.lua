local boardModule = require "core.board"
local conf = {}

function conf.init()
    love.window.setMode(800, 600, {resizable=true, vsync=0, minwidth=400, minheight=300})

    BoardSize = 8
    TileSize = 60
    tile = boardModule.init(BoardSize)
end

return conf