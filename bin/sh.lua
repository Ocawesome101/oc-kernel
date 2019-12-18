-- Shell --

local shell = {}

function shell.run(program, ...)
  kernel.psinit(program, ...)
end

while true do
  io.write("shell: ")
  local str = io.read()
end
