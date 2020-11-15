local Object = Object or require "lib/classic"
local Pause = Object:extend()

local w, h = love.graphics.getDimensions()
local font
local panelSprite = love.graphics.newImage("spr/panelSprite.png")



function Pause:new()
  
  
end

function Pause:update(dt)
    
    
  
end

function Pause:draw()
  font = love.graphics.newFont("Glitch inside.otf", 20)
  love.graphics.draw(panelSprite, w/4+20, h/3+30, 0, 1, 0.5)
  love.graphics.print("Press enter for resume", font, w/3, h/2-50)
  love.graphics.print("Press scape for quit", font, w/3+20, h/2)
    
end




return Pause