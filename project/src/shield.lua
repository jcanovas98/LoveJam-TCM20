local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Player = Player or require "src/player"
local Shield = Object:extend()
local w, h = love.graphics.getDimensions()


function Shield:new()
  --SHIELD POWERUP--
  self.shieldVFX = love.graphics.newImage("spr/shieldVFX.png")
  
  self.incrementScale = Vector.new(0.01, 0.01)
  self.iniScale = Vector.new(0, 0)
  self.fullScale = Vector.new(0.37, 0.37)
  self.scale = self.iniScale
end

function Shield:update(dt, player)
  --SHIELD--
  if player.activateShield then
    if self.scale < self.fullScale then
      self.scale = self.scale + self.incrementScale
    end
  else
    if self.scale > self.iniScale then
      self.scale = self.scale - self.incrementScale
    end
  end

end

function Shield:draw()
  --SHIELD EFFECT--
  if player.activateShield or self.scale > self.iniScale then
    love.graphics.draw(self.shieldVFX, player.position.x - 105, player.position.y - 90, 0, self.scale.x, self.scale.y)
  end
  
end

return Shield