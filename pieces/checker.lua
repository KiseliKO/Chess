local Movement = require("movement")
local Checker = {}

function Checker.new(color)
    return {
        type = "checker",
        color = color,
        cost = 2,
    }
end

function Checker.isValidMove(checker, startX, startY, endX, endY, tile)
    local dx = math.abs(endX - startX)
    local dy = math.abs(endY - startY)
    local midX = math.abs(endX + startX) / 2
    local midY = math.abs(endY + startY) / 2

    -- Capture move (diagonally)
    if (dx == 2 and dy == 2) and tile[midX][midY] ~= nil and (tile[midX][midY].color ~= checker.color) and tile[endX][endY] == nil then
        local points = tile[midX][midY].cost or 0
        
        tile[midX][midY] = nil
        
        if currentPlayer == "white" then
            whitePoints = whitePoints + points
        else
            blackPoints = blackPoints + points
        end

        return true
    else
        -- any directional move
        return (dx <= 1 and dy <= 1) and tile[endX][endY] == nil
    end
end

return Checker