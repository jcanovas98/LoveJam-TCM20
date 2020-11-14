local Object = Object or require "lib.classic"
local ScoreHud = Object:extend()
local w, h = love.graphics.getDimensions(5)
--local file = io.open("savegame.txt", "r+")
local score
local loadScore


function ScoreHud:new()
 -- io.input(file)
  self.saveGame = {}
  self.file = "savegame.txt"
  f = io.open("savegame.txt")
  for line in io.lines("savegame.txt") do 
    self.saveGame[#self.saveGame+1] = line
  end
  io.close(f)

  loadScore = self.saveGame[1]
  
  self.score = 0
  
  font = love.graphics.newFont("Starjhol.ttf",100)
  love.graphics.setFont(font)
end

function ScoreHud:update(dt)
  self.score = self.score + dt * 3
  
  if self.score > tonumber(loadScore) then
    self:saveScore()
  end
end

function ScoreHud:draw()
  love.graphics.setColor(1, 0.8, 0)
  love.graphics.print("Score: "..math.floor(self.score), w - 375, 40 ,0,1/2,1/2)
  love.graphics.print("Record: "..math.floor(loadScore), w - 375, 120 ,0,1/2,1/2)
  love.graphics.setColor(1, 1, 1)
end


function ScoreHud:saveScore() --Saves player credits on a txt file
  f = assert(io.open(self.file, "w"))
  f:write(self.score)
  f:close()
end

function ScoreHud:resetScoreHud()
  self.score = 0
end

return ScoreHud