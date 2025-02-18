local Movement = require("movement")

local Tower = {}

function Tower.new(color)
    return {
        type = "tower",
        color = color,
        cost = 6,
        hasMoved = false
    }
end

function Tower.isValidMove(startX, startY, endX, endY, tile)
    if Movement.isStraightMove(startX, startY, endX, endY) then
        if not Movement.hasObstacles(startX, startY, endX, endY, tile) then
            return true
        end
    end
    return false
end

return Tower