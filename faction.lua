local Faction = Object:extend()

function Faction:new(name, color, pieces)
    self.name = name,
    self.color = color,
    self.pieces = pieces
end

function Faction:looseCondition()
end

return Faction