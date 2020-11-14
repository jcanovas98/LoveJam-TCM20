local Object = Object or require "lib.classic"
local Audio = Object:extend()
local w, h = love.graphics.getDimensions()

function Audio:new()
  gameover = love.audio.newSource("spr/gameOver.mp3", "static")
  menuTrack = love.audio.newSource("spr/menu_track.mp3", "stream")
  track1 = love.audio.newSource("spr/track_1.mp3", "stream")
  track2 = love.audio.newSource("spr/track_2.mp3", "stream")
  click = love.audio.newSource("spr/click_sound.mp3", "static")
  shoot = love.audio.newSource("spr/shoot_sound.mp3", "static")
end

function Audio:update(dt)
  
end

function Audio:draw()
  
end


function Audio:getGameover()
  return gameover
end
function Audio:getMenuTrack()
  return menuTrack
end

function Audio:getTrack1()
  return track1
end

function Audio:getTrack2()
  return track2
end

function Audio:getClick()
  return click
end

function Audio:getShoot()
  return shoot
end

return Audio