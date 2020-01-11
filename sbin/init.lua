-- INITIALIZATION, FINALLY! --

local args = {...}

if kernel then
  require("errors").error("Init is already running")
  return
end

_G.gpu = args[1]
local status = args[2]

status("Wrapping computer.pullSignal")
local ok, err = loadfile("/lib/signals.lua")
if not ok then
  error("Failed to load /lib/signals.lua: " .. err)
end

_G.pullEvent = ok()

status("Loading task scheduler")
local ok, err = loadfile("/lib/multithread.lua")
if not ok then
  error("Failed to load task scheduler: " .. err)
end

_G.kernel = ok()

status("Detecting color ability")
local colordepth = gpu.maxDepth()
gpu.setDepth(colordepth)

status("Initializing dofile and require")
function dofile(file)
  local ok, err = loadfile(file)
  if not ok then
    error(err)
  end

  return ok()
end

function require(api)
  return dofile("/lib/require/" .. api .. ".lua")
end

local w, h = gpu.getResolution()

function clear()
  gpu.fill(1,1,w,h," ")
  computer.pullSignal(0)
end

status("Initializing function tcopy")
function tcopy(tbl)
  local rtn = {}
  for k,v in pairs(tbl) do
    rtn[k] = v
  end
  return rtn
end

status("Loading keyboard library")
local ok, err = loadfile("/lib/keyboard.lua")
if not ok then
  error(err)
end

_G.kb = ok()

status("Loading I/O library")
local ok, err = loadfile("/lib/io.lua")
if not ok then
  error(err)
end

_G.io = ok()

status("Loading user subsystem")
dofile("/lib/users.lua")

status("Wrapping the FS library for file protection")
dofile("/lib/filesystem.lua")

status("Starting login screen")
kernel.psinit("/bin/login.lua")

clear()

while true do
  kernel.psupdate()
end

status("WARNING: Loading in single-user mode!")
loadfile("/bin/ocsh.lua")()
