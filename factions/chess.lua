local Faction = require "faction"
local Piece = require "piece"
local Movement = require "movement"

function LoadChess (color, tile)
    local pieces = {}

    if color == "white" then
        table.insert(pieces, Piece("queen", color, love.graphics.newImage("sprites/white_queen.png"), 9, tile[5][1], Movement.queen_moves))
        table.insert(pieces, Piece("king", color, love.graphics.newImage("sprites/white_king.png"), 9, tile[4][1], Movement.king_moves))
        table.insert(pieces, Piece("bishop", color, love.graphics.newImage("sprites/white_bishop.png"), 3, tile[3][1], Movement.bishop_moves))
        table.insert(pieces, Piece("bishop", color, love.graphics.newImage("sprites/white_bishop.png"), 3, tile[6][1], Movement.bishop_moves))
        table.insert(pieces, Piece("knight", color, love.graphics.newImage("sprites/white_knight.png"), 3, tile[2][1], Movement.knight_moves))
        table.insert(pieces, Piece("knight", color, love.graphics.newImage("sprites/white_knight.png"), 3, tile[7][1], Movement.knight_moves))
        table.insert(pieces, Piece("rook", color, love.graphics.newImage("sprites/white_rook.png"), 6, tile[1][1], Movement.rook_moves))
        table.insert(pieces, Piece("rook", color, love.graphics.newImage("sprites/white_rook.png"), 6, tile[8][1], Movement.rook_moves))
        for i = 1, 8 do
            table.insert(pieces, Piece("pawn", color, love.graphics.newImage("sprites/white_pawn.png"), 1, tile[i][2], Movement.pawn_moves))
        end
    else
        table.insert(pieces, Piece("queen", color, love.graphics.newImage("sprites/black_queen.png"), 9, tile[5][8], Movement.queen_moves))
        table.insert(pieces, Piece("king", color, love.graphics.newImage("sprites/black_queen.png"), 9, tile[4][1], Movement.king_moves))
        table.insert(pieces, Piece("bishop", color, love.graphics.newImage("sprites/black_bishop.png"), 3, tile[3][8], Movement.bishop_moves))
        table.insert(pieces, Piece("bishop", color, love.graphics.newImage("sprites/black_bishop.png"), 3, tile[6][8], Movement.bishop_moves))
        table.insert(pieces, Piece("knight", color, love.graphics.newImage("sprites/black_knight.png"), 3, tile[2][8], Movement.knight_moves))
        table.insert(pieces, Piece("knight", color, love.graphics.newImage("sprites/black_knight.png"), 3, tile[7][8], Movement.knight_moves))
        table.insert(pieces, Piece("rook", color, love.graphics.newImage("sprites/black_rook.png"), 6, tile[1][8], Movement.rook_moves))
        table.insert(pieces, Piece("rook", color, love.graphics.newImage("sprites/black_rook.png"), 6, tile[8][8], Movement.rook_moves))
        for i = 1, 8 do
            table.insert(pieces, Piece("pawn", color, love.graphics.newImage("sprites/black_pawn.png"), 1, tile[i][7], Movement.pawn_moves))
        end
    end
    return Faction("Chess", color, pieces)
end