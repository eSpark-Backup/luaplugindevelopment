local logging = require("logging")
logging.info("The plugin has been started successfully")



--[[ 

require("network")

local ip_addresses = "192.168.18.120 - 192.168.18.130"
local ports = {7000, 3689}
local ip_version = "IPv4"
local script = "HUB:shelly.mdns/scripts/handle_network_scan_results"
local scan_id = network.start_scan_network(script, ip_addresses, ip_version, ports)

logging.info("scanning is started, scan id: " .. tostring(scan_id))


 ]]


 --print(os.execute("lua5.3 -v"))
 --print(os.execute("ls -a"))

 --print(os.execute("apt-get update -y"))
 --print(os.execute("apt-get install -y avahi-daemon"))

--  print(os.execute("which avahi-browse"))
--  print(os.execute("which docker"))
--  print(os.execute("which lua"))
--  print(os.execute("avahi-browse -a --resolve"))
--  print(_VERSION)
