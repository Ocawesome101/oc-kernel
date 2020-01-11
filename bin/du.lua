-- DU --
-- oh boy --

local args = {...}
local flags, args = shell.parseArgs(args)

local humanReadable, produceTotal = false, false

local totalSize = 0

if #args < 1 then
  args[1] = shell.pwd()
end

for i=1, #flags, 1 do
  for n=2, #flags[i] do
    local c = flags[i]:sub(n,n)
    if c == "h" then
      humanReadable = true
    elseif c == "c" then
      produceTotal = true
    else
      print("Unrecognized option -" .. c)
    end
  end
end

local function filesInDirectory(dir)
  local files = fs.list(dir)
  for i=1, #files, 1 do
    local concat = ""
    if dir ~= "/" then
      concat = "/"
      if dir:sub(1,1) ~= "/" then
        dir = "/" .. dir
      end
    end
    local size = fs.getSize(dir .. "/" .. files[i])
    if humanReadable then size = tostring(tonumber(size) / 1024); size = size:sub(1,3) .. "k" end
    size = tostring(size)
    if size:sub(3,3) == "." then
      size = size:sub(1,2) .. "k"
    end
    write(size)
    local x, y = getCursorPos()
    setCursorPos(7, y)
    print(dir .. concat .. files[i])
    if fs.isDir(files[i]) then
      filesInDirectory(files[i])
    end
  end
end

if fs.exists(args[1]) then
  filesInDirectory(args[1])
end
