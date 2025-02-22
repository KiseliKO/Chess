local ChessFaction = require "factions.chess"
local boardModule = require "core.board"
local Sprites = require "sprites.sprites"
local promoteUI = require "promoteUI"

local game = {}

local selectedPiece = nil
local selectedX, selectedY = nil, nil
local draggingPiece = false
local mouseOffsetX, mouseOffsetY = 0, 0

function game.init()
    player1 = ChessFaction("white")
    player2 = ChessFaction("black")
    -- Випадково обираємо першого гравця
    currentPlayer = math.random(2) == 1 and player1 or player2
    gameStarted = true

    -- Initialize player points
    whitePoints = 0
    blackPoints = 0

    player1:placePieces()
    player2:placePieces()

    
end

function game.draw()
    
    
    -- Draw the board
    boardModule.draw(BoardSize, TileSize)
    

    -- Draw pieces
    for x = 1, BoardSize do
        for y = 1, BoardSize do
            if tile[x][y] and not (draggingPiece and selectedX == x and selectedY == y) then
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
    love.graphics.setColor(255, 255, 255) -- Білий колір тексту
    love.graphics.print("Player Turn: " .. currentPlayer.color, 600, 10)

    -- Display player points
    love.graphics.print("White Points: " .. whitePoints, 600, 30)
    love.graphics.print("Black Points: " .. blackPoints, 600, 50)
end

function love.mousepressed(mx, my, button)
    if button == 1 then -- Left mouse button
        local x = math.floor(mx / TileSize) + 1
        local y = math.floor(my / TileSize) + 1
        promoteUI.select(mx, my)

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
            if selectedPiece:canMove(x, y) and (selectedPiece.color == currentPlayer.color) then

                -- if tile[x][y] and tile[x][y].color ~= selectedPiece.color then
                --     local capturedPiece = tile[x][y] -- Взята фігура
                --     local points = capturedPiece.cost or 0 -- Використовуємо cost фігури

                --     -- Додаємо очки відповідному гравцеві
                --     if currentPlayer == "white" then
                --         whitePoints = whitePoints + points
                --     else
                --         blackPoints = blackPoints + points
                --     end
                -- end
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