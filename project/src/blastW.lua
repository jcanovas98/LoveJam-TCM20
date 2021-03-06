require "data"
local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Blast = Object:extend()
local w, h = love.graphics.getDimensions()

function Blast:new(num,image,x,y,time,iscale, xC, yC)
  self.tag = "blast"..num
  self.x = x
  self.y = y
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight() * iscale
  self.width  = self.image:getWidth() * iscale
  
  self.iscalec = iscale
  --punto donde se centran las balas
  self.xC = xC
  self.yC = yC
  self.centered = false
  --punto final
  self.xF =  xC * minW / w + w/2 - minW/2
  self.yF = (yC - h/2) * minH / (h/2) + (h/2 - minH)
  
  self.forward = Vector.new(self.xF - self.position.x, self.yF - self.position.y)
  self.forward:normalize()
  
  self.dist = math.sqrt(math.pow(self.xF - self.position.x, 2) + math.pow(self.yF - self.position.y, 2))
  self.speed = self.dist/time
  self.distM = 0 -- distancia recorrida
  self.depthR = 0
end

function Blast:update(dt, actorList)
  self.position = self.position + self.forward * self.speed * dt
  
  self.distM = self.dist - math.sqrt(math.pow(self.xF - self.position.x, 2) + math.pow(self.yF - self.position.y, 2))
  self.depthR = self.distM / self.dist
  self.iscale = self.iscalec * (1 - self.depthR)--cons size/px + trigo
  
  self.height = self.image:getHeight() * self.iscale
  self.width  = self.image:getWidth() * self.iscale
  
  self:tunelEndCollision(actorList)
end

function Blast:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
  if debug then
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0.5, 0, 0)
    --love.graphics.line(self.x, self.y, self.xF, self.yF)
    --love.graphics.line(self.position.x, self.position.y, self.position.x + self.forward.x * 2, self.position.y + self.forward.y * 2)
  end
    love.graphics.setColor(1, 1, 1)
end

function Blast:tunelEndCollision(actorList)
  if (self.position.y <= self.yF + 3 and self.position.y >= self.yF - 3) and (self.position.x <= self.xF + 3 and self.position.x >= self.xF - 3) or self.position.y <= h/2 then
    self:destroy(actorList)
  end
end

function Blast:destroy(actorList)
  for _,v in ipairs(actorList) do
    if v.tag == self.tag then
      table.remove(actorList, _)
    end
  end
end

return Blast