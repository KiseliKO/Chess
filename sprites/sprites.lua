local Sprites = {}

local pieceImages = {
    Chess = {
        white = {
            king = love.graphics.newImage("sprites/white_king.png"),
            queen = love.graphics.newImage("sprites/white_queen.png"),
            bishop = love.graphics.newImage("sprites/white_bishop.png"),
            rook = love.graphics.newImage("sprites/white_tower.png"),
            knight = love.graphics.newImage("sprites/white_knight.png"),
            pawn = love.graphics.newImage("sprites/white_pawn.png"),
        },
        black = {
            king = love.graphics.newImage("sprites/black_king.png"),
            queen = love.graphics.newImage("sprites/black_queen.png"),
            bishop = love.graphics.newImage("sprites/black_bishop.png"),
            rook = love.graphics.newImage("sprites/black_tower.png"),
            knight = love.graphics.newImage("sprites/black_knight.png"),
            pawn = love.graphics.newImage("sprites/black_pawn.png"),
        }
    }
}

return Sprites