-- Do the bare minimum to boot oc-kernel --

local loadfile = ...

local flags = {multithread_disabled = false}

local ok, err = loadfile("/boot/ockernel.lua")

if not ok then
  error(err)
end

ok(flags)
