-- when '\r' is received.
uart.on("data", ';',
  function(data)
    dofile("httptest.lua")
    print("receive from uart:", data)
end, 0)
