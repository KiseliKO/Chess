local board = {}

function board.init(BoardSize)
    local b = {}
    for x = 1, BoardSize do
        b[x] = {}
        for y = 1, BoardSize do
            b[x][y] = nil
        end
    end
    return b
end

function board.draw(BoardSize, TileSize, Lightcolor, DarkColor)
    for x = 1, BoardSize do
        for y = 1, BoardSize do
            if (x + y) % 2 == 0 then
                love.graphics.setColor(Lightcolor)
            else
                love.graphics.setColor(DarkColor)
            end
            love.graphics.rectangle("fill", (x - 1) * TileSize, (y - 1) * TileSize, TileSize, TileSize)
        end
    end
end

return board
