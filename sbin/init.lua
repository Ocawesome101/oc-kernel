-- INITIALIZATION, FINALLY! --

local args = {...}

_G.gpu = args[1]
local status = args[2]

status("Loading task scheduler")
local ok, err = loadfile("/lib/multithread.lua")
if not ok then
  error("Failed to load task scheduler: " .. err)
end

_G.kernel = ok()

status("Detectimg color ability")
local colordepth = gpu.maxDepth()
gpu.setDepth(colordepth)

status("Initializing dofile")
function dofile(file)
  local ok, err = loadfile(file)
  if not ok then
    error(err)
  end

  return ok()
end

local w, h = gpu.getResolution()

function clear()
  gpu.fill(1,1,w,h," ")
  computer.pullSignal(0)
end

status("Loading I/O library")
local ok, err = loadfile("/lib/io.lua")
if not ok then
  error(err)
end

_G.io = ok()

status("Loading keyboard library")
local ok, err = loadfile("/lib/keyboard.lua")
if not ok then
  error(err)
end

_G.kb = ok()

status("Starting component listener")
kernel.psinit("/lib/component_listener.lua")

status("Starting shell")
kernel.psinit("/bin/sh.lua")

clear()

while true do
  kernel.psupdate()
end


--loadfile("/bin/sh.lua")()
