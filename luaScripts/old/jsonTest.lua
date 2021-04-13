
http.get("http://cpen391-smartcart.herokuapp.com/items/XGAO9797", nil, function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else     
      print(code, data)
      
      ok, tablet_json = pcall(sjson.decode, data)
      
      print (tablet_json["barcode"])
    end
  end)