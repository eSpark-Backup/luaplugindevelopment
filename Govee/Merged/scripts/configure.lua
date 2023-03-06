params = ... or {}
local logging = require("logging")

logging.info("Logger1 called before network.udp();")

if (not isNetworkHandleExist) then
	network = require("network")
	handle = network.udp()
		isNetworkHandleExist = true
else
	return
end

local params = ... or {}
targetedUDPFoundDevs=0
totalPacketsReceived=0
local ipaddress=""


local multicastIP = "239.255.255.250"
local multicastPort = 4001
local multicastPortCommand = 4003
local govee_devices_ip ={}
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

local SetGoveeOnOff = 0
--close a network connection if payload parameter has value "close"
if type(params.DevOnOff) == "string" then
	SetGoveeOnOff = params.DevOnOff
end


-- recursively search the govee message for IP4
local function findrecr(str, substr, callback, init)
    init = init or 1
    local first, last = str:find(substr, init)
    if first then
        --callback(str, first, last)
        table.insert(govee_devices_ip,string.sub(str,first, last))
        return findrecr(str, substr, callback, last+1)
    end
 end

logging.info("Logger1 called before sendto")
network.sendto(handle, PayloadString, multicastIP, multicastPort)--"4001"

logging.info("Logger1 SERVERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRr called before network.udp();")

targetedUDPFoundDevs=0
local ipaddress=""

  local beginTime = os.time()
  
   while os.time() - beginTime < multicastDuration do
     local data, address, port = network.receivefrom(handle)
	 if #address>1 and data then --received any UDP packet?
		targetedUDPFoundDevs=targetedUDPFoundDevs+1
        print("Message: " .. data)
		--search govee message for IP4 and adds to array
		findrecr(data, "%d+%.%d+%.%d+%.%d+", print)

				 print("Address: " .. address)
				 print("Port: " .. port)
	 end
	end

	network.close(handle)

print("Govee SET COMMAND ON/OFF starting!")
print("Govee SET COMMAND ON/OFF starting!")
print("Govee SET COMMAND ON/OFF starting!")

-- reusing network handle for govee command initiative
if (isNetworkHandleExist) then
	network = require("network")
	handle = network.udp()
		isNetworkHandleExist = false
end

--payload to Set ON/OFF
PayloadString = '{'..
'	"msg":{'..
'	  "cmd":"turn",'..
'	  "data":{'..
'		"value":'..SetGoveeOnOff..
'	  }'..
'	}'..
'  }';

print(PayloadString)
print("************************************************")
print("Select value for Client network.handle ="..handle)
print("************************************************")

logging.info("Logger1 called before GoveeCommand setsockname")

if(isSocketName) then
network.setoption(handle, "broadcast")
network.setsockname(handle, "*", multicastPortCommand)--"*", "4003"
isSocketName=true
end

for k,ip4Ditionary in pairs(govee_devices_ip) do 
multicastIP = ip4Ditionary
logging.info("Logger1 called before sendto ")
print(k,ip4Ditionary) 
network.sendto(handle, PayloadString, ip4Ditionary, multicastPortCommand)--"Is there anyone?" "DiscoverMotor"
end

logging.info("Logger1 Commmmmmmmmmmmmmmmmmmmmmmmandddd called before network.udp();")

targetedUDPFoundDevs=0
multicastDuration =20
ipaddress=""
beginTime = os.time()

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

network.close(handle)
