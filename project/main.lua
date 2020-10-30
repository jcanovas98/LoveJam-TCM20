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
end