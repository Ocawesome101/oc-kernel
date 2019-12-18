-- Rudimentary filesystem API. Overridden by /lib/filesystem.lua later --

local boot_address = ...

_G.fs = component.proxy(boot_address)
