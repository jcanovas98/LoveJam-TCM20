local w, h = love.graphics.getDimensions()

--actors
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Enemy = Enemy or require "src/enemy"
local Shield = Shield or require "src/shield"
local PowerupHud = PowerupHud or require "src/powerupHud"
local HealthHud = HealthHud or require "src/healthHud"
local actorList = {}

local shield = Shield()
powerupHud = PowerupHud()
local healthHud = HealthHud()

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
  
  local background = Background(100)
  table.insert(actorList, background)
  
  local enemy1 = Enemy("1","spr/Meteor1.png", w/2 - 100, h - 100, 10, 0.5)
  table.insert(actorList, enemy1)
  
  player = Player("spr/xwing2.png", w/2, h - h/4, 100, 0.75)
  table.insert(actorList, player)
  
  --local enemy = Enemy("spr/blast.png", w/2 - 300, h - 200, 10, 0.2)
  --table.insert(actorList, enemy)
end
function love.update(dt)
  --update list
  for _,v in ipairs(actorList) do
    v:update(dt, actorList)
  end
  
  shield:update(dt, player)
  powerupHud:update(dt, player)
  healthHud:update(dt, player)
  
end
function love.draw()
  for _,v in ipairs(actorList) do
    v:draw()
  end
  
  shield:draw()
  powerupHud:draw()
  healthHud:draw()
end