local w, h = love.graphics.getDimensions()

--actors
local Intro = Intro or require "src/intro"
local Audio = Audio or require "src/audio"
local Player = Player or require "src/player"
local Background = Background or require "src/background"
local Enemy = Enemy or require "src/enemy"
local EnemySpawner = EnemySpawner or require "src/enemySpawner"
local Timer = Timer or require "src/timer"
local Shield = Shield or require "src/shield"
local PowerupHud = PowerupHud or require "src/powerupHud"
local HealthHud = HealthHud or require "src/healthHud"
local ScoreHud = ScoreHud or require "src/scoreHud"
local Gameover = Gameover or require "src/gameover"
local Menu = Menu or require "src/menu"
local PauseMenu = PauseMenu or require "src/pauseMenu"
local BossRoom = BossRoom or require "src/bossRoom"
local FinalBoss = FinalBoss or require "src/finalBoss"
local TextBoxes = TextBoxes or require "src/textBoxes"
local IntroCampaign = IntroCampaign or require "src/introCampaña"
local actorListEndless = {}
local actorListBoss = {}

local isIntro = false
local isMenu = false
local isIntroCampaign = false

local isEndless = false
local isCampaign = true
local isBoss = true
local isGameover = false
local isPause = false
local gameStatus = 0 -- PARA GAMEOVER: 0 ENDLESS, 1 CAMPAIGN, 2 BOSS

local introTimer = 0

local music = Audio()
local shield = Shield()
powerupHud = PowerupHud()
local healthHud = HealthHud()
scoreHud = ScoreHud()
local menu = Menu()
local gameover = Gameover()
local pause = PauseMenu()
local textBox = TextBoxes(love.graphics.newImage("spr/comandante.jpg"), 3, "hola")

local actorLength 


function love.load(arg)
  math.randomseed(os.time())
  
  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Enable the debugging with ZeroBrane Studio
  
  intro = Intro("spr/tecnocampusgames.ogv")
  
  random = math.random(1,2)
  
  track1 = music:getTrack1()
  track2 = music:getTrack2()
  menuTrack = music:getMenuTrack()
  bossTrack = music:getBossTrack()

  local background = Background(100)
  table.insert(actorListEndless, background)
  table.insert(actorListBoss, background)

  enemySpawner1 = EnemySpawner(6, actorListEndless, 1)
  enemySpawner2 = EnemySpawner(4, actorListEndless, 2)
  enemySpawner3 = EnemySpawner(3, actorListEndless, 3)
  enemySpawner4 = EnemySpawner(2, actorListEndless, 4)
  
  bossRoom = BossRoom()
  table.insert(actorListBoss, bossRoom)
  
  finalBoss = FinalBoss("spr/boss_sprite.png",w/3,h/2,1/2)
  table.insert(actorListBoss, finalBoss)
  
  player = Player("spr/xwing2.png", w/2, h - h/4, 100, 0.75)
  table.insert(actorListEndless, player)
  table.insert(actorListBoss, player)
  
  
  actorLengthEndless = #actorListEndless
  actorLengthBoss = #actorListBoss
  
