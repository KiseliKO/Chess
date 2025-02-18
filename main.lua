Object = require "classic"
local boardModule = require("board")
local Pawn = require("pieces.pawn")
local Queen = require("pieces.queen")
local Bishop = require("pieces.bishop")
local Tower = require("pieces.tower")
local Knight = require("pieces.knight")
local King = require("pieces.king")`
local Checker = require("pieces.checker")
local Movement = require("movement")

-- love.load is called once at the start
function love.load()
    love.window.setMode(800, 600, {resizable=true, vsync=0, minwidth=400, minheight=300})
    -- tile settings
    BoardSize = 8
    TileSize = 60 -- Each tile is 80x80 pixels
    
    -- colors
    Lightcolor = { 1, 1, 1 }               -- White tiles
    Darkcolor = { 0.45, 0.45, 0.45 }          -- Black tiles

    -- Initialize the tile
    tile = boardModule.init(BoardSize)

    -- Додаємо короля
    --tile[4][1] = King.new("white")  -- Білий король
    tile[4][8] = King.new("black")  -- Чорний король
    -- Додаємо ферзів
    --tile[5][1] = Queen.new("white") -- Білий ферзь
    tile[5][8] = Queen.new("black") -- Чорний ферзь
    -- Додаємо cлонів
    --tile[6][1] = Bishop.new("white") -- Білий слон
    --tile[3][1] = Bishop.new("white") -- Білий слон
    tile[6][8] = Bishop.new("black") -- Чорний слон
    tile[3][8] = Bishop.new("black") -- Чорний слон
    -- Додаємо ладії
    --tile[1][1] = Tower.new("white") -- Біла лад'я
    --tile[8][1] = Tower.new("white") -- Біла лад'я
    tile[1][8] = Tower.new("black") -- Чорна лад'я
    tile[8][8] = Tower.new("black") -- Чорна лад'я
    -- Додаємо коней
    --tile[2][1] = Knight.new("white") -- Біла лад'я
    --tile[7][1] = Knight.new("white") -- Біла лад'я
    tile[2][8] = Knight.new("black") -- Чорна лад'я
    tile[7][8] = Knight.new("black") -- Чорна лад'я

    for x = 1, BoardSize do
        --tile[x][2] = Pawn.new("white") -- White pawns
        tile[x][7] = Pawn.new("black") -- Black pawns
    end

    for y = 1, 3 do
        for x = 1, BoardSize do
            tile [x][y] = Checker.new("white")
        end
        y = y + 1
    end

    selectedPiece = nil
    selectedX, selectedY = nil, nil
    draggingPiece = false
    mouseOffsetX, mouseOffsetY = 0, 0
    currentPlayer = nil -- Поточний гравець ("white" або "black")
    gameStarted = false -- Чи гра почалася

    -- Випадково обираємо першого гравця
    math.randomseed(os.time())
    currentPlayer = math.random(2) == 1 and "white" or "black"
    gameStarted = true

    -- Завантажуємо окремі зображення для фігур
    pieceImages = {
        white = {
            king = love.graphics.newImage("sprites/white_king.png"),
            queen = love.graphics.newImage("sprites/white_queen.png"),
            bishop = love.graphics.newImage("sprites/white_bishop.png"),
            tower = love.graphics.newImage("sprites/white_tower.png"),
            knight = love.graphics.newImage("sprites/white_knight.png"),
            pawn = love.graphics.newImage("sprites/white_pawn.png"),
            checker = love.graphics.newImage("sprites/white_checker.png"),
        },
        black = {
            king = love.graphics.newImage("sprites/black_king.png"),
            queen = love.graphics.newImage("sprites/black_queen.png"),
            bishop = love.graphics.newImage("sprites/black_bishop.png"),
            tower = love.graphics.newImage("sprites/black_tower.png"),
            knight = love.graphics.newImage("sprites/black_knight.png"),
            pawn = love.graphics.newImage("sprites/black_pawn.png"),
        }
    }

    -- Initialize player points
    whitePoints = 0
    blackPoints = 0

    -- Define abilities and their costs
    abilities = {
        { name = "Extra Move", cost = 3 },
        { name = "Shield (Protect a Piece)", cost = 6 },
        { name = "Revive Piece", cost = 10 },
        { name = "Destroy Opponent Piece", cost = 15 }
    }
end

-- love.draw is called every frame to render
function love.draw()
    -- Draw the board
    boardModule.draw(BoardSize, TileSize, Lightcolor, Darkcolor)

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

                if    
                -- Оновлюємо позицію фігури
                tile[selectedX][selectedY] = nil
                tile[x][y] = selectedPiece

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

    if key == "0" then
        activateAbility(1, currentPlayer)
    elseif key == "2" then
        activateAbility(2, currentPlayer)
    elseif key == "3" then
        activateAbility(3, currentPlayer)
    elseif key == "4" then
        activateAbility(4, currentPlayer)
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

