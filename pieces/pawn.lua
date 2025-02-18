local Pawn = {}

function Pawn.new(color)
    return {
        type = "pawn",
        color = color,
        cost = 1,
        hasMoved = false
    }
end

function Pawn.isValidMove(pawn, startX, startY, endX, endY, tile)
    local direction = (pawn.color == "white") and 1 or -1
    local startRow = (pawn.color == "white") and 2 or 7

    -- Standard move (1 square forward)
    if startX == endX and endY == startY + direction then
        return tile[endX][endY] == nil
    end

    -- Initial two-square move
    if startX == endX and endY == startY + 2 * direction and startY == startRow then
        return tile[endX][endY] == nil and tile[endX][startY + direction] == nil
    end

    -- Capture move (diagonally)
    if math.abs(endX - startX) == 1 and endY == startY + direction then
        return tile[endX][endY] ~= nil and tile[endX][endY].color ~= pawn.color
    end

    return false
end

return Pawn