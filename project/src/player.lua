local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Player = Object:extend()


function Player:new(image,x,y,speed,iscale)
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.forward = Vector.new(0, 0)
  self.speed = speed or 30
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight()
  self.width  = self.image:getWidth()
end

function Player:update(dt)
  --reprogramar movimiento con aceleración
  if love.keyboard.isDown("s") then
    self.forward.y = 1
  elseif love.keyboard.isDown("w") then
    self.forward.y = -1
  else
    self.forward.y = 0
  end
  
  if love.keyboard.isDown("d") then
    self.forward.x = 1
  elseif love.keyboard.isDown("a") then
    self.forward.x = -1
  else
    self.forward.x = 0
  end
  
  self.position = self.position + self.forward * self.speed * dt
end

function Player:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Player