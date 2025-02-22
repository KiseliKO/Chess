local Piece = Object:extend()

function Piece:new(name, faction, color, cost, x, y, moves)
    self.name = name or "NonNamed"
    self.faction = faction or "NonFaction"
    self.color = color or nil
    self.cost = cost or 0
    self.moves = moves or {}
    self.x = x or 0
    self.y = y or 0
    self.hasMoved = false
end

function Piece:move(targetX, targetY)
    tile[targetX][targetY] = tile[self.x][self.y]
    tile[self.x][self.y] = nil
    self.x, self.y = targetX, targetY
    self.hasMoved = true
    currentPlayer = currentPlayer == player1 and player2 or player1
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

function Piece:takePiece(targetX, targetY)
    local targetPiece = tile[targetX][targetY]
    if targetPiece then
        if currentPlayer.color == "white" then
            whitePoints = whitePoints + targetPiece.cost
        else
            blackPoints = blackPoints + targetPiece.cost
        end

        tile[targetX][targetY] = nil
    end
end

return Piece