util = require("util")

node.egc.setmode(node.egc.ALWAYS)
collectgarbage()

function parseSections(response)
	
	sections={}

	--local teststring = '[{"x":319,"y":264,"width":12,"height":61,"colour":15},{"x":319,"y":327,"width":12,"height":96,"colour":15},{"x":287,"y":216,"width":98,"height":17,"colour":15},{"x":34,"y":135,"width":59,"height":18,"colour":15},{"x":34,"y":171,"width":59,"height":18,"colour":15},{"x":34,"y":207,"width":59,"height":18,"colour":15},{"x":34,"y":243,"width":98,"height":17,"colour":15},{"x":34,"y":28,"width":59,"height":17,"colour":15},{"x":34,"y":328,"width":98,"height":17,"colour":15},{"x":319,"y":264,"width":12,"height":61,"colour":15},{"x":34,"y":360,"width":79,"height":18,"colour":15},{"x":34,"y":394,"width":79,"height":17,"colour":15},{"x":34,"y":428,"width":79,"height":17,"colour":15},{"x":34,"y":64,"width":59,"height":17,"colour":15},{"x":34,"y":99,"width":59,"height":17,"colour":15},{"x":45,"y":278,"width":19,"height":33,"colour":15},{"x":92,"y":285,"width":39,"height":18,"colour":15},{"x":429,"y":29,"width":21,"height":160,"colour":15},{"x":347,"y":264,"width":13,"height":61,"colour":46},{"x":347,"y":327,"width":13,"height":96,"colour":46},{"x":381,"y":264,"width":21,"height":71,"colour":46},{"x":381,"y":29,"width":21,"height":160,"colour":46},{"x":381,"y":373,"width":21,"height":72,"colour":46},{"x":151,"y":243,"width":62,"height":17,"colour":30},{"x":151,"y":328,"width":62,"height":17,"colour":30},{"x":151,"y":360,"width":62,"height":18,"colour":30},{"x":151,"y":394,"width":62,"height":17,"colour":30},{"x":151,"y":428,"width":62,"height":17,"colour":30},{"x":431,"y":264,"width":19,"height":71,"colour":13},{"x":24,"y":373,"width":19,"height":72,"colour":13},{"x":431,"y":216,"width":98,"height":17,"colour":13},{"x":527,"y":264,"width":19,"height":71,"colour":23},{"x":527,"y":29,"width":19,"height":160,"colour":23},{"x":527,"y":373,"width":19,"height":72,"colour":23},{"x":478,"y":264,"width":20,"height":71,"colour":63},{"x":478,"y":29,"width":20,"height":160,"colour":63},{"x":478,"y":373,"width":20,"height":72,"colour":63},{"x":290,"y":264,"width":13,"height":61,"colour":10},{"x":290,"y":327,"width":13,"height":96,"colour":10},{"x":299,"y":123,"width":61,"height":18,"colour":10},{"x":299,"y":171,"width":61,"height":18,"colour":10},{"x":299,"y":29,"width":61,"height":17,"colour":10},{"x":299,"y":77,"width":61,"height":17,"colour":10},{"x":132,"y":135,"width":81,"height":18,"colour":9},{"x":132,"y":171,"width":81,"height":18,"colour":9},{"x":132,"y":207,"width":81,"height":18,"colour":9},{"x":132,"y":28,"width":81,"height":17,"colour":9},{"x":132,"y":64,"width":81,"height":17,"colour":9},{"x":132,"y":99,"width":81,"height":17,"colour":9}]'
	

	local sectionJson = sjson.decode(response)

	collectgarbage()

	for k,v in pairs(sectionJson) do 
		
		local xPosition = v["x"]
		local yPosition = v["y"]
		local height = v["height"]
		local width = v["width"]
		local colour = v["colour"]

		local x = table.concat({xPosition, yPosition, height, width, colour}, '|')
		table.insert(sections,x)
	end

	print_iter = util.list_iter(sections)
	
	print_iter()

	collectgarbage()
end

local storeid = args[1]
http.get("http://cpen391-smartcart.herokuapp.com/sections/"..storeid, nil, function(code, data)
    if (code < 0) then
		uart.write(0, 'STRT\n')
		uart.write(0,'EXIT1\0')
    else
      parseSections(data)
    end
  end)
 
 collectgarbage()


