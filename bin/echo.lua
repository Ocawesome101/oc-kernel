-- ECHOOOOOOOOOOOOOOOOOOO --

local args = {...}
local flags, args = shell.parseArgs(args)

for i=1, #args, 1 do
  write(args[i] .. " ")
end

print("")
