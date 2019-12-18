-- For Openloader / Lua BIOS compatibility
local addr, invoke = computer.getBootAddress(), component.invoke

local function loadfile(file)
  local handle = assert(invoke(addr, "open", file))
  local buffer = ""
  repeat
    local data = invoke(addr, "read", handle, math.huge)
    buffer = buffer .. (data or "")
  until not data
  invoke(addr, "close", handle)
  return load(buffer, "=" .. file, "bt", _G)
end

loadfile("/efi/boot/bootoc.lua")(loadfile)

while true do
  if _G.shutdown then
    computer.shutdown()
    break
  end
end
