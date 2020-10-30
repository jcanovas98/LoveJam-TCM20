require "data"
local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Blast = Object:extend()
local w, h = love.graphics.getDimensions()

function Blast:new(image,x,y,speed,iscale)
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.speed = speed or 30
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight()
  self.width  = self.image:getWidth()
  
  self.xF =  w/2 - minW/2 + self.position.x * minW / w
  self.yF = h/2 - minH + self.position.y * minH / h

  self.forward = Vector.new(self.xF - self.position.x, self.yF - self.position.y)
  self.forward:normalized()
  
  self.destroyed = false --destruir en la lista de actores
end

function Blast:update(dt)
  self.position = self.position + self.forward * self.speed * dt
  if not self.destroyed then
    self.iscale = self.iscale - 0.0007
  end
  if self.position.y <= self.yF + 2 and self.position.y >= self.yF - 2 and not self.destroyed then
    self.iscale = 0
    self.destroyed = true
  end
end

function Blast:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Blast