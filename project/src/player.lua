local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Blast = Blast or require "src/blastW"
local wingW = 70
local wingH1 = -45
local wingH2 = 5
local Player = Object:extend()
local dist = 100

function Player:new(image,x,y,speed,iscale)
  self.tag = "player"
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

function Player:update(dt, actorList)
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
  
  if love.keyboard.isDown("space") then --delay al disparar
    local blast11 = Blast:extend()
    blast11:new("spr/blast.png", self.position.x - wingW,  self.position.y + wingH1 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast11)
    local blast12 = Blast:extend()
    blast12:new("spr/blast.png", self.position.x + wingW,  self.position.y + wingH1 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast12)
    local blast21 = Blast:extend()
    blast21:new("spr/blast.png", self.position.x - wingW,  self.position.y + wingH2 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast21)
    local blast22 = Blast:extend()
    blast22:new("spr/blast.png", self.position.x + wingW,  self.position.y + wingH2 , 2, 0.05, self.position.x, self.position.y)
    table.insert(actorList, blast22)
  end
  
  self.position = self.position + self.forward * self.speed * dt
end

function Player:draw()
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, self.iscale, self.iscale, self.origin.x, self.origin.y)
end

return Player