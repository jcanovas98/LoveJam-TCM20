local Vector = Vector or require "src/vector"
local Object = Object or require "lib.classic"
local w, h = love.graphics.getDimensions()

local Explosion = Object:extend()

function Explosion:new(x, y)
  self.position = Vector.new(x, y)
  self.tag = "explosion"
  explosion = love.graphics.newImage("spr/explosion.png")
  self.animation = self:NewAnimation(explosion, 300, 300, 1)
  self.width = explosion:getWidth()
  self.height = explosion:getHeight()
end

function Explosion:update(dt, actorList)
  
  self.animation.currentTime = self.animation.currentTime + dt
  if self.animation.currentTime >= self.animation.duration then
    self:destroy(actorList)
    self.animation.currentTime = self.animation.currentTime - self.animation.duration
  end
  
end

function Explosion:draw()
  local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
  love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.position.x, self.position.y, 0, 0.2, 0.2, 150, 150)
end

function Explosion:NewAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};
 
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
 
    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end

function Explosion:destroy(actorList)
    for _,v in ipairs(actorList) do
      if v.tag == self.tag then
        table.remove(actorList, _)
      end
    end
end

return Explosion