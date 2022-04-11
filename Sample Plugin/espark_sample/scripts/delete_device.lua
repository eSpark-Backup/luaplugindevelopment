local _core = require("core")
local _logger = require("logging")
local _storage = require("storage")

local params = ... or {}

local device = _core.get_device(params.deviceId)

if device.device_type_id == "device_sample" then
    _logger.debug("Prepare to delete device " .. params.deviceId)

    _logger.debug("Close connection")
    loadfile("HUB:espark_sample/scripts/handlers/network") {
        action = "disconnect",
        device_id = params.deviceId
    }

    _logger.debug("Clear storage")
    local dsc_storage = _storage.get_table("dsc") or {}
    dsc_storage[params.deviceId] = nil
    _storage.set_table("dsc", dsc_storage)
end

_logger.info("Delete device: " .. params.deviceId)
_core.remove_device_sync(params.deviceId)
