-- Provide a better event system -- 

local pullSig = computer.pullSignal

local function pull(filter, timeout)
  local sig, param1, param2, param3, param4, param5, param6, param7 = pullSig()
  if sig then
    if filter then
      if sig == filter then
        return sig, param1, param2, param3, param4, param5, param6, param7
      end
    else
      return sig, param1, param2, param3, param4, param5, param6, param7
    end
  end
end

return pull
