local Player = Object:extend()

function Player:new(name, number, color, faction)
    self.name = name or "NonNamed"
    self.number = number or "1"
    self.color = color or "white"
    self.points = 0
    self.faction = faction or nil
   
end


return Player