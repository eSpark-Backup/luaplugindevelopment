local logging = require ("logging")
--local http = require ("http")
logging.info("The plugin has been started successfully")

require("HUB:shelly.mdns/scripts/nethosts")




 --**************************************************************************************************************--

--[[ 


local params = ...

local network = require("network")

if params.event == "requestfrom" then
    network.sendto(
        params.data.handle,
        params.data.user_data .. params.data.datagram,
        params.data.address,
        params.data.port)
    return
end

local handle = network.udp();
network.setsockname(handle, "*", "80")
network.sendto(handle, "Is there anyone?", "127.0.0.1", "80")
network.requestfrom(handle, "HUB:shelly.mdns/scripts/handle_network_scan_results", "Hi, ")
logging.info("Logger1 called before request()")



 ]]




 --**************************************************************************************************************--


--[[ 

require "network"

handle = network.connect( { ip = "127.0.0.1", port = "80", connection_type = "TCP" } )
if not handle then
   print( "fail to connect" )
else
   print( "connection successful" )
end


 ]]
