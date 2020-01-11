-- An elegant way of handling errors, from a more civilized age.... --

local errors = {}

function errors.error(msg)
  print("err: " .. msg .. "\n")
end

function errors.notFoundError(obj)
  errors.error(obj .. " not found")
end

function errors.invalidArgumentError(expected, got)
  errors.error("Bad argument: ecpected " .. expected .. ", got " .. got)
end

function errors.accessDeniedError()
  errors.error("Access denied")
end

function errors.fileNotFoundError(file)
  errors.notFoundError(file or "File")
end

function errors.programNotFoundError(program)
  errors.notFoundError(program or "Program")
end

return errors
 
