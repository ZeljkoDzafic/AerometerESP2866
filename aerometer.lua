-- aerometer
uart.on("data", 0,
    function(json_text)
        data = cjson.decode(json_text)
        testJson (data)
        sendDataAerometer(data)
        sendDataThingSpeak(data)
    end, 0)

	

function testJson(data)
    for k,v in pairs(data) do print(k,v) end
end
function sendDataThingSpeak(data)
    print("Sending data to thingspeak.com")
    conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) print(payload) end)
    print("update?key=6SDDM0XZGA04U1BP&field1="..data.temp.."&field3="..data.hum.."&field2="..data.pressure.."&field8="..data.smoke.."&field7="..data.lpg.."&field4="..data.co.."&field5="..data.co2.."&field6="..data.co1)
    -- api.thingspeak.com 184.106.153.149
    conn:connect(80,'184.106.153.149')
    conn:send("GET /update?key=6SDDM0XZGA04U1BP&field1="..data.temp.."&field3="..data.hum.."&field2="..data.pressure.."&field8="..data.smoke.."&field7="..data.lpg.."&field4="..data.co.."&field5="..data.co2.."&field6="..data.co1)
    conn:send("Host: api.thingspeak.com\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:on("sent",function(conn)
                  print("Closing connection")
                  conn:close()
              end)
    conn:on("disconnection", function(conn)
                  print("Got disconnection...")
    end)
end

function sendDataAerometer(data)
    print("Sending data to aerometer.net")
    conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) print(payload) end)
    print("POST /api/station?unique_id=f6c2b536-8870-3722-a151-49ce7c811660&temperature="..data.temp.."&humidity="..data.hum.."&pressure="..data.pressure.."&smoke="..data.smoke.."&lpg="..data.lpg.."&co="..data.co.."&co2="..data.co2)
    -- app.aerometer.net 104.131.69.19
    conn:connect(80,'104.131.69.19')
    conn:send("POST /api/stations?unique_id=f6c2b536-8870-3722-a151-49ce7c811660&temperature="..data.temp.."&humidity="..data.hum.."&pressure="..data.pressure.."&smoke="..data.smoke.."&lpg="..data.lpg.."&co="..data.co.."&co2="..data.co2)
    conn:send("Host: app.aerometer.net\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:on("sent",function(conn)
                  print("Closing connection")
                  conn:close()
              end)
    conn:on("disconnection", function(conn)
                  print("Got disconnection...")
    end)
end
testJson(data)
sendDataThingSpeak(data)
sendDataAerometer(data)