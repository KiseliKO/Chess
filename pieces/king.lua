local Movement = require("movement")

local King = {}

function King.new(color)
    return {
        type = "king",
        color = color,
        cost = 8, -- King is priceless
        hasMoved = false
    }
end

function King.isValidMove(king, startX, startY, endX, endY, tile)
    local dx = math.abs(endX - startX)
    local dy = math.abs(endY - startY)
    return (dx <= 1 and dy <= 1) and not Movement.isFriendlyPiece(endX, endY, tile, king)
end

return King