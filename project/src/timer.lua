local Object = Object or require "lib/classic"
local Timer = Object:extend()

function Timer:new(time, fun)
  self.ActualT = 0
  self.MaxT = time
  self.f = fun

end

function Timer:update(dt)
  self.actualT = self.actualT + dt
  if self.actualT > self.maxT then
    self.f()
    self.ActualT = 0
  end
  
end

  
  
  return Timer