local Object = Object or require "lib.classic"
local Audio = Audio or require "src/audio"
local Gameover = Object:extend()

local w, h = love.graphics.getDimensions(5)
local alreadyPlayed = false
local audio = Audio()
local font1 = love.graphics.newFont("Starjhol.ttf", 100)
local font2= love.graphics.newFont("Starjedi.ttf", 100)
local retry = false
local timer
local blinkTimer
local alpha1 = 0
local alpha2 = 256

function Gameover:new()
  --self.image = love.graphics.newImage("spr/gameover.jpg")
  gameoverTrack = audio:getGameover()
  self.timer = 0
  self.blinkTimer = 0
end

function Gameover:update(dt)
  if (not self.alreadyPlayed) then
    gameoverTrack:play()
    self.alreadyPlayed = true
  end
  
  if self.timer > 4 then
    if love.keyboard.isDown ("return") then
      self.retry = true
    end
    
    if love.keyboard.isDown ("escape") then
      love.event.quit(0)
    end
    
    if self.blinkTimer > 1.75 and self.blinkTimer < 3.25 then
      alpha2 = 0
    end
      
    if self.blinkTimer > 3.25 then
      alpha2 = 256
      self.blinkTimer = 0
    end
  self.blinkTimer = self.blinkTimer + dt
  end

  alpha1 = alpha1 + dt
  self.timer = self.timer + dt
end

function Gameover:draw()
  love.graphics.setColor(256,0,0, alpha1)
  --love.graphics.draw(self.image, -130, -50, 0, 1, 1)
  love.graphics.print("mission failed", font1, w/6 - 60, h/3, 0, 1, 1)
  
  love.graphics.setColor(256,256,256, alpha2)
  if self.timer > 4 then
    love.graphics.print("Press enter to retry", font2, w / 3 - 40 , h / 2 + 160, 0, 0.35, 0.35)
    love.graphics.print("Press esc to exit", font2, w / 3 + 5 , h / 2 + 200, 0, 0.35, 0.35)
  end
end

function Gameover:getRetry()
  return self.retry
end

function Gameover:setRetry()
  self.retry = false
  self.alreadyPlayed = false
  self.timer = 0
end
return Gameover

