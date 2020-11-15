local Object = Object or require "lib/classic"
local Timer = Timer or require "src/timer"
local TextBoxes = Object:extend()
local timer = Timer:extend()

local w, h = love.graphics.getDimensions()
local font
local panelSprite = love.graphics.newImage("spr/panelSprite.png")
local show = true
local time
local t = Timer()

function TextBoxes:new(image, time, text)
self.image = image
self.text = text
self.time = time
t:new(self.time, function() show = false end, 0)

end
function TextBoxes:update(dt)
  t:update(dt)
end

function TextBoxes:draw()
  local panelX = w/2+80
  local panelY = h/5-20

  if (show) then
    love.graphics.setColor(1,1,1,0.8)
    font = love.graphics.newFont("Glitch inside.otf", 16)
    love.graphics.draw(panelSprite, panelX, panelY, 0, 1, 1)
    love.graphics.draw(self.image, panelX+30, panelY+60, 0, 0.4, 0.4)
    love.graphics.print(self.text, font, panelX+150, panelY+80)
  end

  
end



return TextBoxes
