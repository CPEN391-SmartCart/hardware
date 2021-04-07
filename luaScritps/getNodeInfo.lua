util = require("util")

collectgarbage()

local function parseNodeInfo(response)

	local t = sjson.decode(response)

	local x = t["x"]
	local y = t["y"]
	local node_id = t["node_id"]
	local parent_node_id = t["parent_node_id"]
	local current_cost = t["current_cost"]
	local child_one_id = t["child_one_id"]
	local distance_child_one = t["distance_child_one"]
	local child_two_id = t["child_two_id"]
	local distance_child_two = t["distance_child_two"]
	local child_three_id = t["child_three_id"]
	local distance_child_three = t["distance_child_three"]
	local child_four_id = t["child_four_id"]
	local distance_child_four = t["distance_child_four"]
	local child_five_id = t["child_five_id"]
	local distance_child_five = t["distance_child_five"]
	local child_six_id = t["child_six_id"]
	local distance_child_six = t["distance_child_six"]

	local x = table.concat({x, y, node_id, parent_node_id, current_cost,child_one_id, distance_child_one, child_two_id, distance_child_two,child_three_id ,distance_child_three ,child_four_id , distance_child_four, child_five_id, distance_child_five,child_six_id , distance_child_six}, '|')

	util.sendResponse(x, '0')

end


-- sample response:
-- t = sjson.decode('{"barcode":"XGAO9797","section_id":5,"name":"oysters","cost":56.5,"description":"Snack","requires_weighing":1,"x":89,"y":196,"created_at":"2021-03-14T04:07:27.325Z","updated_at":"2021-03-14T04:07:27.325Z"}')

print(args[1])--TODO : implement args
http.get("http://cpen391-smartcart.herokuapp.com/item-nodes/"..args[1], nil, function(code, data)
    if (code < 0) then
		uart.write(0, 'STRT\n')
		uart.write(0,'EXIT1\0')
    else           
      parseNodeInfo(data)
    end
  end)
 
 collectgarbage()