end
function love.update(dt)
  
  if(isIntro) then
    if love.keyboard.isDown ("escape") then
      intro:stop()
      introTimer = 20
    end
    
    if introTimer > 19 then
      isIntro = false
      isMenu = true
    end
    introTimer = introTimer + dt
  end
  
  if(isMenu) then
    menu:update(dt)
    menuTrack:play()
    if menu:getStartCampaign() then
      isMenu = false
      isCampaign = true
      
      menuTrack:stop()
    end
    
    if menu:getStartEndless() then
      isMenu = false
      isEndless = true
      
      menuTrack:stop()
    end
    
  end
  
  if(isGameover) then
    gameover:update(dt)
    track1:stop()
    track2:stop()
    random = math.random(1,2)
    
    print(gameover:getRetry())
    if gameover:getRetry() and gameStatus == 0 then
      isGameover = false
      isEndless = true
      gameover:setRetry()
      player:resetHealth()
      scoreHud:resetScoreHud()
      powerupHud:resetHud()
    end
    
    if gameover:getRetry() and gameStatus == 1 then
      isGameover = false
      isCampaign = true
      isBoss = false
      gameover:setRetry()
      gameover:setRetry()
      player:resetHealth()
      scoreHud:resetScoreHud()
      powerupHud:resetHud()
    end
    
    if gameover:getRetry() and gameStatus == 2 then
      isGameover = false
      isCampaign = true
      isBoss = true
      gameover:setRetry()
      gameover:setRetry()
      player:resetHealth()
      scoreHud:resetScoreHud()
      powerupHud:resetHud()
    end
    
  end
  if (isIntroCampaign) then
    IntroCampaign:update(dt)
  end
  if(isCampaign) then
    if(isPause) then
      if love.keyboard.isDown ("return") then
        isPause = false
      end
      if love.keyboard.isDown ("escape") then
      love.event.quit(0)
      end
    end
    
    if not isPause then 
      if love.keyboard.isDown ("p") then
        isPause = true
      end
      
    shield:update(dt, player)
    powerupHud:update(dt, player)
    healthHud:update(dt, player)
    scoreHud:update(dt)
    player:UsePowerups(powerupHud)
    
    if random == 2 then
      track1:play()
    elseif random == 1 then
      track2:play()
    end
      
    if scoreHud:getScore() > 2020 then
      --BOSS TRIGGER THINGS
      isBoss = true
      track1:stop()
      track2:stop()
      bossTrack:play()
    end
    
    if not isBoss then
      gameStatus = 1
      
      if scoreHud.difficultySpike == 1 then
        enemySpawner1:update(dt)
      elseif scoreHud.difficultySpike == 2 then
        enemySpawner2:update(dt)
      elseif scoreHud.difficultySpike == 3 then
        enemySpawner3:update(dt)
      elseif scoreHud.difficultySpike == 4 then
        enemySpawner4:update(dt)
      end
        
      if random == 2 then
        track1:play()
      elseif random == 1 then
        track2:play()
      end
    
      for _,v in ipairs(actorListEndless) do
        v:update(dt, actorListEndless)
      end
    end
    
    if player:getHealth() == 0 then
      isGameover = true
      isCampaign = false
    end
    
    if isBoss then
      gameStatus = 2
      for _,v in ipairs(actorListBoss) do
        v:update(dt, actorListBoss)
      end
      bossRoom:update(dt, finalBoss:getAllDestroyed())
      
      
    end
    end
  end
  
  if (isEndless) then
    if(isPause) then
    if love.keyboard.isDown ("return") then
      isPause = false
      end
    if love.keyboard.isDown ("escape") then
      love.event.quit(0)
      end
    end
    
    if not isPause then 
      if love.keyboard.isDown ("p") then
        isPause = true
      end
      
    gameStatus = 0
    shield:update(dt, player)
    powerupHud:update(dt, player)
    healthHud:update(dt, player)
    scoreHud:update(dt)
    player:UsePowerups(powerupHud)
    textBox:update(dt)
    
    if scoreHud.difficultySpike == 1 then
      enemySpawner1:update(dt)
    elseif scoreHud.difficultySpike == 2 then
      enemySpawner2:update(dt)
    elseif scoreHud.difficultySpike == 3 then
      enemySpawner3:update(dt)
    elseif scoreHud.difficultySpike == 4 then
      enemySpawner4:update(dt)
    end
      
    if random == 2 then
      track1:play()
    elseif random == 1 then
      track2:play()
    end
    
    for _,v in ipairs(actorListEndless) do
      v:update(dt, actorListEndless)
    end
    
    if player:getHealth() == 0 then
      isGameover = true
      isEndless = false
    end
    end
  end

end

function love.draw()
  if (isIntro) then
    intro:draw()
    font = love.graphics.newFont("Starjedi.ttf", 20)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Press ESC if you want to skip the intro", font, w/4 + 10, 700)
  end
  
  if (isMenu) then
    menu:draw()
  end
  
  if (isGameover) then
    gameover:draw()
  end
  
  if (isIntroCampaign) then
    IntroCampaign:draw()
  end
  
  
  if (isCampaign) then
    
    if not isBoss then
      for _,v in ipairs(actorListEndless) do
        v:draw()
      end
      
      if scoreHud.difficultySpike == 1 then
        enemySpawner1:draw()
      elseif scoreHud.difficultySpike == 2 then
        enemySpawner2:draw()
      elseif scoreHud.difficultySpike == 3 then
        enemySpawner3:draw()
      elseif scoreHud.difficultySpike == 4 then
        enemySpawner4:draw()
      end

      textBox:draw()
      
    end
    
    if isBoss then
      if (finalBoss:getAllDestroyed()) then
          bossRoom:draw()
        end
      for _,v in ipairs(actorListBoss) do
        v:draw()
        
      end
      
    end
    shield:draw()
    powerupHud:draw()
    healthHud:draw()
    scoreHud:draw()
    
  end
  
  if (isEndless) then
    for _,v in ipairs(actorListEndless) do
      v:draw()
    end
    
    if scoreHud.difficultySpike == 1 then
      enemySpawner1:draw()
    elseif scoreHud.difficultySpike == 2 then
      enemySpawner2:draw()
    elseif scoreHud.difficultySpike == 3 then
      enemySpawner3:draw()
    elseif scoreHud.difficultySpike == 4 then
      enemySpawner4:draw()
    end
    
    shield:draw()
    powerupHud:draw()
    healthHud:draw()
    scoreHud:draw()
  end
  
  if (isPause) then
      pause:draw()
    end
end
