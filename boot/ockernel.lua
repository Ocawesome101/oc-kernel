-- The main kernel. --

local flags = ...

local boot_address = computer.getBootAddress()
local invoke = component.invoke -- For convenience
local version = "OC-Kernel 0.0.3"
local mt

-- Set up our display --
local w, h
local gpu = component.list("gpu")() -- Get the first GPU in the system
local screen = component.list("screen")()

for a in component.list("screen") do -- Try to find a screen with a keyboard
  if #invoke(a, "getKeyboards") > 0 then
    screen = address
  end
end

gpu = component.proxy(gpu)

local cls = function()end
if not gpu.getScreen() then
  gpu.bind(screen)
end

w, h = gpu.getResolution()
gpu.setResolution(w, h)
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")
cls = function()gpu.fill(1, 1, w, h, " ")end

local y = 1
local function status(msg)
  if gpu then
--    computer.beep(200,0.05)
    gpu.set(1, y, msg)
    if y == h then
      gpu.copy(1, 2, w, h - 1, 0, -1)
      gpu.fill(1, h, w, 1, " ")
    else
      y = y + 1
    end
  end
  computer.pullSignal(0)
end


-- Boot --
status("Booting " .. version .. " from disk " .. boot_address)

status("Total memory:", tostring(computer.totalMemory()))

status("Initializing loadfile")

local function loadfile(file)
  local h, r = assert(invoke(boot_address, "open", file))
  if not h then
    error(r)
  end
  local b = ""
  repeat
--    computer.beep(1000,0.1)
    local d, r = invoke(boot_address, "read", h, math.huge)
    if (not d) and r then
      error(r)
    end
--    computer.beep(500,0.1)
    b = b .. (d or "")
  until not d
  invoke(boot_address, "close", h)
  return load(b, "=" .. file, "bt", _G)
end

-- Set up a rudimentary filesystem API --
status("Setting up initial filesystem access")

local ok, err = loadfile("/boot/kmod/filesystem.lua")

if not ok then
  error(err)
end

ok(boot_address)

status("Reinitializing loadfile in _G")

--computer.beep(650,0.1)
function _G.loadfile(file)
  local h, r = fs.open(file, "r")
  if not h then
    error(r)
  end
  local b = ""
  repeat
--    computer.beep(1500,0.1)
    local d, r = fs.read(h, math.huge)
    if not d and r then
      error(r)
    end
--    computer.beep(1000,0.1)
    b = b .. (d or "")
  until not d
  fs.close(h)
  return load(b, "=" .. file)
end

status("Starting init")
local ok, err = loadfile("/sbin/init.lua")
if not ok then
  error("Failed to load init: " .. err)
end

ok(gpu, status)
