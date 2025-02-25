local Piece = require "pieces.piece"
local CheckerKing = require "pieces.checker_king"
local Checker = Piece:extend()

function Checker:new(faction, color, x, y)
    Checker.super.new(self, "checker", faction, color, 2, x, y)
    self.direction = (self.color == "white") and 1 or -1  -- Білий → 1, Чорний → -1
end

function Checker:getMoves()
    self.moves = {}

    -- Всі можливі напрямки: вниз, вгору, вправо, вліво
    local directions = {
        {0, 1},  -- Вниз
        {0, -1}, -- Вгору
        {1, 0},  -- Вправо
        {-1, 0},  -- Вліво
        {1, 1},
        {-1, 1},
        {1, -1},
        {-1, -1},
        {2, -2},
        {2, 2},
        {-2, -2},
        {-2, 2}
    }

    for _, dir in ipairs(directions) do
        local dx, dy = dir[1], dir[2]   
        local targetX, targetY = self.x + dx, self.y + dy

            if (0 < targetX and targetX <= BoardSize) and (0 < targetY and targetY <= BoardSize) then
                if (math.abs(self.x - targetX) == 2) then
                    if tile[targetX][targetY] == nil and tile[(targetX + self.x) / 2][(targetY + self.y) / 2] and tile[(targetX + self.x) / 2][(targetY + self.y) / 2].color ~= self.color then
                        table.insert(self.moves, {targetX, targetY})
                    end
                elseif tile[targetX][targetY] == nil then 
                    table.insert(self.moves, {targetX, targetY})

                elseif (targetX == BoardSize or targetX == 1 or targetY == 1 or targetY == BoardSize) and (math.abs(self.x - targetX) == 1 and math.abs(self.y - targetY) == 1) and tile[targetX][targetY] and tile[targetX][targetY].color ~= self.color then
                    table.insert(self.moves, {targetX, targetY})
                end
            end
            
    end

    return self.moves
end

function Checker:move(targetX, targetY)
    tile[targetX][targetY] = tile[self.x][self.y]
    tile[self.x][self.y] = nil

    if (self.color == "white" and targetY == 8) or (self.color == "black" and targetY == 1) then
        tile[targetX][targetY] = nil
        local newPiece = CheckerKing(CurrentPlayer.color, targetX, targetY)
        tile[targetX][targetY] = newPiece
        table.insert(CurrentPlayer.pieces, newPiece)
        print("Checker promoted to CheckerKing at:", targetX, targetY)
    end

    if (math.abs(self.x - targetX) == 2) then
        print("true")
        if CurrentPlayer.color == "white" then
            Player1.points = Player1.points + tile[(targetX + self.x) / 2][(targetY + self.y) / 2].cost
        else
            Player2.points = Player2.points + tile[(targetX + self.x) / 2][(targetY + self.y) / 2].cost
        end
        tile[(targetX + self.x) / 2][(targetY + self.y) / 2] = nil

    else
        CurrentPlayer = CurrentPlayer == Player1 and Player2 or Player1
    end
    self.x, self.y = targetX, targetY

    
    

end

return Checker