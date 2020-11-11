<<<<<<< HEAD
--Ricard Pelaez Corbero, Pau Sanchez Cairo
local w, h = love.graphics.getDimensions()

--actors
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Blast = Blast or require "src/blast"
local actorList = {}

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
  
  local background = Background:extend()
  background:new(100)
  table.insert(actorList, background)
  
  local player = Player:extend()
  player:new("spr/xwing.png", w/2, h/2 + h/4, 100, 0.25)
  table.insert(actorList, player)
  
  local blast = Blast:extend()
  blast:new("spr/blast.png", 0, h, 0.5, 0.05)
  table.insert(actorList, blast)
  
  local blast1 = Blast:extend()
  blast1:new("spr/blast.png", 0, h/2, 0.5, 0.05)
  table.insert(actorList, blast1)
  
  local blast2 = Blast:extend()
  blast2:new("spr/blast.png", w, h/2, 0.5, 0.05)
  table.insert(actorList, blast2)
  
  local blast3 = Blast:extend()
  blast3:new("spr/blast.png", w, h, 0.5, 0.05)
  table.insert(actorList, blast3)
  
  local blast4 = Blast:extend()
  blast4:new("spr/blast.png", 0, h, 0.5, 0.05)
  table.insert(actorList, blast4)
end
function love.update(dt)
  for _,v in ipairs(actorList) do
    v:update(dt)
  end
end
function love.draw()
  for _,v in ipairs(actorList) do
    v:draw()
  end
=======
local w, h = love.graphics.getDimensions()

--actors
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Enemy = Enemy or require "src/enemy"
local actorList = {}

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
  
  local background = Background(100)
  table.insert(actorList, background)
  
    local enemy1 = Enemy("1","spr/Meteor1.png", w/2 - 100, h - 100, 10, 0.5)
  table.insert(actorList, enemy1)
  
  local player = Player("spr/xwing2.png", w/2, h - h/4, 100, 0.75)
  table.insert(actorList, player)
  
  --local enemy = Enemy("spr/blast.png", w/2 - 300, h - 200, 10, 0.2)
  --table.insert(actorList, enemy)
end
function love.update(dt)
  --update list
  for _,v in ipairs(actorList) do
    v:update(dt, actorList)
  end
end
function love.draw()
  for _,v in ipairs(actorList) do
    v:draw()
  end
>>>>>>> master
end