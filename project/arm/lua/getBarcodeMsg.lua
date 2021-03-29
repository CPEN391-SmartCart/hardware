util = require("util")

collectgarbage()

local decoder = sjson.decoder()

-- decoder:write("{"barcode":"XGAO9797","section_id":5,"name":"oysters","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}")
t = sjson.decode('{"barcode":"XGAO9797","section_id":5,"name":"oysters","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}')
 
barcode = t["barcode"]
section_id = t["section_id"]
name = t["name"]
cost = t["cost"]

x = table.concat({barcode, section_id, name, cost}, '|')

uart.write(0, 'STRT\n')
uart.write(0,x)
uart.write(0,'EXIT0\0')

collectgarbage()

