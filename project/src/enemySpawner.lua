local Vector = Vector or require "src/vector"
local Enemy = Enemy or require "src/enemy"
local Timer = Timer or require "src/Timer"
local EnemySpawner = Timer:extend()
local w, h = love.graphics.getDimensions()

function EnemySpawner:new(time, actorList, difficulty)
  
  function spawn()
    enemy = Enemy("1","spr/tFighter.png", math.random(100, w-100), math.random(h-250, h - 100), math.random(7 - difficulty, 10 - difficulty), 0.3)
    actorList[#actorList + 1] = enemy
  end
  EnemySpawner.super.new(self, time, spawn, true)
end

function EnemySpawner:update(dt)
  EnemySpawner.super.update(self,dt)
end

function EnemySpawner:draw()
  EnemySpawner.super.draw(self)
end

return EnemySpawner