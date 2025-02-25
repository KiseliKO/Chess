local Player = require "player"
local ChessFaction = require "factions.chess"
local CheckersFaction = require "factions.checkers"
local game = require "core.game"

local factionUI = {
    currentPlayer = 1, -- Поточний гравець, який вибирає фракцію (1 або 2)
    selectedFaction = nil, -- Вибрана фракція для поточного гравця
    player1Faction = nil, -- Фракція гравця 1
    player2Faction = nil, -- Фракція гравця 2
    options = {"Chess", "Checkers"}, -- Варіанти фракцій
    buttonWidth = 200, -- Ширина кнопок
    buttonHeight = 50, -- Висота кнопок
    buttonSpacing = 20 -- Відстань між кнопками
}
function factionUI.draw()
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Відображення заголовка
    love.graphics.setColor(1, 1, 1) -- Білий колір
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf("Player " .. factionUI.currentPlayer .. ": Select Faction", 0, screenHeight / 4, screenWidth, "center")

    -- Відображення кнопок
    local buttonY = screenHeight / 2 - (factionUI.buttonHeight + factionUI.buttonSpacing) / 2
    for i, option in ipairs(factionUI.options) do
        local buttonX = screenWidth / 2 - factionUI.buttonWidth / 2
        local buttonY = buttonY + (i - 1) * (factionUI.buttonHeight + factionUI.buttonSpacing)

        -- Колір кнопки
        if factionUI.selectedFaction == option then
            love.graphics.setColor(0, 1, 0) -- Зелений колір для вибраної кнопки
        else
            love.graphics.setColor(0.5, 0.5, 0.5) -- Сірий колір для інших кнопок
        end

        -- Відображення кнопки
        love.graphics.rectangle("fill", buttonX, buttonY, factionUI.buttonWidth, factionUI.buttonHeight)

        -- Текст кнопки
        love.graphics.setColor(1, 1, 1) -- Білий колір тексту
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf(option, buttonX, buttonY + factionUI.buttonHeight / 4, factionUI.buttonWidth, "center")
    end
end

function factionUI.select(mx, my)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local buttonY = screenHeight / 2 - (factionUI.buttonHeight + factionUI.buttonSpacing) / 2
    for i, option in ipairs(factionUI.options) do
        local buttonX = screenWidth / 2 - factionUI.buttonWidth / 2
        local buttonY = buttonY + (i - 1) * (factionUI.buttonHeight + factionUI.buttonSpacing)

        -- Перевірка, чи натиснуто на кнопку
        if mx >= buttonX and mx <= buttonX + factionUI.buttonWidth and
           my >= buttonY and my <= buttonY + factionUI.buttonHeight then
            factionUI.selectedFaction = option

            -- Зберігаємо вибір для поточного гравця
            if factionUI.currentPlayer == 1 then
                factionUI.player1Faction = option
                factionUI.currentPlayer = 2 -- Перехід до вибору другого гравця
                factionUI.selectedFaction = nil -- Скидання вибору
            else
                factionUI.player2Faction = option

                if factionUI.player1Faction == "Chess" then
                    Player1 = Player("player 1", 1, "white", ChessFaction("white"))
                else
                    Player1 = Player("player 1", 1, "white", CheckersFaction("white"))
                end
            
                if factionUI.player2Faction == "Chess" then
                    Player2 = Player("player 2", 2, "black", ChessFaction("black"))
                else
                    Player2 = Player("player 2", 2, "black", CheckersFaction("black"))
                end
            
                -- Initialize player points
                Player1.faction:placePieces()
                Player2.faction:placePieces()

                CurrentPlayer = math.random(2) == 1 and Player1 or Player2

                game.state["faction"] = false
                game.state["running"] = true

                print("Player 1 selected:", factionUI.player1Faction)
                print("Player 2 selected:", factionUI.player2Faction)
            end
        end
    end
end

return factionUI