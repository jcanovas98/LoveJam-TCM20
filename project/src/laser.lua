local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Lasers = Object:extend()
local w, h = love.graphics.getDimensions()
local turretX1 = 30
local turretY1 = -20
local destroyed1 = false

local turretX2 = 90
local turretY2 = -25
local destroyed2 = false

local turretX3 = 200
local turretY3 = -30
local destroyed3 = false

local turretX4 = 395
local turretY4 = -35
local destroyed4 = false

local turretW = 1


function Lasers:new(x,y,xf,yf,time, health1, health2, health3, health4)
  if health1 == 0 then
    destroyed1 = true
  end
  if health2 == 0 then
    destroyed2 = true
  end
  if health3 == 0 then
    destroyed3 = true
  end
  if health4 == 0 then
    destroyed4 = true
  end
  
  self.tag = "lasers"
  self.position = Vector.new(x or 0, y or 0)
  self.dist = h/2
  self.xf = xf
  self.yf = yf
  self.done = false
  self.speed = math.sqrt(math.pow(self.position.x + self.xf, 2) + math.pow(self.position.y + self.yf, 2))/time
end

function Lasers:update(dt)
  if self.dist < self.yf then
    self.dist = self.dist + self.speed * dt
  else
    self.done = true
  end
end

function Lasers:draw()
  love.graphics.setColor(0.2, 1, 0.3)
  cosAlpha = math.deg(math.cos(math.rad(2)))
  sinAlpha = math.deg(math.sin(math.rad(2)))
  
  if not destroyed1 then
    love.graphics.polygon("fill", self.position.x - turretX1 - turretW, self.position.y - turretY1, self.position.x - turretX1 + turretW, self.position.y - turretY1, 
    self.position.x + turretW + self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist, self.position.x - turretW - self.dist/cosAlpha* sinAlpha + (self.xf -            self.position.x), self.dist)
  end
  
  if not destroyed2 then
    love.graphics.polygon("fill", self.position.x + turretX2 - turretW, self.position.y - turretY2, self.position.x + turretX2 + turretW, self.position.y - turretY2, 
    self.position.x + turretW + self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist, self.position.x - turretW - self.dist/cosAlpha* sinAlpha + (self.xf -            self.position.x), self.dist)
  end
  
  
  if not destroyed3 then
    love.graphics.polygon("fill", self.position.x + turretX3 - turretW, self.position.y - turretY3, self.position.x + turretX3 + turretW, self.position.y - turretY3, 
    self.position.x + turretW + self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist, self.position.x - turretW - self.dist/cosAlpha* sinAlpha + (self.xf -             self.position.x), self.dist)
  end
  
  if not destroyed4 then
      love.graphics.polygon("fill", self.position.x + turretX4 - turretW, self.position.y - turretY4, self.position.x + turretX4 + turretW, self.position.y - turretY4, 
    self.position.x + turretW + self.dist/cosAlpha* sinAlpha + (self.xf - self.position.x), self.dist, self.position.x - turretW - self.dist/cosAlpha* sinAlpha + (self.xf -            self.position.x), self.dist)
  end
  
  love.graphics.setColor(1, 1, 1)
end

return Lasers