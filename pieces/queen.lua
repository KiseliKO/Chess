local Movement = require("movement")

local Queen = {}

function Queen.new(color)
    return {
        type = "queen",
        color = color,
        cost = 9
    }
end

function Queen.isValidMove(startX, startY, endX, endY, tile)
    if Movement.isStraightMove(startX, startY, endX, endY) or 
       Movement.isDiagonalMove(startX, startY, endX, endY) then
        if not Movement.hasObstacles(startX, startY, endX, endY, tile) then
            return true
        end
    end
    return false
end

return Queen