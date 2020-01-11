-- A shell. Finally, a shell! --

local args = {...}

if #args >= 1 then
  shell.runScript(args[1])
  return
end

local errors = require("liberrors")

error = errors.error

local exit = false
local dir = users.homeDir()

shell = {}

function shell.upLevel()
  local d = dir
  if d == "/" then
    return d
  end
  while d:sub(#d,#d) ~= "/" do
    d = d:sub(1, #d-1)
  end
  if d ~= "/" then
    d = d:sub(1, #d-1)
  end

  return d
end

function shell.pwd()
  return dir
end

function shell.setPwd(d)
  local d = d
  if d == ".." then
    d = shell.upLevel(d)
  end

  if fs.exists(d) then
    dir = d
  end
end

local shellVars = {
  {
    name = "$PATH",
    value = "/bin:/sbin"
  },
  {
    name = "$HOME",
    value = users.homeDir()
  },
  {
    name = "$USER",
    value = users.user()
  },
  {
    name = "$UID",
    value = users.uid()
  },
  {
    name = "$HOSTNAME",
    value = sys.hostname
  },
  {
    name = "$PWD",
    value = shell.pwd
  }
}

local shellSpecial = {
  {
    name = users.homeDir(),
    value = "~"
  }
}

local builtins = {
  {
    name = "cd",
    func = function(...)
      local args = {...}
      if #args < 1 then
        shell.setPwd(users.homeDir())
        return true
      end
      if type(args[1]) == "string" then
        if args[1] == "." then
          return true
        end
        if args[1] == ".." then
          shell.setPwd("..")
        else
          if args[1]:sub(1,1) == "/" then
            if fs.exists(args[1]) then
              shell.setPwd(args[1])
            else
              errors.fileNotFoundError("Directory")
            end
          else
            if fs.exists(shell.pwd() .. args[1]) then
              shell.setPwd(shell.pwd() .. args[1])
            elseif fs.exists(shell.pwd() .. "/" .. args[1]) then
              shell.setPwd(shell.pwd() .. "/" .. args[1])
            else
              errors.fileNotFoundError("Directory")
            end
          end
        end
      else
        errors.invalidArgumentError("string", type(args[1]))
      end
    end
  },
  {
    name = "exit",
    func = function(...)
      exit = true
    end
  }
}

local function runBuiltin(prg, ...)
  for i=1, #builtins, 1 do
    if builtins[i].name == prg then
      builtins[i].func(...)
      return true
    end
  end

  return false
end

local function tokenize( ... ) -- Straight out of the craftOS shell :P
    local sLine = table.concat( { ... }, " " )
    local tWords = {}
    local bQuoted = false
    for match in string.gmatch( sLine .. "\"", "(.-)\"" ) do
        if bQuoted then
            table.insert( tWords, match )
        else
            for m in string.gmatch( match, "[^ \t]+" ) do
                table.insert( tWords, m )
            end
        end
        bQuoted = not bQuoted
    end
    return tWords
end

function shell.parse(line)
  local words = tokenize(line)
  for i=1, #words, 1 do -- 1st pass-- special characters
    for j=1, #shellSpecial, 1 do
      if words[i] == shellSpecial[j].name then
        words[i] = shellSpecial[j].value
      end
    end
    -- 2nd pass-- variables
    for j=1, #shellVars, 1 do
      if words[i] == shellVars[j].name then
        if type(shellVars[j].value) == "function" then -- Variables can be static or dynamic
          words[i] = shellVars[j].value()
        else
          words[i] = shellVars[j].value
        end
      end
    end
    for j=1, #shellSpecial, 1 do -- 3rd pass-- special characters again
      if words[i] == shellSpecial[j].name then
        words[i] = shellSpecial[j].value
      end
    end
  end

  return words
end

function shell.parseArgs(tArgs) -- Sort flags and arguments
  local rF, rA = {}, {}
  if #tArgs > 0 then
    for i=1, #tArgs, 1 do
      if tArgs[i]:sub(1,1) == "-" then
        table.insert(rF, tArgs[i])
      else
        table.insert(rA, tArgs[i])
      end
    end
  end
  return rF, rA
end

function shell.newVar(n, v)
  local n = n
  if not n:sub(1,1) == "$" then
    n = "$" .. n
  end
  table.insert(shellVars, {name = n, value = v})
end

function shell.setVar(n, v)
  for i=1, #shellVars, 1 do
    if shellVars[i].name == n then
      shellVars[i].value = v
    end
  end
end

function shell.getVar(n)
  return shell.parse(n)[1]
end

function shell.listVars()
  for i=1, #shellVars, 1 do
    print(shellVars[i].name)
  end
end

-- Add more builtins now that we have more of the shell API defined
table.insert(builtins, {
  name = "def",
  func = function(...)
    local args = {...}
    local flags, args = shell.parseArgs(args)
    if #args < 2 then
      print("Usage: def NAME VALUE")
      return false
    end

    shell.newVar(args[1], args[2])
  end
})
table.insert(builtins, {
  name = "vars",
  func = function(...)
    shell.listVars()
  end
})

function shell.exit()
  exit = true
end

function shell.resolveProgram(prg)
  local prg = prg
  if prg:sub(1,1) ~= "/" then
    for p in string.gmatch(shell.getVar("$PATH"), "[^:]+") do
      if fs.exists(p .. "/" .. prg .. ".lua") then
        return p .. "/" .. prg .. ".lua"
      elseif fs.exists(p .. "/" .. prg) then
        return p .. "/" .. prg
      end
    end
    return false
  else
    return prg
  end
end

function shell.resolvePath(path)
  local concat = ""
  if path:sub(1,1) ~= "/" then
    if shell.pwd() ~= "/" then
      concat = "/"
    end

    return shell.pwd() .. concat .. path
  else
    return path
  end
end

local function join(tbl, joinChar)
  local rtn = ""
  for i=1, #tbl, 1 do
    rtn = rtn .. tbl[i] .. (joinChar or "")
  end
  return rtn
end

function shell.run(...)
  local a = {...}

  local s = ""
  for i=1, #a, 1 do
    s = s .. " " .. a[i]
  end

  a = shell.parse(s)

  for i=1, #a, 1 do
    a[i] = tostring(a[i])
  end
  
  local prg = shell.resolveProgram(a[1])
  local args = {}
  for i=2, #a, 1 do
    table.insert(args, a[i])
  end
  if not runBuiltin(a[1], table.unpack(args)) then
    if prg then
      local p, e = loadfile(prg)
      if not p then
        errors.error(e)
        return
      end

      setfenv(p, _G)
      p(table.unpack(args))
    else
      errors.programNotFoundError(a[1])
    end
  end
end

function shell.runScript(path)
  local h = fs.open(shell.resolvePath(path), "r")
  if not h then errors.fileNotFoundError(); return end
  local data = {}
  while true do
    local ln = h.readLine()
    if ln then
      table.insert(data, ln)
    else
      break
    end
  end
  h.close()

  data[#data] = nil

  for i=1, #data, 1 do
    shell.run(data[i])
  end
  return
end

while not exit do
  local prompt = join(shell.parse("$USER @ $HOSTNAME : $PWD"), "")
  if users.user() == "root" then
    prompt = prompt .. "# "
  else
    prompt = prompt .. "$ "
  end

  write(prompt)
  local cmd = read()
  shell.run(cmd)
end
