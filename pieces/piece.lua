local Piece = Object:extend()

function Piece:new(piecename, faction, color, cost, x, y, moves)
    self.piecename = piecename
    self.faction = faction
    self.color = color
    self.cost = cost
    self.moves = moves or {}
    self.x = x or 0
    self.y = y or 0
    local hasMoved = false
end

function Piece:move(targetX, targetY)
    self.x, self.y = targetX, targetY
    local hasMoved = true
end

function Piece:canMove(targetX, targetY)
    -- Перевіряємо, чи цільова клітинка є в списку можливих ходів
    for _, move in ipairs(self.moves) do
        if move[1] == targetX and move[2] == targetY then
            return true
        end
    end
    return false
end

return Piece