local Piece = require "pieces.piece"
local Knight = Piece:extend()

function Knight:new(faction, color, x, y)
    Knight.super.new(self, "knight", faction, color, 3, x, y)
end

function Knight:getMoves(tile)
    local moves = {}

    -- Всі можливі напрямки: вниз, вгору, вправо, вліво
    local directions = {
        {1, 2}, -- Down-right
        {-1, 2}, -- Down-left
        {1, -2}, -- Up-right
        {-1, -2}, -- Up-left
        {2, 1}, -- Right-down
        {-2, 1}, -- Left-down
        {2, -1}, -- Right-up
        {-2, -1} -- Left-up
    }

    for _, dir in ipairs(directions) do
        local dx, dy = dir[1], dir[2]
        local targetX, targetY = self.x + dx, self.y + dy

            -- Перевіряємо межі дошки i чи не стоїть своя фігура
            if tile[targetX] or tile[targetX][targetY] and (tile[targetX][targetY].color ~= self.color) then
                table.insert(moves, {targetX, targetY})
            end
    end

    return moves
end

return Knight