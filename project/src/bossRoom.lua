require "data"
local Object = Object or require "lib.classic"
local FinalBoss = FinalBoss or require "src/finalBoss"
local BossRoom = Object:extend()
local w, h = love.graphics.getDimensions()
local time = 0

function BossRoom:new(speed)
  self.hudImage = love.graphics.newImage("spr/lowerHud.png")
  self.bossRoomImage = love.graphics.newImage("spr/background.jpg")
  self.jump1 = love.graphics.newImage("spr/jump1.jpg")
  self.jump2 = love.graphics.newImage("spr/jump2.png")
  self.venator = love.graphics.newImage("spr/venator.png")
  self.battleship = love.graphics.newImage("spr/battleship.png")
  self.alpha1 = 1.5
  self.alpha2 = 1.5
  self.alpha3 = 1.5
  self.endingTimer = 0
  self.ending = false
end

function BossRoom:update(dt, allDestroyed)
  if allDestroyed then

    self.ending = true
    self.endingTimer = self.endingTimer + dt
    if self.endingTimer > 1 then
      self.alpha1 = self.alpha1 - dt
    end
    if self.endingTimer > 1.5 then
      self.alpha2 = self.alpha2 - dt
    end
    if self.endingTimer > 1.7 then
      self.alpha3 = self.alpha3 - dt
    end
    
  end
  
end

function BossRoom:draw()
  love.graphics.draw(self.bossRoomImage)
  love.graphics.draw(self.hudImage, 0, -20, 0)
  
  if self.ending then
    if self.endingTimer > 1 then
      love.graphics.setColor(1,1,1,self.alpha1)
      love.graphics.draw(self.jump1, -400, 120)
    end
    
    if self.endingTimer > 1.3 then
      love.graphics.setColor(1,1,1)
      love.graphics.draw(self.venator, 90, 480)
      end
    
    if self.endingTimer > 1.5 then
      love.graphics.setColor(1,1,1,self.alpha2)
      love.graphics.draw(self.jump2, 470 , 190)
    end
    
    if self.endingTimer > 1.7 then
      love.graphics.setColor(1,1,1)
      love.graphics.draw(self.battleship, 660, 320)
      love.graphics.setColor(1,1,1, self.alpha3)
      love.graphics.draw(self.jump1, -50, -180)
      love.graphics.draw(self.jump1, -100, -9)
    end
  
    if self.endingTimer > 2 then
      love.graphics.setColor(1,1,1)
      love.graphics.draw(self.venator, 450, 150)
      love.graphics.draw(self.venator, 390, 320)
      end
  end
  
end

function BossRoom:NewAnimation(image, width, height, duration)
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

return BossRoom