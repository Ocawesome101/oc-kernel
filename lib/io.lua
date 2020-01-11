-- Miscellaneous I/O functions --

local w, h = gpu.getResolution()
local y = 1
local x = 1

local function newline()
  if y == h then
    gpu.copy(1, 2, w, h - 1, 0, -1)
    gpu.fill(1, h, w, 1, " ")
  else
    y = y + 1
  end
  x = 1
end

local function writeChar(char)
  gpu.set(x, y, char)
  if x == w then
    newline()
  else
    x = x + 1
  end
end

local function iter(tbl)
  local i = 0
  local rtn = function()
    i = i + 1
    if i <= #tbl then
      return tbl[i]
    end
  end
  return rtn
end

------------------------------------------------------------------------------------------

local io = {}

function io.write(...)
  local toWrite = {...}
  for msg in iter(toWrite) do
    local msg = tostring(msg)
    for i=1, #msg, 1 do
      if msg:sub(i,i) == "\n" then
        newline()
      else
        writeChar(msg:sub(i,i))
      end
    end
    writeChar(" ")
  end
  computer.pullSignal(0)
end

function print(...)
  local toPrint = {...}
  for msg in iter(toPrint) do
    io.write(msg)
  end
  newline()
end

function io.read(substituteChar)
  local rtn = ""
  local stx = x
  while true do
    local kp = kb.pullKey()
    if kp then
--      computer.beep(1000,0.1)
      if kp.code == kb.keys.backspace then
--        computer.beep(800,0.1)
        rtn = rtn:sub(1,-2)
      elseif kp.code == kb.keys.enter then
--        computer.beep(750,0.1)
        break
      elseif #kp.char == 1 then
--        computer.beep(700,0.1)
        rtn = rtn .. kp.char
      end
--      computer.beep(1200,0.1)
    end
    
    x = stx
    gpu.fill(stx,y,w,y," ")
    if not substituteChar then
      io.write(rtn:lower())
    else
      io.write(string.rep(substituteChar, #rtn))
    end
  end
--  computer.beep(500,0.1)
  newline()
  return rtn
end

return io
