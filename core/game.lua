local ChessFaction = require "chess"
local Sprites = require "sprites"

local game = {}

function game.init()
    selectedPiece = nil
    selectedX, selectedY = nil, nil
    draggingPiece = false
    mouseOffsetX, mouseOffsetY = 0, 0
    currentPlayer = nil -- Поточний гравець ("white" або "black")
    gameStarted = false -- Чи гра почалася

    -- Випадково обираємо першого гравця
    currentPlayer = math.random(2) == 1 and "white" or "black"
    gameStarted = true

    -- Initialize player points
    whitePoints = 0
    blackPoints = 0

    player1 = ChessFaction.new("white")
    player2 = ChessFaction.new("black")

    player1.initializePieces()
    player2.initializePieces()

    player1.placePieces()
    player2.placePieces()
end

function game.draw()
    -- Draw the board
    boardModule.draw(BoardSize, TileSize)

    -- Draw pieces
    for x = 1, BoardSize do
        for y = 1, BoardSize do
            if tile[x][y] and not (draggingPiece and selectedX == x and selectedY == y) then
                local piece = tile[x][y]
                local image = Sprites.pieceImages[piece.faction][piece.color][piece.piecename] -- Отримуємо зображення для фігури
                love.graphics.draw(image, (x - 1) * TileSize, (y - 1) * TileSize)
            end
        end
    end

    -- Відображення фігури, яку переміщують
    if draggingPiece and selectedPiece then
        local image = pieceImages[selectedPiece.color][selectedPiece.type]
        love.graphics.draw(image, love.mouse.getX() - mouseOffsetX, love.mouse.getY() - mouseOffsetY)
    end

    -- Відображення поточного гравця
    love.graphics.setColor(255, 255, 255) -- Білий колір тексту
    love.graphics.print("Player Turn: " .. currentPlayer, 600, 10)

    -- Display player points
    love.graphics.print("White Points: " .. whitePoints, 600, 30)
    love.graphics.print("Black Points: " .. blackPoints, 600, 50)
end

return game