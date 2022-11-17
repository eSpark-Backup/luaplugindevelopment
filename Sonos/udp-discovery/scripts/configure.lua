local logging = require("logging")
local network = require("network")

local params = ... or {}

local multicastIP = "239.255.255.250"
local multicastPort = 1900
local PayloadString = 'M-SEARCH * HTTP/1.1\r\n\z
HOST: 239.255.255.250:1900\r\n\z
MAN: "ssdp:discover"\r\n\z
MX: 1\r\n\z
ST: urn:schemas-upnp-org:device:ZonePlayer:1\r\n\r\n'


	if type(params.multicastIP) == "string" and #params.multicastIP <2 then
		multicastIP = params.multicastIP
	end
	if type(params.multicastPort) == "string" and #params.multicastPort <2 then
		multicastPort = params.multicastPort
	end
	if type(params.PayloadString) == "string" and #params.PayloadString <2 then
		PayloadString = params.PayloadString
	end


if params.event ~= "" and params.event == "request" then
	logging.info("The plugin has been STARTED Configuring SucceSSfullY"..params.data.user_data .. params.data.datagram)
    return
end


logging.info("Logger1 called before network.udp();")
local handle = network.udp();

if type(params.PayloadString) == "string" and params.PayloadString == "close" then
	logging.info("NETWORK CONNECTION HAS BEEN CLOSING SucceSSfullY")
	network.close(handle)
	logging.info("NETWORK CONNECTION HAS BEEN CLOSEDDDDD SucceSSfullY")
end


logging.info("Logger1 called before setsockname")
network.setsockname(handle, "*", multicastPort)--"*", "8021"

logging.info("Logger1 called before sendto")
network.sendto(handle, PayloadString, multicastIP, multicastPort)--"Is there anyone?" "DiscoverMotor"

network.setoption(handle, "broadcast")

logging.info("Logger1 called before request()")
network.request(handle, "HUB:minhttp.log_test/scripts/somficallback1", PayloadString)


   local beginTime = os.time()
   while os.time() - beginTime < 20 do
     local data, address, port = network.receivefrom(handle)
	 if #address>1 then
        logging.info("Message: " .. data)
        logging.info("Address: " .. address)
        logging.info("Port: " .. port)
	 end
	end

logging.info("The plugin has been ENDSENDSENDSENDSENDSENDSENDSENDS Configuring SucceSSfullY")
