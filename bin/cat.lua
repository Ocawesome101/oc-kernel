-- CAT --

local args = {...}
local errors = require("liberrors")

local exit = false
local flags, args = shell.parseArgs(args)

if #args < 1 then
  while not exit do
    local inp = read()
    if inp == "!EOF!" then
      exit = true
    end
    print(inp)
  end
  return
end

local path = args[1]

if path:sub(1,1) ~= "/" then
  local concat = ""
  if shell.pwd() ~= "/" then
    concat = "/"
  end
  
  path = shell.pwd() .. concat .. path
end

if fs.exists(path) and not fs.isDir(path) then
  local h = fs.open(path, "r")
  if not h then
    return
  end

  local data = h.readAll()
  h.close()
  print(data)

  return
else
  errors.fileNotFoundError(args[1])
end
