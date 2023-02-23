params = ... or {}
local logging = require("logging")

logging.info("Logger1 called before network.udp();")

if (not isNetworkHandleExist) then
	network = require("network")
	handle = network.udp()
		isNetworkHandleExist = true
end

local params = ... or {}
targetedUDPFoundDevs=0
totalPacketsReceived=0
local ipaddress=""


local multicastIP = "239.255.255.250"
local multicastPort = 4001
local PayloadString = '{'..
'  "msg":{'..
'    "cmd":"scan",'..
'    "data":{'..
'      "account_topic":"reserve"'..
'    }'..
'  }'..
'}';

	print("************************************************")
	print("Select value for Client network.handle ="..handle)
	print("************************************************")
	
local multicastServerPort = 4002
local multicastDuration = 40	--26.6666 = 1sec
logging.info("Logger1 called before setsockname")

if(not isSocketName) then
	network.setoption(handle, "broadcast")
	network.setsockname(handle, "*", multicastServerPort)--"*", "4002"
	isSocketName=true
end



logging.info("Logger1 called before sendto")
network.sendto(handle, PayloadString, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"

logging.info("Logger1 SERVERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRr called before network.udp();")

targetedUDPFoundDevs=0
local ipaddress=""

  local beginTime = os.time()
  
   while os.time() - beginTime < multicastDuration do
     local data, address, port = network.receivefrom(handle)
	 if #address>1 and data then --received any UDP packet?
		targetedUDPFoundDevs=targetedUDPFoundDevs+1
        print("Message: " .. data)
				-- if #data>20 then
				-- 		for i, v in ipairs(devicesSearch) do
				-- 			myvar1,myvar2 = string.find(string.lower(data), string.lower(v))
				-- 			if myvar1 then
				-- 				print(i..' - '..v,myvar1,myvar2)
				-- 				table.insert(targetedDeviceList, data)
				-- 			end
				-- 		end
	 			-- end



				 print("Address: " .. address)
				 print("Port: " .. port)
	 end
	end


print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
