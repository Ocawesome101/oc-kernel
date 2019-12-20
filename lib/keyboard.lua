-- I hope this goes better than the OC-OS one. Yikes. --

local kb = {}

kb.keys = {}

for i=32, 127, 1 do -- dynamic table generation, woo!
  kb.keys[string.char(i)] = i
end


local function findKey(c)
  return string.char(c)
end

function kb.pullKey()
  local sig, kbaddr, char, code, name = computer.pullSignal()
  if sig == "key_down" then
    return {char = findKey(code), code = code}
  end
end

return kb
