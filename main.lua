Object = require "classic"
local boardModule = require("board")
local settings = require("settings")
local game = require("game")
local Pawn = require("pieces.pawn")
local Queen = require("pieces.queen")
local Bishop = require("pieces.bishop")
local Tower = require("pieces.tower")
local Knight = require("pieces.knight")
local King = require("pieces.king")
local Checker = require("pieces.checker")
local Movement = require("movement")

-- love.load is called once at the start
function love.load()
    tile = boardModule.init(BoardSize)
    settings.init()
    game.init()
end

function love.draw()
    -- Draw the board
    boardModule.draw(BoardSize, TileSize)

    -- Draw pieces
    for x = 1, BoardSize do
        for y = 1, BoardSize do
            if tile[x][y] and not (draggingPiece and selectedX == x and selectedY == y) then
                local piece = tile[x][y]
                local image = pieceImages[piece.color][piece.type] -- Отримуємо зображення для фігури
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

promotionPiece = nil -- Фігура, на яку перетворюється пішак
promotingPawn = nil -- Пішак, який перетворюється
promotingX, promotingY = nil, nil -- Координати пішака

-- love.mousepressed is called when the mouse is clicked
function love.mousepressed(mx, my, button)
    if button == 1 then -- Left mouse button
        local x = math.floor(mx / TileSize) + 1
        local y = math.floor(my / TileSize) + 1

        if tile[x] and tile[x][y] then
            selectedPiece = tile[x][y]
            selectedX, selectedY = x, y
            draggingPiece = true
            mouseOffsetX = mx - (x - 1) * TileSize
            mouseOffsetY = my - (y - 1) * TileSize
            print("Start", selectedX, selectedY)
        end
    end
end

-- love.mousereleased is called when the mouse button is released
function love.mousereleased(mx, my, button)
    if button == 1 then -- ЛКМ
        local x = math.floor(mx / TileSize) + 1
        local y = math.floor(my / TileSize) + 1

        if selectedPiece then
            -- Перевіряємо, чи фігура може рухатися
            if (x <= BoardSize and y <= BoardSize) and (selectedPiece.color == currentPlayer) and isValidMove(selectedPiece, selectedX, selectedY, x, y) then
                -- Promote пішака           
                if selectedPiece.type == "pawn" then
                    local promotionRow = (selectedPiece.color == "white") and 8 or 1
                    if y == promotionRow then
                        promotingPawn = selectedPiece
                        promotingX, promotingY = x, y
                    end
                end

                if selectedPiece.type == "king" and math.abs(x - selectedX) == 2 then
                    local towerX = (x > selectedX) and 8 or 1
                    local towerPiece = tile[towerX][selectedY]

                    if towerPiece and towerPiece.type == "tower" and canCastle(selectedPiece, towerPiece, tile, selectedX, selectedY, x) then
                        -- Рухаємо короля
                        tile[x][y] = selectedPiece
                        tile[selectedX][selectedY] = nil

                        -- Рухаємо туру
                        local newtowerX = (x > selectedX) and (x - 1) or (x + 1)
                        tile[newtowerX][selectedY] = towerPiece
                        tile[towerX][selectedY] = nil

                        -- Позначаємо, що вони вже рухалися
                        selectedPiece.hasMoved = true
                        towerPiece.hasMoved = true

                        -- Завершуємо хід
                        currentPlayer = (currentPlayer == "white") and "black" or "white"
                        selectedPiece = nil
                        return
                    else
                        print("cant castle")
                    end
                else
                end

                if tile[x][y] and tile[x][y].color ~= selectedPiece.color then
                    local capturedPiece = tile[x][y] -- Взята фігура
                    local points = capturedPiece.cost or 0 -- Використовуємо cost фігури

                    -- Додаємо очки відповідному гравцеві
                    if currentPlayer == "white" then
                        whitePoints = whitePoints + points
                    else
                        blackPoints = blackPoints + points
                    end
                end

                if capturedPiece.type == "king" then
                    King.kingCount = King.Count - 1
                end

                --if    
                -- Оновлюємо позицію фігури
                --tile[selectedX][selectedY] = nil
                --tile[x][y] = selectedPiece
                --en

                 -- Позначаємо, що король/тура вже рухалися
                if selectedPiece.type == "king" or selectedPiece.type == "tower" then
                    selectedPiece.hasMoved = true
                end

                -- Скидаємо вибір
                selectedPiece = nil
                draggingPiece = false
                -- Завершуємо хід
                selectedPiece = nil
                selectedX, selectedY = nil, nil
                if promotingPawn == nil then
                    currentPlayer = (currentPlayer == "white") and "black" or "white"
                end
                print("End", x, y)
            else
                -- Скасовуємо вибір
                selectedPiece = nil
                selectedX, selectedY = nil, nil
                print("invalid move")
            end
        end
    end
    
