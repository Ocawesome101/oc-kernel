-- Useradd --

local args = {...}
local flags, args = shell.parseArgs(args)

local errors = require("liberrors")

local function serialize(tbl)
  local rtn = "return {\n"
  for i=1, #tbl, 1 do
    rtn = rtn .. "  \"" .. tbl[i] .. "\",\n"
  end

  rtn = rtn .. "}"

  return rtn
end

if #args < 1 then
  print("Usage: useradd [-cansudo] USERNAME")
  print("Example: useradd asdf")
  return
end

local usernames = dofile("/etc/userdata/users.lua")
local passwords = dofile("/etc/userdata/passwords.lua")
local uname = args[1]

for i=1, #usernames, 1 do
  if usernames[i] == uname then
    errors.error("User already exists")
    return
  end
end

write("Input a password for the new user: ")
local pwd = read("*")
write("Confirm password: ")
local cpwd = read("*")

if pwd ~= cpwd then
  errors.error("Passwords do not match")
  return
end

for i=1, #pwd, 1 do
  if pwd:sub(i,i) == " " then
    errors.error("Password cannot contain spaces")
    return
  end
end

print("The following operations will be performed:")
print("Add user " .. uname)
print("Set user home directory to /home/" .. uname)
write("\nIs this correct? [y/n]: ")

local c = read():lower()

if c == "y" then
  users.adduser(uname, pwd)
else
  print("Aborting")
  return
end
