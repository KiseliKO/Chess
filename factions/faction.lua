local Faction = Object:extend()

function Faction:new(factionname, color, pieces)
    self.factionname = factionname
    self.color = color
    self.pieces = pieces
end

function Faction:looseCondition()
end

return Faction