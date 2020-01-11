-- DF --

local args = {...}
local flags, args = shell.parseArgs(args)

local errors = require("liberrors")

local humanReadable = false

for i=1, #flags, 1 do
  if flags[i] == "-h" then
    humanReadable = true
  else
    print("Unrecognized option " .. flags[i])
  end
end

local free = fs.getFreeSpace("/")

if humanReadable then
  free = tostring((tonumber(free)/1024)/1024) .. "M"
end

print("Filesystem   Avail")
print("/            " .. free)
