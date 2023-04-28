local _core = require("core")
local _logger = require("logging")
local _storage = require("storage")

local params = ... or {}

local gateway = _core.get_gateway()
local devices = _core.get_devices()

for _, device in ipairs(devices) do
    if device.gateway_id == gateway.id and device.info then
        if device.info.parent_device_id == params.deviceId then
            _logger.info("Delete lamp: " .. device.name)
            _core.remove_device(device.id)
        end
    end
end

if _core.get_device(params.deviceId).device_type_id == "ezlo.govee" then
    _G.govee_smartleds_rgbic = nil
end

_logger.info("Delete device: " .. params.deviceId)
_storage.delete(params.deviceId)
_storage.delete(_core.get_device(params.deviceId).name)
_core.remove_device(params.deviceId)
