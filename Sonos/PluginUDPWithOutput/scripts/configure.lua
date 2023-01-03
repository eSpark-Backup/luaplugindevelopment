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
targetedDeviceList={}
local ipaddress=""
local ipset=false



function SplitoTable(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


local multicastIP = "239.255.255.250"
local multicastPort = 1900
local multicastDuration = 20
devicesSearch = {'masb','teamviewer','sonos','shelly','lutron','sonoff','somfy','apple','macbook','airTunes','airplay','honeywell','dmp','alk','venstar','harman','doorbird','hayward','milight','samsung','roku','ipbridge','android','philips','hue'}
local PayloadString = 'M-SEARCH * HTTP/1.1\r\n\z
HOST: 239.255.255.250:1900\r\n\z
MAN: "ssdp:discover"\r\n\z
MX: 1\r\n\z
ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n\r\n'

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
		print("Select value for params.multicastDuration ="..params.PayloadString)
		PayloadString = params.PayloadString
	end
	if type(params.multicastDuration) == "number" and (params.multicastDuration) then
		print("Select value for params.PayloadString ="..params.multicastDuration)
		multicastDuration = params.multicastDuration
	end
	-- if type(params.devs) == "string" and (params.devs) and (#params.devs > 2) then
	-- 	devicesSearch = SplitoTable(params.devs,',')
	-- 	print("Select value for Searched Devices ="..params.devs .."  converted to table="..devicesSearch[1])		
	-- end

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

logging.info("Logger1 called before sendto")
network.sendto(handle, PayloadString, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"

network.setoption(handle, "broadcast")

--logging.info("Logger1 called before request()")
--network.request(handle, "HUB:minhttpwaqar1.log_test/scripts/somficallback1", PayloadString)

  local beginTime = os.time()
  
   while os.time() - beginTime < multicastDuration do
     local data, address, port = network.receivefrom(handle)
	 if #address>1 and data then --received any UDP packet?
		targetedUDPFoundDevs=targetedUDPFoundDevs+1
        print("Message: " .. data)
				if #data>20 then
						for i, v in ipairs(devicesSearch) do
							myvar1,myvar2 = string.find(string.lower(data), string.lower(v))
							if myvar1 then
								print(i..' - '..v,myvar1,myvar2)
								table.insert(targetedDeviceList, data)
							end
						end
	 			end



				 print("Address: " .. address)
				 print("Port: " .. port)

				 if ipset then
					ipaddress = address
					ipset = false
					print("ip found ="..ipaddress)
				 end
	 end
	end

-- if ipset then
-- 	print(" NO UDP Setup Found Please Setup Network Settings for UDP/MDns")
-- 	return
-- end
--totalPacketsReceived = targetedUDPFoundDevs
print("Sonos Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Sonos Discovery Plugin has been Ended Configuring SucceSSfullY")
print("Sonos Discovery Plugin has been Ended Configuring SucceSSfullY")

-- function os.capture(cmd, raw)
--     local f = assert(io.popen(cmd, 'r'))
--     local s = assert(f:read('*a'))
--     f:close()
--   if raw then return s end
--     s = string.gsub(s, '^%s+', '')
--     s = string.gsub(s, '%s+$', '')
--     s = string.gsub(s, '[\n\r]+', ' ')
--     return s
--   end


-- local myvar1 = ipaddress--os.capture('hostname -I ',false)
-- local myvar2 = string.match(tostring(myvar1), "%d+.%d+.%d+")
-- local myvar3 = myvar2..".1 - "..myvar2..".255"

logging.info("*********************************************************************************")
logging.info("***************Starting Shelly Devices Searching Starting************************")
logging.info("*********************************************************************************")

-- local ip_addresses = myvar3 --"10.100.132.1 - 10.100.132.254"
-- local ports = "" --80  2020, 30, 8080
-- local ip_version = "IPv4" -- or IPv6
-- --local script = "HUB:minhttpwaqar1.log_test/scripts/handle_network_scan_results"

-- --If user has entered any of the following variables then use them
-- 	if type(params.version) == "string" and (params.version) then
-- 		logging.info("Selected version of IP ="..params.version)
-- 		ip_version = params.version
--     else
--         logging.info("Selected version of IP ="..ip_version)
-- 	end
-- 	if type(params.multicastPort) == "number" and (params.multicastPort) then               -- 80
-- 		logging.info("Selected value for params.ports ="..params.multicastPort)
-- 		ports = params.multicastPort
--     else        
--         logging.info("Selected value for params.ports ="..ports)
-- 	end
-- 	if type(params.multicastIP) == "string" and (params.multicastIP) then                 --192.168.18.1 - 192.168.18.254
-- 		logging.info("Selected value for params.range ="..params.multicastIP)
-- 		ip_addresses = params.multicastIP
--     else
--         logging.info("Selected value for params.range ="..ip_addresses)
-- 	end

    --logging.info("Starting scanning network for ipranges ="..ip_addresses .." and port(s) = "..ports)
    --scan_id = network.start_scan_network(script, ip_addresses, ip_version, ports)

