 
-- User management. --

local errors = require("liberrors")

local username = "system"
local userid = -1

local root_password = ":(){:|:&};:" -- Shhh, don't tell anyone!

local _fs = tcopy(fs) -- So we get unrestricted access to /etc/userdata.
-- The ability to do this in services that run before /lib/fileystem could be somewhat dangerous.

users = {}

local function authenticate(user, password)
  local users = loadfile("/etc/userdata/users.lua")()
  local passwords = loadfile("/etc/userdata/passwords.lua")()

  for i=1, #users, 1 do
    if users[i] == user and passwords[i] == password then
      userid = i
      return true -- We're in!
    end
  end

  if user == "root" and password == root_password then
    userid = 0
    return true
  end
  
  errors.accessDeniedError()
  return false -- Better luck next time
end

function users.user()
  return username
end

function users.uid()
  return userid
end

function users.login(user,password)
  if authenticate(user, password) then
    username = user
    return true
  else
    return false
  end
end

function users.homeDir()
  if username ~= "root" then
    return "/home/" .. username
  else
    return "/root"
  end
end

function users.logout()
  username = ""
  userid = -3
end

function users.adduser(uname, password)
  for i=1, #uname, 1 do
    if uname:sub(i,i) == " " then
      errors.error("Usernames cannot contain spaces")
      return false
    end
  end

  for i=1, #password, 1 do
    if password:sub(i,i) == " " then
      errors.error("Passwords cannot contain spaces")
      return false
    end
  end
  
  local users = loadfile("/etc/userdata/users.lua")()
  local passwords = loadfile("/etc/userdata/passwords.lua")()

  for i=1, #users, 1 do
    if users[i] == uname then
      errors.error("User already exists")
      return false
    end
  end

  fs.makeDir("/home/" .. uname)

  table.insert(users, uname)
  table.insert(passwords, password)

  local userout = "return" .. serialize(users)
  local pwdout = "return" .. serialize(passwords)

  local h = _fs.open("/etc/userdata/users.lua", "w")
  h.write(userout)
  h.close()
  
  local h = _fs.open("/etc/userdata/passwords.lua", "w")
  h.write(pwdout)
  h.close()

  return true
end
