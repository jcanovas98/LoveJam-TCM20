local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Lasers = Lasers or require "src/laser"
local Explosion = Explosion or require "src/explosion"
local FinalBoss = Object:extend()
local w, h = love.graphics.getDimensions()
local timeRot = 3
local time = 3.5
local expTime = 0.3
local laserDelay = 0.3
local horizontalMov = false
local allDestroyed = false
local explosionTimer = 0
local healthTimer = 0
local font


function FinalBoss:new(image,x,y,scale)
  self.health1 = 3
  self.healthAngle1 = -90

  self.health2 = 3
  self.healthAngle2 = -90

  self.health3 = 3
  self.healthAngle3 = -90

  self.health4 = 3
  self.healthAngle4 = -90
  
  self.dimension = scale
  self.position = Vector.new(x or 0, y or 0)
  self.scale = Vector.new(scale,scale)
  self.image = love.graphics.newImage(image or nil)
  self.origin = Vector.new(x,y)
  self.height = self.image:getHeight() * scale
  self.width  = self.image:getWidth() * scale
  self.lasers = nil 
  self.tag = "boss"
  
  self.timer = 0
  self.spawnLaser = true
  self.laserDone = 0
  self.expTimer = 0
  self.laserDelayTimer = 0
  self.exploding = false
  self.laserX = 0
  self.laserY = 0
  self.laserShoots = 0
  self.depthR = 0
end

