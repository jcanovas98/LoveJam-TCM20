local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Player = Player or require "src/player"
local HealthHud = Object:extend()
local w, h = love.graphics.getDimensions()


function HealthHud:new()
  self.image = love.graphics.newImage("spr/shipIcon.png")
  self.healthAngle = -90
end

function HealthHud:update(dt, player)
  if (player.health == 2) then
    self.healthAngle = 30
  elseif (player.health == 1) then
    self.healthAngle = 150
  elseif (player.health == 0) then
    self.healthAngle = 270
  end
  
end

function HealthHud:draw()
  love.graphics.setColor( 0.1, 0.1, 0.1 )
  love.graphics.arc( "fill", 328, 63, 64, math.rad(-90), math.rad(270))
  love.graphics.setColor( 0, 0.6, 0 )
  love.graphics.arc( "fill", 328, 63, 60, math.rad(self.healthAngle), math.rad(270))
  love.graphics.draw(self.image, 291, 23, 0, 0.15, 0.15)
end

function HealthHud:getHealth()
  return self.health
end

function HealthHud:resetHud()
  self.health = 3
end

return HealthHud