end
function love.keypressed(key)
    if promotingPawn then
        -- Гравець обирає фігуру для перетворення
        if key == "q" then
            promotionPiece = Queen.new(promotingPawn.color) -- Ферзь
        elseif key == "r" then
            promotionPiece = Tower.new(promotingPawn.color) -- Лад'я
        elseif key == "b" then
            promotionPiece = Bishop.new(promotingPawn.color) -- Слон
        elseif key == "n" then
            promotionPiece = Knight.new(promotingPawn.color) -- Кінь
        elseif key == "k" then
            promotionPiece = King.new(promotingPawn.color) -- Король
            King.kingCount = King.kingCount + 1
        end

        -- Якщо фігура обрана, із замінюємо пішака
        if promotionPiece then
            tile[promotingX][promotingY] = promotionPiece
            promotingPawn = nil
            promotionPiece = nil
            currentPlayer = (currentPlayer == "white") and "black" or "white"
        end
    end

end

function isValidMove(piece, startX, startY, endX, endY)
    if startX == endX and startY == endY then
        return false -- Фігура не може залишатися на місці
    end

    if Movement.isFriendlyPiece(endX, endY, tile, piece) then
        return false -- Не можна ходити на клітинку із союзною фігурою
    end

    -- Валідація руху фігур
    if piece.type == "pawn" then
        return Pawn.isValidMove(piece, startX, startY, endX, endY, tile)
    elseif piece.type == "tower" then
        return Tower.isValidMove(startX, startY, endX, endY, tile) and not Movement.hasObstacles(startX, startY, endX, endY, tile)
    elseif piece.type == "knight" then
        return Knight.isValidMove(startX, startY, endX, endY)
    elseif piece.type == "bishop" then
        return Bishop.isValidMove(piece, startX, startY, endX, endY, tile) and not Movement.hasObstacles(startX, startY, endX, endY, tile)
    elseif piece.type == "queen" then
        return Queen.isValidMove(startX, startY, endX, endY, tile) and not Movement.hasObstacles(startX, startY, endX, endY, tile)
    elseif piece.type == "king" then
        if math.abs(startX - endX) == 2 then
            return true
        else
            return King.isValidMove(piece, startX, startY, endX, endY, tile)
        end
    elseif piece.type == "checker" then
        return Checker.isValidMove(piece, startX, startY, endX, endY, tile) and not Movement.hasObstacles(startX, startY, endX, endY, tile)
    end

    return false
end

function canCastle(casKing, casTower, tile, startX, startY, endX)
    -- Перевіряємо, чи король і лад'я не рухалися
    if casKing.hasMoved or casTower.hasMoved then
        print("pieces had moved")
        return false
    end

    -- Визначаємо напрямок рокіровки (ліворуч або праворуч)
    local direction = (endX > startX) and 1 or -1
    local x = startX + direction

    -- Перевіряємо, чи немає перешкод між королем і ладією
    while x ~= endX do
        if tile[x][startY] ~= nil then
            print("not nil")
            return false
        end
        print("nil")
        x = x + direction
    end

    return true
end

