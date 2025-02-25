local boardModule = require "core.board"
local Sprites = require "sprites.sprites"
local promoteUI = require "promoteUI"


local game = {
    state = {
        menu = false,
        faction = true,
        pause = false,
        running = false,
        ended = false
    }
}

local selectedPiece = nil
local selectedX, selectedY = nil, nil
local draggingPiece = false
local mouseOffsetX, mouseOffsetY = 0, 0



function game.draw()
  

    boardModule.draw(BoardSize, TileSize)
    -- Draw pieces
    for x = 1, BoardSize do
        for y = 1, BoardSize do
            if tile[x] and tile[x][y] and tile[x][y].faction and tile[x][y].color and tile[x][y].name and not (draggingPiece and selectedX == x and selectedY == y) then
                local piece = tile[x][y]
                local image = Sprites.PieceImages[piece.faction][piece.color][piece.name] -- Отримуємо зображення для фігури
                love.graphics.setColor(0, 0, 0, 0.3)
                love.graphics.draw(image, (x - 1) * TileSize + 2, (y - 1) * TileSize + 2)
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(image, (x - 1) * TileSize, (y - 1) * TileSize)
            end
        end
    end

    promoteUI.draw()

  -- Відображення фігури, яку переміщують
    if draggingPiece and selectedPiece then
        local image = Sprites.PieceImages[selectedPiece.faction][selectedPiece.color][selectedPiece.name]
        love.graphics.draw(image, love.mouse.getX() - mouseOffsetX, love.mouse.getY() - mouseOffsetY)
        local moveList = selectedPiece:getMoves()

        if moveList ~= nil then
            for _, piecePos in ipairs (moveList) do
                local x, y = piecePos[1], piecePos[2]
                love.graphics.setColor(0, 1, 0, 0.5)
                love.graphics.rectangle("fill", (x - 1) * TileSize, (y - 1) * TileSize, TileSize, TileSize)
            end
        end
    end

    -- Відображення поточного гравця
    love.graphics.setFont(love.graphics.newFont(18))
    love.graphics.setColor(255, 255, 255) -- Білий колір тексту
    love.graphics.print("Player Turn: " .. CurrentPlayer.color, 600, 10)

    -- Display player points
    love.graphics.print("Player 1 Points: " .. Player1.points, 600, 80)
    love.graphics.print("Player 2 Points: " .. Player2.points, 600, 110)
end

function game.mousepressed(mx, my, button)
    if button == 1 then -- Left mouse button
        local x = math.floor(mx / TileSize) + 1
        local y = math.floor(my / TileSize) + 1

        if tile[x] and tile[x][y] then
            selectedPiece = tile[x][y]
            selectedX, selectedY = x, y
            draggingPiece = true
            mouseOffsetX = mx - (x - 1) * TileSize
            mouseOffsetY = my - (y - 1) * TileSize
        end
    end
end


function love.mousereleased(mx, my, button)
    if button == 1 then -- ЛКМ
        local x = math.floor(mx / TileSize) + 1
        local y = math.floor(my / TileSize) + 1

        if selectedPiece then
            -- Перевіряємо, чи фігура може рухатися
            if selectedPiece:canMove(x, y) and (selectedPiece.color == CurrentPlayer.color) then
                selectedPiece:takePiece(x, y)
                selectedPiece:move(x, y)
                draggingPiece = false
                
            else
                selectedPiece = nil
                selectedX, selectedY = nil, nil
            end
        end
    end
    
end




return game