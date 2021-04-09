util = require("util")

collectgarbage()

local function parseItem(response)

	t = sjson.decode(response)

	local barcode = t["barcode"]
	local section_id = t["section_id"]
	local name = t["name"]
	local cost = t["cost"]
	local description = t["description"]
	local requires_weighing = t["requires_weighing"]
	local xPosition = t["x"]
	local yPosition = t["y"]
	local weight = t["weight"]
	

	local x = table.concat({barcode, section_id, name, cost, description,requires_weighing, xPosition, yPosition,weight}, '|')

	uart.write(0, 'STRT\n')
	uart.write(0,x)
	uart.write(0,'EXIT0\0')
end


-- sample response:
-- t = sjson.decode('{"barcode":"XGAO9797","section_id":5,"name":"oysters","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}')

print(args[1])--TODO : implement args
http.get("http://cpen391-smartcart.herokuapp.com/items/barcode/"..args[1], nil, function(code, data)
    if (code < 0) then
		uart.write(0, 'STRT\n')
		uart.write(0,'EXIT1\0')
    else           
      parseItem(data)
    end
  end)
 
 collectgarbage()


