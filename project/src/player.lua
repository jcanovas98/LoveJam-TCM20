local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Blast = Blast or require "src/blastW"
local Audio = Audio or require "src/audio"
require "data"

local w, h = love.graphics.getDimensions()

local wingW1 = 55
local wingW2 = 55
local wingH1 = -60
local wingH2 = 8
local Player = Object:extend()
local dist = 100

function Player:new(image,x,y,speed,iscale)
  self.tag = "player"
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(1,1)
  self.forward = Vector.new(0, 0)
  self.health = 3
  self.speed = speed or 30
  self.image = love.graphics.newImage(image or nil)
  self.iscale = iscale
  self.origin = Vector.new(self.image:getWidth()/2 ,self.image:getHeight()/2)
  self.height = self.image:getHeight() * iscale
  self.width  = self.image:getWidth() * iscale
  self.timer = 0
  self.chargeShield = false
  self.activateShield = false
  self.chargeSpeed = false
  self.activateSpeed = false
  
  audio = Audio()
  shootSound = audio:getShoot()
end

function Player:update(dt, actorList)
  --Movement
  if love.keyboard.isDown("s") then
    self.forward.y = self.forward.y + 0.1
    if self.activateSpeed then
      self.image = love.graphics.newImage("spr/xwing1_boost.png")
    else
      self.image = love.graphics.newImage("spr/xwing1.png")
    end
  elseif love.keyboard.isDown("w") then
    self.forward.y = self.forward.y - 0.1
  else
    if self.forward.y < 0.2 and self.forward.y > -0.2  then
      self.forward.y = 0
    elseif self.forward.y > 0 then
      self.forward.y = self.forward.y - 0.2
    elseif self.forward.y < 0 then
      self.forward.y = self.forward.y + 0.2
    end
    if self.activateSpeed then
      self.image = love.graphics.newImage("spr/xwing2_boost.png")
    else
      self.image = love.graphics.newImage("spr/xwing2.png")
    end
  end
  
  if love.keyboard.isDown("d") then
    self.forward.x = self.forward.x + 0.1
    if self.activateSpeed then
      self.image = love.graphics.newImage("spr/xwing3i_boost.png")
    else
      self.image = love.graphics.newImage("spr/xwing3i.png")
    end
  elseif love.keyboard.isDown("a") then
    self.forward.x = self.forward.x - 0.1
    if self.activateSpeed then
      self.image = love.graphics.newImage("spr/xwing3d_boost.png")
    else
      self.image = love.graphics.newImage("spr/xwing3d.png")
    end
  else
    if self.forward.x < 0.2 and self.forward.x > -0.2 then
      self.forward.x = 0
    elseif self.forward.x > 0 then
      self.forward.x = self.forward.x - 0.2
    elseif self.forward.x < 0 then
      self.forward.x = self.forward.x + 0.2
    end
  end
  
  --Shoot
  if love.keyboard.isDown("space") and self.timer > 0.5 and (self.forward.x < 0.1 and self.forward.x > -0.1) and (self.forward.y < 0.1 and self.forward.y > -0.1) then
    shootSound:play()
    
    blastNum = blastNum + 1 

    local blast11 = Blast(tostring(blastNum),"spr/blast3_rojo.png", self.position.x - wingW1 - 7,  self.position.y + wingH1 , 2, 0.04, self.position.x, self.position.y)
    actorList[#actorList + 1] = blast11
    blastNum = blastNum + 1
    local blast12 = Blast(tostring(blastNum),"spr/blast3_rojo.png", self.position.x + wingW1,  self.position.y + wingH1 , 2, 0.04, self.position.x, self.position.y)
    actorList[#actorList + 1] = blast12
    blastNum = blastNum + 1
    local blast21 = Blast(tostring(blastNum),"spr/blast3_rojo.png", self.position.x - wingW2 - 7,  self.position.y + wingH2 , 2, 0.04, self.position.x, self.position.y)
    actorList[#actorList + 1] = blast21
    blastNum = blastNum + 1
    local blast22 = Blast(tostring(blastNum),"spr/blast3_rojo.png", self.position.x + wingW2,  self.position.y + wingH2 , 2, 0.04, self.position.x, self.position.y)

    actorList[#actorList + 1] = blast22
    self.timer = 0
  end
  self.timer = self.timer + dt
  
  --Collision
  if (self.position.y >= h - self.height/2 and self.forward.y > 0) or (self.position.y <= h/2 - minH + self.height/2  and self.forward.y < 0) then
    self.forward.y = 0
  end
  if (self.position.x >= w - self.width/2 and self.forward.x > 0) or (self.position.x <= 0 + self.width/2 and self.forward.x < 0) then
    self.forward.x = 0
  end
  self.position = self.position + self.forward * self.speed * dt
end

function Player:draw()
  xI = self.position.x
  yI = self.position.y
  xF =  xI * minW / w + w/2 - minW/2
  yF = (yI - h/2) * minH / (h/2) + (h/2 - minH)
  if debug then
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0.5, 0, 0)
    xF =  self.position.x * minW / w + w/2 - minW/2
    yF = (self.position.y - h/2) * minH / (h/2) + (h/2 - minH)
    if not (love.keyboard.isDown("w") or love.keyboard.isDown("s") or love.keyboard.isDown("a") or love.keyboard.isDown("d")) then
      love.graphics.line(self.position.x - wingW1 - 7, self.position.y + wingH1, xF, yF)
      love.graphics.line(self.position.x + wingW1, self.position.y + wingH1, xF, yF)
      love.graphics.line(self.position.x - wingW2 - 7, self.position.y + wingH2, xF, yF)
      love.graphics.line(self.position.x + wingW2, self.position.y + wingH2, xF, yF)
    end
    --love.graphics.line(xI, yI, xF, yF)
  end
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

function Player:UsePowerups(powerupHud)
  function love.keypressed(key)
    if key == "h" then
      self.health = self.health - 1
    end
    if key == "j" and not self.activateShield and powerupHud.shieldAngle < 270  then
      self.chargeShield = true
    end
    if key == "k" and not self.activateSpeed and powerupHud.speedAngle < 270 then
      self.chargeSpeed = true
    end
    if key == "q" and powerupHud.shieldAngle == 270 then
      self.activateShield = true
    end
    if key == "e" and powerupHud.speedAngle == 270 then
      self.activateSpeed = true
    end
  end
end

function Player:getHealth()
  return self.health
end

function Player:resetHealth()
  self.health = 3
end


return Player