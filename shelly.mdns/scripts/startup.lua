local logging = require ("logging")
logging.info("The plugin has been started successfully")

require("network")

local ip_addresses = "192.168.18.1 - 192.168.18.250"
local ports = {80, 2020, 30, 8080}
local ip_version = "IPv4"
local script = "HUB:shelly.mdns/scripts/handle_network_scan_results"
local scan_id2 = network.start_scan_network(script, ip_addresses, ip_version,  ports )

logging.info("scanning is started, scan id2: " .. tostring(scan_id2))
