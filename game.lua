local game = {}

function game.init()
    selectedPiece = nil
    selectedX, selectedY = nil, nil
    draggingPiece = false
    mouseOffsetX, mouseOffsetY = 0, 0
    currentPlayer = nil -- Поточний гравець ("white" або "black")
    gameStarted = false -- Чи гра почалася

    -- Випадково обираємо першого гравця
    math.randomseed(os.time())
    currentPlayer = math.random(2) == 1 and "white" or "black"
    gameStarted = true

    -- Initialize player points
    whitePoints = 0
    blackPoints = 0
end

return game