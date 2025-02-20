local Piece = require "pieces.piece"
local King = Piece:extend()

function King:new(faction, color, x, y)
    King.super.new(self, "king", faction, color, 8, x, y)
end

function King:getMoves(tile)
    local moves = {}

    -- Всі можливі напрямки: вниз, вгору, вправо, вліво
    local directions = {
        {0, 1},  -- Вниз
        {0, -1}, -- Вгору
        {1, 0},  -- Вправо
        {-1, 0},  -- Вліво
        {1, 1}, -- Down-right
        {-1, 1}, -- Down-left
        {1, -1}, -- Up-right
        {-1, -1} -- Up-left
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

return King