local Object = Object or require "lib.classic"
local ScoreHud = Object:extend()
local w, h = love.graphics.getDimensions(5)
--local file = io.open("savegame.txt", "r+")

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
  self.difficultySpike = 1


  
  font = love.graphics.newFont("Starjedi.ttf",100)
  love.graphics.setFont(font)
end

function ScoreHud:update(dt)
  self.score = self.score + dt * 10
  
  if self.score >= 500 and self.difficultySpike == 1 then
    self.difficultySpike = self.difficultySpike + 1
  elseif self.score >= 1000 and self.difficultySpike == 2 then
    self.difficultySpike = self.difficultySpike + 1
  elseif self.score >= 1500 and self.difficultySpike == 3 then
    self.difficultySpike = self.difficultySpike + 1
  end
  
  if self.score > tonumber(loadScore) then
    self:saveScore()
  end
end

function ScoreHud:draw()
  love.graphics.setColor(256,256,256)
  love.graphics.print("data: "..math.floor(self.score), w - 230, 20 ,0,1/4,1/4)
  love.graphics.print("record: "..math.floor(loadScore), w - 230, 60 ,0,1/4,1/4)
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

function ScoreHud:getScore()
  return self.score 
end

function ScoreHud:addScore(i)
  self.score = self.score + i
end


return ScoreHud