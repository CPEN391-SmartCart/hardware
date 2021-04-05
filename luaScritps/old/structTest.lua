util = require("util")

local decoder = sjson.decoder()

-- decoder:write("{"barcode":"XGAO9797","section_id":5,"name":"oysters and their liquor","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}")

t = sjson.decode('{"barcode":"XGAO9797","section_id":5,"name":"oysters and their liquor","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}')

barcode = t["barcode"]
section_id = util.ToInteger(t["section_id"])
name = t["name"]
cost = tonumber(t["cost"])

x = struct.pack("BBc0BBBc0Bf", 4, string.len(barcode), barcode, 1, section_id, string.len(name), name, 8, cost)

print(x)
print('DONE\n\n\n')
--for i = 0, string.len(x),1 do
--  print(string.byte(x, i))
--end

