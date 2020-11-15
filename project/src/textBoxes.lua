local Object = Object or require "lib/classic"
local TextBoxes = Object:extend()

local w, h = love.graphics.getDimensions()
local font
local panelSprite = love.graphics.newImage("spr/panelSprite.png")
local imageSprite = love.graphics.newImage("spr/comandante.jpg")
local text = "pues yo soy mas de star trek"
function TextBoxes:new()
--self.image = image
--self.text = text
end

function TextBoxes:update(dt)

end

function TextBoxes:draw()
  local panelX = w/2+80
  local panelY = h/5-20

  love.graphics.setColor(1,1,1,0.8)
  font = love.graphics.newFont("Glitch inside.otf", 16)
  love.graphics.draw(panelSprite, panelX, panelY, 0, 1, 1)
  love.graphics.draw(imageSprite, panelX+30, panelY+60, 0, 0.4, 0.4)
  love.graphics.print(text, font, panelX+120, panelY+80)
  
end

return TextBoxes
