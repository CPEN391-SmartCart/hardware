local moduleName = "util"
local M = {}
_G[moduleName] = M


function M.sendResponse(response, exit_status)
	uart.write(0, 'STRT\n')
	uart.write(0,response)
	uart.write(0,'EXIT'..exit_status..'\0')
end

--return 0 at success, 1 at list end
function M.list_iter (t)
  local i = 0
  local n = table.getn(t)
  return function ()
		   i = i + 1
		   if n == 1 then M.sendResponse(tostring(n)..'|'..t[i], '0') 
		   elseif i == 1 then M.sendResponse(tostring(n)..'|'..t[i], '9')
		   elseif i < n then M.sendResponse(t[i], '9')
		   elseif i == n then 
		   	   M.sendResponse(t[i], '0') 
			   t = nil		   
		   else sendResponse('EOFRESPONSE', '2') end
		 end --end anon function
end

return M