local _logger = require("logging")
local _core = require("core")

_logger.info("████████████████████   DSC alarm panel plugin starting up...   ████████████████████")

_G.dsc = {
    commands = require("HUB:espark_sample/scripts/modules/tpi_commands"),
    connections = {},
    const = {
        TEST_DEV_ID = "test",
        TPI_COMM_ACK_WATCHDOG_TIMER = "tpi_comm_ack_watchdog"
    }
}

loadfile("HUB:espark_sample/scripts/handlers/network")({ action = "subscribe" })

local gateway_id = _core.get_gateway().id
local num_devices = 0

for _, device in ipairs(_core.get_devices() or {}) do
    if device.gateway_id == gateway_id and device.device_type_id == "device_sample" then
        loadfile("HUB:espark_sample/scripts/init") {
            action = "start_init",
            device_id = device.id
        }
        num_devices = num_devices + 1
    end
end

if num_devices > 0 then
    loadfile("HUB:espark_sample/scripts/handlers/dhcp")({ action = "start" })
end
