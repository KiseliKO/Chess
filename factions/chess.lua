local ChessFaction = Class:extend()
local Queen = require "queen"
local King = require "king"
local Bishop = require "bishop"
local Knight = require "knight"
local Rook = require "rook"
local Pawn = require "pawn"

function ChessFaction:new(color)
    ChessFaction.super.new(self, "Chess", color)
    self.color = color
    self.pieces = self:initializePieces()
end

function ChessFaction:initializePieces()
    -- Створюємо фігури
    local pieces = {
        Queen(self.factionname, self.color, 5, (self.color == "white") and 1 or 8),
        King(self.factionname, self.color, 4, (self.color == "white") and 1 or 8),
        Bishop(self.factionname, self.color, 3, (self.color == "white") and 1 or 8),
        Bishop(self.factionname, self.color, 6, (self.color == "white") and 1 or 8),
        Knight(self.factionname, self.color, 2, (self.color == "white") and 1 or 8),
        Knight(self.factionname, self.color, 7, (self.color == "white") and 1 or 8),
        Rook(self.factionname, self.color, 1, (self.color == "white") and 1 or 8),
        Rook(self.factionname, self.color, 8, (self.color == "white") and 1 or 8)
    }

    for i = 1, boardSize do
        table.insert(pieces, Pawn(self.factionname, self.color, (self.color == "white") and 2 or 7))
    return pieces
    end
end

function ChessFaction:getPieces()
    return self.pieces
end

function ChessFaction:placePieces()
    local startX, startY = nil
    for _, i inpairs(pieces) do
        tile[pieces[i].x][pieces[i].y] = pieces[i]
    end
end

return ChessFaction