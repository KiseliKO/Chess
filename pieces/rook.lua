local Piece = require "pieces.piece"
local Rook = Piece:extend()

function Rook:new(faction, color, x, y)
    Rook.super.new(self, "rook", faction, color, 6, x, y)
end

function Rook:getMoves()
    self.moves = {}

    -- Всі можливі напрямки: вниз, вгору, вправо, вліво
    local directions = {
        {0, 1},  -- Вниз
        {0, -1}, -- Вгору
        {1, 0},  -- Вправо
        {-1, 0}  -- Вліво
    }

    for _, dir in ipairs(directions) do
        local dx, dy = dir[1], dir[2]
        for i = 1, BoardSize do
            local targetX, targetY = self.x + dx * i, self.y + dy * i

            if (0 >= targetX or targetX > BoardSize) or (0 >= targetY or targetY > BoardSize) then
                break
            end

            if tile[targetX][targetY] and tile[targetX][targetY].color == self.color then
                break
            end

            table.insert(self.moves, {targetX, targetY})

            -- Якщо тут стоїть ворожа фігура, зупиняємось
            if tile[targetX][targetY] and tile[targetX][targetY].color ~= self.color then
                break
            end
        end
    end

    return self.moves
end

return Rook