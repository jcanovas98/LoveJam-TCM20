local w, h = love.graphics.getDimensions()

--actors
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Blast = Blast or require "src/blast"
local Enemy = Enemy or require "src/enemy"
local actorList = {}

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
  
  local background = Background(100)
  table.insert(actorList, background)
  
  local player = Player("spr/xwing2.png", w/2, h - h/4, 100, 0.75)
  table.insert(actorList, player)
  
  --local enemy = Enemy("spr/blast.png", w/2 - 300, h - 200, 10, 0.2)
  --table.insert(actorList, enemy)
  
  local enemy1 = Enemy("1","spr/blast.png", w/2 - 100, h - 100, 10, 0.2)
  table.insert(actorList, enemy1)
end
function love.update(dt)
  --collision list
  for _,v in ipairs(actorList) do
    if v.tag == "blast" then
      if (v.position.y <= v.yF + 3 and v.position.y >= v.yF - 3) and (v.position.x <= v.xF + 3 and v.position.x >= v.xF - 3) or v.position.y <= h/2 then
        table.remove(actorList, _)
      end
    end
  end
  --update list
  for _,v in ipairs(actorList) do
    v:update(dt, actorList)
  end
end
function love.draw()
  for _,v in ipairs(actorList) do
    v:draw()
  end
end