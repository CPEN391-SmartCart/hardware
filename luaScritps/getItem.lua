util = require("util")

collectgarbage()

local function parseItem(response)

	t = sjson.decode(response)

	barcode = t["barcode"]
	section_id = t["section_id"]
	name = t["name"]
	cost = t["cost"]
	description = t["description"]
	requires_weighing = t["requires_weighing"]
	xPosition = t["x"]
	yPosition = t["y"]


	x = table.concat({barcode, section_id, name, cost, description,requires_weighing, xPosition, yPosition}, '|')

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


