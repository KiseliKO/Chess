local Faction = require "factions.faction"
local ChessFaction = Faction:extend()
local Queen = require "pieces.queen"
local King = require "pieces.king"
local Bishop = require "pieces.bishop"
local Knight = require "pieces.knight"
local Rook = require "pieces.rook"
local Pawn = require "pieces.pawn"

function ChessFaction:new(color)
    ChessFaction.super.new(self, "Chess", color)
    self.color = color
    self.pieces = self:initializePieces()
end

function ChessFaction:initializePieces()
    -- Створюємо фігури
    local pieces = {
        Queen(self.name, self.color, 5, (self.color == "white") and 1 or 8),
        King(self.name, self.color, 4, (self.color == "white") and 1 or 8),
        Bishop(self.name, self.color, 3, (self.color == "white") and 1 or 8),
        Bishop(self.name, self.color, 6, (self.color == "white") and 1 or 8),
        Knight(self.name, self.color, 2, (self.color == "white") and 1 or 8),
        Knight(self.name, self.color, 7, (self.color == "white") and 1 or 8),
        Rook(self.name, self.color, 1, (self.color == "white") and 1 or 8),
        Rook(self.name, self.color, 8, (self.color == "white") and 1 or 8)
    }

    for i = 1, BoardSize do
        table.insert(pieces, Pawn(self.name, self.color, i, (self.color == "white") and 2 or 7))
    end
    return pieces
end

function ChessFaction:getPieces()
    return self.pieces
end


return ChessFaction