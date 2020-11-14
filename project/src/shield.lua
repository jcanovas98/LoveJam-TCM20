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
  self.fullScale = Vector.new(0.38, 0.38)
  self.scale = self.iniScale
  self.shieldRot = 0
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
  
  if love.keyboard.isDown("d") then
    self.shieldRot = 20
  elseif love.keyboard.isDown("a") then
    self.shieldRot = -20
  else
    self.shieldRot = 0
  end

end

function Shield:draw()
  --SHIELD EFFECT--
  if player.activateShield or self.scale > self.iniScale then
    love.graphics.draw(self.shieldVFX, player.position.x - 3, player.position.y, math.rad(self.shieldRot), self.scale.x, self.scale.y, 278, 278)
  end
  
end

return Shield