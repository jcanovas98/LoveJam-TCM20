local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Enemy = Object:extend()
local w, h = love.graphics.getDimensions()


function Enemy:new(num,image,x,y,time,iscale)
  self.tag = "enemy"
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.speed = speed or 30
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight()
  self.width  = self.image:getWidth()
  
  self.iscalec = iscale
  
  self.xF = self.position.x
  self.yF = self.position.y
  self.xI =  w/2 - minW/2 + self.xF * minW / w
  self.yI = h/2 - minH - minH/2 + self.yF * minH / h
  self.position.x = self.xI
  self.position.y = self.yI
  self.depthR = 0

  self.forward = Vector.new(self.xF - self.xI, self.yF - self.yI)
  self.forward:normalize()
  
  self.dist = math.sqrt(math.pow(self.xF - self.xI, 2) + math.pow(self.yF - self.yI, 2))
  self.speed = self.dist/time
  self.distM = 0 -- distancia recorrida
end

function Enemy:update(dt)
  self.position = self.position + self.forward * self.speed * dt
  
  self.distM = self.dist - math.sqrt(math.pow(self.xF - self.position.x, 2) + math.pow(self.yF - self.position.y, 2))
  self.depthR = self.distM / self.dist
  self.iscale = self.iscalec * (self.depthR)--cons size/px + trigo 
  
  --wif self.depthR > 0.99 then
    
end

function Enemy:draw()
  love.graphics.setColor(self.depthR + 0.25,self.depthR + 0.25,self.depthR + 0.25)
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
  if debug then
    --love.graphics.setLineWidth(1)
    --love.graphics.setColor(0.5, 0, 0)
    --love.graphics.line(self.xI, self.yI, self.xF, self.yF)
    --love.graphics.rectangle("fill", self.position.x - 5, self.position.y - 5, 10, 10)
    --love.graphics.line(self.position.x, self.position.y, self.position.x + self.forward.x * 10, self.position.y + self.forward.y * 10)
  end
  love.graphics.setColor(1,1,1)
end

return Enemy