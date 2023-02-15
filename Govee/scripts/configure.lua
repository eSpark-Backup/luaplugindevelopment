local logging = require("logging")
local network = require("network")

logging.info("Logger1 called before network.udp();")

if (not isNetworkHandleExist) then
		handle = network.udp()
		isNetworkHandleExist = true
end

local params = ... or {}

--local multicastIP = "239.255.255.250"
--local multicastPort = 1900
local multicastDuration = 20			--'M-SEARCH * HTTP/1.1\r\n HOST: 239.255.255.250:1900\r\n MAN:ssdp:discover\r\n MX:1\r\n\z ST:ssdp:all\r\n\z'

-- local PayloadString = 'M-SEARCH * HTTP/1.1\r\n\z		
-- HOST: 239.255.255.250:1900\r\n\z
-- MAN: "ssdp:discover"\r\n\z
-- MX: 1\r\n\z
-- ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n\r\n'

local PayloadString = "{'msg':{    'cmd':'scan',    'data':{      'account_topic':'reserve'    }  }}"
local PayloadString2 = "{msg:{    cmd:scan,    data:{      account_topic:reserve    }  }}"
local PayloadString3 = "{msg:{    cmd:'scan',    data:{      account_topic:'reserve'    }  }}\r\n"

multicastIp = '239.255.255.250';
multicastPort = 4001;
--local receiverPort = 4002;
--local devicePort = 4003;
--local getDevicesScanTimeoutMs = 2000;



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
		logging.info("Select value for params.multicastDuration ="..params.PayloadString)
		PayloadString = params.PayloadString
	end
	if type(params.multicastDuration) == "number" and (params.multicastDuration) then
		logging.info("Select value for params.PayloadString ="..params.multicastDuration)
		multicastDuration = params.multicastDuration
	end

	logging.info("************************************************")
	logging.info("Select value for network.handle ="..handle)
	logging.info("Select value for multicastIP ="..multicastIP)
	logging.info("Select value for multicastPort ="..multicastPort)
	logging.info("Select value for multicastDuration ="..multicastDuration)
	logging.info("Select value for PayloadString ="..PayloadString)
	logging.info("************************************************")
	
if params.event ~= "" and params.event == "request" then
	logging.info("Govee SSDP Plugin has been STARTED Configuring SucceSSfullY"..params.data.user_data .. params.data.datagram)
    return
end


logging.info("Logger1 called before setsockname")
if(isSocketName) then
	network.setsockname(handle, "*", multicastPort)--"*", "8021"
	isSocketName=false
end

--close a network connection if payload parameter has value "close"
if type(params.PayloadString) == "string" and params.PayloadString == "close" then
	logging.info("NETWORK CONNECTION HAS BEEN CLOSING SucceSSfullY")
	isSocketName = true
	network.close(handle)
	logging.info("NETWORK CONNECTION HAS BEEN CLOSEDDDDD SucceSSfullY")
	return
end
--print(os.date("%x", 906000490))
logging.info(os.date("%X",os.time()) .. "Logger1 called before sendto")
network.sendto(handle, PayloadString, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"
logging.info(os.date("%X",os.time()) .. "Logger2 called before sendto")
network.sendto(handle, PayloadString2, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"
logging.info(os.date("%X",os.time()) .. "Logger3 called before sendto")
network.sendto(handle, PayloadString3, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"

network.setoption(handle, "broadcast")

--logging.info("Logger1 called before request()")
--network.request(handle, "HUB:minhttp.log_test/scripts/somficallback1", PayloadString)

  local beginTime = os.time()
  
   while os.time() - beginTime < multicastDuration do
     local data, address, port = network.receivefrom(handle)
	 if #address>1 then --received any UDP packet?
		totalPacketsReceived=totalPacketsReceived+1
        logging.info(os.date("%X",os.time()))
		logging.info("Message: " .. data)
        logging.info("Address: " .. address)
        logging.info("Port: " .. port)
	 end
	end

	
logging.info("**************Summary **********************")
logging.info("totalPacketsReceived= "..totalPacketsReceived)
logging.info("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
logging.info("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")
logging.info("Govee Discovery Plugin has been Ended Configuring SucceSSfullY")

totalPacketsReceived=0