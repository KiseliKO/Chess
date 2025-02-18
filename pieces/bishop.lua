local Movement = require("movement")

local Bishop = {}

function Bishop.new(color)
    return {
        type = "bishop",
        color = color,
        cost = 3
    }
end

function Bishop.isValidMove(bishop, startX, startY, endX, endY, tile)
    -- Слон рухається по діагоналі
    if Movement.isDiagonalMove(startX, startY, endX, endY) then
        -- Перевіряємо, чи немає перешкод на шляху
        if not Movement.hasObstacles(startX, startY, endX, endY, tile) then
            -- Перевіряємо, чи клітинка призначення не містить союзної фігури
            return not Movement.isFriendlyPiece(endX, endY, tile, bishop)
        end
    end
    return false
end

return Bishop