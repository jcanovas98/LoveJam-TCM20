local Object = Object or require "lib/classic"
local IntroCampaña = Object:extend()

local w, h = love.graphics.getDimensions()
local font
local up = 0

function IntroCampaña:new()
  
  
end

function IntroCampaña:update(dt)
    up = up+50*dt
   
  
end

function IntroCampaña:draw()
  font = love.graphics.newFont("Starjedi.ttf", 45)
  love.graphics.setColor(1,1,0)
  love.graphics.print("buenos dias por la mañana\n \t\t\t o no\n\n\n \t\t ya veremos", font, w/7, h-up, 0, 1, 1)
    
end




return IntroCampaña