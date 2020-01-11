-- Which --

local args = {...}
local flags, args = shell.parseArgs(args)

if #args < 1 then
  print("Usage: which COMMAND")
  return
end

if type(args[1]) == "string" then
  local a = shell.resolveProgram(args[1])
  if a then
    print(a)
  else
    print("no " .. args[1] .. " in " .. shell.getVar("$PATH"))
  end
else
  print("THIS PROGRAM IS STUPID")
  return
end
