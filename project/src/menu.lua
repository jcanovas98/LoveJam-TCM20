local Object = Object or require "lib/classic"
local Timer = Timer or require "src/timer"
local Audio = Audio or require "src/audio"
local Menu = Object:extend()

local w, h = love.graphics.getDimensions()
local buttons = {}

local startGame = false
local transition = false
local optionsPanel = false
local controlsPanel = false

local asteroidRot
local font
local timer = Timer:extend()
local alpha = 0

local background = love.graphics.newImage("spr/background.jpg")
local asteroid = love.graphics.newImage("spr/Meteor1.png")
local asteroids = love.graphics.newImage("spr/Asteroids.png")
local buttonSprite = love.graphics.newImage("spr/button.png")
local interfaceSprite = love.graphics.newImage("spr/interface.png")
local panelSprite = love.graphics.newImage("spr/panelSprite.png")
local t = timer(3, function() transition = true end)


function Menu:new()
  table.insert(buttons, Menu:newButton(" Start", function() startGame = true end))
  table.insert(buttons, Menu:newButton("Options", self.options))
  table.insert(buttons, Menu:newButton("Controls", self.controls))
  table.insert(buttons, Menu:newButton("   Exit", function() love.event.quit(0) end))
  
  self.image = background
  asteroidRot = 0
  
end


function Menu:update(dt)
  menuTrack:play()
  asteroidRot = asteroidRot + 1 * dt
  if (startGame) then
    t:update(dt)
    if alpha <= 3 then
      alpha = alpha + 0.5*dt
    end
  end
  
  
  
    
  
end

function Menu:draw()
  
  love.graphics.draw(self.image, 0, 0, 0, 0.7, 1)
  love.graphics.draw(asteroids, w/2, h/2, math.rad(-30), 3, 3, 256, 144)
  
  local margin = 120
  local buttonW = w/4
  local buttonH = h/7
  local buttonX = w/2 - buttonW/2
  local buttonY = h/2 - buttonH/2 - 50
  font = love.graphics.newFont("Glitch inside.otf", 100)
  love.graphics.draw(interfaceSprite, 0, 0, 0, 1.94, 2)
  love.graphics.print("STAR WARS", font, w/9+15, h/6)
  
  
  font = love.graphics.newFont("Glitch inside.otf", 40)
  for i, button in ipairs(buttons) do
    local mX, mY = love.mouse.getPosition()
    local bX = buttonX
    local bY = buttonY + margin * (i - 1)
    
    
    local select = mX > bX and mX < bX + buttonW and mY > bY and mY < bY + buttonH
    
    if select then
      
      love.graphics.draw(asteroid, bX-60, bY+30, asteroidRot, 0.3, 0.3, 224*0.5, 224*0.5)
      love.graphics.draw(asteroid, bX+buttonW+60, bY+30, asteroidRot+180, 0.3, 0.3, 224*0.5, 224*0.5)
      love.graphics.setColor(1, 1, 1, 1)
    else
      love.graphics.setColor(1,1,1, 0.5)
    end
    
    if love.mouse.isDown(1) and select then
      button.f()
      end
      love.graphics.draw(buttonSprite, buttonX-5, buttonY-20 + margin * (i - 1), 0, 1.5, 1)
  
  love.graphics.setColor(1,1,1)

  
  
  local textW = font:getWidth(button.text)
  local textH = font:getHeight(button.text)
  if i == 3 then
    font = love.graphics.newFont("Glitch inside.otf", 32)
  else
    font = love.graphics.newFont("Glitch inside.otf", 40)
  end
    
  love.graphics.print(button.text, font, w/2 - buttonW/4-20, bY + buttonH/4-15)
  
end
  
  if (optionsPanel) then
    love.graphics.setColor(1,1,1,0.9)
    love.graphics.draw(panelSprite, w/1.61, h/2.6, 0, 0.9, 0.9)
    font = love.graphics.newFont("Glitch inside.otf", 20)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("press enter to close", font, w/1.5+40, h/1.5)
    love.graphics.setColor(1,1,1)
    if love.keyboard.isDown("return") then
      optionsPanel = false
    end
    
  end
  
  if (controlsPanel) then
    love.graphics.setColor(1,1,1,0.9)
    love.graphics.draw(panelSprite, 0, h/2.6, 0, 0.9, 0.9)
    font = love.graphics.newFont("Glitch inside.otf", 25)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("MOVE    -    W A S D", font, 50, h/2.1)
    love.graphics.print("SHOOT  -  SPACE BAR", font, 30, h/1.75)
    font = love.graphics.newFont("Glitch inside.otf", 20)
    love.graphics.print("press enter to close", font, 90, h/1.5)
    love.graphics.setColor(1,1,1)
    if love.keyboard.isDown("return") then
      controlsPanel = false
    end
    
  end
  
  if (startGame) then
    
    love.graphics.setColor(0,0,0,alpha)
    love.graphics.rectangle("fill", 0, 0, 1024, 768)
    love.graphics.setColor(1,1,1,1)
  end
  
  
  
end

function Menu:newButton(text, f)
  return {
  text = text,
  f = f
  }
end

function Menu:getStartGame()
  if (transition) then
    return startGame
  end
end

function Menu:options()
  
  if optionsPanel == false then
    optionsPanel = true
  end
  
end

function Menu:controls()
  if controlsPanel == false then
    controlsPanel = true
  end
end



return Menu