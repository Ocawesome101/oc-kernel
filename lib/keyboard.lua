-- I hope this goes better than the OC-OS one. Yikes. --

local kb = {}

kb.keys = {}

kb.keys["1"]           = 0x02
kb.keys["2"]           = 0x03
kb.keys["3"]           = 0x04
kb.keys["4"]           = 0x05
kb.keys["5"]           = 0x06
kb.keys["6"]           = 0x07
kb.keys["7"]           = 0x08
kb.keys["8"]           = 0x09
kb.keys["9"]           = 0x0A
kb.keys["0"]           = 0x0B
kb.keys.a               = 0x1E
kb.keys.b               = 0x30
kb.keys.c               = 0x2E
kb.keys.d               = 0x20
kb.keys.e               = 0x12
kb.keys.f               = 0x21
kb.keys.g               = 0x22
kb.keys.h               = 0x23
kb.keys.i               = 0x17
kb.keys.j               = 0x24
kb.keys.k               = 0x25
kb.keys.l               = 0x26
kb.keys.m               = 0x32
kb.keys.n               = 0x31
kb.keys.o               = 0x18
kb.keys.p               = 0x19
kb.keys.q               = 0x10
kb.keys.r               = 0x13
kb.keys.s               = 0x1F
kb.keys.t               = 0x14
kb.keys.u               = 0x16
kb.keys.v               = 0x2F
kb.keys.w               = 0x11
kb.keys.x               = 0x2D
kb.keys.y               = 0x15
kb.keys.z               = 0x2C

kb.keys["'"]            = 0x28
kb.keys["@"]            = 0x91
kb.keys.back            = 0x0E -- backspace
kb.keys["\\"]           = 0x2B
kb.keys.capital         = 0x3A -- capslock
kb.keys[","]            = 0x92
kb.keys[":"]            = 0x33
kb.keys.enter           = 0x1C
kb.keys["="]            = 0x0D
kb.keys["`"]            = 0x29 -- accent grave
kb.keys["["]            = 0x1A
kb.keys.lcontrol        = 0x1D
kb.keys.lmenu           = 0x38 -- left Alt
kb.keys.lshift          = 0x2A
kb.keys["-"]            = 0x0C
kb.keys.numlock         = 0x45
kb.keys.pause           = 0xC5
kb.keys["."]            = 0x34
kb.keys.rbracket        = 0x1B
kb.keys.rcontrol        = 0x9D
kb.keys.rmenu           = 0xB8 -- right Alt
kb.keys.rshift          = 0x36
kb.keys.scroll          = 0x46 -- Scroll Lock
kb.keys[";"]            = 0x27
kb.keys["/"]            = 0x35 -- / on main kb
kb.keys[" "]            = 0x39
kb.keys.stop            = 0x95
kb.keys.tab             = 0x0F
kb.keys["_"]            = 0x93

-- Keypad (and numpad with numlock off)
kb.keys.up              = 0xC8
kb.keys.down            = 0xD0
kb.keys.left            = 0xCB
kb.keys.right           = 0xCD
kb.keys.home            = 0xC7
kb.keys["end"]         = 0xCF
kb.keys.pageUp          = 0xC9
kb.keys.pageDown        = 0xD1
kb.keys.insert          = 0xD2
kb.keys.delete          = 0xD3

-- Function keys
kb.keys.f1              = 0x3B
kb.keys.f2              = 0x3C
kb.keys.f3              = 0x3D
kb.keys.f4              = 0x3E
kb.keys.f5              = 0x3F
kb.keys.f6              = 0x40
kb.keys.f7              = 0x41
kb.keys.f8              = 0x42
kb.keys.f9              = 0x43
kb.keys.f10             = 0x44
kb.keys.f11             = 0x57
kb.keys.f12             = 0x58
kb.keys.f13             = 0x64
kb.keys.f14             = 0x65
kb.keys.f15             = 0x66
kb.keys.f16             = 0x67
kb.keys.f17             = 0x68
kb.keys.f18             = 0x69
kb.keys.f19             = 0x71

-- Japanese kbs
kb.keys.kana            = 0x70
kb.keys.kanji           = 0x94
kb.keys.convert         = 0x79
kb.keys.noconvert       = 0x7B
kb.keys.yen             = 0x7D
kb.keys.circumflex      = 0x90
kb.keys.ax              = 0x96

-- Numpad
kb.keys.numpad0         = 0x52
kb.keys.numpad1         = 0x4F
kb.keys.numpad2         = 0x50
kb.keys.numpad3         = 0x51
kb.keys.numpad4         = 0x4B
kb.keys.numpad5         = 0x4C
kb.keys.numpad6         = 0x4D
kb.keys.numpad7         = 0x47
kb.keys.numpad8         = 0x48
kb.keys.numpad9         = 0x49
kb.keys.numpadmul       = 0x37
kb.keys.numpaddiv       = 0xB5
kb.keys.numpadsub       = 0x4A
kb.keys.numpadadd       = 0x4E
kb.keys.numpaddecimal   = 0x53
kb.keys.numpadcomma     = 0xB3
kb.keys.numpadenter     = 0x9C
kb.keys.numpadequals    = 0x8D

-- Create inverse mapping for name lookup.
setmetatable(kb.keys,
{
  __index = function(tbl, k)
    if type(k) ~= "number" then return end
     for name,value in pairs(tbl) do
        if value == k then
          return name
        end
     end
  end
})

local function findKey(c)
  return string.char(c)
end

function kb.pullKey(eventData)
  local sig, kbaddr, char, code, name = table.unpack(eventData)
  if sig == "key_down" then
    return {char = findKey(code), code = code}
  end
end

return kb
