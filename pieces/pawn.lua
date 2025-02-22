local Piece = require "pieces.piece"
local promoteUI = require "promoteUI"
local Pawn = Piece:extend()

function Pawn:new(faction, color, x, y)
    Pawn.super.new(self, "pawn", faction, color, 1, x, y)
    self.direction = (self.color == "white") and 1 or -1  -- Білий → 1, Чорний → -1
end

function Pawn:getMoves()
    self.moves = {}
    
    
    if tile[self.x][self.y + self.direction] == nil then
            table.insert(self.moves, {self.x, self.y + self.direction})
            if tile[self.x][self.y + self.direction * 2] == nil and self.hasMoved == false then
                table.insert(self.moves, {self.x, self.y + self.direction * 2})
            end
    end

    local diagonalAttack = {-1, 1}
    for _, dx in ipairs(diagonalAttack) do
     
        if tile[self.x + dx] and tile[self.x + dx][self.y + self.direction] and tile[self.x + dx][self.y + self.direction].color ~= self.color then
                table.insert(self.moves, {self.x + dx, self.y + self.direction})
        end
    end

    return self.moves
end

function Pawn:move(targetX, targetY)
    tile[targetX][targetY] = tile[self.x][self.y]
    tile[self.x][self.y] = nil
    self.x, self.y = targetX, targetY
    self.hasMoved = true
    
    if (self.color == "white" and self.y == 8) or (self.color == "black" and self.y == 1) then
        promoteUI.open(self)
    else 
        currentPlayer = currentPlayer == player1 and player2 or player1
    end
end

return Pawn