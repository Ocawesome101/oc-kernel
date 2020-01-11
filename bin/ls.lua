-- LS --

local args = {...}
local errors = require("liberrors")
local files = {}

local showHidden = false
local showSize = false
local lsDir = false

local dirColor = colors.lightBlue
local fileColor = colors.white
local scriptColor = colors.lime

local flags, args = shell.parseArgs(args)

local lsPath

if #args > 0 then
  if args[1]:sub(1,1) == "/" then
    lsPath = args[1]
  else
    lsPath = shell.pwd() .. "/" .. args[1]
  end
else
  lsPath = shell.pwd()
end

if not fs.exists(lsPath) then
  errors.fileNotFoundError(lsPath)
  return false
end

if #flags > 0 then
  for i=1, #flags, 1 do
    if #flags[i] >= 2 then -- We've got a long enough flag
      for n=2, #flags[i], 1 do
        local c = flags[i]:sub(n,n)
        if c == "a" then
          table.insert(files, "..")
          showHidden = true
        elseif c == "l" then
          showSize = true
        elseif c == "d" then
          lsDir = true
        end
      end
    end
  end
end

local oldColor = getTextColor()

if lsPath:sub(2,2) == "/" then
  lsPath = lsPath:sub(2,#lsPath)
end

if (not fs.isDir(lsPath)) or (lsDir == true) then
  if showSize == true then
    setTextColor(colors.white)
    local concat = ""  
    local size = fs.getSize(lsPath)
    while #(concat .. size) < 4 do
      concat = concat .. " "
    end
    write(concat .. size .. " ")
  end

  if lsPath:sub(#lsPath-3,#lsPath) == ".lua" then
    setTextColor(scriptColor)
  else
    setTextColor(fileColor)
  end

  if fs.isDir(lsPath) then
    setTextColor(dirColor)
  end

  print(lsPath)

  setTextColor(oldColor)
  return
end

files = fs.list(lsPath)

if #files == 0 then
  return
end

for i=1, #files, 1 do
  if (files[i]:sub(1,1) ~= ".") or (showHidden == true) then
    if showSize == true then
      setTextColor(colors.white)
      local concat = ""
      local size = fs.getSize(lsPath .. "/" .. files[i])
      while #(concat .. size) < 4 do
        concat = concat .. " "
      end
      write(concat .. size .. " ")
    end
    if files[i]:sub(#files[i]-3, #files[i]) == ".lua" then
      setTextColor(scriptColor)
    else
      setTextColor(fileColor)
    end
    if fs.isDir(lsPath .. "/" .. files[i]) then
      setTextColor(dirColor)
    end
    
    print(files[i])
  end
end

setTextColor(oldColor)
