local Piece = require "pieces.piece"
local King = Piece:extend()

function King:new(faction, color, x, y)
    King.super.new(self, "king", faction, color, 8, x, y)
end

function King:getMoves()
    self.moves = {}

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

            if (0 < targetX and targetX <= BoardSize) and (0 < targetY and targetY <= BoardSize) then
                if tile[targetX][targetY] and tile[targetX][targetY].color ~= self.color then 
                    table.insert(self.moves, {targetX, targetY})
                elseif tile[targetX][targetY] == nil then
                    table.insert(self.moves, {targetX, targetY})
                end
            end
            
    end

    if self:canCastle("left") then
        table.insert(self.moves, {2, self.y})
    end
    if self:canCastle("right") then
        table.insert(self.moves, {6, self.y})
    end

    return self.moves
end

function King:canCastle(direction)
    local startCol, endCol
    local rookCol

    if direction == "left" then
        startCol, endCol = 2, 3  -- Перевіряємо клітинки між королем і турою
        rookCol = 1              -- Колонка тури
    elseif direction == "right" then
        startCol, endCol = 5, 7  -- Для правої рокіровки
        rookCol = 8
    else
        return false  -- Невірний напрямок
    end

    -- Перевіряємо, чи є перешкоди
    for i = startCol, endCol do
        if tile[i][self.y] ~= nil then
            return false
        end
    end

    -- Перевіряємо, чи король і тура не рухалися
    if not self.hasMoved and tile[rookCol][self.y] and not tile[rookCol][self.y].hasMoved then
        return true
    end

    return false
end

function King:move(targetX, targetY)
    tile[targetX][targetY] = tile[self.x][self.y]
    tile[self.x][self.y] = nil
    self.x, self.y = targetX, targetY
    if self.hasMoved == false and ((targetX == 2) or (targetX == 6)) then
        if targetX == 2 then
            tile[3][self.y] = tile[1][self.y]
            tile[3][self.y].x, tile[3][self.y].y = 3, self.y
            tile[1][self.y] = nil
        else
            tile[5][self.y] = tile[8][self.y]
            tile[5][self.y].x, tile[5][self.y].y = 5, self.y
            tile[8][self.y] = nil
        end
    end
    self.hasMoved = true
    CurrentPlayer = CurrentPlayer == Player1 and Player2 or Player1
end

return King