-- Listen for attached components --

local eventData = ...

while true do
  local sig, addr, type = table.unpack(eventData)
  if sig == "component_added" then
    computer.pushSignal("init_component", addr, type)
  end

  coroutine.yield({addr, type})
end
