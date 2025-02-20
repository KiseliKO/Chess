Object = require "classic"
local confModule = require("conf")
local gameModule = require("core.game")

function love.load()
    math.randomseed(os.time())
    confModule.init()
    gameModule.init()
end

function love.draw()
    gameModule.draw()
end

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
