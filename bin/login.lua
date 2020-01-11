-- Login screen --

if shell then
  print("Cannot run login from inside a shell")
  return
end

local loginPrompt = sys.hostname() .. " login: "
local passwordPrompt = "password: "

local bShutdown = false

error = require("liberrors").error

while not bShutdown do
  while true do
    write(loginPrompt)
    local uname = read()
    write(passwordPrompt)
    local pwd = read("*")
    if users.login(uname, pwd) then
      break
    end
  end

  print("Logging in")
  kernel.run("/bin/ocsh.lua")
end
