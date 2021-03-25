local moduleName = "util"
local M = {}
_G[moduleName] = M

-- padds str with the char 0 until it is the size of num
function M.padString(str, num)
-- does nothing if str length is greater than num 
	if(string.len(str)>=num) then
		return str
	end

	ex = string.rep("0", num - string.len(str))
	return str..ex
end

function M.ToInteger(number)
    return math.floor(tonumber(number) or error("Could not cast '" .. tostring(number) .. "' to number.'"))
end

function M.fitCString(str, size)
	new_str = str..'\0'
	
	if(string.len(new_str) > size) then 
		new_str = string.sub(new_str, 0,size)
		new_str[-1] = '\0'
		return new_str
	end
	
	new_str = M.padString(new_str, size)
	return new_str
end

return M