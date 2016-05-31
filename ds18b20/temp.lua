require('ds18b20')

-- ESP-01 GPIO Mapping
gpio0 =3
gpio2 =4

ds18b20.setup(gpio0)
t=ds18b20.read()
print("Temp:" .. ds18b20.read() .. " C\n")

-- if( t==nil ) then t=0 end

tmr.alarm(0,30000, 1, function()
t=ds18b20.read()
conn=net.createConnection(net.TCP, 0) 
conn:on("receive", function(sck, c) print(c) end )
conn:on("connection", function(sck) 
sck:send("GET /update?key=<key>&field1=" .. t .. "HTTP/1.1\r\nHost: myserver.ovh.net\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n") 
end) 
conn:connect(80,"api.thingspeak.com")

conn:on("sent",function(conn) print("Closing connection") conn:close() end)
end)
