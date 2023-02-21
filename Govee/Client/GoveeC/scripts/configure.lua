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
	print("Select value for Client network.handle ="..handle)
	--print("Select value for Server network.handle ="..handleserver)
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

logging.info("Logger1 called before sendto")
network.sendto(handle, PayloadString, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"

network.setoption(handle, "broadcast")

print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")