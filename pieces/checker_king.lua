local Piece = require "pieces.piece"
local CheckerKing = Piece:extend()

function CheckerKing:new(color, x, y)
    CheckerKing.super.new(self, "checker_king", "Checkers", color, 8, x, y)
end

function CheckerKing:getMoves()
    self.moves = {}

    -- Всі можливі напрямки: по діагоналі, вертикалі та горизонталі
    local directions = {
        {1, 1},   -- Вниз-вправо (діагональ)
        {1, -1},  -- Вгору-вправо (діагональ)
        {-1, 1},  -- Вниз-вліво (діагональ)
        {-1, -1}, -- Вгору-вліво (діагональ)
        {1, 0},   -- Вниз (вертикаль)
        {-1, 0},  -- Вгору (вертикаль)
        {0, 1},   -- Вправо (горизонталь)
        {0, -1}   -- Вліво (горизонталь)
    }

    for _, dir in ipairs(directions) do
        local dx, dy = dir[1], dir[2]
        for i = 1, BoardSize do
            local targetX, targetY = self.x + dx * i, self.y + dy * i

            -- Перевірка, чи цільова клітинка знаходиться в межах дошки
            if targetX < 1 or targetX > BoardSize or targetY < 1 or targetY > BoardSize then
                break
            end

            -- Перевірка, чи на цільовій клітинці стоїть фігура
            if tile[targetX][targetY] then
                -- Якщо це діагональний напрямок і фігура ворожа, перевіряємо, чи можна її перестрибнути
                if (dx ~= 0 and dy ~= 0) and tile[targetX][targetY].color ~= self.color then
                    local jumpX, jumpY = targetX + dx, targetY + dy
                    if jumpX >= 1 and jumpX <= BoardSize and jumpY >= 1 and jumpY <= BoardSize and not tile[jumpX][jumpY] then
                        table.insert(self.moves, {jumpX, jumpY})
                    end
                elseif (targetX == BoardSize or targetX == 1 or targetY == 1 or targetY == BoardSize) and (math.abs(self.x - targetX) == 1 and math.abs(self.y - targetY) == 1) and tile[targetX][targetY] and tile[targetX][targetY].color ~= self.color then
                    table.insert(self.moves, {targetX, targetY})
                end
                break -- Зупиняємо пошук у цьому напрямку після знаходження фігури
            end

            -- Якщо клітинка порожня, додаємо її до можливих ходів
            table.insert(self.moves, {targetX, targetY})
        end
    end

    return self.moves
end

function CheckerKing:move(targetX, targetY)
    -- Переміщуємо короля на нову позицію
    tile[targetX][targetY] = tile[self.x][self.y]
    tile[self.x][self.y] = nil

    -- Перевіряємо, чи це була атака (перестрибування ворожої фігури)
    if math.abs(self.x - targetX) == 2 and math.abs(self.y - targetY) == 2 then
        -- Знаходимо позицію ворожої фігури, яку перестрибнули
        local enemyX = (self.x + targetX) / 2
        local enemyY = (self.y + targetY) / 2

        -- Зараховуємо очки за взяття ворожої фігури
        if tile[enemyX][enemyY] then
            if CurrentPlayer.color == "white" then
                Player1.points = Player1.points + tile[enemyX][enemyY].cost
            else
                Player2.points = Player2.points + tile[enemyX][enemyY].cost
            end
        end

        -- Видаляємо ворожу фігуру з дошки
        tile[enemyX][enemyY] = nil
    else
        -- Якщо це не атака, змінюємо поточного гравця
        CurrentPlayer = CurrentPlayer == Player1 and Player2 or Player1
    end

    -- Оновлюємо позицію короля
    self.x, self.y = targetX, targetY

end

return CheckerKing