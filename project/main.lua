local w, h = love.graphics.getDimensions()

--actors
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Enemy = Enemy or require "src/enemy"
local Shield = Shield or require "src/shield"
local PowerupHud = PowerupHud or require "src/powerupHud"
local HealthHud = HealthHud or require "src/healthHud"
local ScoreHud = ScoreHud or require "src/scoreHud"
local GameOver = GameOver or require "src/gameover"
local Menu = Menu or require "src/menu"
local BossRoom = BossRoom or require "src/bossRoom"
local FinalBoss = FinalBoss or require "src/finalBoss"
local actorList = {}

local shield = Shield()
powerupHud = PowerupHud()
local healthHud = HealthHud()
local scoreHud = ScoreHud()


function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
  
  --menu = Menu()
  --gameOver = GameOver()
  local background = Background(100)
  table.insert(actorList, background)
  
  bossRoom = BossRoom()
  --table.insert(actorList, bossRoom)
  
  --finalBoss = FinalBoss("spr/boss_sprite.png",w/3,h/2,1/2)
  --table.insert(actorList, finalBoss)
  
  local enemy1 = Enemy("enemy","spr/tFighter.png", w/2 - 100, h - 100, 10, 0.25, actorList)
  table.insert(actorList, enemy1)
  
  player = Player("spr/xwing2.png", w/2, h - h/4, 100, 0.75)
  table.insert(actorList, player)--]]
  
end
function love.update(dt)
  --menu:update(dt)
  --gameOver:update(dt)
  --update list
  for _,v in ipairs(actorList) do
    v:update(dt, actorList)
  end

  --bossRoom:update(dt, finalBoss:getAllDestroyed())
  shield:update(dt, player)
  powerupHud:update(dt, player)
  healthHud:update(dt, player)
  scoreHud:update(dt)--]]
  
end

function love.draw()
  --menu:draw()
  --gameOver:draw()
  --bossRoom:draw()
  for _,v in ipairs(actorList) do
    v:draw()
  end
  
  
  shield:draw()
  powerupHud:draw()
  healthHud:draw()
  scoreHud:draw()
--]]
end
