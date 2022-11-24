local logging = require("logging")
logging.info("The plugin has been started successfully")

require("network")

local ip_addresses = "192.168.18.120 - 192.168.18.130"
local ports = {7000, 3689}
local ip_version = "IPv4"
local script = "HUB:shelly.mdns/scripts/handle_network_scan_results"
local scan_id = network.start_scan_network(script, ip_addresses, ip_version, ports)

logging.info("scanning is started, scan id: " .. tostring(scan_id))
