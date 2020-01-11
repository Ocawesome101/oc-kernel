-- Shutdown -- 

local args = {...}

if args[1] == "-r" then
  computer.shutdown(true)
elseif args[1] == "-s" then
  computer.shutdown(false)
else
  print("Usage: shutdown -r|-s")
end
