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
  
  spaceImage = love.graphics.newImage("spr/upperBackground.png")
  spaceImage:setFilter("nearest", "nearest") -- PENDIENTE ARREGLAR BLUR Y RES
  self.animation = self:NewAnimation(spaceImage, 1024, 356, 1)
end

function Background:update(dt)    
  --Upper background animation--
  self.animation.currentTime = self.animation.currentTime + dt
  if self.animation.currentTime >= self.animation.duration then
    self.animation.currentTime = self.animation.currentTime - self.animation.duration
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
  
  --Upper background--
  local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
  love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], 0, 0, 0)
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