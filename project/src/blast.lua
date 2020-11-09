require "data"
local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Blast = Object:extend()
local w, h = love.graphics.getDimensions()

function Blast:new(image,x,y,time,iscale)
  self.tag = "blast"
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight()
  self.width  = self.image:getWidth()
  
  self.iscalec = iscale
  self.xF =  w/2 - minW/2 + self.position.x * minW / w
  self.yF = h/2 - minH - minH/2 + self.position.y * minH / h

  self.forward = Vector.new(self.xF - self.position.x, self.yF - self.position.y)
  self.forward:normalize()
  
  self.dist = math.sqrt(math.pow(self.xF - self.position.x, 2) + math.pow(self.yF - self.position.y, 2))
  self.speed = self.dist/time
  self.distM = 0 -- distancia recorrida
end

function Blast:update(dt)
  self.position = self.position + self.forward * self.speed * dt
  self.distM = self.dist - math.sqrt(math.pow(self.xF - self.position.x, 2) + math.pow(self.yF - self.position.y, 2))
  
  self.iscale = self.iscalec * (1 - self.distM / self.dist)--cons size/px + trigo
  
  self.height = self.image:getHeight() * self.iscale
  self.width  = self.image:getWidth() * self.iscale
end

function Blast:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Blast