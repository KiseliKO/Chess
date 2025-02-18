local Movement = {}

-- Перевірка наявності перешкод на шляху
function Movement.hasObstacles(startX, startY, endX, endY, tile)
    local dx = (endX > startX) and 1 or (endX < startX and -1 or 0)
    local dy = (endY > startY) and 1 or (endY < startY and -1 or 0)

    local x, y = startX + dx, startY + dy

    -- Якщо рухаємося по горизонталі або вертикалі
    if startX == endX or startY == endY then
        while x ~= endX or y ~= endY do
            if tile[x][y] ~= nil then
                return true -- Якщо є перешкода
            end
            x = x + dx
            y = y + dy
        end
    else
        -- Діагональний рух (для слона або ферзя)
        while x ~= endX and y ~= endY do
            if tile[x][y] ~= nil then
                return true -- Якщо є перешкода
            end
            x = x + dx
            y = y + dy
        end
    end

    return false
end

-- Перевірка валідності для прямолінійних ходів (тура)
function Movement.isStraightMove(startX, startY, endX, endY)
    return startX == endX or startY == endY
end

-- Перевірка валідності для діагональних ходів (слон)
function Movement.isDiagonalMove(startX, startY, endX, endY)
    return math.abs(endX - startX) == math.abs(endY - startY)
end

-- Перевірка, чи клітинка призначення містить союзну фігуру
function Movement.isFriendlyPiece(x, y, tile, piece)
    if x < 1 or x > 8 or y < 1 or y > 8 then
        return false -- Координати поза межами дошки
    end

    local targetPiece = tile[x][y] -- Виправлено `tile[y][x]`
    return targetPiece ~= nil and targetPiece.color == piece.color
end

--function Movement.queen_moves()
    


return Movement