local logging = require("logging")
local network = require("network")

logging.info("Logger1 called before network.udp();")

if (not isNetworkHandleExist) then
		handle = network.udp()
		isNetworkHandleExist = true
end

local params = ... or {}
targetedUDPFoundDevs=0
totalPacketsReceived=0
--targetedDeviceList={}
local ipaddress=""
--local ipset=false



function SplitoTable(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


local multicastIP = "239.255.255.250"
local multicastPort = 4001
local multicastDuration = 2000
--devicesSearch = {'masb','teamviewer','sonos','shelly','lutron','sonoff','somfy','apple','macbook','airTunes','airplay','honeywell','dmp','alk','venstar','harman','doorbird','hayward','milight','samsung','roku','ipbridge','android','philips','hue'}

local PayloadString = '{"msg":{    "cmd":"scan",    "data":{      "account_topic":"reserve"    }  }}'

	--If user has entered any of the following variables then use them
	if type(params.multicastIP) == "string" and (params.multicastIP) then
		logging.info("Select value for params.multicastIP ="..params.multicastIP)
		multicastIP = params.multicastIP
	end
	if type(params.multicastPort) == "number" and (params.multicastPort) then
		logging.info("Select value for params.multicastPort ="..params.multicastPort)
		multicastPort = params.multicastPort
	end
	if type(params.PayloadString) == "string" and (params.PayloadString) then
		print("Select value for params.PayloadString ="..params.PayloadString)
		PayloadString = params.PayloadString
	end
	if type(params.multicastDuration) == "number" and (params.multicastDuration) then
		print("Select value for params.multicastDuration ="..params.multicastDuration)
		multicastDuration = params.multicastDuration
	end

	print("************************************************")
	print("Select value for network.handle ="..handle)
	print("Select value for multicastIP ="..multicastIP)
	print("Select value for multicastPort ="..multicastPort)
	print("Select value for multicastDuration ="..multicastDuration)
	print("Select value for PayloadString ="..PayloadString)
	print("************************************************")
	
if params.event ~= "" and params.event == "request" then
	print("Sonos SSDP Plugin has been STARTED Configuring SucceSSfullY"..params.data.user_data .. params.data.datagram)
    return
end


--close a network connection if payload parameter has value "close"
if type(params.PayloadString) == "string" and params.PayloadString == "close" then
	logging.info("NETWORK CONNECTION HAS BEEN CLOSING SucceSSfullY")
	network.close(handle)
	logging.info("NETWORK CONNECTION HAS BEEN CLOSEDDDDD SucceSSfullY")
	return
end


logging.info("Logger1 called before setsockname")
if(not isSocketName) then
	network.setsockname(handle, "*", multicastPort)--"*", "8021"
	isSocketName=true
end

logging.info(os.date("%X",os.time()) .. "Logger1 called before sendto")
network.sendto(handle, PayloadString, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"

network.setoption(handle, "broadcast")

--logging.info("Logger1 called before request()")
--network.request(handle, "HUB:goveedevice.discovery/scripts/somficallback1", PayloadString)

  local beginTime = os.time()
  
   while os.time() - beginTime < multicastDuration do
     local data, address, port = network.receivefrom(handle)
	 if #address>1 and data then --received any UDP packet?
		targetedUDPFoundDevs=targetedUDPFoundDevs+1
		 logging.info(os.date("%X",os.time()))
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

				--  if ipset then
				-- 	ipaddress = address
				-- 	ipset = false
				-- 	print("ip found ="..ipaddress)
				--  end
	 end
	end

-- if ipset then
-- 	print(" NO UDP Setup Found Please Setup Network Settings for UDP/MDns")
-- 	return
-- end
--totalPacketsReceived = targetedUDPFoundDevs

print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
