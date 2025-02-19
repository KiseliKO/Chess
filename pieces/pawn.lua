local Piece = require "piece"
local Pawn = Piece:extend()

function Pawn:new(color, x, y)
    Pawn.super.new(self, "pawn", faction, color, 1, x, y)
    self.direction = (color == "white") and 1 or -1  -- Білий → 1, Чорний → -1
end

function Pawn:getMoves(tile)
    local moves = {}

    -- Хід вперед на 1 клітинку
    if not tile[self.x][self.y + self.direction] then
        table.insert(moves, {self.x, self.y + self.direction})
    end

    -- Подвійний хід на старті
    if (self.y == 2 and self.color == "white") or (self.y == 7 and self.color == "black") then
        if not tile[self.x][self.y + self.direction] and not tile[self.x][self.y + 2 * self.direction] then
            table.insert(moves, {self.x, self.y + 2 * self.direction})
        end
    end

    -- Взяття по діагоналі
    for _, dx in ipairs({-1, 1}) do
        local targetX, targetY = self.x + dx, self.y + self.direction
        if tile[targetX] and tile[targetX][targetY] and tile[targetX][targetY].color ~= self.color then
            table.insert(moves, {targetX, targetY})
        end
    end

    return moves
end

return Pawn