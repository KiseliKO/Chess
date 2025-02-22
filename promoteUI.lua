local Sprites = require "sprites.sprites"
local promoteUI = {}

promoteUI.showPromoteUI = false
local promotion_pieces = {"queen", "rook", "bishop", "knight", "king"}
local uiX, uiY = 100, 100
promoteUI.promotingPawn = nil

function promoteUI.draw()
    if promoteUI.showPromoteUI then

        love.graphics.setColor(0, 0, 0, 0.8) -- Затемнити екран
        love.graphics.rectangle("fill", uiX, uiY, #promotion_pieces * TileSize , TileSize)
        love.graphics.setColor(1, 1, 1)

        for i, piece in ipairs(promotion_pieces) do
            local image = Sprites.PieceImages["Chess"][currentPlayer.color][piece]
            love.graphics.draw(image, uiX + (TileSize * (i - 1)), uiY)
        end
    end
end

function promoteUI.select(mx, my)
    if promoteUI.showPromoteUI then
        -- Координати кнопок вибору
        if (my > uiY and my < (uiY + TileSize)) and (mx > uiX and mx < (uiX + (#promotion_pieces * TileSize))) then
            local index = math.floor((mx - uiX) / TileSize) + 1
            local selectedPiece = promotion_pieces[index]
        
            -- Замінюємо пішака на обрану фігуру
            local newPiece = require("pieces." .. selectedPiece)(
                promoteUI.promotingPawn.faction,
                promoteUI.promotingPawn.color,
                promoteUI.promotingPawn.x,
                promoteUI.promotingPawn.y
            )
            tile[promoteUI.promotingPawn.x][promoteUI.promotingPawn.y] = newPiece
            table.insert(currentPlayer.pieces, newPiece)
            newPiece.hasMoved = true
            promoteUI.promotingPawn = nil
            promoteUI.showPromoteUI = false  -- Закриваємо UI
            currentPlayer = currentPlayer == player1 and player2 or player1
        end
    end
end

function promoteUI.open(pawn)
    promoteUI.promotingPawn = pawn
    promoteUI.showPromoteUI = true
end

return promoteUI