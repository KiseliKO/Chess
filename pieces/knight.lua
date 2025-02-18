local Knight = {}

function Knight.new(color)
    return {
        type = "knight",
        color = color,
        cost = 3
    }
end

function Knight.isValidMove(startX, startY, endX, endY)
    local dx = math.abs(endX - startX)
    local dy = math.abs(endY - startY)
    return (dx == 2 and dy == 1) or (dx == 1 and dy == 2)
end

return Knight