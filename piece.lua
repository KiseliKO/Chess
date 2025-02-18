local Piece = Object:extend()

function Piece:new(name, color, sprite, cost, startPos, moves)
    self.name = name,
    self.color = color,
    self.sprite = sprite,
    self.cost = cost,
    self.startPos = startPos,
    self.moves = moves
end

function Piece:move(targetX, targetY)
    self.x, self.y = targetX, targetY
end

return Piece