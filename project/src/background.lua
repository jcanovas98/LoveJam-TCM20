require "data"
local Object = Object or require "lib.classic"
local Background = Object:extend()
local w, h = love.graphics.getDimensions()

function Background:new(speed)
  self.tag = "background"
  self.speed = speed
  self.lines = {5*h/12, 4*h/12, 3*h/12, 2*h/12, h/12, 0} --generar lineas automaticamente, solo num de lineas
  self.varH = 0
  self.varW = 0
  
  hudImage = love.graphics.newImage("spr/lowerHud.png")
  
  spaceImage = love.graphics.newImage("spr/upperBackground.png")
  spaceImage:setFilter("nearest", "nearest") 
  self.animationCeiling = self:NewAnimation(spaceImage, 256, 137, 1)
  
  groundImage = love.graphics.newImage("spr/groundBackground.png")
  groundImage:setFilter("nearest", "nearest") 
  self.animationGround = self:NewAnimation(groundImage, 256, 137, 1/1.5)
end

function Background:update(dt)    
  --Upper background animation--
  self.animationCeiling.currentTime = self.animationCeiling.currentTime + dt
  if self.animationCeiling.currentTime >= self.animationCeiling.duration then
    self.animationCeiling.currentTime = self.animationCeiling.currentTime - self.animationCeiling.duration
  end
  
  self.animationGround.currentTime = self.animationGround.currentTime + dt
  if self.animationGround.currentTime >= self.animationGround.duration then
    self.animationGround.currentTime = self.animationGround.currentTime - self.animationGround.duration
  end
  --speed
  for i = 1, #self.lines do
    self.lines[i] = self.lines[i] + self.speed * dt
  end
  --remove lines
  if (self.lines[1] >= h/2) then 
    linesN = {}
    for i = 1, #self.lines - 1, 1 do
      linesN[i] = self.lines[i+1]
    end
    linesN[#self.lines] = 0
    self.lines = linesN
  end
    --[[
  if self.minH < 100 then
    self.varH = 1
  elseif self.minH > 200 then
    self.varH = -1
  end

  if self.minW <= 100 then
    self.v1 = 2
  elseif self.minW >= 300 then
    self.v1 = -2
  end
  ]]--
  minH = minH + self.varH
  minW = minW + self.varH
  
end

function Background:draw()
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, 0, w, h/2)
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.rectangle("fill", 0, h/2, w, h/2)
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.rectangle("fill", 0, h/2 - minH, w/2 - minW/2, h/2 - minH)
  love.graphics.rectangle("fill",w/2 + minW/2, h/2 - minH, w, h/2 - minW/2)
  
  --width of the line depending distance/height
  lineWidth = 14
  for i = 1, #self.lines do
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setLineWidth(lineWidth)
    cosAlpha = math.deg(math.cos(alpha))
    sinAlpha = math.deg(math.sin(alpha))
    --linea horitzontal
    love.graphics.line(w/2 - self.lines[i] / cosAlpha * sinAlpha - minW/2 ,h/2 + self.lines[i] ,
      w/2 + self.lines[i] /cosAlpha* sinAlpha + minW/2, h/2 + self.lines[i]) --ajustar el ancho min según el grosso de linea
    --linea vertical
    love.graphics.line(w/2 - minW/2 - self.lines[i]/ cosAlpha * sinAlpha, h/2 - minH, 
      w/2 - minW/2 - self.lines[i]/ cosAlpha * sinAlpha, h/2 + self.lines[i])
    
    love.graphics.line(w/2 + minW/2 + self.lines[i]/ cosAlpha * sinAlpha, h/2 - minH, 
      w/2 + minW/2 + self.lines[i]/ cosAlpha * sinAlpha, h/2 + self.lines[i])
    lineWidth = lineWidth - 2
  end
  
  --Upper background--animationGround
  love.graphics.setColor(256,256,256)
  
  local spriteNum1 = math.floor(self.animationCeiling.currentTime / self.animationCeiling.duration * #self.animationCeiling.quads) + 1
  love.graphics.draw(self.animationCeiling.spriteSheet, self.animationCeiling.quads[spriteNum1], 0, 0, 0, 4, 3)
  
  local spriteNum2 = math.floor(self.animationGround.currentTime / self.animationGround.duration * #self.animationGround.quads) + 1
  love.graphics.draw(self.animationGround.spriteSheet, self.animationGround.quads[spriteNum2], 0, h/3 - 125, 0, 4, 5)
  
  love.graphics.draw(hudImage, 0, -20, 0)
end

function Background:NewAnimation(image, width, height, duration)
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

return Background