function FinalBoss:update(dt, actorList)
  healthTimer = healthTimer + dt
  if self.health1 == 0 and self.health2 == 0 and self.health3 == 0 and self.health4 == 0 then
    self.allDestroyed = true
  end

  if self.health1 == 2 then
    self.healthAngle1 = 30
  elseif self.health1 == 1 then
    self.healthAngle1 = 150
  elseif self.health1 == 0 then
    self.healthAngle1 = 270
  end
  
  if self.health2 == 2 then
    self.healthAngle2 = 30
  elseif self.health2 == 1 then
    self.healthAngle2 = 150
  elseif self.health2 == 0 then
    self.healthAngle2 = 270
  end

  if self.health3 == 2 then
    self.healthAngle3 = 30
  elseif self.health3 == 1 then
    self.healthAngle3 = 150
  elseif self.health3 == 0 then
    self.healthAngle3 = 270
  end
  
  if self.health4 == 2 then
    self.healthAngle4 = 30
  elseif self.health4 == 1 then
    self.healthAngle4= 150
  elseif self.health4 == 0 then
    self.healthAngle4 = 270
  end
  
  if self.position.x > 550 then
    horizontalMov = false
  elseif self.position.x < 170 then
    horizontalMov = true
  end
  
  if horizontalMov then
    self.position.x = self.position.x + dt*20
  end
  if not horizontalMov then
    self.position.x = self.position.x - dt*20
  end
  
  if self.timer < timeRot  then
    self.lasers = nil 
    self.spawnLaser = true
    self.laserDone = 0
    self.expTimer = 0
    self.laserDelayTimer = 0
    self.exploding = false
    self.laserX = 0
    self.laserY = 0
    math.randomseed(os.time())
    self.laserShoots = math.random(3, 6)
  
  elseif self.lasers ~= nil then
    if self.lasers.done then
      
      if self.expTimer >= expTime and not self.allDestroyed then
        for _,v in ipairs(actorList) do
          if v.tag == "lasers" then
            table.remove(actorList, _)
          end
        end
        self.laserDone = self.laserDone + 1
        local explosion = Explosion(self.laserX, self.laserY)
        actorList[#actorList + 1] = explosion
        
        self.expTimer = 0
        self.exploding = true
      end
    
      if self.laserDelayTimer >= laserDelay then
        --[[for _,v in ipairs(actorList) do
          if v.tag == "explosion" then
            table.remove(actorList, _)
            hud.score = hud.score + 50
          end
        end--]]
        self.exploding = false
        self.laserDelayTimer = 0
        self.spawnLaser = true
        self.lasers = nil
      end
      
      if self.laserDone == self.laserShoots and not self.exploding then 
        self.timer = 0
        self.laserDone = 0
        self.spawnLaser = false
        self.exploding = true
      end
      
      if self.exploding then
        self.laserDelayTimer = self.laserDelayTimer + dt
      else
        self.expTimer = self.expTimer + dt
      end
    end
  end

  if self.spawnLaser and self.timer > timeRot then
    math.randomseed(os.time())

    for _,v in ipairs(actorList) do
      if v.tag == "player" then
        self.laserX = v.position.x
        self.laserY = v.position.y
      end
    end
    self.lasers = Lasers(self.position.x, self.position.y, self.laserX, self.laserY, time, self.health1, self.health2, self.health3, self.health4)
    actorList[#actorList + 1] = self.lasers
    self.spawnLaser = false
  end
  self.timer = self.timer + dt
  
  self:blastCollision(dt, actorList)
  self:playerCollision(dt, actorList)
end

function FinalBoss:draw()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.image, self.position.x, self.position.y, self.rot, self.scale.x, self.scale.y, self.origin.x, self.origin.y)
  self:drawHealth(self.healthAngle1, self.position.x - 30, self.position.y + 15)
  self:drawHealth(self.healthAngle2, self.position.x + 90, self.position.y + 20)
  self:drawHealth(self.healthAngle3, self.position.x + 200, self.position.y + 25)
  self:drawHealth(self.healthAngle4, self.position.x + 300, self.position.y + 30)
  
  font = love.graphics.newFont("Starjedi.ttf", 50) 
  
  if self.health1 == 0 and self.health2 == 0 and self.health3 == 0 and self.health4 == 0 then
        
        love.graphics.print("mission complete", font, w/4, h-100)
      end
  
end

function FinalBoss:drawHealth(healthAngle, x, y)
  love.graphics.setColor( 0.6, 0, 0, 0.5)
  love.graphics.arc( "fill", x, y, 20, math.rad(healthAngle), math.rad(270))
  love.graphics.setColor( 1, 1, 1 )
end

function FinalBoss:blastCollision(dt, actorList)

  for _,v in ipairs(actorList) do
      if v.tag:sub(1,5) == "blast" then
        if v.depthR > 0.95 then
          if self.position.x -30 > w/2 - 40 and self.position.x -30 < w/2 + 40 and self.health1 > 0 then
            self.health1 = self.health1  -  1
            table.remove(actorList, _) --remove blast
            
            local explosion = Explosion(self.position.x -30, self.position.y)
            actorList[#actorList + 1] = explosion
            self.destroyD = true
          end
          if self.position.x + 90 > w/2 - 40 and self.position.x + 90 < w/2 + 40 and self.health2 > 0 then
            self.health2 = self.health2  -  1
            table.remove(actorList, _) --remove blast
            
            local explosion = Explosion(self.position.x + 90, self.position.y)
            actorList[#actorList + 1] = explosion
            self.destroyD = true
          end
          if self.position.x + 200 > w/2 - 40 and self.position.x + 200 < w/2 + 40 and self.health3 > 0 then
            self.health3 = self.health3  -  1
            table.remove(actorList, _) --remove blast
            
            local explosion = Explosion(self.position.x + 200, self.position.y)
            actorList[#actorList + 1] = explosion
            self.destroyD = true
          end
          if self.position.x + 300 > w/2 - 40 and self.position.x + 300 < w/2 + 40 and self.health4 > 0 then
            self.health4 = self.health4  -  1
            table.remove(actorList, _) --remove blast
            
            local explosion = Explosion(self.position.x + 300, self.position.y)
            actorList[#actorList + 1] = explosion
            self.destroyD = true
          end
        end
      end
  end
end

function FinalBoss:playerCollision(dt, actorList)
  if healthTimer > 3 then
    for _,v in ipairs(actorList) do
      if v.tag == "player" then
        for e,k in ipairs(actorList) do
          if k.tag == "explosion" then
            if k.position.x + k.width/2 > v.position.x and k.position.x < v.position.x + v.width/2 and 
              k.position.y + k.height/2 > v.position.y and k.position.y < v.position.y + v.height/2 then
              
              v.health = v.health - 1
                healthTimer = 0
            end
          end
        end
      end
    end
  end
end
function FinalBoss:getAllDestroyed()
  return self.allDestroyed
end


return FinalBoss