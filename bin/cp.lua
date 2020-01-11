-- MV --

local args = {...}
local errors = require("liberrors")
local flags, args = shell.parseArgs(args)

if #args < 2 then
  print("Usage: mv FILE DEST")
  return
end

local src = args[1]
local dest = args[2]

if not (type(src) == "string" and type(dest) == "string") then
  errors.invalidArgumentError("string, string", type(src) .. ", " .. type(dest))
  return
end
local c = ""

if shell.pwd() ~= "/" then c = "/" end

if src:sub(1,1) ~= "/" then
  src = shell.pwd() .. c .. src
end

if dest:sub(1,1) ~= "/" then
  dest = shell.pwd() .. c .. dest
end

if not fs.exists(src) then
  errors.fileNotFoundError(args[1])
  return
end

if fs.exists(dest) then
  errors.error(args[2] .. " already exists")
  return
end

fs.copy(src, dest)
