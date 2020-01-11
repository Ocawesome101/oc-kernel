-- Hostname --

local args = {...}
local errors = require("liberrors")

local flags, args = shell.parseArgs(args)

for i=1, #flags, 1 do
  if #flags[i] >= 2 then
    for n=1, #flags[i], 1 do
      local c = flags[i]:sub(n,n)
      if c == "s" then
        print(sys.hostname())
        return
      end
    end
  end
end

if #args < 1 then
  print(sys.hostname())
  return
end

if type(args[1]) ~= "string" then
  errors.invalidArgumentError("string", type(args[1]))
end

sys.setHostname(args[1])
