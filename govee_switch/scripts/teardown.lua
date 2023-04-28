print("test govee deice tearDowen000")
local _logger = require("logging")
local _storage = require("storage")
local _core = require("core")
local _timer = require("timer")
--local _network = require("network")
local TIMER_ID = "philips_lamps_update"

_logger.info("Govee-LED's teardown")

-- local result = _network.stop_listening_dhcp(_G.philips_dhcp_subscription_id)
_logger.info("Stop listening dhcp: " .. tostring(result))
_G.philips_dhcp_subscription_id = nil
_G.philips_hue.requests = nil
_G.govee_smartleds_rgbic = nil

if _timer.exists(TIMER_ID) then
    _timer.cancel(TIMER_ID)
end

function Purge()
    _logger.info("Remove all devices")
    _core.remove_gateway_devices(_core.get_gateway().id)

    _logger.info("Clear all storage")
    _storage.delete_all()
end

function OldFW()
    local fw = {}
    local firmware = _core.get_hub_info().firmware or ""
    _logger.info("FW: " .. firmware)
    for value in string.gmatch(firmware, "([^.]+)") do
        table.insert(fw, tonumber(value))
    end

    if #fw > 3 and (fw[1] < 2 or fw[2] < 0 or fw[3] < 31 or fw[4] < 2062) then
        _logger.info("Old firmware")
        return true
    end
    return false
end

local success, res = pcall(OldFW)
if success and res then
    Purge()
end

local params = ... or {}

if params.operation then
    if params.operation == 'uninstall' then
        Purge()

    elseif params.operation == 'teardown' then
        --
    else
        _logger.error('Unrecognized teardown operation ' .. params.operation)
    end
end


network.close(handle)
network.close(handle)
network.close(handle)