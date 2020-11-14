local Object = Object or require "lib/classic"
local Timer = Object:extend()

function Timer:new(time, fun)
  self.ActualT = 0
  self.MaxT = time
  self.f = fun

end

function Timer:update(dt)
  self.ActualT = self.ActualT + dt
  if self.ActualT > self.MaxT then
    self.f()
    self.ActualT = 0
  end
end
  
  return Timer