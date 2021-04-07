util = require("util")

node.egc.setmode(node.egc.ALWAYS)
collectgarbage()

function parseLegends(response)
	
	legends={}

	--local teststring = '[{"id":21,"store_id":1,"key":"FROZEN FOOD","colour":15},{"id":22,"store_id":1,"key":"FRUITS AND VEGETABLES","colour":46},{"id":23,"store_id":1,"key":"STAPLES","colour":30},{"id":24,"store_id":1,"key":"CONDIMENTS","colour":13},{"id":25,"store_id":1,"key":"PHARMA AND SELF-CARE","colour":23},{"id":26,"store_id":1,"key":"BAKERY","colour":63},{"id":27,"store_id":1,"key":"BREAKFAST","colour":10},{"id":28,"store_id":1,"key":"CHECKOUT COUNTERS","colour":9}]'
	

	local legendsJson = sjson.decode(response)

	collectgarbage()

	for k,v in pairs(legendsJson) do 
		
		local key = v["key"]
		local colour = v["colour"]

		local x = table.concat({key, colour}, '|')
		table.insert(legends,x)
	end

	print_iter = util.list_iter(legends)
	
	print_iter()
	
	collectgarbage()
end

local storeid = args[1]
http.get("http://cpen391-smartcart.herokuapp.com/legends/"..storeid, nil, function(code, data)
    if (code < 0) then
		uart.write(0, 'STRT\n')
		uart.write(0,'EXIT1\0')
    else
      parseLegends(data)
    end
  end)
 
 collectgarbage()


