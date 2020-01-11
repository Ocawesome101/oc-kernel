-- Listen for attached components --

while true do
  local sig, addr, type = computer.pullSignal(0.001)
  if sig == "component_added" then
    computer.pushSignal("init_component", addr, type)
  end

  coroutine.yield({addr, type})
end
