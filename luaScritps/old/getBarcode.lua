util = require("util")

collectgarbage()

local decoder = sjson.decoder()

-- decoder:write("{"barcode":"XGAO9797","section_id":5,"name":"oysters","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}")
t = sjson.decode('{"barcode":"XGAO9797","section_id":5,"name":"oysters","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}')
 
barcode = util.fitCString(t["barcode"]..'\0',10)
section_id = util.ToInteger(t["section_id"])
name = util.fitCString(t["name"]..'\0', 25)
cost = tonumber(t["cost"])

x = struct.pack("c10i1c25f", barcode, section_id, name, cost)

uart.write(0, 'STRT\n')
--for i = 0, string.len(x),1 do
  --uart.write(0,string.byte(x, i))
--end

section_id = 12345
print(section_id)
for i = 0, 4, 1 do
  uart.write(0, math.floor(section_id/256), section_id%256)
  print('')
end
uart.write(0,'EXIT\n')

collectgarbage()



