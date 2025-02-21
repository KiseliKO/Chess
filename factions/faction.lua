local Faction = Object:extend()

function Faction:new(name, color, pieces)
    self.name = name or "NoName"
    self.color = color or nil
    self.pieces = pieces or {}
end

function Faction:looseCondition()
end

return Faction