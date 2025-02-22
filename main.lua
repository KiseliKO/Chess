Object = require "classic"
local confModule = require("conf")
local gameModule = require("core.game")
local boardModule = require "core.board"

function love.load()
    math.randomseed(os.time())
    confModule.init()
    tile = boardModule.init(BoardSize)
    gameModule.init()
end

function love.draw()
    gameModule.draw()
end


