-- RM --

local args = {...}
local flags, args = shell.parseArgs(args)

local errors = require("liberrors")

local ignoreErrors = false

if #args < 1 then
  print("Usage: rm FILE")
  return
end
--[[
for i=1, #flags, 1 do
  if flags[i] == "-f" then
    ignoreErrors = true
  end
end
]]--

local path = args[1]

if path:sub(1,1) ~= "/" then
  path = shell.resolvePath(path)
end

fs.delete(path)
