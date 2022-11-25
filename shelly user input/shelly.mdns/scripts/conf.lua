local logging = require("logging")

logging.info("The plugin has been configured successfully")


require("network")

param = ... or {}
ip_addresses = param.range
ip_version = param.version
ports = param.ports
script = "HUB:shelly.mdns/scripts/handle_network_scan_results"
scan_id = network.start_scan_network(script, ip_addresses, ip_version, ports)
