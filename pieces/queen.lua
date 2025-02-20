local Piece = require "pieces.piece"
local Queen = Piece:extend()

function Queen:new(faction, color, x, y)
    Queen.super.new(self, "queen", faction, color, 8, x, y)
end

function Queen:getMoves(tile)
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
        for i = 1, BoardSize do
            local targetX, targetY = self.x + dx * i, self.y + dy * i

            -- Перевіряємо межі дошки
            if not tile[targetX] or not tile[targetX][targetY] then
                break
            end

            -- Перевіряємо, чи можемо рухатися в цю клітинку
            if tile[targetX][targetY].color == self.color then
                break
            end

            table.insert(moves, {targetX, targetY})

            -- Якщо тут стоїть ворожа фігура, зупиняємось
            if tile[targetX][targetY] then
                break
            end
        end
    end

    return moves
end

return Queen