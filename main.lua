Object = require "classic"
local conf = require("conf")
local game = require("core.game")
local board = require "core.board"
local factionUI = require "factionUI"


function love.load()
    math.randomseed(os.time())
    conf.init()
    tile = board.init(BoardSize)
    Player1, Player2 = nil, nil
    CurrentPlayer = nil
end

function love.draw()
    if game.state["faction"] then
        factionUI.draw()
    elseif game.state["running"] then
        
        game.draw()
    end
end

function love.mousepressed(mx, my, button)
    if game.state["faction"] then
        factionUI.select(mx, my)

    elseif game.state["running"] then
        -- Обробка натискань миші для гри
        
        game.mousepressed(mx, my, button)
    end
end