-- Login screen --

if shell then
  print("Cannot run login from inside a shell")
  return
end

local loginPrompt = "localhost login: "
local passwordPrompt = "password: "

local bShutdown = false

while not bShutdown do
  while true do
    io.write(loginPrompt)
    local uname = io.read()
    io.write(passwordPrompt)
    local pwd = io.read("*")
    if users.login(uname, pwd) then
      break
    end
  end

  print("Logging in")
  loadfile("/bin/sh.lua")()
end
