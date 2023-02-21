local logging = require("logging")
local networkServer = require("network")

logging.info("Logger1 called before network.udp();")

if (not isNetworkHandleExist) then
		handleserver = networkServer.udp()
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
local multicastServerPort = 4002
local multicastDuration = 80
--devicesSearch = {'masb','teamviewer','sonos','shelly','lutron','sonoff','somfy','apple','macbook','airTunes','airplay','honeywell','dmp','alk','venstar','harman','doorbird','hayward','milight','samsung','roku','ipbridge','android','philips','hue'}

local PayloadString = '{'..
'  "msg":{'..
'    "cmd":"scan",'..
'    "data":{'..
'      "account_topic":"reserve"'..
'    }'..
'  }'..
'}';




	print("************************************************")
	--print("Select value for Client network.handle ="..handle)
	print("Select value for Server network.handle ="..handleserver)
	-- print("Select value for multicastIP ="..multicastIP)
	-- print("Select value for multicastPort ="..multicastPort)
	-- print("Select value for multicastDuration ="..multicastDuration)
	-- print("Select value for PayloadString ="..PayloadString)
	print("************************************************")
	
if params.event ~= "" and params.event == "request" then
	print("Sonos SSDP Plugin has been STARTED Configuring SucceSSfullY"..params.data.user_data .. params.data.datagram)
    return
end


--close a network connection if payload parameter has value "close"
if type(params.PayloadString) == "string" and params.PayloadString == "close" then
	logging.info("NETWORK CONNECTION STARTING TO CLOSE SucceSSfullY")
	networkServer.close(handleserver)
	logging.info("NETWORK CONNECTION NOW CLOSEDDDDD SucceSSfullY")
	return
end


logging.info("Logger1 called before setsockname")
if(not isSocketName) then
	--network.setsockname(handle, "*", multicastPort)--"*", "8021"
	networkServer.setsockname(handleserver, "*", multicastServerPort)--"*", "8021"
	isSocketName=true
end

networkServer.setoption(handleserver, "broadcast")


  local beginTime = os.time()
  
   while os.time() - beginTime < multicastDuration do
     local data, address, port = networkServer.receivefrom(handleserver)
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