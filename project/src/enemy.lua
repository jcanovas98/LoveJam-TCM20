local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Player = Player or require "src/player"
local Explosion = Explosion or require "src/explosion"
local PowerupHud = PowerupHud or require "src/powerupHud"
local Enemy = Object:extend()
local w, h = love.graphics.getDimensions()

function Enemy:new(num,image,x,y,time,iscale)
  self.tag = "enemy"..num
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.speed = speed or 30
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight() * iscale
  self.width  = self.image:getWidth() * iscale
  
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
  
  self.destroyD = false
end

function Enemy:update(dt, actorList)  
  self.position = self.position + self.forward * self.speed * dt
  
  self.distM = self.dist - math.sqrt(math.pow(self.xF - self.position.x, 2) + math.pow(self.yF - self.position.y, 2))
  self.depthR = self.distM / self.dist
  self.iscale = self.iscalec * (self.depthR)--cons size/px + trigo 
  
  self.height = self.image:getHeight() * self.iscale
  self.width  = self.image:getWidth() * self.iscale
  
  self:playerCollision(dt, actorList, powerupHud)
  
  if self.depthR >= 0.99 then --screen end collision
    self:destroy(actorList)
  end
  self:blastCollision(dt,actorList)
end

function Enemy:draw()
  if debug then
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0.5, 0, 0)
    --love.graphics.line(self.xI, self.yI, self.xF, self.yF)
    --love.graphics.rectangle("fill", self.position.x - 5, self.position.y - 5, 10, 10)
    --love.graphics.line(self.position.x, self.position.y, self.position.x + self.forward.x * 10, self.position.y + self.forward.y * 10)
  end
  love.graphics.setColor(self.depthR + 0.25,self.depthR + 0.25,self.depthR + 0.25)
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
  love.graphics.setColor(1,1,1)
end

function Enemy:blastCollision(dt, actorList)
  for _,v in ipairs(actorList) do
    if v.tag:sub(1,5) == "blast" then
      if math.abs(1 - v.depthR - self.depthR) <= 0.2 then
        if self.position.x + self.width/2 > v.position.x and self.position.x < v.position.x + v.width/2 and 
        self.position.y + self.height/2 > v.position.y and self.position.y < v.position.y + v.height/2 then
          table.remove(actorList, _) --remove blast
          if not player.activateShield then
            player.chargeShield = true
          end
          if not player.activateSpeed then
            player.chargeSpeed = true
          end
          local explosion = Explosion(self.position.x, self.position.y)
          table.insert(actorList, explosion)
          self.destroyD = true
        end
      end
    end
  end
  if self.destroyD then
    self:destroy(actorList)
    --remove all blast before destroying self
  end
end

function Enemy:playerCollision(dt, actorList, powerupHud)
  if self.depthR >= 0.85 and self.depthR < 0.99 then
    for _,v in ipairs(actorList) do
      if v.tag == "player" then
        if self.position.x + self.width/2 > v.position.x and self.position.x < v.position.x + v.width/2 and 
        self.position.y + self.height/2 > v.position.y and self.position.y < v.position.y + v.height/2 then
          self:destroy(actorList) --remove meteor
          if not player.activateShield then
            player.health = player.health - 1
          else
            player.activateShield = false
            powerupHud.shieldAngle = -90
          end
      end
    end
  end
end
end


function Enemy:destroy(actorList)
    for _,v in ipairs(actorList) do
      if v.tag == self.tag then
        table.remove(actorList, _)
      end
    end
end

return Enemy