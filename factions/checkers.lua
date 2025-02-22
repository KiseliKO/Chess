local Faction = require "factions.faction"
local CheckersFaction = Faction:extend()
local Checker = require "pieces.checker"

function CheckersFaction:new(color)
    CheckersFaction.super.new(self, "Checkers", color)
    self.color = color
    self.pieces = self:initializePieces()
end

function CheckersFaction:initializePieces()
    -- Створюємо фігури
    local pieces = {}

    for x = 1, BoardSize do
        table.insert(pieces, Checker(self.name, self.color, x, (self.color == "white") and 1 or 8))
        table.insert(pieces, Checker(self.name, self.color, x, (self.color == "white") and 2 or 7))
        table.insert(pieces, Checker(self.name, self.color, x, (self.color == "white") and 3 or 6))
    end
    return pieces
    
end

function CheckersFaction:getPieces()
    return self.pieces
end

function CheckersFaction:placePieces()
    for _, piece in ipairs(self.pieces) do
        tile[piece.x][piece.y] = piece
    end
   
end

return CheckersFaction