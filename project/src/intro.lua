local Object = Object or require "lib.classic"
local Intro = Object:extend()
local w, h = love.graphics.getDimensions()

function Intro:new(source)
  self.intro = love.graphics.newVideo(source)
  self.intro:play()
end

function Intro:update(dt)
  
end

function Intro:draw()
  love.graphics.draw(self.intro, w/7, h/5)
end

function Intro:stop()
  self.intro:pause()
end


return Intro