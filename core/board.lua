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

function board.draw(BoardSize, TileSize)
    local image
    for x = 1, BoardSize do
        for y = 1, BoardSize do
            if (x + y) % 2 == 0 then
                image = love.graphics.newImage("sprites/tile_grass_light.png")
            else
                image = love.graphics.newImage("sprites/tile_grass_dark.png")
            end
            love.graphics.draw(image, (x - 1) * TileSize, (y - 1) * TileSize)
        end
    end
end

return board