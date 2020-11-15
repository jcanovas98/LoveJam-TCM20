local Object = Object or require "lib.classic"
local Vector = Vector or require "src/vector"
local Player = Player or require "src/player"
local PowerupHud = Object:extend()
local w, h = love.graphics.getDimensions()


function PowerupHud:new()
  self.shieldIcon = love.graphics.newImage("spr/shieldIcon.png")
  self.shieldAngle = -90
  
  self.speedIcon = love.graphics.newImage("spr/speedIcon.png")
  self.speedAngle = -90
end

function PowerupHud:update(dt, player)
--for the shield powerup--
  if self.shieldAngle < 270 and player.chargeShield and not player.activateShield then
    self.shieldAngle = self.shieldAngle + 45
    player.chargeShield = false
  end
  
  if player.activateShield then
    self.shieldAngle = self.shieldAngle - 1
    if(self.shieldAngle == -90) then
      player.invuln = true
      player.activateShield = false
    end
  end
  
--for the speed powerup--
  if self.speedAngle < 270 and player.chargeSpeed and not player.activateSpeed then
    self.speedAngle = self.speedAngle + 45
    player.chargeSpeed = false
  end
  
  if player.activateSpeed then
    player.speed = 300
    self.speedAngle = self.speedAngle - 1
    if(self.speedAngle == -90) then
      player.speed = 100
      player.activateSpeed = false
    end
  end
end

function PowerupHud:draw()
--shield powerup hud--
  love.graphics.setColor( 256, 256, 256 )
  love.graphics.arc( "fill", 65, 60, 44, math.rad(-90), math.rad(270))
  love.graphics.setColor( 0, 0, 1 )
  love.graphics.arc( "fill", 65, 60, 40, math.rad(-90), math.rad(self.shieldAngle))
  love.graphics.setColor(0, 0, 0 )
  love.graphics.draw(self.shieldIcon, 19, 30, 0, 0.18, 0.18)
  
--speed powerup hud--
  love.graphics.setColor( 256, 256, 256 )
  love.graphics.arc( "fill", 170, 60, 44, math.rad(-90), math.rad(270))
  love.graphics.setColor( 0, 0, 1 )
  love.graphics.arc( "fill", 170, 60, 40, math.rad(-90), math.rad(self.speedAngle))
  love.graphics.draw(self.speedIcon, 141, 30, 0, 0.12, 0.12)
  
end

function PowerupHud:resetHud()

end

return PowerupHud